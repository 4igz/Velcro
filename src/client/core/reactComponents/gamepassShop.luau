local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local e = React.createElement

return function(props)
	return e("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, {
		main = e("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.244, 0.172),
			Size = UDim2.fromOffset(635, 421),
		}, {
			uICorner = e("UICorner", {
				CornerRadius = UDim.new(0, 20),
			}),

			uIStroke = e("UIStroke", {
				Color = Color3.fromRGB(30, 31, 54),
				Thickness = 8,
			}),

			title = e("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Text = "Shop",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 76,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(-0.0325, -0.135),
				Rotation = -5,
				Size = UDim2.fromOffset(176, 95),
				ZIndex = 3,
			}, {
				uIStroke1 = e("UIStroke", {
					Color = Color3.fromRGB(30, 31, 54),
					Thickness = 6,
				}),
			}),

			uIGradient = e("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 252, 255)),
				}),
				Rotation = 90,
			}),

			icon = e("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=16899045753",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(-0.12, -0.207),
				Size = UDim2.fromOffset(126, 126),
				ZIndex = 2,
			}),

			background = e("ImageLabel", {
				Image = "http://www.roblox.com/asset/?id=16901078110",
				ImageColor3 = Color3.fromRGB(166, 227, 255),
				ImageTransparency = 0.57,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(50, 50),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
			}, {
				uICorner1 = e("UICorner", {
					CornerRadius = UDim.new(0, 20),
				}),

				uIGradient1 = e("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.385, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
			}),

			scrollingFrame = e("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BottomImage = "rbxassetid://16550250729",
				CanvasSize = UDim2.new(),
				MidImage = "rbxassetid://16550249873",
				ScrollBarImageColor3 = Color3.fromRGB(30, 31, 54),
				ScrollBarThickness = 15,
				TopImage = "rbxassetid://16550248960",
				Active = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.00472, 0.0356),
				Size = UDim2.fromOffset(644, 390),
			}, {
				uIListLayout = e("UIListLayout", {
					Padding = UDim.new(0, 20),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				banner = e("ImageLabel", {
					Image = "http://www.roblox.com/asset/?id=16901285179",
					ImageColor3 = Color3.fromRGB(232, 75, 75),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(287, 164, 703, 164),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.0513, -0.0113),
					Size = UDim2.fromOffset(537, 93),
				}, {
					uIListLayout1 = e("UIListLayout", {
						Padding = UDim.new(0, 15),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					icon1 = e("ImageLabel", {
						Image = "http://www.roblox.com/asset/?id=16925722637",
						ImageColor3 = Color3.fromRGB(255, 246, 144),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.185, 0.0921),
						Size = UDim2.fromOffset(62, 62),
					}, {
						uIGradient2 = e("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 213, 44)),
							}),
							Rotation = 80,
						}),
					}),

					title1 = e("TextLabel", {
						FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
						Text = "LIMITED TIME",
						TextColor3 = Color3.fromRGB(255, 246, 144),
						TextScaled = true,
						TextSize = 51,
						TextWrapped = true,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.314, 0.161),
						Size = UDim2.fromScale(0.516, 0.677),
					}, {
						uITextSizeConstraint = e("UITextSizeConstraint", {
							MaxTextSize = 50,
						}),

						uIStroke2 = e("UIStroke", {
							Color = Color3.fromRGB(80, 58, 27),
							Thickness = 5.3,
						}),

						uIGradient3 = e("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 213, 44)),
							}),
							Rotation = 80,
						}),
					}),

					icon2 = e("ImageLabel", {
						Image = "http://www.roblox.com/asset/?id=16925722637",
						ImageColor3 = Color3.fromRGB(255, 246, 144),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.75, 0.0921),
						Size = UDim2.fromOffset(62, 62),
					}, {
						uIGradient4 = e("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 213, 44)),
							}),
							Rotation = 80,
						}),
					}),

					uIPadding = e("UIPadding", {
						PaddingBottom = UDim.new(0, 17),
					}),
				}),

				uIGradient5 = e("UIGradient", {
					Rotation = -90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
				}),

				uIPadding1 = e("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 25),
					PaddingTop = UDim.new(0, 35),
				}),

				eggs = e("Frame", {
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.0107, -0.0141),
					Size = UDim2.fromOffset(596, 176),
				}, {
					uIListLayout2 = e("UIListLayout", {
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					eggBillboard = e("Frame", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.0319, 0.0933),
						Size = UDim2.fromOffset(596, 117),
					}, {
						uICorner2 = e("UICorner", {
							CornerRadius = UDim.new(0, 15),
						}),

						uIStroke3 = e("UIStroke", {
							Color = Color3.fromRGB(30, 31, 54),
							Thickness = 5.3,
						}),

						uIGradient6 = e("UIGradient", {
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 255, 137)),
								ColorSequenceKeypoint.new(0.5, Color3.fromRGB(129, 255, 228)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 255, 92)),
							}),
							Rotation = 45,
						}),

						label = e("TextLabel", {
							FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
							Text = "Lucky Egg!",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 56,
							TextXAlignment = Enum.TextXAlignment.Left,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.0201, -0.301),
							Size = UDim2.fromOffset(352, 50),
						}, {
							uIStroke4 = e("UIStroke", {
								Color = Color3.fromRGB(30, 31, 54),
								Thickness = 4.1,
							}),
						}),

						eggIcon = e("ImageLabel", {
							Image = "rbxassetid://9194077649",
							ImageColor3 = Color3.fromRGB(36, 43, 83),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.0369, 0.137),
							Size = UDim2.fromOffset(84, 84),
						}),

						frame = e("Frame", {
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.394, 0.214),
							Size = UDim2.fromOffset(361, 67),
						}, {
							uIListLayout3 = e("UIListLayout", {
								Padding = UDim.new(0, 15),
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Center,
							}),

							frame1 = e("Frame", {
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = UDim2.fromScale(0, 0.00746),
								Size = UDim2.fromOffset(66, 66),
							}, {
								uICorner3 = e("UICorner", {
									CornerRadius = UDim.new(0, 15),
								}),

								uIStroke5 = e("UIStroke", {
									Color = Color3.fromRGB(30, 31, 54),
									Thickness = 4.1,
								}),
							}),

							frame2 = e("Frame", {
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = UDim2.fromScale(0, 0.00746),
								Size = UDim2.fromOffset(66, 66),
							}, {
								uICorner4 = e("UICorner", {
									CornerRadius = UDim.new(0, 15),
								}),

								uIStroke6 = e("UIStroke", {
									Color = Color3.fromRGB(30, 31, 54),
									Thickness = 4.1,
								}),
							}),

							frame3 = e("Frame", {
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								LayoutOrder = 1,
								Position = UDim2.fromScale(0.564, -0.209),
								Size = UDim2.fromOffset(95, 95),
							}, {
								uICorner5 = e("UICorner", {
									CornerRadius = UDim.new(0, 15),
								}),

								uIStroke7 = e("UIStroke", {
									Color = Color3.fromRGB(30, 31, 54),
									Thickness = 4.1,
								}),
							}),

							frame4 = e("Frame", {
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								LayoutOrder = -1,
								Position = UDim2.fromScale(0, 0.00746),
								Size = UDim2.fromOffset(66, 66),
							}, {
								uICorner6 = e("UICorner", {
									CornerRadius = UDim.new(0, 15),
								}),

								uIStroke8 = e("UIStroke", {
									Color = Color3.fromRGB(30, 31, 54),
									Thickness = 4.1,
								}),
							}),
						}),

						textButton = e("TextButton", {
							FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
							Text = "PURCHASE",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 36,
							BackgroundColor3 = Color3.fromRGB(60, 247, 60),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.305, 0.906),
							Size = UDim2.fromOffset(233, 50),
						}, {
							uICorner7 = e("UICorner", {
								CornerRadius = UDim.new(0, 10),
							}),

							uIStroke9 = e("UIStroke", {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Color = Color3.fromRGB(30, 31, 54),
								Thickness = 3.7,
							}),

							uIStroke10 = e("UIStroke", {
								Color = Color3.fromRGB(30, 31, 54),
								Thickness = 3.3,
							}),
						}),
					}),

					uIPadding2 = e("UIPadding", {
						PaddingTop = UDim.new(0, 15),
					}),
				}),

				slots = e("Frame", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.0271, 0.346),
					Size = UDim2.fromOffset(576, 232),
				}, {
					uIGridLayout = e("UIGridLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					frame5 = e("Frame", {
						BackgroundColor3 = Color3.fromRGB(225, 248, 255),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.fromOffset(100, 100),
					}, {
						uICorner8 = e("UICorner", {
							CornerRadius = UDim.new(0, 10),
						}),

						uIStroke11 = e("UIStroke", {
							Color = Color3.fromRGB(30, 31, 54),
							Thickness = 5.4,
						}),

						textLabel = e("TextLabel", {
							FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
							Text = "Title",
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 23,
							TextWrapped = true,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 0.27),
							ZIndex = 2,
						}, {
							uIStroke12 = e("UIStroke", {
								Color = Color3.fromRGB(30, 31, 54),
								Thickness = 2.2,
							}),

							uITextSizeConstraint1 = e("UITextSizeConstraint", {
								MaxTextSize = 23,
							}),
						}),

						textLabel1 = e("TextLabel", {
							FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
							Text = "30 robux or something",
							TextColor3 = Color3.fromRGB(57, 255, 80),
							TextScaled = true,
							TextSize = 19,
							TextWrapped = true,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0, 0.73),
							Size = UDim2.fromScale(1, 0.27),
							ZIndex = 2,
						}, {
							uIStroke13 = e("UIStroke", {
								Color = Color3.fromRGB(59, 85, 34),
								Thickness = 2.2,
							}),

							uITextSizeConstraint2 = e("UITextSizeConstraint", {
								MaxTextSize = 18,
							}),
						}),

						imageLabel = e("ImageLabel", {
							Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromScale(0.8, 0.8),
						}),
					}),
				}),
			}),
		}),
	})
end
