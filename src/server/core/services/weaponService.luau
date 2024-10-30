local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")

local server = ServerStorage.server.modules
local weaponServiceModules = server.weaponService

local gameStateService = require(script.Parent.gameStateService)
local levelService = require(ServerStorage.server.services.levelService)
local monetizationUtil = require(ReplicatedStorage.shared.utilities.monetizationUtil)
local moneyService = require(ServerStorage.server.services.moneyService)
local playerDataService = require(script.Parent.playerDataService)
local playerUtil = require(ReplicatedStorage.shared.utilities.playerUtil)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local skillService = require(script.Parent.skillService)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ServerStorage.zap)
local zombieStatConfig = require(ReplicatedStorage.shared.configurations.zombieStatConfig)

local meleeHitParams = OverlapParams.new()
meleeHitParams.FilterType = Enum.RaycastFilterType.Exclude

local trackedWeapons = {}
local bulletTypes = {}
local hitTypes = {}
local cooldowns = {}

local COOLDOWN = 0.01

local weaponService = {}

local function loadModulesInto(table: {}, directory: Instance)
	if not table or not directory then
		return
	end

	for _, v: Instance in directory:GetChildren() do
		if v:IsA("ModuleScript") then
			table[v.Name] = require(v)
		end
	end
end

local function trackWeapon(weapon: Tool, addedOptionalData: { any })
	local ws = table.clone(weaponConfig.settings[weapon.Name])
	for name, addedData in addedOptionalData do
		ws[name] = addedData
	end
	trackedWeapons[weapon] = ws

	weapon.AncestryChanged:Connect(function(child: Instance)
		if not child or not child.Parent then
			trackedWeapons[weapon] = nil
		end
	end)
end

local function fireGun(player: Player, weapon: Tool, to: Vector3, hitPart: Instance)
	local now = time()
	if now < (cooldowns[player] or 0) + COOLDOWN then
		return
	end
	cooldowns[player] = now
	local weaponName = weapon.Name
	local handle = weapon:FindFirstChild("Handle")
	if not handle then
		error(`Expected a "Handle" part in weapon {weaponName}`)
	end
	local firepoint = handle:FindFirstChild("Firepoint")
	if not firepoint then
		error(`Expected an attachment in the handle of {weaponName} named "Firepoint"`)
	end
	local ws = weaponConfig.settings[weaponName]
	if not ws then
		error(`Weapon {weaponName} not found.`)
	end

	-- Play gunshot sound
	local soundName = ws.sounds.fire
	if soundName ~= "" then
		local sound = SoundService.Weapons:FindFirstChild(ws.sounds.fire) :: Sound

		if sound then
			local soundPart = Instance.new("Part")
			soundPart.Position = firepoint.WorldPosition
			soundPart.CanCollide = false
			soundPart.Transparency = 1
			soundPart.Name = "SoundPart"
			soundPart:AddTag("SoundPart")
			soundPart.Parent = workspace

			local newSound = sound:Clone()
			newSound.Parent = soundPart

			newSound.Ended:Connect(function()
				soundPart:Destroy()
			end)
			newSound:Play()
		else
			warn(`Fire sound {soundName} not found in SoundService.`)
		end
	end

	-- Modify ws
	ws = skillService.applySkills(player, ws)

	zap.replicateCast.FireExcept(player, { firepoint = firepoint, hit = to })

	bulletTypes[ws.bulletType](player, ws, firepoint, to, hitPart, weapon.Name)
end

local function melee(player: Player, weapon: Tool)
	local damagePart = weapon:FindFirstChild("DamagePart")
	assert(damagePart ~= nil, `DamagePart not found in melee weapon {weapon.Name}`)
	if not trackedWeapons[weapon] then
		-- Add saved state to this melee weapon since we will need it
		trackWeapon(weapon, {
			isActive = true,
			isAttacking = false,
			lastHitPerCharacter = {},
		})
	end
	local ws = trackedWeapons[weapon]
	local character = player.Character
	if not character and character.Parent then
		return
	end
	if ws.isAttacking then
		return
	end
	ws.isAttacking = true
	-- Communicate when the HitLength has finished:
	task.defer(function()
		task.wait(ws.fireCooldown)
		ws.isAttacking = false
	end)
	-- Only detect hits while the player is still hitting or tool is active:
	task.spawn(function()
		while ws.isAttacking do
			meleeHitParams.FilterDescendantsInstances = { character }
			local touches = workspace:GetPartsInPart(damagePart, meleeHitParams)
			task.wait()
			-- In other words, if nothing was detected in the query then just end
			if not touches[1] then
				continue
			end
			for _, part in touches do
				local victim = playerUtil.playerFromInstance(part)
				local victimCharacter = victim and victim.Character
				local humanoid = victimCharacter and victimCharacter:FindFirstChild("Humanoid")
				if not humanoid then
					continue
				end
				-- if not weaponUtil.canDamage(player, victim, ws) then
				-- 	continue
				-- end

				local victimHrp = victimCharacter:FindFirstChild("HumanoidRootPart")
				local attackerHrp = character:FindFirstChild("HumanoidRootPart")

				local now = os.clock()
				if
					not victimCharacter
					or not victimCharacter.Parent
					or not victimHrp
					or not attackerHrp
					or now < (ws.lastHitPerCharacter[humanoid] or 0) + ws.damageRate
					-- Range check, give a little slack (the magic number here)
					or (attackerHrp.Position - victimHrp.Position).Magnitude
						> (damagePart.Size.Y + 4)
				then
					continue
				end
				ws.lastHitPerCharacter[humanoid] = now
				humanoid:TakeDamage(ws.damage)
				break
			end
		end
	end)
