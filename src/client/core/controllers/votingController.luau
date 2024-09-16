local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local zap = require(ReplicatedStorage.zap)
local votingController = {}

local function setupVotingBoards(votingBoards)
	for _, votingUi in votingBoards do
		local bg = votingUi:WaitForChild("BG")
		local vote: TextButton = bg:WaitForChild("Vote")

		vote.MouseButton1Click:Connect(function()
			zap.voteForMap.Fire(votingUi:GetAttribute("map"))
		end)
	end
end

function votingController.start()
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

return votingController
