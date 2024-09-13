export type Settings = {
	maxBulletSpreadAngle: number,
	minBulletSpreadAngle: number,
	fireCooldown: number,
	bulletSpeed: number,
	bulletDrop: number,
	lifetime: number,
	bullets: number, -- How many bullets fire per shot
	damage: number,
	magSize: number,
	range: number,
	reloadTime: number,
	zoneSize: number, -- Only applies to gasExplosion hitType
	damageRate: number, -- How long before you can hit the same person again with the weapon
	bulletName: string, -- The name of the bullet in ServerStorage>BulletTemplates
	raycastBeamColor: Color3,
	showDamageText: boolean,
	meleeAttackLength: number, -- How long to detect hits for with weapon while attacking
	image: number, -- Image shown in inventory and toolbar
	allowRandomKill: boolean,
	allowTeamKill: boolean,
	maxPierce: number,

	itemType: "gun" | "melee" | "equipment",
	bulletType: "melee" | "raycast" | "projectileBullet", -- The BulletType function to run on firing
	hitType: "normal" | "taser" | "heal", -- The HitType function to run on hit
	reloadType: "mag" | "charge",
	hitVisual: "none" | "highlight",
	visualReplicationType: "all" | "shooter" | "victim" | "both",
	anims: {},
	sounds: {},
}

local default: Settings = {
	maxBulletSpreadAngle = 0,
	minBulletSpreadAngle = 0,
	fireCooldown = 0.1,
	damage = 10,
	bullets = 1,
	range = 999,
	lifetime = 10,
	zoneSize = 15,
	raycastBeamColor = Color3.fromRGB(255, 255, 255),
	damageRate = 0.5,
	showDamageText = true,
	meleeAttackLength = 0.5,
	maxPierce = 3,

	itemType = "gun",
	bulletName = "bullet",
	bulletType = "raycast",
	hitType = "normal",
	hitVisual = "none",
	visualReplicationType = "shooter",

	anims = {
		idle = "rbxassetid://13726957002",
		run = "rbxassetid://13726960693",
		holster = "rbxassetid://13726959880",
		reload = "rbxassetid://13726958423",
	},

	sounds = {
		-- Name of sound in SoundService>Weapons
		-- Put "" for no sound
		fire = "P90Fire",
		reload = "P90Reload",
	},
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages

local Signal = require(sharedPackages.Signal)

local settings: { [string]: Settings } = {
	["Starter Pistol"] = {
		damage = 15,
		bulletType = "raycast",
		hitType = "normal",
		hitVisual = "highlight",
		itemType = "gun",
		fireCooldown = 0.1,
	},

	["Katana"] = {
		damage = 100,
		bulletType = "melee",
		itemType = "melee",
	},

	["Sawed-Off Shotgun"] = {
		damage = 20,
		bullets = 8,
		fireCooldown = 1,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 50,
		sounds = {
			fire = "ShotgunFire",
			reload = "ShotgunReload",
		},
		itemType = "gun",
	},

	["Double Barrel Shotgun"] = {
		damage = 15,
		hitType = "normal",
		bulletType = "raycast",
		bullets = 8,
		fireCooldown = 0.5,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 100,
		sounds = {
			fire = "ShotgunFire",
			reload = "ShotgunReload",
		},
		itemType = "gun",
	},
}

-- Applies to things that are not guns, like grenade pickups
local toolSettings: { [string]: Settings } = {
	["Grenade"] = {
		itemType = "equipment",
	},
}

return {
	settings = settings,
	toolSettings = toolSettings,
	default = default,
	signals = {
		targetHit = Signal.new(),
		bulletHit = Signal.new(),
		kill = Signal.new(),
		setAnim = Signal.new(),
		setReloading = Signal.new(),
		finishReload = Signal.new(),
	},
}
