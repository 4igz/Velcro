local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages
local shared = ReplicatedStorage.shared

local Component = require(sharedPackages.Component)
local Trove = require(sharedPackages.Trove)

local Node = Component.new({
	tag = "Node",
})

function Node:construct()
	self._trove = Trove.new()

	local i = self.instance

	self.maxHealth = i:GetAttribute("MaxHealth") or 100
end

function Node:stop()
	self._trove:Destroy()
end

return Node
