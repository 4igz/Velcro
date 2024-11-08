--!native
--!optimize 2
--!nocheck
--!nolint
--#selene: allow(unused_variable, shadowing, incorrect_standard_library_use)
-- Server generated by Zap v0.6.2 (https://github.com/red-blox/zap)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local outgoing_buff: buffer
local outgoing_used: number
local outgoing_size: number
local outgoing_inst: { Instance }
local outgoing_apos: number

local incoming_buff: buffer
local incoming_read: number
local incoming_inst: { Instance }
local incoming_ipos: number

-- thanks to https://dom.rojo.space/binary.html#cframe
local CFrameSpecialCases = {
	CFrame.Angles(0, 0, 0),
	CFrame.Angles(math.rad(90), 0, 0),
	CFrame.Angles(0, math.rad(180), math.rad(180)),
	CFrame.Angles(math.rad(-90), 0, 0),
	CFrame.Angles(0, math.rad(180), math.rad(90)),
	CFrame.Angles(0, math.rad(90), math.rad(90)),
	CFrame.Angles(0, 0, math.rad(90)),
	CFrame.Angles(0, math.rad(-90), math.rad(90)),
	CFrame.Angles(math.rad(-90), math.rad(-90), 0),
	CFrame.Angles(0, math.rad(-90), 0),
	CFrame.Angles(math.rad(90), math.rad(-90), 0),
	CFrame.Angles(0, math.rad(90), math.rad(180)),
	CFrame.Angles(0, math.rad(-90), math.rad(180)),
	CFrame.Angles(0, math.rad(180), math.rad(0)),
	CFrame.Angles(math.rad(-90), math.rad(-180), math.rad(0)),
	CFrame.Angles(0, math.rad(0), math.rad(180)),
	CFrame.Angles(math.rad(90), math.rad(180), math.rad(0)),
	CFrame.Angles(0, math.rad(0), math.rad(-90)),
	CFrame.Angles(0, math.rad(-90), math.rad(-90)),
	CFrame.Angles(0, math.rad(-180), math.rad(-90)),
	CFrame.Angles(0, math.rad(90), math.rad(-90)),
	CFrame.Angles(math.rad(90), math.rad(90), 0),
	CFrame.Angles(0, math.rad(90), 0),
	CFrame.Angles(math.rad(-90), math.rad(90), 0),
}

local function alloc(len: number)
	if outgoing_used + len > outgoing_size then
		while outgoing_used + len > outgoing_size do
			outgoing_size = outgoing_size * 2
		end

		local new_buff = buffer.create(outgoing_size)
		buffer.copy(new_buff, 0, outgoing_buff, 0, outgoing_used)

		outgoing_buff = new_buff
	end

	outgoing_apos = outgoing_used
	outgoing_used = outgoing_used + len

	return outgoing_apos
end

local function read(len: number)
	local pos = incoming_read
	incoming_read = incoming_read + len

	return pos
end

local function save()
	return {
		buff = outgoing_buff,
		used = outgoing_used,
		size = outgoing_size,
		inst = outgoing_inst,
	}
end

local function load(data: {
	buff: buffer,
	used: number,
	size: number,
	inst: { Instance },
})
	outgoing_buff = data.buff
	outgoing_used = data.used
	outgoing_size = data.size
	outgoing_inst = data.inst
end

local function load_empty()
	outgoing_buff = buffer.create(64)
	outgoing_used = 0
	outgoing_size = 64
	outgoing_inst = {}
end

load_empty()

local types = {}
local Players = game:GetService("Players")

if RunService:IsClient() then
	error("Cannot use the server module on the client!")
end

local reliable = ReplicatedStorage:FindFirstChild("ZAP_RELIABLE")
if reliable == nil then
	reliable = Instance.new("RemoteEvent")
	reliable.Name = "ZAP_RELIABLE"
	reliable.Parent = ReplicatedStorage
end

local unreliable = ReplicatedStorage:FindFirstChild("ZAP_UNRELIABLE")
if unreliable == nil then
	unreliable = Instance.new("UnreliableRemoteEvent")
	unreliable.Name = "ZAP_UNRELIABLE"
	unreliable.Parent = ReplicatedStorage
end

local player_map = {}

local function load_player(player: Player)
	if player_map[player] then
		load(player_map[player])
	else
		load_empty()
	end
end

Players.PlayerRemoving:Connect(function(player)
	player_map[player] = nil
end)

RunService.Heartbeat:Connect(function()
	for player, outgoing in player_map do
		if outgoing.used > 0 then
			local buff = buffer.create(outgoing.used)
			buffer.copy(buff, 0, outgoing.buff, 0, outgoing.used)

			reliable:FireClient(player, buff, outgoing.inst)

			outgoing.buff = buffer.create(64)
			outgoing.used = 0
			outgoing.size = 64
			table.clear(outgoing.inst)
		end
	end
end)

local events = table.create(4)
unreliable.OnServerEvent:Connect(function(player, buff, inst)
	incoming_buff = buff
	incoming_inst = inst
	incoming_read = 0
	incoming_ipos = 0
	local id = buffer.readu8(buff, read(1))
	if id == 3 then
		local value
		value = {}
		local len = buffer.readu16(incoming_buff, read(2))
		assert(len <= 8)
		value.itemId = buffer.readstring(incoming_buff, read(len), len)
		if events[3] then
			task.spawn(events[3], player, value)
		end
	elseif id == 4 then
		local value
		value = {}
		local len = buffer.readu16(incoming_buff, read(2))
		assert(len <= 32)
		value.itemName = buffer.readstring(incoming_buff, read(len), len)
		if events[4] then
			task.spawn(events[4], player, value)
		end
	else
		error("Unknown event id")
	end
end)
return {
	RevealPickup = {
		Fire = function(Player: Player, Value: ({
			pickupType: (string),
			position: (Vector3),
			itemId: (string),
		}))
			load_player(Player)
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 1)
			local len = #Value.pickupType
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.pickupType, len)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.X)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Y)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Z)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			player_map[Player] = save()
		end,
		FireAll = function(Value: ({
			pickupType: (string),
			position: (Vector3),
			itemId: (string),
		}))
			load_empty()
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 1)
			local len = #Value.pickupType
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.pickupType, len)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.X)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Y)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Z)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			local buff, used, inst = outgoing_buff, outgoing_used, outgoing_inst
			for _, player in Players:GetPlayers() do
				load_player(player)
				alloc(used)
				buffer.copy(outgoing_buff, outgoing_apos, buff, 0, used)
				table.move(inst, 1, #inst, #outgoing_inst + 1, outgoing_inst)
				player_map[player] = save()
			end
		end,
		FireExcept = function(Except: Player, Value: ({
			pickupType: (string),
			position: (Vector3),
			itemId: (string),
		}))
			load_empty()
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 1)
			local len = #Value.pickupType
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.pickupType, len)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.X)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Y)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Z)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			local buff, used, inst = outgoing_buff, outgoing_used, outgoing_inst
			for _, player in Players:GetPlayers() do
				if player ~= Except then
					load_player(player)
					alloc(used)
					buffer.copy(outgoing_buff, outgoing_apos, buff, 0, used)
					table.move(inst, 1, #inst, #outgoing_inst + 1, outgoing_inst)
					player_map[player] = save()
				end
			end
		end,
		FireList = function(List: { Player }, Value: ({
			pickupType: (string),
			position: (Vector3),
			itemId: (string),
		}))
			load_empty()
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 1)
			local len = #Value.pickupType
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.pickupType, len)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.X)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Y)
			alloc(4)
			buffer.writef32(outgoing_buff, outgoing_apos, Value.position.Z)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			local buff, used, inst = outgoing_buff, outgoing_used, outgoing_inst
			for _, player in List do
				load_player(player)
				alloc(used)
				buffer.copy(outgoing_buff, outgoing_apos, buff, 0, used)
				table.move(inst, 1, #inst, #outgoing_inst + 1, outgoing_inst)
				player_map[player] = save()
			end
		end,
	},
	DestroyPickup = {
		Fire = function(Player: Player, Value: ({
			itemId: (string),
		}))
			load_player(Player)
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 2)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			player_map[Player] = save()
		end,
		FireAll = function(Value: ({
			itemId: (string),
		}))
			load_empty()
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 2)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			local buff, used, inst = outgoing_buff, outgoing_used, outgoing_inst
			for _, player in Players:GetPlayers() do
				load_player(player)
				alloc(used)
				buffer.copy(outgoing_buff, outgoing_apos, buff, 0, used)
				table.move(inst, 1, #inst, #outgoing_inst + 1, outgoing_inst)
				player_map[player] = save()
			end
		end,
		FireExcept = function(Except: Player, Value: ({
			itemId: (string),
		}))
			load_empty()
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 2)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			local buff, used, inst = outgoing_buff, outgoing_used, outgoing_inst
			for _, player in Players:GetPlayers() do
				if player ~= Except then
					load_player(player)
					alloc(used)
					buffer.copy(outgoing_buff, outgoing_apos, buff, 0, used)
					table.move(inst, 1, #inst, #outgoing_inst + 1, outgoing_inst)
					player_map[player] = save()
				end
			end
		end,
		FireList = function(List: { Player }, Value: ({
			itemId: (string),
		}))
			load_empty()
			alloc(1)
			buffer.writeu8(outgoing_buff, outgoing_apos, 2)
			local len = #Value.itemId
			alloc(2)
			buffer.writeu16(outgoing_buff, outgoing_apos, len)
			alloc(len)
			buffer.writestring(outgoing_buff, outgoing_apos, Value.itemId, len)
			local buff, used, inst = outgoing_buff, outgoing_used, outgoing_inst
			for _, player in List do
				load_player(player)
				alloc(used)
				buffer.copy(outgoing_buff, outgoing_apos, buff, 0, used)
				table.move(inst, 1, #inst, #outgoing_inst + 1, outgoing_inst)
				player_map[player] = save()
			end
		end,
	},
	Pickup = {
		SetCallback = function(Callback: (Player, ({
			itemId: (string),
		})) -> ()): () -> ()
			events[3] = Callback
			return function()
				events[3] = nil
			end
		end,
	},
	Craft = {
		SetCallback = function(Callback: (Player, ({
			itemName: (string),
		})) -> ()): () -> ()
			events[4] = Callback
			return function()
				events[4] = nil
			end
		end,
	},
}
