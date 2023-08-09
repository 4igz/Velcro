-- A relatively basic player data service that is fully functional.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local ProfileService = require(ServerStorage.serverPackages.ProfileService)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)

local Profiles = {} -- [player] = profile

local playerDataService = {}

-- ProfileTemplate table is what empty profiles will default to.
playerDataService.ProfileTemplate = {
	Credits = 500,
	Level = 1,
}

local ProfileStore = ProfileService.GetProfileStore("PlayerData", playerDataService.ProfileTemplate)
playerDataService.playerDataLoaded = Signal.new()
playerDataService.playerDataChanged = Signal.new()

local function playerAdded(player: Player)
	local profile = ProfileStore:LoadProfileAsync(`Player_{player.UserId}`)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			playerDataService.playerDataLoaded:Fire(player)
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick()
	end
end

function playerDataService.start()
	-- Create profile for players who could have joined before this script started.
	for _, player in Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	Players.PlayerAdded:Connect(playerAdded)

	Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end)
end

-- Gives a copy of the profile rather than the actual profile for immutability purposes
function playerDataService.getProfile(player: Player): any?
	return table.clone(Profiles[player])
end

function playerDataService.setProfile(player: Player, newProfile)
	Profiles[player] = newProfile
	playerDataService.playerDataChanged:Fire(player, newProfile)
end

return playerDataService
