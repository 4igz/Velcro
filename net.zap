
opt server_output = "path/to/server/init.luau"
opt client_output = "path/to/client/init.luau"

event buyWeapon = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        weaponName: string
    }
}

event equipWeapon = {
    from: Client,
    type: Reliable,
    call: SingleAsync,
    data: struct {
        weaponName: string
    }
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
        weaponName: string(..25),
        victim: string(..20)?,
		targetHit: boolean
    }
}

event updateUI = {
    from: Server,
    type: Unreliable,
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
    rets: struct {
        zombies: u16?,
        wave: u16?,
        wavesTillBoss: u16?,
        timeLeft: f64?,
        gameActive: boolean?
    }
}