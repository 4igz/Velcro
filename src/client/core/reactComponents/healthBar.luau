local function createBar(imageId, imageColor, backgroundColor, borderColor)
	return Roact.createElement("ImageLabel", {
		Image = "rbxassetid://" .. imageId,
		ImageColor3 = imageColor,
		BackgroundColor3 = backgroundColor,
		BackgroundTransparency = 1,
		BorderColor3 = borderColor,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	})
end

local function createTextLabel(text, textSize)
	return Roact.createElement("TextLabel", {
		Font = Enum.Font.FredokaOne,
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextScaled = true,
		TextSize = textSize,
		TextWrapped = true,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		uITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = textSize,
		}),
	})
end

return function(props)
	local backgroundColor = Color3.fromRGB(255, 255, 255)
	local borderColor = Color3.fromRGB(0, 0, 0)
	local textSize = 25
	local playerHealth = props.playerHealth or 100 -- Assuming props.playerHealth contains the current health of the player

	return Roact.createElement("Frame", {
		BackgroundColor3 = backgroundColor,
		BackgroundTransparency = 1,
		BorderColor3 = borderColor,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.00716, 0.731),
		Size = UDim2.fromScale(0.397, 0.0893),
	}, {
		bottomBar = createBar(
			18205306598,
			Color3.fromRGB(141, 0, 127),
			backgroundColor,
			borderColor
		),
		greenBar = createBar(
			18205429135,
			Color3.fromRGB(255, 255, 255),
			backgroundColor,
			borderColor
		),
		redBar = createBar(
			18205506990,
			Color3.fromRGB(255, 255, 255),
			backgroundColor,
			borderColor
		),
		textLabel = createTextLabel(`{playerHealth:getValue()}/1000`, textSize),
	})
end