end

local function registerHit(
	shooter: Player,
	ws: weaponConfig.Settings,
	raycastResult: RaycastResult,
	weaponName: string
)
	assert(
		hitTypes[ws.hitType] ~= nil,
		`No known hitType "{ws.hitType}" -- double-check weaponSettings.`
	)

	-- Perform bullet hits for non-zombies (standard hit processing)
	hitTypes[ws.hitType](shooter, ws, raycastResult)

	-- Replicate bullet hits
	if raycastResult and raycastResult.Instance then
		-- zap.replicateHit.Fire(
		-- 	shooter,
		-- 	{ weaponName = weaponName, hitPart = raycastResult.Instance, damage = ws.damage }
		-- )
	end
end

function weaponService.buyWeapon(player: Player, data: { weaponName: string, weaponType: string })
	local cfg = shopConfig[data.weaponType][data.weaponName]
	local profile = playerDataService.getProfile(player)
	if
		profile.Data.Money >= cfg.price
		and not table.find(profile.Data.ownedWeapons, data.weaponName)
		and profile.Data.Level >= cfg.levelReq
	then
		profile.Data.Money -= cfg.price
		table.insert(profile.Data.ownedWeapons, data.weaponName)
		playerDataService.setProfile(player, profile)
	end
end

function weaponService.onWeaponEquipped(player: Player, weapon: Tool)
	local ws = weaponConfig.settings[weapon.Name]
	if not ws then
		warn(`Weapon {weapon.Name} not found in weaponConfig.settings.`)
		return
	end

	ws = skillService.applySkills(player, ws)

	local character = player.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return
	end

	humanoid.WalkSpeed = (ws.walkspeed or 16)
		* (
			if monetizationUtil
					.userOwnsGamepass(player.UserId, sharedInfo.Gamepasses["Extra Speed!"])
					:expect()
				then 1.5
				else 1
		)
end

function weaponService.getWeaponFromPlayer(player: Player): Tool?
	local char = player.Character
	if not char then
		return
	end
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum:GetState() == Enum.HumanoidStateType.Dead then
		return
	end
	local weapon = char:FindFirstChildWhichIsA("Tool")
	if not weapon then
		return
	end
	-- Make sure the tool is a registered weapon
	if not weaponConfig.settings[weapon.Name] then
		return
	end
	return weapon
end

function weaponService.getWeaponSettings(weaponName: string)
	local ws = weaponConfig.settings[weaponName]
	if not ws then
		return error(`Weapon '{weaponName}' could not be found in weapon settings.`)
	end
	return ws
end

function weaponService.start()
	-- Set defaults for all weapon types
	for _, settings in weaponConfig.settings do
		for name, setting in weaponConfig.default do
			if not settings[name] then
				settings[name] = setting
			end
		end
	end

	loadModulesInto(bulletTypes, weaponServiceModules.bulletTypes)
	loadModulesInto(hitTypes, weaponServiceModules.hitTypes)

	zap.fireGun.SetCallback(function(shooter, data)
		local weapon: Tool? = weaponService.getWeaponFromPlayer(shooter)
		if not weapon then
			return
		end
		fireGun(shooter, weapon, data.hitPos, data.rayHit)
	end)

	zap.melee.SetCallback(function(player)
		local weapon: Tool? = weaponService.getWeaponFromPlayer(player)
		if not weapon then
			return
		end
		melee(player, weapon)
	end)

	-- Fires when someone has been killed by a hitType
	weaponConfig.signals.kill:Connect(
		function(shooter: Player, zombie: Model, ws: weaponConfig.Settings)
			skillService.trackZombieKill(shooter, zombie)
			if ws then
				skillService.applySkills(shooter, ws)
			end

			-- TODO: Add money and xp to player for killing certain zombies
			local cfg = zombieStatConfig[zombie.Name]

			if math.random() < 0.1 then
				local profile = playerDataService.getProfile(shooter)
				profile.Data.rampageEssence += 1
				playerDataService.setProfile(shooter, profile)
			end

			--TODO:  This will later change based on rebirth status and gamepasses and such
			levelService.addExperience(shooter, cfg.xpDropped or 1)
			local moneyDropped = cfg.moneyDropped
					* (1 + (0.10 * gameStateService.getCurrentRound()))
				or 10
			moneyService.addMoney(shooter, moneyDropped)
			zap.updateFeeds.Fire(
				shooter,
				{ type = "money", amtGain = moneyDropped, reason = "Killed Zombie" }
			)
			zap.replicateKill.Fire(shooter)
			-- amounts are temporary
		end
	)

	weaponConfig.signals.bulletHit:Connect(
		function(shooter: Player, ws: any, raycastResult: RaycastResult, weaponName: string)
			registerHit(shooter, ws, raycastResult, weaponName)
		end
	)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			character.ChildAdded:Connect(function(child)
				if weaponConfig.settings[child.Name] then
					weaponService.onWeaponEquipped(player, child)
				end
			end)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if cooldowns[player] then
			cooldowns[player] = nil
		end
	end)

	zap.buyWeapon.SetCallback(weaponService.buyWeapon)

	zap.getOwnedWeapons.SetCallback(function(player)
		local profile = playerDataService.getProfile(player)
		if not profile then
			return {}
		end

		return {
			equippedWeapons = {
				gun = profile.Data.gun,
				melee = profile.Data.melee,
				equipment = profile.Data.equipment,
			},
			ownedWeapons = profile.Data.ownedWeapons,
		}
	end)
end

return weaponService
