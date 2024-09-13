
opt server_output = "path/to/server/init.luau"
opt client_output = "path/to/client/init.luau"

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

event replicateHit = {
    from: Server,
    type: Unreliable,
    call: SingleAsync,
    data: struct {
        weaponName: string(..50),
        victim: string(..20)?,
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


event updateUI = {
    from: Server,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        zombies: u16?,
        wave: u16?,
        wavesTillBoss: u16?,
        timeLeft: f64?,
        gameActive: boolean?
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
        xp: u32
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
    }
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