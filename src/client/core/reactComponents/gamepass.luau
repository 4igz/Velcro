local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local e = React.createElement

return function(props)
	return e("Frame", {
		Size = UDim2.new(0.500, -5, 0.400, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		Name = e("TextLabel", {
			Position = UDim2.new(0.500, 0, 0.000, 0),
			Font = Enum.Font.Gotham,
			BackgroundTransparency = 1,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0.500, 0, 0.500, 0),
			Text = props.gpName,
			TextSize = 22,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}),

		Buy = e("TextButton", {
			Position = UDim2.new(0.500, 0, 0.500, 0),
			Font = Enum.Font.GothamBlack,
			BackgroundTransparency = 0.5,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(0.500, 0, 0.500, 0),
			Text = `{props.price}R$`,
			TextSize = 39,
			BackgroundColor3 = Color3.fromRGB(79, 220, 64),
			[React.Event.MouseButton1Click] = function()
				MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, props.gpId)
			end,
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.500, 0),
			}),

			TextCorner = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				LineJoinMode = Enum.LineJoinMode.Round,
				Color = Color3.fromRGB(255, 255, 255),
				Thickness = 1,
				Transparency = 0,
			}),

			ButtonCorner = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Round,
				Color = Color3.fromRGB(255, 255, 255),
				Thickness = 1,
				Transparency = 0,
			}),
		}),

		Icon = e("ImageButton", {
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			Image = props.gpImage,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.500, 0, 1.000, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}),
	})
end
