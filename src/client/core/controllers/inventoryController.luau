local ReplicatedStorage = game:GetService("ReplicatedStorage")
local zap = require(ReplicatedStorage.zap)
local inventoryController = {}

local function equipWeapon(weaponName: string)
	zap.equipWeapon.Fire(weaponName)
end

function inventoryController.start()
	-- equipWeapon("Starter Pistol")
end

return inventoryController
