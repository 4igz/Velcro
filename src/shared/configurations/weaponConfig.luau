export type Settings = {
	maxBulletSpreadAngle: number?,
	minBulletSpreadAngle: number?,
	fireCooldown: number?,
	bulletSpeed: number?,
	bulletDrop: number?,
	lifetime: number?,
	bullets: number?, -- How many bullets fire per shot
	damage: number?,
	magSize: number?,
	range: number?,
	reloadTime: number?,
	zoneSize: number?, -- Only applies to gasExplosion hitType
	damageRate: number?, -- How long before you can hit the same person again with the weapon
	bulletName: string?, -- The name of the bullet in ServerStorage>BulletTemplates
	raycastBeamColor: Color3?,
	showDamageText: boolean?,
	meleeAttackLength: number?, -- How long to detect hits for with weapon while attacking
	image: number?, -- Image shown in inventory and toolbar
	allowRandomKill: boolean?,
	allowTeamKill: boolean?,
	maxPierce: number?,
	walkspeed: number?,

	itemType: ("gun" | "melee" | "equipment")?,
	bulletType: ("melee" | "raycast" | "projectileBullet")?, -- The BulletType function to run on firing
	hitType: ("normal" | "taser" | "heal")?, -- The HitType function to run on hit
	reloadType: ("mag" | "charge")?,
	hitVisual: ("none" | "highlight")?,
	visualReplicationType: ("all" | "shooter" | "victim" | "both")?,
	anims: {}?,
	sounds: {}?,
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
	walkspeed = 16,

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
		damage = 20,
		bulletType = "raycast",
		hitType = "normal",
		hitVisual = "highlight",
		itemType = "gun",
		fireCooldown = 0.2,
		walkspeed = 18,
	},

	["Katana"] = {
		damage = 100,
		bulletType = "melee",
		itemType = "melee",
		walkspeed = 18,
	},

	["Sawed-Off Shotgun"] = {
		damage = 25,
		bullets = 8,
		fireCooldown = 1,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 8,
		sounds = {
			fire = "ShotgunFire",
			reload = "ShotgunReload",
		},
		itemType = "gun",
	},

	["BNT-2"] = {
		damage = 15,
		bullets = 8,
		fireCooldown = 0.8,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 12,
		sounds = {
			fire = "ShotgunFire",
			reload = "ShotgunReload",
		},
		itemType = "gun",
	},

	["Super90"] = {
		damage = 12,
		bullets = 8,
		fireCooldown = 0.6,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 12,
		sounds = {
			fire = "ShotgunFire",
			reload = "ShotgunReload",
		},
		itemType = "gun",
	},
	["Jacket 3"] = {
		damage = 16,
		bullets = 8,
		fireCooldown = 1.2,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 12,
		sounds = {
			fire = "ShotgunFire",
			reload = "ShotgunReload",
		},
		itemType = "gun",
	},

	-- Pistols
	["Deagle"] = {
		damage = 80,
		headshotDamage = 120,
		walkspeed = 22,
		fireCooldown = 0.5,
		attackDodgeChance = 0.1,
		itemType = "gun",
	},

	-- SMGs
	["SMG-2"] = {
		damage = 5,
		walkspeed = 16.5,
		fireCooldown = 0.1,
		itemType = "gun",
	},

	["VC-5"] = {
		damage = 6,
		walkspeed = 16.5,
		fireCooldown = 0.1,
		itemType = "gun",
	},

	["PM12"] = {
		damage = 6,
		walkspeed = 16.5,
		fireCooldown = 0.05,
		itemType = "gun",
	},

	["VP70"] = {
		damage = 7,
		walkspeed = 17,
		fireCooldown = 0.05,
		itemType = "gun",
	},

	["AR57"] = {
		damage = 9,
		walkspeed = 17,
		fireCooldown = 0.04,
		itemType = "gun",
	},

	-- Snipers
	["AWP"] = {
		damage = 35,
		maxPierce = 15,
		fireCooldown = 2,
		itemType = "gun",
	},

	["Moisin"] = {
		damage = 20,
		maxPierce = 12,
		fireCooldown = 2.5,
		itemType = "gun",
	},

	["LaserBadger"] = {
		damage = 80,
		maxPierce = 25,
		fireCooldown = 1.2,
		itemType = "gun",
	},

	["BFG-5000"] = {
		damage = 50,
		pierce = 20,
		fireCooldown = 1.5,
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
