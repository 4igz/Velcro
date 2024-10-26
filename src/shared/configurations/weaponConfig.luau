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
		damage = 28,
		headshotMultiplier = 1.5,
		bulletType = "raycast",
		hitType = "normal",
		hitVisual = "highlight",
		itemType = "gun",
		fireCooldown = 0.2,
		walkspeed = 18,
		sounds = {
			fire = "PistolFire",
		},
		anims = {
			idle = "rbxassetid://95617185581990",
		},
	},

	["Katana"] = {
		damage = 140,
		bulletType = "melee",
		itemType = "melee",
		walkspeed = 18,
	},

	["Jacket-3"] = {
		damage = 42,
		headshotMultiplier = 1.75,
		bullets = 8,
		fireCooldown = 0.8,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 40,
		walkspeed = 17,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
		anims = {
			idle = "rbxassetid://13726957002",
		},
	},

	["Sawed-Off Shotgun"] = {
		damage = 42,
		headshotMultiplier = 1.75,
		bullets = 8,
		fireCooldown = 0.8,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 40,
		walkspeed = 17,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
		anims = {
			idle = "rbxassetid://13726957002",
		},
	},

	["BNT-2"] = {
		damage = 48,
		headshotMultiplier = 1.75,
		bullets = 8,
		fireCooldown = 0.6,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 40,
		walkspeed = 17,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
		anims = {
			idle = "rbxassetid://13726957002",
		},
	},

	["Super90"] = {
		damage = 65,
		headshotMultiplier = 1.75,
		bullets = 8,
		fireCooldown = 0.6,
		minBulletSpreadAngle = 1,
		maxBulletSpreadAngle = 5,
		range = 40,
		walkspeed = 17,
		sounds = {
			fire = "ShotgunFire",
		},
		itemType = "gun",
		anims = {
			idle = "rbxassetid://13726957002",
		},
	},

	-- Pistols
	["Deagle"] = {
		damage = 112,
		headshotMultiplier = 2,
		walkspeed = 18,
		fireCooldown = 0.5,
		maxPierce = 3,
		attackDodgeChance = 0.3,
		sounds = {
			fire = "PistolFire",
		},
		itemType = "gun",
		anims = {
			idle = "rbxassetid://95617185581990",
		},
	},

	-- Assault Rifles
	["M4 Carbine"] = {
		damage = 7.5,
		headshotMultiplier = 1.2,
		walkspeed = 17,
		fireCooldown = 0.15,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	["Tommy Gun"] = {
		damage = 9,
		headshotMultiplier = 1.2,
		walkspeed = 17,
		fireCooldown = 0.12,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	["Scar-H"] = {
		damage = 15,
		headshotMultiplier = 1.2,
		walkspeed = 17,
		fireCooldown = 0.15,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	["Nova-9"] = {
		damage = 15,
		headshotMultiplier = 1.2,
		walkspeed = 17,
		fireCooldown = 0.1,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	["Viper"] = {
		damage = 14,
		headshotMultiplier = 1.2,
		walkspeed = 17,
		fireCooldown = 0.07,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	["Annihilator"] = {
		damage = 32,
		headshotMultiplier = 1.2,
		walkspeed = 18,
		fireCooldown = 0.1,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	["Nightfall"] = {
		damage = 80,
		headshotMultiplier = 2,
		walkspeed = 19,
		fireCooldown = 0.15,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	-- SMGs
	["SMG"] = {
		damage = 21,
		headshotMultiplier = 1.5,
		walkspeed = 18,
		fireCooldown = 0.1,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107113017419325",
		},
	},

	["VC-S"] = {
		damage = 24,
		headshotMultiplier = 1.5,
		walkspeed = 18,
		fireCooldown = 0.1,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107113017419325",
		},
	},

	["PM12"] = {
		damage = 24,
		headshotMultiplier = 1.5,
		walkspeed = 18,
		fireCooldown = 0.08,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107113017419325",
		},
	},

	["VP70"] = {
		damage = 26,
		headshotMultiplier = 1.5,
		walkspeed = 18,
		fireCooldown = 0.08,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107113017419325",
		},
	},

	["AR57"] = {
		damage = 28,
		headshotMultiplier = 1.5,
		walkspeed = 18,
		fireCooldown = 0.06,
		itemType = "gun",
		anims = {
			idle = "rbxassetid://107732452399041",
		},
	},

	-- Snipers
	["Moisin"] = {
		damage = 210,
		headshotMultiplier = 2,
		maxPierce = 4,
		fireCooldown = 1.5,
		itemType = "gun",
		sounds = {
			fire = "SniperFire",
		},
		anims = {
			idle = "rbxassetid://121962199292086",
		},
	},

	["AWP"] = {
		damage = 266,
		headshotMultiplier = 2,
		maxPierce = 5,
		fireCooldown = 2,
		itemType = "gun",
		sounds = {
			fire = "SniperFire",
		},
		anims = {
			idle = "rbxassetid://121962199292086",
		},
	},

	["BFG-5000"] = {
		damage = 490,
		headshotMultiplier = 2,
		maxPierce = 7,
		fireCooldown = 1.75,
		sounds = {
			fire = "SniperFire",
		},
		itemType = "gun",
		anims = {
			idle = "rbxassetid://121962199292086",
		},
	},

	["Laserbadger"] = {
		damage = 420,
		headshotMultiplier = 2,
		maxPierce = 5,
		fireCooldown = 1.2,
		itemType = "gun",
		sounds = {
			fire = "SniperFire",
		},
		anims = {
			idle = "rbxassetid://121962199292086",
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
