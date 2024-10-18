local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local leaderboardController = require(ReplicatedStorage.client.controllers.leaderboardController)
local moneyUi = require(script.Parent.moneyUi)
local playerHUDController = require(ReplicatedStorage.client.controllers.playerHUDController)
local playerUtil = require(ReplicatedStorage.shared.utilities.playerUtil)
local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local zap = require(ReplicatedStorage.zap)

local WHATS_NEW = "New UI"

local e = React.createElement

local function createTopBar(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.9,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.0689),
		Size = UDim2.fromScale(1, 0.138),
		ZIndex = 100,
		Visible = props.shown ~= "none",
	}, {
		info = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.192, 0.5),
			Size = UDim2.fromScale(0.353, 0.5),
		}, {
			header = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://105304761064572",
				ImageColor3 = Color3.fromRGB(22, 22, 22),
				Position = UDim2.fromScale(0.41, 1),
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.fromScale(0.821, 1),
				SliceCenter = Rect.new(0, 0, 757, 200),
			}, {
				container = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.497, 0.5),
					Size = UDim2.fromScale(0.993, 1),
				}, {
					pfp = e("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = playerUtil.avatarImage(
							Players.LocalPlayer.UserId,
							Enum.ThumbnailSize.Size420x420,
							Enum.ThumbnailType.HeadShot
						),
						Position = UDim2.fromScale(0.07, 0.5),
						Size = UDim2.fromScale(0.198, 0.7),
					}, {
						uIAspectRatioConstraint = e("UIAspectRatioConstraint"),

						uICorner = e("UICorner", {
							CornerRadius = UDim.new(1, 0),
						}),

						uIStroke = e("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(39, 39, 39),
							Thickness = 2,
						}),
					}),

					username = e("TextLabel", {
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
						Position = UDim2.fromScale(0.494, 0.49),
						Size = UDim2.fromScale(0.704, 0.417),
						Text = Players.LocalPlayer.Name,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					}),
				}),
			}),

			add = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://80628076134787",
				ImageColor3 = Color3.fromRGB(22, 22, 22),
				Position = UDim2.fromScale(0.845, 1),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.311, 1),
				SliceCenter = Rect.new(0, 0, 1022, 371),
			}),
		}),

		backInfo = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Position = UDim2.fromScale(0.841, 0.5),
			Size = UDim2.fromScale(0.286, 0.5),
			Visible = props.shown == "shop",
		}, {
			header = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://94037862615919",
				ImageColor3 = Color3.fromRGB(22, 22, 22),
				Position = UDim2.fromScale(0.656, 1),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.683, 0.998),
				SliceCenter = Rect.new(284, 0, 1020, 200),
			}, {
				text = e("TextLabel", {
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
					Position = UDim2.fromScale(0.542, 0.5),
					Size = UDim2.fromScale(0.917, 0.649),
					Text = "SHOP",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),
			}),

			add = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://80628076134787",
				ImageColor3 = Color3.fromRGB(22, 22, 22),
				Position = UDim2.fromScale(0.289, 1),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.438, 1),
				SliceCenter = Rect.new(0, 0, 1022, 371),
			}, {
				button = e("ImageButton", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://10747365359",
					Position = UDim2.fromScale(0.4, 0.17),
					Size = UDim2.fromScale(0.187, 0.609),
					[React.Event.MouseButton1Click] = function()
						props.setMenu(props.lastMenu.current)
						props.lastMenu.current = props.shown
					end,
				}, {
					uIAspectRatioConstraint = e("UIAspectRatioConstraint"),
				}),
			}),
		}),
	})
end

