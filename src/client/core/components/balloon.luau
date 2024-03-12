local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages
local shared = ReplicatedStorage.shared

local Component = require(sharedPackages.Component)
local Trove = require(sharedPackages.Trove)

local Balloon = Component.new({
	tag = "Balloon",
})

function Balloon:construct()
	self._trove = Trove.new()
end

function Balloon:start() end

function Balloon:stop()
	self._trove:Destroy()
end

return Balloon
