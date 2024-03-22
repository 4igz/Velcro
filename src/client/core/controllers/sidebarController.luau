local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hudUi = require(ReplicatedStorage.client.reactComponents.sidebar)

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.Name = "HUD"

local hudUiController = {}

function hudUiController.start()
	hudUi(gui)
end

return hudUiController
