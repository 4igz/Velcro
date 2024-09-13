local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local e = React.createElement

local function bgGp(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(69, 179, 237),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.491, 0.0942),
		Size = UDim2.fromScale(0.982, 0.188),
	}, {
		uICorner4 = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),

		uIStroke8 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(46, 123, 162),
			Thickness = 2,
		}),

		button1 = e("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(98, 233, 51),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.898, 0.66),
			Size = UDim2.fromScale(0.178, 0.46),
			[React.Event.MouseButton1Click] = function()
				MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, props.gpId)
			end,
		}, {
			uICorner5 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			uIStroke9 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(92, 214, 47),
				Thickness = 2,
			}),

			uIGradient3 = e("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.936, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.939, Color3.fromRGB(173, 173, 173)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(173, 173, 173)),
				}),
				Rotation = 90,
			}),

			price1 = e("TextLabel", {
				FontFace = Font.new(
					"rbxassetid://12187607287",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = props.price,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.621, 0.5),
				Size = UDim2.fromScale(0.667, 0.786),
			}, {
				uIStroke10 = e("UIStroke", {
					Color = Color3.fromRGB(78, 182, 40),
					Thickness = 2,
				}),
			}),

			icon2 = e("ImageLabel", {
				Image = "rbxassetid://17181563489",
				ImageColor3 = Color3.fromRGB(78, 182, 40),
				ScaleType = Enum.ScaleType.Fit,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.173, 0.498),
				Size = UDim2.fromScale(0.229, 0.781),
			}, {
				uIAspectRatioConstraint1 = e("UIAspectRatioConstraint"),
			}),
		}),

		title2 = e("TextLabel", {
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.458, 0.255),
			Size = UDim2.fromScale(0.647, 0.35),
		}, {
			uIStroke11 = e("UIStroke", {
				Color = Color3.fromRGB(46, 123, 162),
				Thickness = 2,
			}),
		}),

		icon3 = e("ImageLabel", {
			Image = props.bgImage,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.06, 0.5),
			Size = UDim2.fromScale(0.125, 0.874),
		}, {
			uIAspectRatioConstraint2 = e("UIAspectRatioConstraint"),
		}),

		description1 = e("TextLabel", {
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = props.description,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.458, 0.684),
			Size = UDim2.fromScale(0.647, 0.507),
		}, {
			uITextSizeConstraint1 = e("UITextSizeConstraint", {
				MaxTextSize = 18,
			}),
		}),
	})
end

return function(props)
	local gps = {
		uIListLayout = e("UIListLayout", {
			Padding = UDim.new(0.03, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}

	for name, id in sharedInfo.Gamepasses do
		local gpInfo = MarketplaceService:GetProductInfo(id, Enum.InfoType.GamePass)
		gps[name] = bgGp({
			name = name,
			price = gpInfo.PriceInRobux,
			description = gpInfo.Description,
			bgImage = `rbxassetid://{gpInfo.IconImageAssetId}`,
			gpId = id,
		})
	end

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.515, 0.676),
		Visible = props.open,
	}, {
		uIStroke = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(46, 123, 162),
			Thickness = 4,
		}),

		uICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),

		title = e("TextLabel", {
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "Gamepass Shop",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, -0.006),
			Size = UDim2.fromScale(0.562, 0.11),
		}, {
			uIStroke1 = e("UIStroke", {
				Color = Color3.fromRGB(33, 90, 118),
				Thickness = 2,
			}),

			uIGradient = e("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 204, 204)),
				}),
				Rotation = 90,
			}),
		}),

		scrollingFrame = e("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			BottomImage = "rbxassetid://12058295216",
			CanvasSize = UDim2.fromScale(0, 1),
			HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			MidImage = "rbxassetid://12058295216",
			ScrollBarImageColor3 = Color3.fromRGB(46, 123, 162),
			ScrollBarThickness = 6,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			TopImage = "rbxassetid://12058295216",
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(227, 227, 227),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.503, 0.523),
			Size = UDim2.fromScale(0.982, 0.95),
			ZIndex = 2,
		}, gps),

		shadow = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(24, 63, 83),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.521, 0.539),
			Size = UDim2.fromScale(1, 1),
			ZIndex = -1,
		}, {
			uICorner1 = e("UICorner"),

			uIGradient1 = e("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(189, 189, 189)),
				}),
				Rotation = 90,
			}),

			uIStroke2 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(14, 38, 50),
				Thickness = 3,
			}),
		}),

		button2 = e("TextButton", {
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Text = "X",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(62, 171, 222),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.995, -0.00657),
			Size = UDim2.fromScale(0.0511, 0.0807),
			Visible = true,

			[React.Event.MouseButton1Click] = function()
				props.onClose()
			end,
		}, {
			uICorner6 = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke12 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(33, 90, 118),
				Thickness = 2,
			}),

			uIAspectRatioConstraint3 = e("UIAspectRatioConstraint"),
		}),
	})
end
