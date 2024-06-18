local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local shared = ReplicatedStorage.shared
local packages = ReplicatedStorage.sharedPackages

local Input = require(packages.Input)
local PartCache = require(shared.utilities.PartCache)
local React = require(packages.React)
local ReactRoblox = require(packages.ReactRoblox)
local contextActionServiceUtil = require(packages.contextActionServiceUtil)
local loader = require(packages.loader)
local playerUtil = require(shared.utilities.playerUtil)
local util = require(shared.utilities.weaponUtil)
local weaponConfig = require(shared.configurations.weaponConfig)
local weaponSettings = require(shared.configurations.weaponConfig)
local zap = require(ReplicatedStorage.zap)

local RAYCAST_BEAM_DURATION = 0.05
local HITMARKER_DURATION = 0.05
local HIT_PARTICLE_DURATION = 0.5
local SPRINT_SPEED = 21
local DAMAGE_DISPLAY_LIFETIME = 2
-- The keys of the control keys to their names in ContextActionService
-- List of controls for cross platform compatibilty
local CONTROLS = {
	activation = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }, -- Aka attack, shoot, swing, throw, etc
	run = { Enum.KeyCode.F, Enum.KeyCode.ButtonL3 },
}

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local mouseInput = Input.Mouse.new()

-- Create the params just once at the top for increased performance.
local params = RaycastParams.new()
params.FilterDescendantsInstances = { workspace.RaycastIgnore }
params.FilterType = Enum.RaycastFilterType.Exclude

-- Initial instance for beam cache
local beam = Instance.new("Beam")
beam.Width0 = 0.1
beam.Width1 = 0.1
beam.LightEmission = 1
beam.LightInfluence = 1
beam.FaceCamera = true

local hitParticle1 = Instance.new("ParticleEmitter") -- Particles
hitParticle1.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
hitParticle1.Lifetime = NumberRange.new(0.3, HIT_PARTICLE_DURATION)
local hitParticle2 = Instance.new("ParticleEmitter") -- Smoke
hitParticle2.Lifetime = NumberRange.new(0.3, HIT_PARTICLE_DURATION)
hitParticle2.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))

local WEAPON_CACHE_SIZE = 50
local cacheFolder = Instance.new("Folder")
-- Create a cache of attachments and beams that are reused for optimal performance.
local attachmentCache =
	PartCache.new(Instance.new("Attachment"), WEAPON_CACHE_SIZE * 2, workspace.Terrain)
local beamCache = PartCache.new(beam, WEAPON_CACHE_SIZE, workspace.Terrain)
local hp1Cache = PartCache.new(hitParticle1, WEAPON_CACHE_SIZE, cacheFolder)

