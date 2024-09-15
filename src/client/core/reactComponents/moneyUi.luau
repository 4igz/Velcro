local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)

local function moneyFrame()
	local leaderstats = Players.LocalPlayer:WaitForChild("leaderstats")
	local money: IntValue = leaderstats:WaitForChild("Money")
	local moneyV, setMoney = React.useState(money.Value)

	money.Changed:Connect(function()
		setMoney(money.Value)
	end)

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
	}, {
		frame = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(1, -15, 1, -15),
			Size = UDim2.fromScale(0.154, 0.0578),
		}, {
			button = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(69, 179, 237),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.01, 0.5),
				Size = UDim2.fromScale(0.147, 0.707),
				Text = "+",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				ZIndex = 3,
			}, {
				uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

				uIStroke = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				uICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),

			icon = React.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://15018952022",
				Position = UDim2.fromScale(0.89, 0.5),
				Size = UDim2.fromScale(0.297, 1.43),
				ZIndex = 3,
			}, {
				uIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),
			}),

			money = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxassetid://12187607287",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.43, 0.5),
				Size = UDim2.fromScale(0.658, 0.78),
				Text = moneyV,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				ZIndex = 3,
			}, {
				uIStroke1 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(46, 123, 162),
				}),

				uIGradient = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(143, 199, 208)),
					}),
					Rotation = 90,
				}),
			}),

			background = React.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://16365582478",
				ImageColor3 = Color3.fromRGB(93, 193, 255),
				ImageTransparency = 0.3,
				Position = UDim2.fromScale(0.5, 0.5),
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}, {
				uICorner1 = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				uIStroke2 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),
			}),
		}),
	})
end

return moneyFrame
