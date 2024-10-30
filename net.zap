
opt server_output = "path/to/server/init.luau"
opt client_output = "path/to/client/init.luau"

type Skill = struct {
    unlocked: boolean,
    level: i32
}

type WeaponSkills = map {
    [string]: Skill
}

type SkillTree = struct {
    pistol: WeaponSkills,
    sniper: WeaponSkills,
    shotgun: WeaponSkills,
    rifle: WeaponSkills,
    smg: WeaponSkills,
}

funct getSkillTree = {
    call: Async,
    rets: unknown,
}

event updatedSkillUi = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: unknown,
}

event upgradeSkill = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        weapon: string,
        skill: i32,
    }
}

funct getFirerate = {
    call: Async,
    rets: f64
}

event joinCurrentRound = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
}

funct getSkillPoints = {
    call: Async,
    rets: struct {
        skillPoints: i32,
        rampageEssence: i32,
    },
}

event buyWeapon = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        weaponName: string,
        weaponType: string,
    }
}

event equipWeapon = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: string, -- WeaponName
}


event fireGun = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        hitPos: Vector3,
        rayHit: Instance?
    }
}

event melee = {
    from: Client,
    type: Unreliable,
    call: SingleAsync,
}

funct getPlayerMissions = {
    call: Async,
    rets: unknown
}

funct claimMissionRewards = {
	call: Async,
	args: i32,
	rets: boolean,
}

event missionUpdated = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: unknown,
}

event missionGoalCompleted = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        taskId: i32,
        goalId: i32,
    },
}

event updateLbData = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: unknown
}

event replicateKill = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
}

funct getLbData = {
    call: Async,
    args: string,
    rets: unknown
}

event missionRewardClaimed = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        taskId: i32,
        goalId: unknown,
    },
}

event replicateHit = {
    from: Server,
    type: Unreliable,
    call: SingleAsync,
    data: struct {
        hitPart: Instance(BasePart)?,
        damage: f64,
        isCritical: boolean,
    }
}

event replicateCast = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		firepoint: Instance (Attachment),
		hit: Vector3,
		beamColor: unknown,
	}
}

event useEquipment = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        equipmentName: string,
        hitPos: Vector3,
    }
}

event updateUI = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        zombies: u16?,
        wave: u16?,
        wavesTillBoss: u16?,
        timeLeft: f64?,
        gameActive: boolean?,
        playerState: string?,
    }
}

funct getTopbarUIInfo = {
    call: Async,
    rets: struct {
        zombies: i32?,
        wave: u16?,
        wavesTillBoss: u16?,
        timeLeft: f64?,
        gameActive: boolean?
    }
}

funct getLevelData = {
    call: Async,
    rets: struct {
        level: u32,
        xp: u32,
        xpMax: u32,
    }
}

funct getOwnedWeapons = {
    call: Async,
    rets: struct{equippedWeapons: struct{gun: string, melee: string, equipment: string}, ownedWeapons: string[]},
}

event updateLevelUi = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        level: u32,
        xp: u32,
        xpMax: u32,
    }
}

event updateFeeds = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        type: string,
        amtGain: i32,
        reason: string,
    }
}

event showVoteUi = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: string[]
}

event voteForMap = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: string
}

event deployed = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
}

event attributeChangedEvent = {
	from: Client,
	type: Reliable,
	call: SingleAsync,
	data: struct {
        name: string,
        value: enum "type" {
            num {value: f64},
            str {value: string},
            boo {value: boolean},
        },
    }
}

event tpToMap = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: string,
}