local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local e = React.createElement

local function button(props)
	local styles, api = ReactSpring.useSpring(function()
		return {
			alpha = 0,
			config = {
				tension = 300,
			}
		}
	end)

	return e("ImageButton", {
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		Image = props.buttonImage or "rbxassetid://16809870867",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.765, 0, 0.19, 0),
		Size = styles.alpha:map(function(alpha)
			return (props.startingSize or UDim2.fromScale(0.657, 0.168)):Lerp(UDim2.fromScale(0.8, 0.27), alpha)
		end),
		[React.Event.MouseEnter] = function()
			api.start({ alpha = 1 })
		end,
		[React.Event.MouseLeave] = function()
			api.start({ alpha = 0 })
		end,
		AnchorPoint = Vector2.new(0.500, 0.500),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {}),

		UICorner = e("UICorner", {
			CornerRadius = UDim.new(1.000, 0),
		}),

		label = e("TextLabel", {
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = props.text,
			AnchorPoint = Vector2.new(0.500, 0.500),
			Font = Enum.Font.BuilderSansBold,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.500, 0, 0.919, 0),
			Size = UDim2.new(1.388, 0, 0.365, 0),
			ZIndex = 2,
			TextScaled = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}, {
			UIStroke = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				LineJoinMode = Enum.LineJoinMode.Round,
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = 2,
				Transparency = 0,
			}),
		}),

		icon = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.500, 0.500),
			Image = props.image,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.500, 0, 0.500, 0),
			Size = props.iconSize or UDim2.new(0.702, 0, 0.756, 0),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}),
	})
end

local function app()
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
		}, {
			UIListLayout = e("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.010, 0),
				SortOrder = Enum.SortOrder.Name,
			}),

			pets = button({text = "Pets", image = ""}),
			gamepass = button({text = "Gamepass", image = "rbxassetid://16809903957", buttonImage = "rbxassetid://16809872201", startingSize = UDim2.fromScale(0.657, 0.19)}),
			setting = button({text = "Settings", image = "rbxassetid://16809921789", iconSize = UDim2.fromScale(1.266, 1.266)}),
			shop = button({text = "Shop", image = "rbxassetid://16809890167", iconSize = UDim2.fromScale(1.132, 1.132)}),
		}),
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app),
	}, target))

	return function()
		root:unmount()
	end
end