local fadeOutBeamTweenInfo =
	TweenInfo.new(RAYCAST_BEAM_DURATION, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

-- Controller state
local weapons = {}
local weaponEngaged = false
local expectingInput = false
local reloading = false
local currentAnim = "idle"
local currentWep = nil
local dead = true
local animTracks = {}
local casActions = {}

local weaponController = {}

-- This stops all weapon animations that could be playing and plays the desired animation.
local function stopAllAndPlay(animName: string)
	-- if not animTracks[animName].IsPlaying then
	for _, anim in animTracks do
		if type(anim) == "table" then
			continue
		end
		anim:Stop()
	end
	if animTracks[animName] then
		animTracks[animName]:Play()
	end
	-- end
	currentAnim = animName
end

-- Whenever an activation key is pressed this function is fired
function casActions.activation(_, state: Enum.UserInputState)
	weaponEngaged = if state == Enum.UserInputState.Begin then true else false
end

-- Run with your weapon by pressing the sprint CAS key
function casActions.run(_, state)
	if state ~= Enum.UserInputState.Begin or reloading then
		return
	end
	local character = localPlayer.Character
	-- Ensure character exists as well as humanoid
	local humanoid = (character ~= nil) and character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end
	-- We can set the sprinting state based on their state already.
	if humanoid.WalkSpeed <= 16 then
		humanoid.WalkSpeed = SPRINT_SPEED
		currentAnim = "run"
	else
		humanoid.WalkSpeed = 16
		currentAnim = "idle"
	end
	stopAllAndPlay(currentAnim)
end

-- What to do when the player has equipped a tool that is registered as a weapon in weaponSettings
local function weaponEquipped(tool: Tool)
	-- Reset weapon state to default
	mouse.Icon = "rbxassetid://5992580992"
	stopAllAndPlay("idle")
	currentWep = tool
	expectingInput = true
	local mag = tool:FindFirstChild("Mag")
	if mag then
		mag.Transparency = 0
	end

	-- Setup controls
	for casName, controls in CONTROLS do
		contextActionServiceUtil.bindActionNoInputSink(
			casName,
			casActions[casName],
			true,
			table.unpack(controls)
		)
	end
end

local function setupCharacter(character: Model)
	local humanoid = character:WaitForChild("Humanoid")
	local animator: Animator = humanoid:WaitForChild("Animator")

	-- Reset character state
	expectingInput = false
	currentWep = nil
	dead = false
	mouse.Icon = ""
	currentAnim = "idle"
	table.clear(animTracks)
	table.clear(weapons)

	character.ChildAdded:Connect(function(child: Instance)
		if child:IsA("Tool") then
			-- Check that the tool is a weapon
			local ws = weaponConfig.settings[child.Name]
			if not ws then
				return
			end

			-- Initialize weapon if not already
			if not weapons[child] then
				weapons[child] = ws
				ws.bulletsLeft = ws.magSize
			end

			-- Load weapon animations
			for name, animId in ws.anims do
				if animId == "" then
					continue
				end
				if not animTracks[name] then
					if type(animId) == "table" then
						animTracks[name] = {}
						local animation = Instance.new("Animation")
						for _, id in animId do
							animation.AnimationId = id
							local track = animator:LoadAnimation(animation)
							track.Priority = Enum.AnimationPriority.Action
							track.Looped = false
							table.insert(animTracks[name], track)
						end
						continue
					end
					local animation = Instance.new("Animation")
					animation.AnimationId = animId
					local track = animator:LoadAnimation(animation)
					track.Priority = Enum.AnimationPriority.Action
					track.Looped = false
					animTracks[name] = track
				end
			end

			weaponEquipped(child)
		end
	end)

	-- Listen for anything removed from the player's character and check if it's a weapon
	character.ChildRemoved:Connect(function(child: Instance)
		-- If expectingInput is true, that means the player is holding a weapon.
		if expectingInput and child:IsA("Tool") then
			task.defer(function()
				for _, anim in animTracks do
					if type(anim) == "table" then
						continue
					end
					anim:Stop()
				end
			end)
			humanoid.WalkSpeed = 16
			mouse.Icon = ""
			expectingInput = false
			currentWep = nil

			-- Disconnect controls
			for name, _ in casActions do
				ContextActionService:UnbindAction(name)
			end
		end
	end)

	character.Humanoid.Died:Connect(function()
		dead = true
		-- TODO: UI action
	end)
end

local function hitmarker()
	local mousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
	return React.createElement("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "http://www.roblox.com/asset/?id=9999783439",
		Size = UDim2.new(0, 25, 0, 25),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(mousePosition.X, mousePosition.Y),
		Name = "Hitmarker",
		Visible = true,
	})
end

-- This visualizes casts in a unique way, using beams. It's more performant and much easier to do.
function weaponController.visualizeCast(data)
	-- Using a modified part cache we get our cached instances
	local a0: Attachment = attachmentCache:GetPart()
	local a1: Attachment = attachmentCache:GetPart() --getUnusedCachePart(attachmentCache, "ParticleEmitter")
	local cachedBeam = beamCache:GetPart()
	cachedBeam.Color = ColorSequence.new(data.beamColor)
	cachedBeam.Attachment0 = a0
	cachedBeam.Attachment1 = a1

	a0.WorldPosition = data.firepoint.WorldPosition
	a1.WorldPosition = data.hit

	task.spawn(function()
		local fadeOutTween = TweenService:Create(cachedBeam, fadeOutBeamTweenInfo, { Width0 = 0 })
		fadeOutTween:Play()
		fadeOutTween.Completed:Wait()
		cachedBeam.Attachment0 = nil
		cachedBeam.Attachment1 = nil
		cachedBeam.Width0 = 0.1
		-- Return instances after we're done with them.
		attachmentCache:ReturnPart(a0)
		attachmentCache:ReturnPart(a1)
		beamCache:ReturnPart(cachedBeam)
	end)
