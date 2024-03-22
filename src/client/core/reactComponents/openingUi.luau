local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local e = React.createElement

local function app(props)
	local styles, api = ReactSpring.useSpring(function()
		return {
			alpha = 0,
		}
	end)

	React.useEffect(function()
		api.start({ alpha = 1 })
	end)

	return e("Frame", {
		BackgroundColor3 = props.bgColor,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = styles.alpha:map(function(alpha)
			return UDim2.fromScale(0, 0):Lerp(UDim2.fromScale(0.5, 0.5), alpha)
		end),
	}, {
		corner = e("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
	})
end

return function(target, props)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app, props),
	}, target))

	return function()
		root:unmount()
	end
end
