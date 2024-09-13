local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local bars = require(ReplicatedStorage.client.reactComponents.bars)
local zap = require(ReplicatedStorage.zap)

local localPlayer = Players.LocalPlayer

local barController = {}

local function app(props)
	return React.createElement(bars, props)
end

function barController.start()
	local root = ReactRoblox.createRoot(Instance.new("Folder", localPlayer.PlayerGui))

	localPlayer.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end
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
end

return barController
