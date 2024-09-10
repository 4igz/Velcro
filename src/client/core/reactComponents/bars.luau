local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)

local currentXp = 0
local xpMax = 0

local function createBar()
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 207, 14),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
	}, {
		uIGradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 214, 214)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.987, 0),
				NumberSequenceKeypoint.new(1, 0),
			}),
		}),
		uICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),
	})
end

local function createAmountLabel(props)
	return React.createElement("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		FontFace = Font.new(
			"rbxassetid://12187607287",
			Enum.FontWeight.SemiBold,
			Enum.FontStyle.Italic
		),
		Position = UDim2.fromScale(0.784, 0.5),
		Size = UDim2.fromScale(0.414, 0.958),
		Text = props.text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		TextSize = 14,
		TextTransparency = 0.2,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, {
		uIStroke1 = React.createElement("UIStroke", {
			Color = Color3.fromRGB(249, 202, 34),
			Transparency = 0.3,
		}),
		uIGradient1 = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 250, 90)),
			}),
			Rotation = 90,
		}),
	})
end

local function xpBar(props)
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.109, 0.79),
		Size = UDim2.fromScale(0.205, 0.19),
	}, {
		uIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(255, 221, 51),
		}),
		bar = createBar(),
		uICorner1 = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),
		level = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.SemiBold,
				Enum.FontStyle.Italic
			),
			Position = UDim2.fromScale(0.251, 0.557),
			Size = UDim2.fromScale(0.279, 0.982),
			Text = "Level 10",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextTransparency = 0.2,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
		}),
		icon = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 221, 51),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://18401296670",
			ImageColor3 = Color3.fromRGB(255, 221, 51),
			Position = UDim2.fromScale(0.05, 0.5),
			Size = UDim2.fromScale(0.07, 0.925),
			ZIndex = 2,
		}, {
			uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
		}),
		amount = createAmountLabel({ text = `{props.xpAmount}/{props.xpMax}` }),
	})
end

local function healthBar(props)
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.169, 0.49),
		Size = UDim2.fromScale(0.324, 0.303),
	}, {
		uIStroke2 = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(255, 92, 92),
		}),
		bar1 = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(0, 1)
				:Lerp(UDim2.fromScale(1, 1), props.health / props.maxHealth),
		}, {
			uIGradient2 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 214, 214)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.987, 0),
					NumberSequenceKeypoint.new(1, 0),
				}),
			}),
			uICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.01, 0),
			}),
			decor = React.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://18401265229",
				ImageColor3 = Color3.fromRGB(255, 74, 74),
				ImageTransparency = 0.7,
				Position = UDim2.fromScale(0.931, 0.496),
				Size = UDim2.fromScale(0.331, 1.76),
				ZIndex = 2,
			}, {
				uIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),
			}),
		}),
		uICorner3 = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),
		amount1 = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.SemiBold,
				Enum.FontStyle.Italic
			),
			Position = UDim2.fromScale(0.181, 0.5),
			Size = UDim2.fromScale(0.189, 0.843),
			Text = `{props.health}/{props.maxHealth}`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextTransparency = 0.2,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
		}),
		icon1 = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://18401258963",
			ImageColor3 = Color3.fromRGB(255, 74, 74),
			Position = UDim2.fromScale(0.04, 0.5),
			Size = UDim2.fromScale(0.0561, 0.728),
			ZIndex = 2,
		}, {
			uIAspectRatioConstraint2 = React.createElement("UIAspectRatioConstraint"),
		}),
	})
end

local function createMainContainer(props)
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.499, 0.928),
		Size = UDim2.fromScale(0.999, 0.141),
	}, {
		xpBar = xpBar({ xpAmount = 5, maxXp = 10 }),
		healthBar = healthBar({ health = props.health or 100, maxHealth = props.maxHealth or 100 }),
	})
end

return function(props)
	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
	}, {
		container = createMainContainer(props),
	})
end
