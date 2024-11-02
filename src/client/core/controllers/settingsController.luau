local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local settingsConfig = require(ReplicatedStorage.shared.configurations.settingsConfig)
local settingsUi = require(ReplicatedStorage.client.reactComponents.settingsUi)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local uiController = require(script.Parent.uiController)
local zap = require(ReplicatedStorage.zap)
local settingsController = {}

local ui = uiController.getUi("Settings")
local root = ReactRoblox.createRoot(ui)

local disableZombieVFX = false

local function app(props)
	local savedSettings = zap.getSettings.Call()
	return React.createElement(
		settingsUi,
		Sift.Dictionary.join(
			props,
			{ savedSettings = savedSettings, close = settingsController.close }
		)
	)
end

function settingsController.open()
	root:render(app({ visible = true }))
end

function settingsController.close()
	root:render(app({ visible = false }))
end

function settingsController.start()
	local savedSettings
	repeat
		savedSettings = zap.getSettings.Call()
		if not savedSettings then
			warn("Failed to get settings from server, retrying...")
			wait(1) -- Wait for 1 second before retrying
		end
	until savedSettings

	-- call the step function of each setting with its saved setting value
	for categoryName, category in settingsConfig do
		for name, setting in category do
			if savedSettings[categoryName] and savedSettings[categoryName][name] then
				setting.stepFunction(savedSettings[categoryName][name])
			else
				warn(
					"Missing setting for category: "
						.. tostring(categoryName)
						.. ", name: "
						.. tostring(name)
				)
			end
		end
	end

	sharedInfo.UISignals.toggleZombieVFX:Connect(function(value)
		disableZombieVFX = value
		for _, zombie in workspace.Zombies:GetChildren() do
			for _, v in zombie:GetDescendants() do
				if v:IsA("ParticleEmitter") then
					v.Enabled = value
				end
			end
		end
	end)

	workspace.Zombies.ChildAdded:Connect(function(zombie)
		if disableZombieVFX then
			for _, v in zombie:GetDescendants() do
				if v:IsA("ParticleEmitter") then
					v.Enabled = false
				end
			end
		end
	end)
end

return settingsController