end

-- Perform any client sided actions when a bullet hits something.
function weaponController.replicateBulletHit(data)
	local weaponName = data.weaponName
	local victim = data.victim
	-- If a player is hit and this is replicated to the client, make sure that person isn't the client who is being shot.
	local ws = weaponSettings.settings[weaponName]
	assert(ws, `No weapon settings for weapon named {weaponName}`)
	if victim and victim ~= localPlayer.Name then
		local hitmarkerSound = SoundService.Weapons.Hitmarker
		hitmarkerSound:Play()
		-- hitmarkerRoot:render(hitmarker())
		-- task.delay(HITMARKER_DURATION, function()
		-- 	hitmarkerRoot:unmount()
		-- end)

		-- victim = playerUtil.playerFromName(victim)
		-- if not victim and not data.targetHit then
		-- 	return
		-- end
		-- if not data.targetHit and not util.canDamage(localPlayer, victim, ws) then
		-- 	return
		-- end
		-- displayDamage(ws)
	end
end

function weaponController.start()
	local lastFire = 0
	local swingAnim = 1

	-- Set defaults for all weapon types
	for _, settings in weaponSettings.settings do
		for name, setting in weaponSettings.default do
			if not settings[name] then
				settings[name] = setting
			end
		end
	end

	-- Do this as soon as the system starts incase the CharacterAdded event is called before the system
	-- has had a chance to start. This is where we initially setup the weapon controller.
	local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	setupCharacter(char)

	RunService.RenderStepped:Connect(function(dt)
		if weaponEngaged and expectingInput and not dead then
			local now = time()
			local currentWs = weapons[currentWep]
			-- Don't fire weapon while reloading and make sure we have a registered weapon equipped.
			if not currentWs or reloading then
				return
			end
			local character = localPlayer.Character
			local hum = (character ~= nil) and character:FindFirstChild("Humanoid")
			if not hum then
				return
			end
			-- Cooldown based on clock
			if (now - lastFire) > currentWs.fireCooldown then
				lastFire = now
				-- Player fired a shot, also make them idle again incase they were running.
				hum.WalkSpeed = 16
				stopAllAndPlay("idle")

				-- Cast a ray to the player's mouse from their head so they can't shoot
				-- through walls but can shoot above walls their head can see over.
				-- This also makes first person more accurate.
				params.FilterDescendantsInstances =
					{ workspace.RaycastIgnore, localPlayer.Character }
				local hit = workspace:Raycast(
					character.Head.Position,
					(mouse.Hit.Position - character.Head.Position).Unit * currentWs.range,
					params
				)

				-- If the cast doesn't hit anything then let's say they hit somewhere at the
				-- end of the range of their weapon.
				local pos = if hit then hit.Position else mouseInput:Project(currentWs.range)
				-- Multiple bullets are visualized by the server because each bullets direction is calculated by the server.
				if currentWs.bullets == 1 then
					weaponController.visualizeCast({
						firepoint = currentWep.Handle.Firepoint,
						hit = pos,
						beamColor = currentWs.raycastBeamColor,
					})
				end

				-- TODO: UI

				local rayHit = if hit then hit.Instance else nil
				local victim
				-- TODO: Hit visual modules
				-- if rayHit then
				-- 	victim = Players:GetPlayerFromCharacter(rayHit.Parent)
				-- 	if hitVisuals[currentWs.hitVisual] then
				-- 		hitVisuals[currentWs.hitVisual](currentWs, rayHit, victim)
				-- 	end
				-- end

				-- Send a message to the server telling them that we have fired our weapon so that the rest can be handled there.
				zap.fireGun.Fire({ hitPos = pos, rayHit = rayHit })
			end
		end
	end)

	zap.replicateHit.SetCallback(weaponController.replicateBulletHit)
	localPlayer.CharacterAdded:Connect(setupCharacter)
end

return weaponController
