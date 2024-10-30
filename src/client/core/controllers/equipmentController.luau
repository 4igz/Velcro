-- Services
local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Modules
local equipmentConfig = require(ReplicatedStorage.shared.configurations.equipmentConfig)
local zap = require(ReplicatedStorage.zap)

-- Local Player and Mouse
local localPlayer = Players.LocalPlayer
local camera = workspace.Camera :: Camera
local mouse = localPlayer:GetMouse()

-- Equipment Controller Module
local equipmentController = {}

-- Table to keep track of tool connections (optional for cleanup)
local toolConnections = {}

local params = RaycastParams.new()
params.FilterDescendantsInstances = { workspace.RaycastIgnore }
params.FilterType = Enum.RaycastFilterType.Exclude

local function getMobileAdjustedCenterScreenRay()
	-- Get the center of the screen for mobile shooting
	local viewportSize = camera.ViewportSize
	local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

	-- Adjust the Y value to move the crosshair slightly higher
	local adjustedY = screenCenter.Y - 87 -- Adjust this value to move the crosshair higher or lower

	-- Return the ray cast from the adjusted position
	return camera:ScreenPointToRay(screenCenter.X, adjustedY)
end

function equipmentController.hasEquipment(name)
	for _, tool in localPlayer.Character:GetChildren() do
		if equipmentConfig[tool.Name] and tool.Name == name then
			return tool.Name
		end
	end
	for _, tool in localPlayer.Backpack:GetChildren() do
		if equipmentConfig[tool.Name] and tool.Name == name then
			return tool.Name
		end
	end
	return false
end

-- Function to handle equipment usage
function equipmentController.useEquipment(name)
	local hitPosition = mouse.Hit

	-- Get hit position of crosshair on mobile
	if UserInputService.TouchEnabled then
		local ray = getMobileAdjustedCenterScreenRay()
		params.FilterDescendantsInstances = {
			workspace.RaycastIgnore,
			localPlayer.Character,
			CollectionService:GetTagged("ZombieSpawns"),
			CollectionService:GetTagged("SoundPart"),
		}
		local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
		if hit then
			hitPosition = hit.Position
		else
			-- If no hit, cast the ray outwards to max range
			hitPosition = ray.Origin + ray.Direction * 1000
		end
	end

	zap.useEquipment.Fire({ equipmentName = name, hitPos = hitPosition })
end

-- Function to connect the Activated event for a tool
local function connectTool(tool)
	if equipmentConfig[tool.Name] then
		toolConnections[tool] = tool.Activated:Connect(function()
			equipmentController.useEquipment(tool.Name)
		end)
	end
end

-- Function to disconnect the Activated event for a tool (optional for cleanup)
local function disconnectTool(tool)
	if toolConnections[tool] then
		toolConnections[tool]:Disconnect()
		toolConnections[tool] = nil
	end
end

-- Start function to initialize the controller
function equipmentController.start()
	localPlayer.Character.ChildAdded:Connect(connectTool)
	localPlayer.Character.ChildRemoved:Connect(disconnectTool)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.KeyCode == Enum.KeyCode.R and equipmentController.hasEquipment("Shield") then
			equipmentController.useEquipment("Shield")
		elseif input.KeyCode == Enum.KeyCode.F and equipmentController.hasEquipment("Grenade") then
			equipmentController.useEquipment("Grenade")
		end
	end)
end

return equipmentController
