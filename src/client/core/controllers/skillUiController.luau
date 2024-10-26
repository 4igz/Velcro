local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local skillUi = require(ReplicatedStorage.client.reactComponents.skillUi)
local uiController = require(script.Parent.uiController)
local zap = require(ReplicatedStorage.zap)
local skillUIController = {}
local gui = uiController.getUi("SkillUi")
local root = ReactRoblox.createRoot(gui)

local visible = false

local function app(props)
	return React.createElement(skillUi, props)
end

local function refresh(skillTree)
	skillTree = skillTree or zap.getSkillTree.Call()
	local points = zap.getSkillPoints.Call()
	root:render(app({
		visible = visible,
		skillTree = skillTree,
		rampageEssence = points.rampageEssence,
		skillPoints = points.skillPoints,
		onClose = function()
			skillUIController.toggleUi(false)
		end,
	}))
end

function skillUIController.toggleUi(value)
	visible = value
	local skillTree

	if visible then
		skillTree = zap.getSkillTree.Call()
	end

	local points = zap.getSkillPoints.Call()

	root:render(app({
		visible = value,
		skillTree = skillTree,
		rampageEssence = points.rampageEssence,
		skillPoints = points.skillPoints,
		onClose = function()
			skillUIController.toggleUi(false)
		end,
	}))
end

function skillUIController.start()
	zap.updatedSkillUi.SetCallback(function(skillData)
		refresh(skillData.skillTree)
	end)
end

return skillUIController
