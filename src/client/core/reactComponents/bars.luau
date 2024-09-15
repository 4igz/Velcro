local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)

local function createBar(props)
	if props == {} then
		return
	end
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 207, 14),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(0, 1):Lerp(UDim2.fromScale(1, 1), props.x / props.y),
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
		ZIndex = 3,
	}, {
		uIStroke1 = React.createElement("UIStroke", {
			Color = Color3.fromRGB(255, 255, 255),
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
			Color = Color3.fromRGB(0, 0, 0),
		}),
		bar = createBar({ x = props.xp or 0, y = props.xpMax or 0 }),
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
			Text = `Level {props.level}`,
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
		amount = createAmountLabel({ text = `{props.xp}/{props.xpMax}` }),
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
	-- Store the health, maxHealth, xp, and xpMax as state
	local health, setHealth = React.useState(props.health or 100)
	local maxHealth, setMaxHealth = React.useState(props.maxHealth or 100)
	local xp, setXp = React.useState(props.xp or 0)
	local xpMax, setXpMax = React.useState(props.xpMax or 1)
	local level, setLevel = React.useState(props.xpMax or 1)

	-- Update the state if new props are passed
	React.useEffect(function()
		if props.health then
			setHealth(props.health)
		end
		if props.level then
			setLevel(props.level)
		end
		if props.maxHealth then
			setMaxHealth(props.maxHealth)
		end
		if props.xp then
			setXp(props.xp)
		end
		if props.xpMax then
			setXpMax(props.xpMax)
		end
	end, { props.health, props.maxHealth, props.xp, props.xpMax, props.level })

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.499, 0.928),
		Size = UDim2.fromScale(0.999, 0.141),
	}, {
		bar = xpBar({
			xp = xp,
			xpMax = xpMax,
			level = level or 1,
		}),
		healthBar = healthBar({
			health = math.round(health),
			maxHealth = maxHealth,
		}),
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
