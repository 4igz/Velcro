local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

local zap = require(ReplicatedStorage.zap)
local mapController = {}

local function setupVotingBoards(votingBoards)
	for _, votingUi in votingBoards do
		local bg = votingUi:WaitForChild("BG")
		local vote: TextButton = bg:WaitForChild("Vote")

		vote.MouseButton1Click:Connect(function()
			zap.voteForMap.Fire(votingUi:GetAttribute("map"))
		end)
	end
end

function mapController.start()
	----- Teleport to maps:
	zap.tpToMap.SetCallback(function(mapName)
		local map = workspace.MapContainer.MapContent[mapName]
		map:WaitForChild("Floor")

		local spawnRadius = 10

		-- Generate random offset for the player spawn location
		local randomOffsetX = math.random(-spawnRadius, spawnRadius)
		local randomOffsetZ = math.random(-spawnRadius, spawnRadius)
		local spawnLocation = map:WaitForChild("SpawnLocation")	

		-- Create a new CFrame for the spawn location with the random offset
		local randomSpawnPosition = spawnLocation.CFrame
			* CFrame.new(randomOffsetX, 0, randomOffsetZ)
		localPlayer.Character:PivotTo(randomSpawnPosition)
	end)

	----- Setup voting:
	local numVotingBoards = workspace:GetAttribute("NumVotingBoards") or 4
	local votingBoards = CollectionService:GetTagged("VotingBoard")

	-- Check if the current number of boards matches NumVotingBoards
	if #votingBoards < numVotingBoards then
		local addedConnection
		addedConnection = CollectionService:GetInstanceAddedSignal("VotingBoard")
			:Connect(function(newInstance)
				votingBoards = CollectionService:GetTagged("VotingBoard")
				if #votingBoards == numVotingBoards then
					addedConnection:Disconnect()
					setupVotingBoards(votingBoards)
				end
			end)
	else
		setupVotingBoards(votingBoards)
	end
end

return mapController
