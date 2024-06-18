local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap

local getState

if RunService:IsClient() then
	zap = require(ReplicatedStorage.zap)

	getState = function(_)
		return zap.getPlayerState.Call()
	end
else
	local playerStateService = require(ServerStorage.server.services.playerStateService)

	getState = function(player)
		return playerStateService.getPlayerState(player)
	end
end

local weaponUtil = {}

function weaponUtil.getShopConfig(weaponName): shopConfig.ShopConfig
	for _, shopCfg in shopConfig do
		if shopCfg.name == weaponName then
			return shopCfg
		end
	end
	if not weaponConfig.settings[weaponName] then
		return error(`No weapon named {weaponName}`)
	end
end

function weaponUtil.getWeaponsByType(itemType: "gun" | "melee" | "equipment")
	local filteredWeapons = {}
	for name, weapon in weaponConfig.settings do
		if weapon.itemType == itemType then
			if weaponUtil.getShopConfig(name) ~= nil then
				table.insert(filteredWeapons, name)
			end
		end
	end
	return filteredWeapons
end

function weaponUtil.folder(name: string, parent: Instance)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

return weaponUtil
