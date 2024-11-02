local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local mainMenu = require(ReplicatedStorage.client.reactComponents.mainMenu)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)
local mainMenuController = {}

local gui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Name = "MainUI"
local root = ReactRoblox.createRoot(gui)

local currentMenu = "main"

local hasDeployed = false

local function app(props)
	return React.createElement(mainMenu, props)
end

function mainMenuController.changeMenu(menuName, props)
	if currentMenu == menuName then
		root:render(app(Sift.Dictionary.merge({ menu = "none" }, props or {}))) -- Close the shop if already open
		currentMenu = "none"
	else
		root:render(app(Sift.Dictionary.merge({ menu = menuName }, props or {}))) -- Open the specified menu
		currentMenu = menuName
	end
end

local function deploy()
	-- Remove the main menu, show HUD
	sharedInfo.UISignals.deployed:Fire()

	-- Inform the server that the player has deployed
	if not hasDeployed then
		hasDeployed = true
		zap.deployed.Fire()
	end
end

-- Get xp info from the server
root:render(app({ onDeployClicked = deploy, levelData = {}, menu = "none" }))
task.defer(function()
	deploy()
end)

return mainMenuController
