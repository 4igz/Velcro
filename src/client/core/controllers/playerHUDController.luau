local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local playerHUD = require(ReplicatedStorage.client.reactComponents.playerHUD)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)
local playerHUDController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Name = "PlayerHUD"

local localPlayer = Players.LocalPlayer
local root = ReactRoblox.createRoot(gui)

local listeningToUIUpdates = false

local function app(props)
	return React.createElement(playerHUD, props)
end

local function listenToDeploy(root)
	sharedInfo.UISignals.deployed:Once(function()
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid", 5)

		humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			root:render(
				app({ health = math.round(humanoid.Health), maxHealth = humanoid.MaxHealth })
			)
		end)

		local levelData = zap.getLevelData.Call()

		root:render(app({
			health = math.round(humanoid.Health),
			maxHealth = humanoid.MaxHealth,
			level = levelData.level,
			xp = levelData.xp,
			xpMax = levelData.xpMax,
		}))

		if not listeningToUIUpdates then
			listeningToUIUpdates = true

			localPlayer.CharacterAdded:Connect(function(character)
				humanoid = character:WaitForChild("Humanoid", 5)
				if not humanoid then
					return
				end
				root:render(
					app({ health = math.round(humanoid.Health), maxHealth = humanoid.MaxHealth })
				)

				humanoid:GetPropertyChangedSignal("Health"):Connect(function()
					root:render(
						app({ health = math.round(humanoid.Health), maxHealth = humanoid.MaxHealth })
					)
				end)
			end)

			zap.updateLevelUi.SetCallback(function(levelData)
				local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
				local humanoid = character:WaitForChild("Humanoid", 5)

				root:render(app({
					health = math.round(humanoid.Health),
					maxHealth = humanoid.MaxHealth,
					level = levelData.level,
					xp = levelData.xp,
					xpMax = levelData.xpMax,
				}))
			end)
		end
	end)
end

function playerHUDController.setVisibility(value)
	root:render(app({ visible = value }))
end

function playerHUDController.start()
	listenToDeploy(root)

	-- TODO: Unmount UI when undeployed
	-- TODO: When undeployed, listen to deploy again
end

return playerHUDController