local function createMainMenu(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Visible = props.shown,
	}, {
		frame2 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.192, 0.505),
			Size = UDim2.fromScale(0.353, 0.927),
		}, {
			deploy = e("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://18416084269",
				Position = UDim2.fromScale(0.5, 0.153),
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(0.925, 0.249),

				[React.Event.MouseButton1Click] = function()
					props.onDeploy()
					props.lastMenu.current = "none"
				end,
			}, {
				uIGradient1 = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
					}),
					Rotation = 90,
				}),

				uIStroke1 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				button1 = e("Frame", {
					Active = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.126, 0.501),
					Selectable = true,
					Size = UDim2.fromScale(0.252, 1),
				}, {
					imageLabel = e("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = "rbxassetid://131116519317416",
						Position = UDim2.fromScale(0.403, 0.495),
						Size = UDim2.fromScale(0.553, 0.409),
					}, {
						uIAspectRatioConstraint2 = e("UIAspectRatioConstraint"),
					}),

					uIGradient2 = e("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(0.751, 0),
							NumberSequenceKeypoint.new(0.859, 0.443),
							NumberSequenceKeypoint.new(1, 1),
						}),
					}),
				}),
			}),

			shop = e("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.387, 0.389),
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(0.7, 0.146),

				[React.Event.MouseButton1Click] = function()
					props.onShopButtonClick()
				end,
			}, {
				uIStroke2 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				textLabel = e("TextLabel", {
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
					Text = "SHOPSHOP SHOP SHOPSHOP SHOPSHOPSHOP SHOP SHOPSHOP",
					TextColor3 = Color3.fromRGB(255, 64, 0),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					TextWrapped = true,
					ZIndex = 0,
				}),

				textLabel1 = e("TextLabel", {
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
					Position = UDim2.fromScale(0.425, 0.5),
					Size = UDim2.fromScale(0.749, 0.272),
					Text = "SHOP",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),

			frame3 = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.451, 0.946),
				Size = UDim2.fromScale(0.827, 0.0569),
			}, {
				uIStroke3 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				frame4 = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(16, 16, 16),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.559, 0.5),
					Size = UDim2.fromScale(0.85, 0.545),
				}, {
					frame5 = e("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 106, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.271, 0.5),
						Size = UDim2.fromScale(0.543, 1),
					}, {
						textLabel2 = e("TextLabel", {
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
							Position = UDim2.fromScale(0.508, 0.5),
							Size = UDim2.fromScale(0.964, 1),
							Text = "491 XP",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextTransparency = 0.5,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),
					}),

					uIStroke4 = e("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(11, 11, 11),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 2,
					}),

					textLabel3 = e("TextLabel", {
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
						Position = UDim2.fromScale(0.871, 0.5),
						Size = UDim2.fromScale(0.239, 1),
						Text = "1000",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextTransparency = 0.5,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Right,
					}),
				}),

				textLabel4 = e("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Regular,
						Enum.FontStyle.Italic
					),
					Position = UDim2.fromScale(0.066, 0.305),
					RichText = true,
					Size = UDim2.fromScale(0.104, 0.462),
					Text = "Level",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),

				textLabel5 = e("TextLabel", {
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
					Position = UDim2.fromScale(0.0674, 0.768),
					RichText = true,
					Size = UDim2.fromScale(0.101, 0.5),
					Text = "10",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),

			var_settings = e("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.925, 0.946),
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(0.0741, 0.0569),
			}, {
				uIStroke5 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				imageLabel1 = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://16166050749",
					Position = UDim2.fromScale(0.5, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromScale(0.91, 0.839),
				}),
			}),

			frame6 = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.5, 0.691),
				Size = UDim2.fromScale(0.925, 0.367),
			}, {
				uIStroke6 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				design = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(16, 16, 16),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.5, 0.948),
					Size = UDim2.fromScale(1, 0.103),
				}, {
					textLabel6 = e("TextLabel", {
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
						Position = UDim2.fromScale(0.494, 0.594),
						Size = UDim2.fromScale(0.96, 0.813),
						Text = "WHAT'S NEW",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					}),
				}),

				textLabel7 = e("TextLabel", {
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
					Position = UDim2.fromScale(0.623, 0.483),
					Size = UDim2.fromScale(3.05, 1.9),
					Text = "UPDATEUPDATEUPDATE UPDATEUPDATEUPDATEUPDATE UPDATEUPDATE UPDATEUPDATE UPDATE",
					TextColor3 = Color3.fromRGB(255, 64, 0),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					TextWrapped = true,
					ZIndex = 0,
				}),

				new = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(16, 16, 16),
					BackgroundTransparency = 0.5,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.5, 0.448),
					Size = UDim2.fromScale(0.956, 0.793),
				}, {
					txt = e("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.945, 0.911),
						Text = WHATS_NEW,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
					}),
				}),
			}),
		}),
	})
