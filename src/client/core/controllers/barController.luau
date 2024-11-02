local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local bars = require(ReplicatedStorage.client.reactComponents.bars)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)

local localPlayer = Players.LocalPlayer

local barController = {}

local gui = Instance.new("ScreenGui", localPlayer.PlayerGui)
gui.Name = "bars"
gui.ResetOnSpawn = false

local function app(props)
	return React.createElement(bars, props)
end

function barController.start()
	if true then
		return
	end
	local root = ReactRoblox.createRoot(gui)

	localPlayer.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end
		root:render(app({ health = humanoid.Health, maxHealth = humanoid.MaxHealth }))

		humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			root:render(app({ health = humanoid.Health, maxHealth = humanoid.MaxHealth }))
		end)
	end)
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid", 5)

	local levelData = zap.getLevelData.Call()

	root:render(app({
		health = humanoid.Health,
		maxHealth = humanoid.MaxHealth,
		level = levelData.level,
		xp = levelData.xp,
		xpMax = levelData.xpMax,
	}))

	zap.updateLevelUi.SetCallback(function(levelData)
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid", 5)

		root:render(app({
			health = humanoid.Health,
			maxHealth = humanoid.MaxHealth,
			level = levelData.level,
			xp = levelData.xp,
			xpMax = levelData.xpMax,
		}))
	end)
end

return barController
