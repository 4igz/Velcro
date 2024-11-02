local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local uiController = {}

local gui = Instance.new("ScreenGui")
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

function uiController.getUi(name, ignoreInset)
	local newUi = gui:Clone()
	newUi.Name = name
	newUi.IgnoreGuiInset = ignoreInset or false
	newUi.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	return newUi
end

return uiController
