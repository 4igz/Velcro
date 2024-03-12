
opt server_output = "path/to/server/init.luau"
opt client_output = "path/to/client/init.luau"

event RevealPickup = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		pickupType: string,
		position: Vector3,
		-- itemId is the attribute on the instance of the item
		-- the client communicates to server to find the pickup using this id
		itemId: string,
	},
}

event DestroyPickup = {
	from: Server,
	type: Reliable,
	call: SingleAsync,
	data: struct {
		itemId: string
	}
}

event Pickup = {
	from: Client,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		itemId: string(..8)
	}
}

event Craft = {
	from: Client,
	type: Unreliable,
	call: SingleAsync,
	data: struct {
		itemName: string(..32)
	}
}