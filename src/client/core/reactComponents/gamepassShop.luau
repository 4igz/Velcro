local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local monetizationUtil = require(ReplicatedStorage.shared.utilities.monetizationUtil)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local e = React.createElement

local function featuredGp(props)
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.379, 0.185),
		Size = UDim2.fromScale(0.987, 0.384),
	}, {
		frame1 = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.979, 0.925),
		}, {
			uIStroke3 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(9, 9, 9),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 3,
			}),

			gradient = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.4,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Interactable = false,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}, {
				uIGradient = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 109, 5)),
					}),
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.33, 0.973),
						NumberSequenceKeypoint.new(0.658, 0.907),
						NumberSequenceKeypoint.new(0.885, 0.858),
						NumberSequenceKeypoint.new(1, 0.77),
					}),
				}),
			}),

			gamepass = React.createElement("TextLabel", {
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
				Position = UDim2.fromScale(0.219, 0.26),
				Size = UDim2.fromScale(0.394, 0.28),
				Text = `{props.name}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
			}, {
				uIGradient1 = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(144, 144, 144)),
					}),
					Rotation = 90,
				}),

				uIStroke4 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(22, 22, 22),
					Thickness = 2,
				}),
			}),

			button2 = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.844, 0.671),
				Size = UDim2.fromScale(0.26, 0.328),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
				ZIndex = 2,
			}, {
				uIStroke5 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text2 = React.createElement("TextLabel", {
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
					LineHeight = 0.63,
					Position = UDim2.fromScale(0.602, 0.488),
					Size = UDim2.fromScale(1.77, 1.9),
					Text = "BUYBUYBUY BUYBUY BUYBUY",
					TextColor3 = Color3.fromRGB(255, 64, 0),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					TextWrapped = true,
					ZIndex = 0,
				}),

				header2 = React.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Italic
					),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.749, 0.701),
					Text = "BUY",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),
			}),

			price = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Italic
				),
				Position = UDim2.fromScale(0.842, 0.3),
				Size = UDim2.fromScale(0.26, 0.274),
				Text = `{props.price} R$`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				ZIndex = 2,
			}, {
				uIGradient2 = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 85, 6)),
					}),
					Rotation = 90,
				}),

				uIStroke6 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(15, 15, 15),
					Thickness = 2,
				}),
			}),

			viewportFrame = React.createElement("ViewportFrame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.501, 0.521),
				Size = UDim2.fromScale(0.973, 0.79),
			}, {
				uIStroke7 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text3 = React.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Italic
					),
					Position = UDim2.fromScale(0.21, 0.904),
					Size = UDim2.fromScale(0.402, 0.175),
					Text = "PREVIEW",
					TextColor3 = Color3.fromRGB(74, 74, 74),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),
		}),
	})
end

local function gp(props)
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.8,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.249, 0.834),
		Size = UDim2.fromScale(0.463, 0.821),
	}, {
		bottom = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.5, 0.68),
			Size = UDim2.fromScale(0.982, 0.604),
		}, {
			button3 = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.711, 0.813),
				Size = UDim2.fromScale(0.511, 0.225),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				ZIndex = 2,
				TextSize = 14,
				[React.Event.MouseButton1Click] = function()
					MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, props.gpId)
				end,
			}, {
				uIStroke8 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text4 = React.createElement("TextLabel", {
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
					LineHeight = 0.63,
					Position = UDim2.fromScale(0.602, 0.488),
					Size = UDim2.fromScale(1.77, 1.9),
					Text = "BUYBUYBUY BUYBUY BUYBUY",
					TextColor3 = Color3.fromRGB(255, 64, 0),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					ZIndex = 2,
					TextWrapped = true,
				}),

				header3 = React.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Italic
					),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.749, 0.701),
					Text = "BUY",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					ZIndex = 2,
					TextWrapped = true,
				}),
			}),

			price1 = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Italic
				),
				Position = UDim2.fromScale(0.219, 0.813),
				Size = UDim2.fromScale(0.374, 0.225),
				Text = `{props.price} R$`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				ZIndex = 2,
			}, {
				uIGradient3 = React.createElement("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 85, 6)),
					}),
					Rotation = 90,
				}),

				uIStroke9 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(15, 15, 15),
					Thickness = 2,
				}),
			}),

			bgImage = React.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Image = `{props.bgImage}`,
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 1,
			}, {
				uIStroke10 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),
			}),

			-- viewportFrame1 = React.createElement("ViewportFrame", {
			-- 	AnchorPoint = Vector2.new(0.5, 0.5),
			-- 	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			-- 	BorderColor3 = Color3.fromRGB(0, 0, 0),
			-- 	BorderSizePixel = 0,
			-- 	Position = UDim2.fromScale(0.5, 0.34),
			-- 	Size = UDim2.fromScale(0.935, 0.55),
			-- }, {
			-- 	uIStroke10 = React.createElement("UIStroke", {
			-- 		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			-- 		Color = Color3.fromRGB(15, 15, 15),
			-- 		LineJoinMode = Enum.LineJoinMode.Miter,
			-- 		Thickness = 3,
			-- 	}),

			-- 	text5 = React.createElement("TextLabel", {
			-- 		AnchorPoint = Vector2.new(0.5, 0.5),
			-- 		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			-- 		BackgroundTransparency = 1,
			-- 		BorderColor3 = Color3.fromRGB(0, 0, 0),
			-- 		BorderSizePixel = 0,
			-- 		FontFace = Font.new(
			-- 			"rbxasset://fonts/families/GothamSSm.json",
			-- 			Enum.FontWeight.Medium,
			-- 			Enum.FontStyle.Italic
			-- 		),
			-- 		Position = UDim2.fromScale(0.21, 0.904),
			-- 		Size = UDim2.fromScale(0.402, 0.175),
			-- 		Text = "PREVIEW",
			-- 		TextColor3 = Color3.fromRGB(74, 74, 74),
			-- 		TextScaled = true,
			-- 		TextSize = 14,
			-- 		TextWrapped = true,
			-- 		TextXAlignment = Enum.TextXAlignment.Left,
			-- 	}),
			-- }),
		}),

		top = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.5, 0.188),
			Size = UDim2.fromScale(0.982, 0.345),
		}, {
			header4 = React.createElement("TextLabel", {
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
				Position = UDim2.fromScale(0.5, 0.221),
				Size = UDim2.fromScale(0.913, 0.352),
				Text = props.name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke11 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(16, 16, 16),
					Thickness = 3,
				}),
			}),

			desc = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Position = UDim2.fromScale(0.5, 0.657),
				Size = UDim2.fromScale(0.913, 0.52),
				Text = props.description,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextTransparency = 0.3,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			}, {
				uIStroke12 = React.createElement("UIStroke", {
					Color = Color3.fromRGB(16, 16, 16),
				}),

				uITextSizeConstraint = React.createElement("UITextSizeConstraint", {
					MaxTextSize = 16,
				}),
			}),
		}),

		uIStroke13 = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(9, 9, 9),
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 3,
		}),
	})
end

return function(props)
	local gps = {
		uIListLayout1 = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0.04, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Wraps = true,
		}),
	}

	for name, id in sharedInfo.Gamepasses do
		local gpInfo = MarketplaceService:GetProductInfo(id, Enum.InfoType.GamePass)
		local gpData = {
			name = name,
			price = gpInfo.PriceInRobux,
			description = gpInfo.Description,
			bgImage = `rbxassetid://{gpInfo.IconImageAssetId}`,
			gpId = id,
		}
		gps[name] = if gpInfo.featured then featuredGp(gpData) else gp(gpData)
	end

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.463),
		Size = UDim2.fromScale(0.578, 0.613),
		Visible = props.visible,
	}, {
		uIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			Thickness = 2,
		}),

		uICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),

		bar = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.131),
			Size = UDim2.fromScale(0.952, 0.182),
		}, {
			uICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			uIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			button = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Size = UDim2.fromScale(0.473, 0.768),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
			}, {
				uIStroke1 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(9, 9, 9),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text = React.createElement("TextLabel", {
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
					LineHeight = 0.63,
					Position = UDim2.fromScale(0.602, 0.488),
					Size = UDim2.fromScale(1.77, 1.9),
					Text = "GAMEPASSGAMEPASSGAMEPASS GAMEPASSGAMEPASS GAMEPASSGAMEPASSGAME",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					TextWrapped = true,
					ZIndex = 0,
				}),

				header = React.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Normal
					),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.749, 0.598),
					Text = "GAMEPASSES",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),
			}),

			button1 = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Size = UDim2.fromScale(0.473, 0.768),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
			}, {
				uIStroke2 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(9, 9, 9),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text1 = React.createElement("TextLabel", {
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
					LineHeight = 0.63,
					Position = UDim2.fromScale(0.602, 0.488),
					Size = UDim2.fromScale(1.77, 1.9),
					Text = "COINSCOINSCOINSCOINS COINSCOINSCOINSCOIN COINSCOINSCOINSCOINSCOINS",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					TextWrapped = true,
					ZIndex = 0,
				}),

				header1 = React.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Normal
					),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.749, 0.598),
					Text = "COINS",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),
			}),
		}),

		container = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.61),
			Size = UDim2.fromScale(0.952, 0.695),
		}, {
			uICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.01, 0),
			}),

			frame = React.createElement("ScrollingFrame", {
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				CanvasSize = UDim2.new(),
				Position = UDim2.fromScale(0.5, 0.5),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
				ScrollBarThickness = 4,
				Size = UDim2.fromScale(0.966, 0.912),
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			}, gps),

			gradient1 = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(15, 15, 15),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.93),
				Size = UDim2.fromScale(1, 0.139),
			}, {
				uIGradient5 = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.777, 0.0383),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
			}),
		}),

		button5 = React.createElement("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(1, 0.00405),
			Size = UDim2.fromScale(0.049, 0.0728),
			Text = "X",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			ZIndex = 10,
			[React.Event.MouseButton1Click] = function()
				props.onClose()
			end,
		}, {
			uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

			uICorner3 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke20 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				Thickness = 2,
			}),
		}),
	})
end
