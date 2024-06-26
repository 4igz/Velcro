return function(props)
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.00758, 0.821),
		Size = UDim2.fromScale(0.449, 0.166),
	}, {
		bar = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(6, 104, 39),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0.538),
			Size = UDim2.fromScale(1, 0.463),
		}, {
			uICorner = React.createElement("UICorner"),

			bottomBar = React.createElement("ImageLabel", {
				Image = "rbxassetid://18205306598",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			}),

			topBar = React.createElement("ImageLabel", {
				Image = "rbxassetid://18205312194",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(4.06e-08, 0),
				Size = UDim2.fromScale(0.838, 1),
			}),

			textLabel = React.createElement("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Text = "865/1000 EXP  (80%)",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 25,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			}, {
				uITextSizeConstraint = React.createElement("UITextSizeConstraint", {
					MaxTextSize = 25,
				}),
			}),
		}),

		level = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(6, 104, 39),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0.075),
			Size = UDim2.fromScale(0.457, 0.463),
		}, {
			uICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),

			textLabel1 = React.createElement("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Text = "Level 29",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 22,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			}, {
				uITextSizeConstraint1 = React.createElement("UITextSizeConstraint", {
					MaxTextSize = 22,
				}),
			}),
		}),
	})
end
