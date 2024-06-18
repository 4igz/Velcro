local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local sidebarButton = require(script.Parent.sidebarButton)
local e = React.createElement

local function app(props)
	local refs = {
		list = React.useRef(),
		container = React.useRef(),
	}

	return e("Frame", {
		AnchorPoint = Vector2.new(0.500, 0.500),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.073, 0, 0.619, 0),
		Size = UDim2.new(0.147, 0, 0.763, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		container = e("Frame", {
			AnchorPoint = Vector2.new(0.500, 0.500),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.248, 0, 0.419, 0),
			Size = UDim2.new(0.495, 0, 0.756, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ref = refs.container,
		}, {
			UIListLayout = e("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.010, 0),
				SortOrder = Enum.SortOrder.Name,
				ref = refs.list,
			}),

			-- pets = sidebarButton({ text = "Pets", image = "" }, refs, props.target),

			gamepass = sidebarButton({
				text = "Gamepass",
				image = "rbxassetid://16809903957",
				buttonImage = "rbxassetid://16809872201",
				startingSize = UDim2.fromScale(0.657, 0.19),
			}, refs, props.target),

			settings = sidebarButton({
				text = "Settings",
				image = "rbxassetid://16809921789",
				iconSize = UDim2.fromScale(1.266, 1.266),
			}, refs, props.target),

			shop = sidebarButton({
				text = "Shop",
				image = "rbxassetid://16809890167",
				iconSize = UDim2.fromScale(1.132, 1.132),
			}, refs, props.target),
		}),
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app, { target = target }),
	}, target))

	return function()
		root:unmount()
	end
end
