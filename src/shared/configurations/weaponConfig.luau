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
	headshotMultiplier: number?,

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
		fire = "SMGFire",
	},
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages

local Signal = require(sharedPackages.Signal)

local settings: { [string]: Settings } = {
	["Starter Pistol"] = {
		damage = 20,
		headshotMultiplier = 1.5,
		bulletType = "raycast",
		hitType = "normal",
		hitVisual = "highlight",
		itemType = "gun",
		fireCooldown = 0.2,
		walkspeed = 16,
		sounds = {
			fire = "PistolFire",
		},
	},

	["Katana"] = {
		damage = 100,
		bulletType = "melee",
		itemType = "melee",
		walkspeed = 18,
	},

	["Jacket-3"] = {
		damage = 25,
		headshotMultiplier = 1.5,
		bullets = 8,
		fireCooldown = 1.2,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 30,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
	},

	["Sawed-Off Shotgun"] = {
		damage = 20,
		headshotMultiplier = 1.5,
		bullets = 8,
		fireCooldown = 1,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 20,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
	},

	["BNT-2"] = {
		damage = 35,
		headshotMultiplier = 1.5,
		bullets = 8,
		fireCooldown = 0.8,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 30,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
	},

	["Super90"] = {
		damage = 45,
		headshotMultiplier = 1.5,
		bullets = 8,
		fireCooldown = 0.6,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 40,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
	},

	-- Pistols
	["Deagle"] = {
		damage = 80,
		headshotMultiplier = 1.5,
		headshotDamage = 120,
		walkspeed = 22,
		fireCooldown = 0.5,
		maxPierce = 10,
		attackDodgeChance = 0.1,
		sounds = {
			fire = "PistolFire",
		},
		itemType = "gun",
	},

	-- SMGs
	["SMG"] = {
		damage = 15,
		headshotMultiplier = 1.5,
		walkspeed = 16.5,
		fireCooldown = 0.1,
		itemType = "gun",
	},

	["VC-S"] = {
		damage = 17,
		headshotMultiplier = 1.5,
		walkspeed = 17,
		fireCooldown = 0.1,
		itemType = "gun",
	},

	["PM12"] = {
		damage = 19,
		headshotMultiplier = 1.5,
		walkspeed = 18,
		fireCooldown = 0.05,
		itemType = "gun",
	},

	["VP70"] = {
		damage = 20,
		headshotMultiplier = 1.5,
		walkspeed = 18.5,
		fireCooldown = 0.05,
		itemType = "gun",
	},

	["AR57"] = {
		damage = 21,
		headshotMultiplier = 1.5,
		walkspeed = 19.5,
		fireCooldown = 0.04,
		itemType = "gun",
	},

	-- Snipers
	["Moisin"] = {
		damage = 45,
		headshotMultiplier = 2,
		maxPierce = 12,
		fireCooldown = 2.5,
		itemType = "gun",
		sounds = {
			fire = "SniperFire",
		},
	},

	["AWP"] = {
		damage = 70,
		headshotMultiplier = 2,
		maxPierce = 15,
		fireCooldown = 2,
		itemType = "gun",
		sounds = {
			fire = "SniperFire",
		},
	},

	["BFG-5000"] = {
		damage = 100,
		headshotMultiplier = 2,
		maxPierce = 20,
		fireCooldown = 1.5,
		sounds = {
			fire = "SniperFire",
		},
		itemType = "gun",
	},

	["Laserbadger"] = {
		damage = 150,
		headshotMultiplier = 2,
		maxPierce = 25,
		fireCooldown = 0.8,
		itemType = "gun",
		sounds = {
			fire = "SniperFire",
		},
	},
}

-- Applies to tools that are not guns, like grenades
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
