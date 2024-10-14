local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local e = React.createElement

return function(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.463),
		Size = UDim2.fromScale(0.578, 0.613),
		Visible = false,
	}, {
		uIStroke14 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			Thickness = 2,
		}),

		uICorner = e("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),

		bar3 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.131),
			Size = UDim2.fromScale(0.952, 0.182),
		}, {
			uICorner1 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			uIListLayout1 = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			button1 = e("TextButton", {
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
				uIStroke15 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(9, 9, 9),
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
					Text = "GAMEPASSGAMEPASSGAMEPASS GAMEPASSGAMEPASS GAMEPASSGAMEPASSGAME",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextTransparency = 0.97,
					TextWrapped = true,
					ZIndex = 0,
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

			button2 = e("TextButton", {
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
				uIStroke16 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(9, 9, 9),
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

				header1 = e("TextLabel", {
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

		container = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.61),
			Size = UDim2.fromScale(0.952, 0.695),
		}, {
			uICorner2 = e("UICorner", {
				CornerRadius = UDim.new(0.01, 0),
			}),

			frame = e("ScrollingFrame", {
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
			}, {
				featured = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.379, 0.185),
					Size = UDim2.fromScale(0.987, 0.384),
				}, {
					frame1 = e("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 0.7,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.979, 0.925),
					}, {
						uIStroke17 = e("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(9, 9, 9),
							LineJoinMode = Enum.LineJoinMode.Miter,
							Thickness = 3,
						}),

						gradient = e("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 0.4,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(1, 1),
							ZIndex = 2,
						}, {
							uIGradient2 = e("UIGradient", {
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

						gamepass = e("TextLabel", {
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
							Text = "+50 HEALTH",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 2,
						}, {
							uIGradient3 = e("UIGradient", {
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(144, 144, 144)),
								}),
								Rotation = 90,
							}),

							uIStroke18 = e("UIStroke", {
								Color = Color3.fromRGB(22, 22, 22),
								Thickness = 2,
							}),
						}),

						button3 = e("TextButton", {
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
							uIStroke19 = e("UIStroke", {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Color = Color3.fromRGB(15, 15, 15),
								LineJoinMode = Enum.LineJoinMode.Miter,
								Thickness = 3,
							}),

							text2 = e("TextLabel", {
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
								Size = UDim2.fromScale(0.749, 0.701),
								Text = "BUY",
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
							Position = UDim2.fromScale(0.842, 0.3),
							Size = UDim2.fromScale(0.26, 0.274),
							Text = "500$",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
							ZIndex = 2,
						}, {
							uIGradient4 = e("UIGradient", {
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 85, 6)),
								}),
								Rotation = 90,
							}),

							uIStroke20 = e("UIStroke", {
								Color = Color3.fromRGB(15, 15, 15),
								Thickness = 2,
							}),
						}),

						viewportFrame = e("ViewportFrame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(22, 22, 22),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.501, 0.521),
							Size = UDim2.fromScale(0.973, 0.79),
						}, {
							uIStroke21 = e("UIStroke", {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Color = Color3.fromRGB(15, 15, 15),
								LineJoinMode = Enum.LineJoinMode.Miter,
								Thickness = 3,
							}),

							text3 = e("TextLabel", {
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
				}),

				template = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.7,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Position = UDim2.fromScale(0.242, 0.709),
					Size = UDim2.fromScale(0.463, 0.57),
				}, {
					button4 = e("TextButton", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(22, 22, 22),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Position = UDim2.fromScale(0.711, 0.791),
						Size = UDim2.fromScale(0.511, 0.268),
						Text = "",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,
					}, {
						uIStroke22 = e("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(15, 15, 15),
							LineJoinMode = Enum.LineJoinMode.Miter,
							Thickness = 3,
						}),

						text4 = e("TextLabel", {
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

						header3 = e("TextLabel", {
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

					price1 = e("TextLabel", {
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
						Position = UDim2.fromScale(0.219, 0.79),
						Size = UDim2.fromScale(0.374, 0.266),
						Text = "500$",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
					}, {
						uIGradient5 = e("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 85, 6)),
							}),
							Rotation = 90,
						}),

						uIStroke23 = e("UIStroke", {
							Color = Color3.fromRGB(15, 15, 15),
							Thickness = 2,
						}),
					}),

					viewportFrame1 = e("ViewportFrame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(22, 22, 22),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.499, 0.321),
						Size = UDim2.fromScale(0.935, 0.51),
					}, {
						uIStroke24 = e("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(15, 15, 15),
							LineJoinMode = Enum.LineJoinMode.Miter,
							Thickness = 3,
						}),

						text5 = e("TextLabel", {
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

					uIStroke25 = e("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(9, 9, 9),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 3,
					}),
				}),

				uIListLayout2 = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0.04, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			}),
		}),

		button5 = e("TextButton", {
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
		}, {
			uIAspectRatioConstraint8 = e("UIAspectRatioConstraint"),

			uICorner3 = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke26 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				Thickness = 2,
			}),
		}),
	})
end
