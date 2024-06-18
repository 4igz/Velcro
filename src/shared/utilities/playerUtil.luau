local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages

local Promise = require(sharedPackages.Promise)
local Sift = require(sharedPackages.Sift)

local DEFAULT_PLAYER_GROUP_RANK = 0
local DEFAULT_GROUP_ROLE = "Guest"

local playerGroupRankCache = {}
local playerIconCache = {}
local playerGroupRoleCache = {}

local playerUtil = {}

function playerUtil.playerFromInstance(descendant: Instance): Player?
	while descendant.Parent do
		local player = Players:GetPlayerFromCharacter(descendant)

		if player then
			return player
		end

		descendant = descendant.Parent
	end

	return nil
end

function playerUtil.playerFromName(name: string)
	for _, player in Players:GetPlayers() do
		if player.Name == name then
			return player
		end
	end
end

function playerUtil.getHumanoidDescriptionFromUserId(userId: number)
	local playerDescription
	local success = pcall(function()
		playerDescription = Players:GetHumanoidDescriptionFromUserId(userId)
	end)
	while not success do
		task.wait()
		success = pcall(function()
			playerDescription = Players:GetHumanoidDescriptionFromUserId(userId)
		end)
	end
	return playerDescription
end

return table.freeze(playerUtil)
