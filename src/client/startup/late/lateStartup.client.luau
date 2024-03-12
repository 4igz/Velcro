local ReplicatedStorage = game:GetService("ReplicatedStorage")

local startup = require(ReplicatedStorage.shared.utilities.startup)

startup(ReplicatedStorage.client.controllers, ReplicatedStorage.client.components)