end

local function menuSwitchButton(props)
	return e("ImageButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.0917, 0.5),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(0.187, 0.732),
		LayoutOrder = props.order,

		[React.Event.MouseButton1Click] = function()
			props.onWeaponClick(props.weaponType)
		end,
	}, {
		uIStroke7 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 3,
		}),

		text1 = e("TextLabel", {
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
			LineHeight = 1,
			Position = UDim2.fromScale(0.602, 0.488),
			Size = UDim2.fromScale(1.77, 1.9),
			Text = string.rep(`{string.rep(string.upper(props.weaponType), 6)}\n`, 6),
			TextColor3 = Color3.fromRGB(255, 64, 0),
			TextScaled = true,
			TextTransparency = 0.97,
			TextWrapped = true,
			ZIndex = 1,
		}),

		header2 = e("TextLabel", {
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
			Size = UDim2.fromScale(0.749, 0.422),
			Text = string.upper(props.weaponType),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),
	})
end

local function createShopMenu(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Visible = props.shown,
	}, {
		container1 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.968, 0.927),
		}, {
			topbar1 = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.132),
				Size = UDim2.fromScale(0.972, 0.205),
			}, {
				uIListLayout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0.01, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				pistol = menuSwitchButton({
					order = 1,
					weaponType = "pistol",
					onWeaponClick = props.onWeaponClick,
				}),

				sniper = menuSwitchButton({
					order = 2,
					weaponType = "sniper",
					onWeaponClick = props.onWeaponClick,
				}),

				smg = menuSwitchButton({
					order = 3,
					weaponType = "smg",
					onWeaponClick = props.onWeaponClick,
				}),

				rifle = menuSwitchButton({
					order = 4,
					weaponType = "rifle",
					onWeaponClick = props.onWeaponClick,
				}),

				shotgun = menuSwitchButton({
					order = 5,
					weaponType = "shotgun",
					onWeaponClick = props.onWeaponClick,
				}),
			}),

			button2 = e("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.0363, 0.622),
				Size = UDim2.fromScale(0.0454, 0.698),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
			}, {
				icon = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://10709791281",
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.825, 0.116),
				}, {
					uIAspectRatioConstraint3 = e("UIAspectRatioConstraint"),
				}),
			}),

			button3 = e("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.963, 0.622),
				Size = UDim2.fromScale(0.0454, 0.698),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
			}, {
				icon1 = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://10709791437",
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.825, 0.116),
				}, {
					uIAspectRatioConstraint4 = e("UIAspectRatioConstraint"),
				}),
			}),

			container2 = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.622),
				Size = UDim2.fromScale(0.851, 0.698),
			}, {
				scrollingFrame = e("ScrollingFrame", {
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
					ScrollBarThickness = 6,
					Size = UDim2.fromScale(0.977, 0.944),
					TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				}, props.weapons),
			}),
		}),
	})
end

local function weaponFrame(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.8,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0.323, 0.6),
		LayoutOrder = props.order,
	}, {
		bottom = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.5, 0.68),
			Size = UDim2.fromScale(0.982, 0.604),
		}, {
			button = e("TextButton", {
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
				TextSize = 14,

				[React.Event.MouseButton1Click] = function()
					local weaponData = { weaponName = props.name, weaponType = props.type }

					if not props.owned then
						zap.buyWeapon.Fire(weaponData)
						props.updateUi(props.type)
						return
					end

					zap.equipWeapon.Fire(props.name)
					props.updateUi(props.type)
				end,
			}, {
				uIStroke = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text = e("TextLabel", {
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
					ZIndex = 2,
				}),

				header = e("TextLabel", {
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
					Text = not props.owned and "BUY"
						or if props.equipped then "EQUIPPED" else "EQUIP",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),
			}),

			price = e("TextLabel", {
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
				Text = `${props.price}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIGradient = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 85, 6)),
					}),
					Rotation = 90,
				}),

				uIStroke1 = e("UIStroke", {
					Color = Color3.fromRGB(15, 15, 15),
					Thickness = 2,
				}),
			}),

			viewportFrame = e("ViewportFrame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.34),
				Size = UDim2.fromScale(0.935, 0.55),
			}, {
				uIStroke2 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(15, 15, 15),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				text1 = e("TextLabel", {
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

		top = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.5, 0.188),
			Size = UDim2.fromScale(0.982, 0.345),
		}, {
			header1 = e("TextLabel", {
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
				Text = `{string.upper(props.name)}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke3 = e("UIStroke", {
					Color = Color3.fromRGB(16, 16, 16),
					Thickness = 3,
				}),
			}),

			desc = e("TextLabel", {
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
				RichText = true,
				TextYAlignment = Enum.TextYAlignment.Top,
			}, {
				uIStroke4 = e("UIStroke", {
					Color = Color3.fromRGB(16, 16, 16),
				}),

				uITextSizeConstraint = e("UITextSizeConstraint", {
					MaxTextSize = 16,
				}),
			}),
		}),
	})
