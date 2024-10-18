local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)

local function moneyFrame(props)
	local leaderstats = Players.LocalPlayer:WaitForChild("leaderstats")
	local money: IntValue = leaderstats:WaitForChild("Money")
	local moneyV, setMoney = React.useState(money.Value)

	money.Changed:Connect(function()
		setMoney(money.Value)
	end)

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = props.position,
		Size = UDim2.fromScale(0.1, 0.05),
		ZIndex = 2,
	}, {
		uIStroke3 = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 2,
		}),

		amount1 = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.437, 0.5),
			Size = UDim2.fromScale(0.821, 0.761),
			Text = `${moneyV}`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 3,
		}),
	})
end

return moneyFrame
