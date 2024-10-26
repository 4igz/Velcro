local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local sidebarButton = require(script.Parent.sidebarButton)
local e = React.createElement

local function app(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.500, 0.500),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.042, 0, 0.5, 0),
		Size = UDim2.new(0.072, 0, 0.45, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		UIListLayout = e("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0.045, 0),
			SortOrder = Enum.SortOrder.Name,
		}),

		-- Sidebar buttons:
		gamepass = sidebarButton({
			text = "Gamepass",
			image = "rbxassetid://17181563489",
			startingSize = UDim2.fromScale(0.657, 0.19),
			openGamepassShop = props.openGamepassShop,
			onClose = function()
				props.openGamepassShop(false)
			end,
		}),

		settings = sidebarButton({
			text = "Settings",
			image = "rbxassetid://126441385489793",
			iconSize = UDim2.fromScale(1.266, 1.266),
		}),

		shop = sidebarButton({
			text = "Shop",
			image = "rbxassetid://106154331839572",
			iconSize = UDim2.fromScale(1.132, 1.132),
		}),

		skillUi = sidebarButton({
			text = "Skills",
			image = "rbxassetid://104185914549448",
			iconSize = UDim2.fromScale(1.132, 1.132),
		}),
	})
end

return function(props)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app, { target = props.gui, openGamepassShop = props.openGamepassShop }),
	}, props.gui))

	return function()
		root:unmount()
	end
end
