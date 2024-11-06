--!native
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local monetizationUtil = require(ReplicatedStorage.shared.utilities.monetizationUtil)
local playerDataService = require(ServerStorage.server.services.playerDataService)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local skillConfig = require(ReplicatedStorage.shared.configurations.skillConfig)
local zap = require(ServerStorage.zap)
local zombieStatConfig = require(ReplicatedStorage.shared.configurations.zombieStatConfig)
local zombieUtil = require(ReplicatedStorage.shared.utilities.zombieUtil)
local skillService = {}

local ZOMBIE_TRACKING_TIMER = 2

-- Build a lookup table to prevent unnecessary iteration
local skillLookup = {}
local killTracker = {}
local hitTracker = {}
local activeHealthRecovery = {}
local headshotTracker = {}

local function getHitZombies(shooter)
	return hitTracker[shooter.UserId] or {}
end

local function getKilledZombies(shooter)
	return killTracker[shooter.UserId] or {}
end

local function getHeadshots(shooter)
	return headshotTracker[shooter.UserId] or {}
end

local function ownsSpeedGamepass(player)
	return if monetizationUtil
			.userOwnsGamepass(player.UserId, sharedInfo.Gamepasses["Extra Speed!"])
			:expect()
		then 1.5
		else 1
end

local effectHandlers = {
	-- Player stat modifications
	["playerStat"] = function(player, ws, effectData, skillData)
		if skillData.level == 0 then
			return
		end
		if effectData.stat == "walkSpeed" and effectData.condition ~= "kill" then
			player.Character.Humanoid.WalkSpeed = ws.walkspeed
				* (1 + (effectData.amount * skillData.level))
				* ownsSpeedGamepass(player)
		elseif effectData.stat == "walkSpeed" and effectData.condition == "kill" then
			local kills = getKilledZombies(player)
			if #kills >= 1 then
				player.Character.Humanoid.WalkSpeed = ws.walkspeed
					* (1 + (effectData.amount * skillData.level))
					* ownsSpeedGamepass(player)
				task.delay(7, function()
					if #kills == 0 then
						local char = player.Character
						local hum = char and char:FindFirstChild("Humanoid")
						if not hum then
							return
						end
						hum.WalkSpeed = ws.walkspeed * ownsSpeedGamepass(player)
					end
				end)
			end
		end
	end,

	-- Zombie modifications
	["zombieEffect"] = function(shooter, hitZombie, effectData, skillData)
		local stat = effectData.stat
		local amount = effectData.amount
		local duration = effectData.duration

		if not hitZombie or not hitZombie.Parent then
			return
		end
		if skillData.level == 0 then
			return
		end

		-- Example for changing zombie walk speed
		if stat == "walkSpeed" then
			local humanoid = hitZombie:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.WalkSpeed += amount
				task.delay(duration, function()
					humanoid.WalkSpeed -= amount
				end)
			end
		elseif stat == "slow" then
			local humanoid = hitZombie:FindFirstChild("Humanoid") :: Humanoid
			local cfg = zombieStatConfig[hitZombie.Name]
			if humanoid then
				-- Store original speed if not already stored
				if not humanoid:GetAttribute("OriginalWalkSpeed") then
					humanoid:SetAttribute("OriginalWalkSpeed", humanoid.WalkSpeed)
					humanoid:SetAttribute("CurrentSlowAmount", 0) -- Track total slow
					humanoid:SetAttribute("SlowDurationTaskActive", false) -- Track if a restore task is active
				end

				-- Current slow amount (from previous shots)
				local currentSlowAmount = humanoid:GetAttribute("CurrentSlowAmount")
				-- Add 10% slow with each shot, max 50%
				local newSlowAmount =
					math.min(currentSlowAmount + amount, 1 - amount * skillData.level) -- 'amount' represents the 0.1 (10%) passed in the effectData
				humanoid:SetAttribute("CurrentSlowAmount", newSlowAmount)

				-- Apply the slow by modifying the WalkSpeed
				humanoid.WalkSpeed = cfg.speed * (1 - newSlowAmount)

				-- If a restore task is already running, just update the slow and reset the duration timer
				if humanoid:GetAttribute("SlowDurationTaskActive") == true then
					-- Task is active, just reset the timer
					humanoid:SetAttribute("SlowEndTime", tick() + (duration or 2))
					return
				end

				-- Set task as active and store the end time
				humanoid:SetAttribute("SlowDurationTaskActive", true)
				humanoid:SetAttribute("SlowEndTime", tick() + (duration or 2))

				-- Periodic check to see when the duration ends
				task.spawn(function()
					while humanoid:GetAttribute("CurrentSlowAmount") > 0 do
						local endTime = humanoid:GetAttribute("SlowEndTime")

						-- Check if slow duration is over
						if tick() >= endTime then
							local currentSlow = humanoid:GetAttribute("CurrentSlowAmount")
							local newSlow = math.max(currentSlow - amount, 0)
							humanoid:SetAttribute("CurrentSlowAmount", newSlow)
							humanoid.WalkSpeed = cfg.speed * (1 - newSlow)

							-- Reset the timer for the next reduction
							humanoid:SetAttribute("SlowEndTime", tick() + 1)
						end

						task.wait(1) -- Adjust time between checks
					end

					-- Restore original speed and clear attributes once fully restored
					humanoid.WalkSpeed = humanoid:GetAttribute("OriginalWalkSpeed")
					humanoid:SetAttribute("OriginalWalkSpeed", nil)
					humanoid:SetAttribute("CurrentSlowAmount", nil)
					humanoid:SetAttribute("SlowDurationTaskActive", false) -- Mark the task as done
				end)
			end
		end

		-- Example for stunning a zombie
		if stat == "stun" then
			local humanoid = hitZombie:FindFirstChild("Humanoid")
			if humanoid then
				-- Generate a random number between 0 and 1
				local chance = math.random()
				if chance <= 0.4 then -- 40% chance
					-- Store the original WalkSpeed if not already stored
					if not humanoid:GetAttribute("OriginalWalkSpeed") then
						humanoid:SetAttribute("OriginalWalkSpeed", humanoid.WalkSpeed)
					end
					humanoid.WalkSpeed = 4 -- Stun the zombie

					-- Delay for the specified duration, then unstun
					task.delay(duration or 2, function()
						-- Check if the humanoid still exists
						if humanoid and humanoid.Parent then
							-- Retrieve the original WalkSpeed
							local originalWalkSpeed = humanoid:GetAttribute("OriginalWalkSpeed")
							if originalWalkSpeed then
								humanoid.WalkSpeed = originalWalkSpeed -- Unstun the zombie
								humanoid:SetAttribute("OriginalWalkSpeed", nil) -- Clear the attribute
							end
						end
					end)
				end
			end
		end
	end,

	-- Weapon stat modifications
	["weaponStat"] = function(shooter, ws, effectData, skillData)
		local stat = effectData.stat
		local multiplier = effectData.multiplier
		if skillData.level == 0 then
			return
		end
		-- Example for damage increase
		if stat == "damage" then
			ws.damage *= 1 + (multiplier * skillData.level)
		elseif stat == "maxPierce" or stat == "bullets" then
			ws[stat] += skillData.level
		end
	end,

	-- Area-based effects (e.g., hitting multiple zombies)
	["areaEffect"] = function(shooter, ws, hitZombies, effectData, skillData)
		local requiredHits = effectData.requiredHits
		local radius = effectData.radius
		local shockwaveDamage = effectData.bonusDamage

		if skillData.level == 0 then
			return
		end

		if #getHeadshots(shooter) >= requiredHits then
			zombieUtil.createShockwave:Fire(hitZombies, radius, shockwaveDamage)
		end
	end,

	-- Conditional effects based on player state (e.g., health below threshold)
	["conditionalEffect"] = function(shooter, ws, effectData, skillData)
		local condition = effectData.condition
		local stat = effectData.stat
		local threshold = effectData.threshold
		local multiplier = effectData.multiplier

		local char = shooter.Character
		local plrHum = char and char:FindFirstChild("Humanoid")
		if not plrHum then
			return
		end
		if skillData.level == 0 then
			return
		end
		if condition == "belowHealth" and plrHum.Health < threshold then
			ws[stat] *= 1 + (multiplier * skillData.level)
		elseif condition == "notMoving" and plrHum.MoveDirection.Magnitude == 0 then
			ws[stat] *= 1 + (multiplier * skillData.level)
		elseif condition == "kill" then
			-- Apply the effect if the player has killed a zombie in the last second
			if stat == "healthRecovery" then
				if #getKilledZombies(shooter) >= 1 and not activeHealthRecovery[shooter.UserId] then
					-- Set the flag to prevent multiple concurrent effects
					activeHealthRecovery[shooter.UserId] = true
					table.remove(killTracker[shooter.UserId], 1)

					task.spawn(function()
						-- For 5 seconds, recover 5 health every second
						for _ = 1, 5 do
							local char = shooter.Character
							local hum = char and char:FindFirstChild("Humanoid")
							if hum and hum.Health < 100 then
								hum.Health += 5
							end
							task.wait(1)
						end
						-- Reset the flag after the effect duration
						activeHealthRecovery[shooter.UserId] = false
					end)
				end
			elseif stat == "damage" then
				if #getKilledZombies(shooter) >= 1 then
					ws[stat] *= math.min(
						2,
						1 + (multiplier * skillData.level * #(getKilledZombies(shooter)))
					)
				end
			end
		end
	end,
}

local skillEffects = {
	-- Pistol
	["Speed Increase"] = {
		type = "playerStat",
		effectData = { stat = "walkSpeed", amount = 0.05 }, -- 5% per level
	},
	["Dodging"] = {
		type = "playerStat",
		effectData = { stat = "dodgeChance", amount = 0.05 }, -- 5% per level
	},
	["Speed Fire"] = {
		type = "weaponStat",
		effectData = { stat = "fireCooldown", multiplier = 0.1 },
	},
	["Stunt Bullets"] = {
		type = "zombieEffect",
		effectData = { stat = "stun", duration = 2 }, -- 40% chance to stun
	},
	-------------------------------------------------------

	-- Sniper skills
	["Hidden in Plain Sight"] = {
		type = "conditionalEffect",
		effectData = {
			condition = "notMoving",
			stat = "damage",
			multiplier = 0.05, -- Per level
		},
	},
	["Pierce Count"] = {
		type = "weaponStat",
		effectData = { stat = "maxPierce", multiplier = 1 },
	},
	["Movement Speed"] = {
		type = "playerStat",
		effectData = { stat = "walkSpeed", amount = 0.1 }, -- 10% per level
	},
	["Shockwave Impact"] = {
		type = "areaEffect",
		effectData = { requiredHits = 1, bonusDamage = 50, radius = 10 },
	},
	-------------------------------------------------------

	-- Rifle skills
	["Damage Increase"] = {
		type = "weaponStat",
		effectData = { stat = "damage", multiplier = 0.02 }, -- % per level
	},
	["Pierce"] = {
		type = "weaponStat",
		effectData = { stat = "maxPierce", multiplier = 1 },
	},
	["Combat Conditioning"] = {
		type = "conditionalEffect",
		effectData = {
			condition = "kill",
			stat = "healthRecovery",
			threshold = 50,
			multiplier = 5,
		},
	},
	["Master Determination"] = {
		type = "conditionalEffect",
		effectData = {
			condition = "belowHealth",
			stat = "damage",
			threshold = 90,
			multiplier = 0.3,
		},
	},
	-------------------------------------------------------

	-- Shotgun skills
	["Stronger Pellets"] = {
		type = "weaponStat",
		effectData = { stat = "maxPierce", multiplier = 1 },
	},
	["Fight or Flight"] = {
		type = "playerStat",
		effectData = { stat = "fireCooldown", amount = 0.1 },
	},
	["Boomstick"] = {
		type = "weaponStat",
		effectData = { stat = "bullets", multiplier = 1 },
	},
	["Immovable Object"] = {
		type = "conditionalEffect",
		effectData = {
			condition = "kill",
			stat = "damage",
			threshold = 2,
			multiplier = 0.1,
		},
	},
	-------------------------------------------------------

	-- Smg Skills
	["Rapid Fire"] = {
		type = "weaponStat",
		effectData = { stat = "fireCooldown", multiplier = 1.1 }, -- 10% per level
	},

	["Suppressing Fire"] = {
		type = "zombieEffect",
		effectData = { stat = "slow", amount = 0.1, duration = 3 }, -- 10% slow per level, 3 seconds
	},

	["Piercing Shots"] = {
		type = "weaponStat",
		effectData = { stat = "maxPierce", multiplier = 1 }, -- Each level adds the ability to pierce one more zombie
	},

	["Adrenaline Surge"] = {
		type = "playerStat",
		effectData = { stat = "walkSpeed", amount = 0.07, condition = "kill" }, -- 7% speed increase per level after kills
	},
}

function skillService.trackZombieKill(shooter, hitZombie)
	killTracker[shooter.UserId] = killTracker[shooter.UserId] or {}

	if table.find(killTracker[shooter.UserId], hitZombie) then
		return
	end

	table.insert(killTracker[shooter.UserId], hitZombie)

	task.delay(ZOMBIE_TRACKING_TIMER, function()
		local idx = table.find(killTracker[shooter.UserId], hitZombie)
		if idx then
			table.remove(killTracker[shooter.UserId], idx)
		end
	end)
end

function skillService.trackHitZombie(shooter, hitZombie)
	hitTracker[shooter.UserId] = hitTracker[shooter.UserId] or {}

	if table.find(hitTracker[shooter.UserId], hitZombie) then
		return
	end

	table.insert(hitTracker[shooter.UserId], hitZombie)

	task.delay(ZOMBIE_TRACKING_TIMER, function()
		local idx = table.find(hitTracker[shooter.UserId], hitZombie)
		if idx then
			table.remove(hitTracker[shooter.UserId], idx)
		end
	end)
end

function skillService.trackHeadshotHit(shooter, hitZombie, hitPart)
	-- Ensure only headshots trigger the effect
	if hitPart.Name ~= "Head" then
		return
	end

	-- Track headshots separately
	headshotTracker[shooter.UserId] = headshotTracker[shooter.UserId] or {}

	if table.find(headshotTracker[shooter.UserId], hitZombie) then
		return
	end

	table.insert(headshotTracker[shooter.UserId], hitZombie)

	-- Delay to remove tracked zombies after the timer expires
	task.delay(ZOMBIE_TRACKING_TIMER, function()
		local idx = table.find(headshotTracker[shooter.UserId], hitZombie)
		if idx then
			table.remove(headshotTracker[shooter.UserId], idx)
		end
	end)
end

-- Function to apply skills to the player, modifying weapon stats and handling hit effects
function skillService.applySkills(shooter, ws)
	ws = table.clone(ws)
	local profile = playerDataService.getProfile(shooter)

	-- Get all zombies the player has hit in the last 5 seconds
	local hitZombies = getHitZombies(shooter)

	for _, skillInfo in skillConfig[profile.Data.weaponClass] do
		local skillEffect = skillEffects[skillInfo.name]
		if skillEffect then
			local effectType = skillEffect.type
			local effectData = skillEffect.effectData

			-- Get skill level
			local skillData = skillService.getSkillData(shooter, skillInfo.name)

			-- Apply the effect using the appropriate handler
			local handler = effectHandlers[effectType]
			if handler then
				if effectType == "areaEffect" then
					handler(shooter, ws, hitZombies, effectData, skillData) -- Apply area effects like Crowd Control
				elseif effectType == "zombieEffect" and hitZombies then
					for _, hitZombie in hitZombies do
						handler(shooter, hitZombie, effectData, skillData) -- Apply effects on each hit zombie
					end
				else
					handler(shooter, ws, effectData, skillData) -- Apply non-zombie related effects (e.g., damage increase)
				end
			end
		end
	end

	return ws
end

function skillService.getSkillData(player, skillName)
	local skillInfo = skillLookup[skillName]
	if not skillInfo then
		error(`Skill not found: {skillName}`)
	end

	local profile = playerDataService.getProfile(player)
	if profile then
		return profile.Data.skillTree[skillInfo.class][skillInfo.index]
	end

	error("Player profile not found")
end

function skillService.getEquippedWeaponClass(player, weaponType)
	local profile = playerDataService.getProfile(player)
	if profile then
		return profile.Data.weaponClass
	end

	error("Player profile not found")
end

function skillService.start()
	for weaponClass, skills in skillConfig do
		for i, data in skills do
			skillLookup[data.name] = { class = weaponClass, index = i }
		end
	end

	zap.getFirerate.SetCallback(function(player)
		local profile = playerDataService.getProfile(player)
		local isPistol = profile.Data.weaponClass == "pistol"
		local isSMG = profile.Data.weaponClass == "smg"
		local isShotgun = profile.Data.weaponClass == "shotgun"

		local speedFire = skillService.getSkillData(player, "Speed Fire")
		local rapidFire = skillService.getSkillData(player, "Rapid Fire")
		local fightOrFlight = skillService.getSkillData(player, "Fight or Flight")

		if fightOrFlight.level > 0 and isShotgun then
			local cooldownMultiplier = 1 - (0.05 * fightOrFlight.level)
			return cooldownMultiplier
		end
		if rapidFire.level > 0 and isSMG then
			local cooldownMultiplier = 1 - (0.02 * rapidFire.level)
			return cooldownMultiplier
		end

		if isPistol and speedFire.level > 0 then
			return 0.625
		end

		return 1
	end)

	zap.upgradeSkill.SetCallback(function(player, data)
		local profile = playerDataService.getProfile(player)
		local skillData = profile.Data.skillTree[data.weapon][data.skill]
		local skillInfo = skillConfig[data.weapon][data.skill]

		if not skillInfo.costs[skillData.level + 1] then
			return
		end

		if
			skillData.unlocked
			and profile.Data.rampageEssence >= skillInfo.costs[skillData.level + 1]
		then
			profile.Data.rampageEssence -= skillInfo.costs[skillData.level + 1]
			skillData.level += 1
			zap.playSound.Fire(player, "Upgrade")
		elseif not skillData.unlocked and profile.Data.skillPoints >= skillInfo.skillPointCost then
			skillData.unlocked = true
			profile.Data.skillPoints -= skillInfo.skillPointCost
			zap.playSound.Fire(player, "Unlock")
		else
			zap.playSound.Fire(player, "PurchaseFail")
		end
		playerDataService.setProfile(player, profile)
		zap.updatedSkillUi.Fire(player, {
			data = skillData,
			info = skillInfo,
			id = data.skill,
			skillTree = profile.Data.skillTree,
			weapon = data.weapon,
		})
	end)
end

return skillService