end

return function(props)
	local menuShown, setMenuShown = React.useState(props.menu or "main")

	-- If a menu is opened like the shop that has a back button, we need to know what the last menu was to go back
	local lastMenu = React.useRef("main")

	local displayedWeapons, setWeapons = React.useState({})

	local function updateDisplayedWeapons(type)
		local weaponTypes = shopConfig[type]
		local data = zap.getOwnedWeapons.Call()

		local state = {}

		for name, info in weaponTypes do
			local itemType = weaponConfig.settings[name].itemType
			state[name] = weaponFrame({
				description = info.description,
				iconImageId = info.imageId,
				name = name,
				price = info.price,
				order = info.order,
				type = type,
				owned = table.find(data.ownedWeapons, name),
				equipped = data.equippedWeapons[itemType] == name,
				updateUi = updateDisplayedWeapons,
			})
		end

		state.uIGridLayout = e("UIGridLayout", {
			CellPadding = UDim2.fromScale(0.013, 0.035),
			CellSize = UDim2.fromScale(0.323, 0.4),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		setWeapons(state)
	end

	local function handleShopButtonClick()
		if menuShown == "shop" then
			setMenuShown(lastMenu.current) -- Return to previous menu
		else
			updateDisplayedWeapons("pistol")
			lastMenu.current = menuShown -- Save current menu before switching
			setMenuShown("shop") -- Open the shop
		end
	end

	local function handleDeployClick()
		props.onDeployClicked()
		setMenuShown("none") -- Hide the menu after deploy
	end

	-- update lastMenu and menuShown if props.menu changes
	React.useEffect(function()
		lastMenu.current = menuShown -- Store the previous menu
		setMenuShown(props.menu or "main") -- Ensure the main menu is set on reopen
	end, { props.menu })

	playerHUDController.setVisibility(menuShown == "none")
	leaderboardController.setVisibility(menuShown == "none")

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Visible = menuShown ~= "none",
	}, {
		background = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(13, 13, 13),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://84682077650492",
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			ZIndex = -1,
			Visible = not props.fromSidebar,
		}, {
			gradient = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.812),
				Size = UDim2.fromScale(1, 0.376),
			}, {
				uIGradient = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
					}),
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.306, 0.694),
						NumberSequenceKeypoint.new(0.756, 0.115),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
			}),
		}),

		-- Top Bar
		topbar = createTopBar({
			shown = menuShown,
			setMenu = setMenuShown,
			lastMenu = lastMenu,
		}),

		moneyUi = moneyUi({ position = UDim2.fromScale(0.3, 0.035) }),

		-- Main UI Frame with menus
		main = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.9,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.569),
			Size = UDim2.fromScale(1, 0.862),
		}, {
			-- Main Menu
			menu = createMainMenu({
				shown = menuShown == "main",
				onDeploy = handleDeployClick,
				onShopButtonClick = handleShopButtonClick, -- Pass shop click handler
				lastMenu = lastMenu,
			}),

			-- Shop Menu
			shopFrame = createShopMenu({
				shown = menuShown == "shop",
				onWeaponClick = updateDisplayedWeapons,
				weapons = displayedWeapons,
			}),
		}),
	})
end
