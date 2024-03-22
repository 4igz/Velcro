
opt server_output = "path/to/server/init.luau"
opt client_output = "path/to/client/init.luau"

event BuyGenerator = {
	from: Client,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		generatorName: string(..32),
		amt: u32
	}
}

event GetEnergy = {
	from: Client,
	type: Unreliable,
	call: SingleAsync,
}

event UpdateEnergy = {
	from: Server,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		energy: string(..32)
	}
}

event UpdateGenerators = {
	from: Server,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		generators: map {[string]: u32}
	}
}

event RollEgg = {
	from: Client,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		eggName: string(..32),
		amt: u16
	}
}

event FusePets = {
	from: Client,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		petName: string(..32),
		level: u32
	}
}