local ReplicatedStorage = game:GetService("ReplicatedStorage")
local zap = require(ReplicatedStorage.zap)
local UserInputService = game:GetService("UserInputService")
local eggRollController = {}

function eggRollController.start()
	--
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.R then
			zap.RollEgg.Fire({ eggName = "basic", amt = 1 })
		end
	end)
end

return eggRollController
