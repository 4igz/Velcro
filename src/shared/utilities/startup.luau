local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local sharedPackages = ReplicatedStorage.sharedPackages
local sharedModules = ReplicatedStorage.shared

local Loader = require(sharedPackages.loader)

local startupUtil = {}

return function(path, components)
	local loadedServicesOrControllers

	if RunService:IsServer() then
		loadedServicesOrControllers = Loader.LoadDescendants(path)
	end

	if RunService:IsClient() then
		loadedServicesOrControllers = Loader.LoadDescendants(path)
	end

	for _, module in loadedServicesOrControllers do
		table.freeze(module)
	end

	Loader.SpawnAll(loadedServicesOrControllers, "start")
	Loader.LoadDescendants(components)
end
