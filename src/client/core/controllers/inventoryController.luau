local ReplicatedStorage = game:GetService("ReplicatedStorage")
local zap = require(ReplicatedStorage.zap)
local inventoryController = {}

local function equipWeapon(weaponName: string)
	zap.equipWeapon.Fire({ weaponName = weaponName })
end

function inventoryController.start()
	equipWeapon("starter pistol")
end

return inventoryController
