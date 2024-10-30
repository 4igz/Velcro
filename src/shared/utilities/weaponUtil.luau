local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap

export type firedShotsDataForServer = {
	[number]: {
		distance: number,
		victim: Player?,
		hitPos: Vector3,
		rayHit: Instance?,
	},
}

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

function weaponUtil.raycastForBullets(
	character: Model,
	originalPosition: Vector3,
	direction: Vector3,
	distance: number,
	givenParams: RaycastParams?
)
	local params = givenParams
	-- We add default ignores to the params
	if params then
		params:AddToFilter({ workspace.Terrain, workspace.RaycastIgnore })
	else
		params = RaycastParams.new()
		params.FilterDescendantsInstances =
			{ workspace.Terrain, character, workspace.RaycastIgnore }
		params.FilterType = Enum.RaycastFilterType.Exclude
	end

	local originPosition = originalPosition
	local totalDistance = 0
	local castResult
	local castsNumber = 0
	while distance > 0.1 and castsNumber < 15 do
		castResult = workspace:Raycast(originPosition, direction.Unit * distance, params)
		local acceptedResult = true
		-- We ignore non functional accessories
		if castResult then
			local hitPart = castResult.Instance
			if hitPart and hitPart:IsA("BasePart") and hitPart.Parent:IsA("Accessory") then
				params:AddToFilter(hitPart.Parent)
				acceptedResult = false
			end
		end
		castsNumber += 1
		local thisTravelledDistance = castResult
				and (castResult.Position - originPosition).Magnitude
			or distance
		if acceptedResult then
			totalDistance += thisTravelledDistance
			break
		else
			originPosition = castResult.Position
			distance -= thisTravelledDistance
			totalDistance += thisTravelledDistance
		end
	end

	return castResult, totalDistance
end

function weaponUtil.getSpreadDirectionFromSettings(
	rawDirection: Vector3,
	currentWs: weaponConfig.Settings,
	randomData: any
)
	local randomObject = randomData.object
	local zrandom = randomObject:NextNumber(0, math.pi * 2)
	local xrandom = math.rad(
		randomObject:NextNumber(currentWs.minBulletSpreadAngle, currentWs.maxBulletSpreadAngle)
	)
	local direction = (CFrame.new(Vector3.new(), rawDirection) * CFrame.fromOrientation(
		0,
		0,
		zrandom
	) * CFrame.fromOrientation(xrandom, 0, 0)).LookVector

	randomData.randomCalls += 2 -- This has to match the number of times the random object is called per bullet, which is currently 2
	return direction
end

function weaponUtil.getShopConfig(weaponName): shopConfig.ShopConfig?
	for _, shopCfg in shopConfig do
		if shopCfg.name == weaponName then
			return shopCfg
		end
	end
	if not weaponConfig.settings[weaponName] then
		return error(`No weapon named {weaponName}`)
	end
	return
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
