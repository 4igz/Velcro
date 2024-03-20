local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local e = React.createElement

return function(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.27, 0, 0.25, 0),
		Size = UDim2.new(1.5, 0, 0.35, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		energyFrame = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.500, 0.500),
			Image = "rbxassetid://16791518320",
			BackgroundTransparency = 1,
			Position = UDim2.new(1.4, 0, 0.210, 0),
			Size = UDim2.new(0.144, 0, 0.274, 0),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}, {
			interactionButton = e("ImageButton", {
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Image = "rbxassetid://16791520425",
				BackgroundTransparency = 1,
				Position = UDim2.new(0.004, 0, 0.528, 0),
				Size = UDim2.new(0.145, 0, 0.651, 0),
				AnchorPoint = Vector2.new(0.500, 0.500),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint", {}),
			}),

			num = e("TextLabel", {
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Text = props.text,
				AnchorPoint = Vector2.new(0.500, 0.500),
				Font = Enum.Font.GothamBold,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.491, 0, 0.528, 0),
				Size = UDim2.new(0.719, 0, 0.651, 0),
				TextScaled = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				UIStroke = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
					LineJoinMode = Enum.LineJoinMode.Round,
					Color = Color3.fromRGB(124, 81, 12),
					Thickness = 2,
					Transparency = 0,
				}),

				UIGradient = e("UIGradient", {
					Offset = Vector2.new(0.000, 0.000),
					Transparency = NumberSequence.new(0),
					Color = ColorSequence.new(
						Color3.fromRGB(255, 255, 255),
						Color3.fromHex("ffae21")
					),
					Rotation = 90,
				}),
			}),

			bolt = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.500, 0.500),
				Image = "rbxassetid://16791523802",
				BackgroundTransparency = 1,
				Position = UDim2.new(0.965, 0, 0.500, 0),
				Size = UDim2.new(0.203, 0, 1.068, 0),
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				Transparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}),
		}),
	})
end
