local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local energyDisplay = require(ReplicatedStorage.client.reactComponents.energyDisplay)
local zap = require(ReplicatedStorage.zap)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.Name = "Energy"
local root = ReactRoblox.createRoot(gui)

local energyController = {}

function energyController.start()
	zap.UpdateEnergy.SetCallback(function(data)
		root:render(React.createElement(energyDisplay, {
			text = data.energy,
		}))
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			zap.GetEnergy.Fire()
		end

		if input.KeyCode == Enum.KeyCode.K then
			zap.BuyGenerator.Fire({ generatorName = "dirt", amt = 1 })
		end
	end)
end

return energyController
