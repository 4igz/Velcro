local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local reactComponents = ReplicatedStorage.client.reactComponents

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local button = require(ReplicatedStorage.client.reactComponents.button)

local localPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", localPlayer.PlayerGui)
gui.Name = "MainMenu"
gui.ResetOnSpawn = false

local mainMenuRoot = ReactRoblox.createRoot(gui)

local e = React.createElement

local mainMenu = {}

local function mainMenuApp(props)
	local controls =
		require(localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

	controls:Disable()

	local function startGame()
		mainMenu.startGame()
		controls:Enable()
	end

	local function openOptions()
		print("Opening options...")
		-- Options logic here
	end

	-- Menu container that renders menu components
	return e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Transparency = 1,
		-- Visible = not props.started,
	}, {
		StartGameButton = e(button, {
			text = "Start Game",
			position = UDim2.new(0.5, 0, 0.5, 0),
			onClick = startGame,
			color = Color3.new(0.55, 0.85, 0.45),
		}),
		OptionsButton = e(button, {
			text = "Options",
			position = UDim2.new(0.5, 0, 0.75, 0),
			onClick = openOptions,
			color = Color3.new(0.36, 0.36, 1),
		}),
		-- Additional buttons or menu items can be added here
	})
end

function mainMenu.start()
	mainMenuRoot:render(React.createElement(mainMenuApp))
end

function mainMenu.startGame()
	mainMenuRoot:unmount()
end

return mainMenu
