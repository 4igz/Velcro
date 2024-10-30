local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)

return function(props)
	return React.createElement("BillboardGui", {
		ClipsDescendants = true,
		LightInfluence = 1,
		Adornee = props.adornee,
		Size = UDim2.fromScale(5, 1.5),
		StudsOffset = Vector3.new(0, 1.5, 0),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, {
		background = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			Size = UDim2.fromScale(1, 1),
		}, {
			name = React.createElement("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0, 0.35),
				Size = UDim2.fromScale(1, 0.3),
				Text = string.upper(props.zombieName),
				TextColor3 = Color3.fromRGB(255, 42, 46),
				TextScaled = true,
				TextSize = 14,
				TextStrokeColor3 = Color3.fromRGB(59, 59, 59),
				TextWrapped = true,
			}, {
				uIStroke = React.createElement("UIStroke", {
					Color = Color3.fromRGB(20, 20, 20),
					Thickness = 2,
					Transparency = 0.3,
				}),

				uIGradient = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145)),
					}),
					Rotation = 90,
				}),
			}),

			healthbar = React.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(21, 21, 21),
				BackgroundTransparency = 0.3,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Position = UDim2.fromScale(0.025, 0.7),
				Size = UDim2.fromScale(0.95, 0.1),
				Visible = props.health < props.maxHealth,
			}, {
				bar = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(147, 0, 0),
					BorderColor3 = Color3.fromRGB(27, 42, 53),
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(0, 0.8)
						:Lerp(UDim2.fromScale(1, 0.8), props.health / props.maxHealth),
				}),
			}),
		}),
	})
end
