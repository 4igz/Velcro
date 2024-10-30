-- Assuming you have a Promise library available
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local sharedPackages = ReplicatedStorage.sharedPackages

local Loader = require(sharedPackages.loader)
local Promise = require(ReplicatedStorage.sharedPackages.Promise)

-- Function to start modules and return a Promise
return function(path, components)
	local loadedServicesOrControllers

	if RunService:IsServer() then
		loadedServicesOrControllers = Loader.LoadDescendants(path)
	end

	if RunService:IsClient() then
		loadedServicesOrControllers = Loader.LoadDescendants(path)
	end

	for _, module in ipairs(loadedServicesOrControllers) do
		table.freeze(module)
	end

	-- Create a table to hold all promises
	local startPromises = {}

	-- Iterate through each module and start it, collecting promises
	for _, module in loadedServicesOrControllers do
		if typeof(module.start) == "function" then
			table.insert(
				startPromises,
				Promise.new(function(resolve, reject)
					local success, err = pcall(function()
						module.start()
					end)
					if success then
						resolve()
					else
						reject(err)
					end
				end)
			)
		end
	end

	-- Return a promise that resolves when all modules have started
	return Promise.all(startPromises)
		:andThen(function()
			-- Optionally load additional components after all modules have started
			Loader.LoadDescendants(components)
		end)
		:catch(function(err)
			warn("Error starting modules:", err)
		end)
end
