local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sharedPackages = ReplicatedStorage.sharedPackages
local shared = ReplicatedStorage.shared

local Component = require(sharedPackages.Component)
local Trove = require(sharedPackages.Trove)

local remoteComponentExtension = require(shared.componentExtensions.remoteComponent)

local Balloon = Component.new({
	tag = "Balloon",
	extensions = { remoteComponentExtension },
	requiredServerComponents = { "Balloon" },
})

function Balloon:construct()
	self._trove = Trove.new()
end

function Balloon:start()
	warn(self.server.Balloon:hello())
end

function Balloon:stop()
	self._trove:Destroy()
end

return Balloon
