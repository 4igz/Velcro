local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local e = React.createElement

local menus = {
	Gamepass = require(script.Parent.gamepassMenu),
	Shop = require(script.Parent.weaponShop),
}

local closed = Signal.new()

local function app(props)
	local styles, api = ReactSpring.useSpring(function()
		return {
			alpha = 0,
		}
	end)

	local menuRef = React.createRef()

	React.useEffect(function()
		api.start({ alpha = 1 }):andThen(function()
			menuRef.current.Visible = true
		end)
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
		closeButton = e("ImageButton", {
			BackgroundColor3 = Color3.new(0.7, 0.25, 0.25),
			Image = "rbxassetid://5198838744",
			AnchorPoint = Vector2.new(0.6, 0.4),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.15, 0.15),
			ZIndex = 200,
			[React.Event.MouseButton1Click] = function()
				closed:Fire()
				closed:DisconnectAll()
			end,
		}, {
			corner = e("UICorner", {
				CornerRadius = UDim.new(0.25, 0),
			}),
			ratio = e("UIAspectRatioConstraint", {}),
		}),
		menu = menus[props.menuName](menuRef),
	})
end

return function(target, props)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app, props),
	}, target))

	return root, closed
end
