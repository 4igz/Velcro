local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local skillUi = require(ReplicatedStorage.client.reactComponents.skillUi)

return function(target)
	local root = ReactRoblox.createRoot(target)
	root:render(React.createElement(skillUi, { visible = true }))

	return function()
		root:unmount()
	end
end
