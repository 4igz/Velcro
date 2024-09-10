local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local weaponUtil = require(ReplicatedStorage.shared.utilities.weaponUtil)
local zap = require(ReplicatedStorage.zap)

local e = React.createElement

return function(menuRef)
	local displayedWeapons, setWeapons = React.useState(weaponUtil.getWeaponsByType("gun"))

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.515, 0.676),
	}, {
		uIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(46, 123, 162),
			Thickness = 4,
		}),

		uICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),

		title = React.createElement("TextLabel", {
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
			Position = UDim2.fromScale(0.5, -0.006),
			Size = UDim2.fromScale(0.562, 0.11),
			Text = "Shop",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}, {
			uIStroke1 = React.createElement("UIStroke", {
				Color = Color3.fromRGB(33, 90, 118),
				Thickness = 2,
			}),

			uIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 204, 204)),
				}),
				Rotation = 90,
			}),
		}),

		shadow = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(24, 63, 83),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.521, 0.539),
			Size = UDim2.fromScale(1, 1),
			ZIndex = -1,
		}, {
			uICorner1 = React.createElement("UICorner"),

			uIGradient1 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(189, 189, 189)),
				}),
				Rotation = 90,
			}),

			uIStroke2 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(14, 38, 50),
				Thickness = 3,
			}),
		}),

		bar = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(227, 227, 227),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.112),
			Size = UDim2.fromScale(0.929, 0.0983),
		}, {
			uIStroke3 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(208, 208, 208),
				Thickness = 2,
			}),

			uICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			button = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(69, 185, 243),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.168, 0.537),
				Size = UDim2.fromScale(0.312, 0.732),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uICorner3 = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),

				uIStroke4 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				textLabel = React.createElement("TextLabel", {
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
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.926, 0.758),
					Text = "PRIMARY",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}, {
					uIStroke5 = React.createElement("UIStroke", {
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),
				}),
			}),

			uIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			button1 = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(69, 185, 243),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.5, 0.537),
				Size = UDim2.fromScale(0.312, 0.732),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uICorner4 = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),

				uIStroke6 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				textLabel1 = React.createElement("TextLabel", {
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
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.926, 0.758),
					Text = "SECONDARY",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}, {
					uIStroke7 = React.createElement("UIStroke", {
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),
				}),
			}),

			button2 = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(69, 185, 243),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.832, 0.537),
				Size = UDim2.fromScale(0.312, 0.732),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uICorner5 = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),

				uIStroke8 = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				textLabel2 = React.createElement("TextLabel", {
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
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.926, 0.758),
					Text = "MELEE",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}, {
					uIStroke9 = React.createElement("UIStroke", {
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),
				}),
			}),
		}),

		frameContainer = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(227, 227, 227),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.5, 0.573),
			Size = UDim2.fromScale(0.929, 0.751),
		}, {
			uIStroke10 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(208, 208, 208),
				Thickness = 2,
			}),

			frame = React.createElement("ScrollingFrame", {
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Color3.fromRGB(227, 227, 227),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BottomImage = "rbxassetid://12058295216",
				CanvasSize = UDim2.fromScale(0, 1),
				ClipsDescendants = false,
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				MidImage = "rbxassetid://12058295216",
				Position = UDim2.fromScale(0.503, 0.5),
				ScrollBarImageColor3 = Color3.fromRGB(46, 123, 162),
				ScrollBarThickness = 6,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Size = UDim2.fromScale(0.982, 0.952),
				TopImage = "rbxassetid://12058295216",
				ZIndex = 2,
			}, {
				uIListLayout1 = React.createElement("UIListLayout", {
					Padding = UDim.new(0.03, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				frame2 = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(69, 179, 237),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Position = UDim2.fromScale(0.491, 0.386),
					Size = UDim2.fromScale(0.982, 0.237),
				}, {
					uICorner6 = React.createElement("UICorner", {
						CornerRadius = UDim.new(0.02, 0),
					}),

					uIStroke11 = React.createElement("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),

					title1 = React.createElement("TextLabel", {
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
						Position = UDim2.fromScale(0.403, 0.255),
						Size = UDim2.fromScale(0.758, 0.35),
						Text = "Permanent M4A1",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 2,
					}, {
						uIStroke12 = React.createElement("UIStroke", {
							Color = Color3.fromRGB(46, 123, 162),
							Thickness = 2,
						}),
					}),

					description = React.createElement("TextLabel", {
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
						Position = UDim2.fromScale(0.403, 0.684),
						Size = UDim2.fromScale(0.758, 0.507),
						Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						ZIndex = 2,
					}, {
						uITextSizeConstraint = React.createElement("UITextSizeConstraint", {
							MaxTextSize = 18,
						}),
					}),

					icon = React.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = "rbxassetid://11910903697",
						Position = UDim2.fromScale(0.397, 0.5),
						ScaleType = Enum.ScaleType.Crop,
						Size = UDim2.fromScale(0.794, 1),
					}),

					button3 = React.createElement("TextButton", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(98, 233, 51),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Position = UDim2.fromScale(0.898, 0.66),
						Size = UDim2.fromScale(0.178, 0.46),
						Text = "",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,
					}, {
						uICorner7 = React.createElement("UICorner", {
							CornerRadius = UDim.new(0.05, 0),
						}),

						uIStroke13 = React.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(92, 214, 47),
							Thickness = 2,
						}),

						uIGradient2 = React.createElement("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(0.936, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(0.939, Color3.fromRGB(173, 173, 173)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(173, 173, 173)),
							}),
							Rotation = 90,
						}),

						price = React.createElement("TextLabel", {
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
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.909, 0.786),
							Text = "500$",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
						}, {
							uIStroke14 = React.createElement("UIStroke", {
								Color = Color3.fromRGB(78, 182, 40),
								Thickness = 2,
							}),
						}),
					}),
				}),

				frame1 = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(69, 179, 237),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.491, 1.99),
					Size = UDim2.fromScale(0.982, 0.237),
				}, {
					uICorner8 = React.createElement("UICorner", {
						CornerRadius = UDim.new(0.02, 0),
					}),

					uIStroke15 = React.createElement("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),

					button4 = React.createElement("TextButton", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(98, 233, 51),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Position = UDim2.fromScale(0.898, 0.66),
						Size = UDim2.fromScale(0.178, 0.46),
						Text = "",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,
					}, {
						uICorner9 = React.createElement("UICorner", {
							CornerRadius = UDim.new(0.05, 0),
						}),

						uIStroke16 = React.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(92, 214, 47),
							Thickness = 2,
						}),

						uIGradient3 = React.createElement("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(0.936, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(0.939, Color3.fromRGB(173, 173, 173)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(173, 173, 173)),
							}),
							Rotation = 90,
						}),

						price1 = React.createElement("TextLabel", {
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
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.909, 0.786),
							Text = "500$",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
						}, {
							uIStroke17 = React.createElement("UIStroke", {
								Color = Color3.fromRGB(78, 182, 40),
								Thickness = 2,
							}),
						}),
					}),

					title2 = React.createElement("TextLabel", {
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
						Position = UDim2.fromScale(0.458, 0.255),
						Size = UDim2.fromScale(0.647, 0.35),
						Text = "x2 XP",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					}, {
						uIStroke18 = React.createElement("UIStroke", {
							Color = Color3.fromRGB(46, 123, 162),
							Thickness = 2,
						}),
					}),

					icon1 = React.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = "rbxassetid://12934658355",
						Position = UDim2.fromScale(0.06, 0.5),
						Size = UDim2.fromScale(0.125, 0.874),
					}, {
						uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
					}),

					description1 = React.createElement("TextLabel", {
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
						Position = UDim2.fromScale(0.458, 0.684),
						Size = UDim2.fromScale(0.647, 0.507),
						Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
					}, {
						uITextSizeConstraint1 = React.createElement("UITextSizeConstraint", {
							MaxTextSize = 18,
						}),
					}),
				}),
			}),

			gradient = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.893),
				Size = UDim2.fromScale(1, 0.213),
				ZIndex = 3,
			}, {
				uIGradient4 = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
			}),
		}),

		button5 = React.createElement("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(62, 171, 222),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxassetid://12187607287",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.995, -0.00657),
			Size = UDim2.fromScale(0.0511, 0.0807),
			Text = "X",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}, {
			uICorner10 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke19 = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(33, 90, 118),
				Thickness = 2,
			}),

			uIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),
		}),
	})
end
