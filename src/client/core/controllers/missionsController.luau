local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local missionUi = require(ReplicatedStorage.client.reactComponents.missionUi)
local uiController = require(script.Parent.uiController)
local zap = require(ReplicatedStorage.zap)
local missionController = {}

local ui = uiController.getUi("MissionUi")
local root = ReactRoblox.createRoot(ui)

local function app(props)
	return React.createElement(missionUi, props)
end

function missionController.open()
	-- Open the missions UI with mission information
	local missionInfo = zap.getPlayerMissions.Call()
	root:render(
		app({ visible = true, missionInfo = missionInfo, onClose = missionController.close })
	)
end

function missionController.close()
	-- Close the missions UI
	root:render(app({ visible = false }))
end

function missionController.start()
	-- Initialize the UI in a closed state
	root:render(app({ visible = false }))
end

return missionController
