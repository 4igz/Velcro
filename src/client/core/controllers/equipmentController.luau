local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local equipmentController = {}

function equipmentController.start()
	-- Listen to the G keybind using context action service
	game.ContextActionService:BindAction(
		"UseEquipment",
		function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				-- Equip the grenade
				equipmentController.useEquipment()
			end
		end,
		false,
		Enum.KeyCode.G
	)
end

-- Function to check what type of equipment the player has equipped
function equipmentController.hasEquipment()
	local character = localPlayer.Character
	if not (character and character.Parent) then
		return false
	end
	return localPlayer:GetAttribute("HasEquipment")
end

function equipmentController.useEquipment()
	-- Check if the player has any grenades
	if not equipmentController.hasEquipment() then
		return
	end

	local equipmentType = localPlayer:GetAttribute("EquipmentType")
end

return equipmentController
