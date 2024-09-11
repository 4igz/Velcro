local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local weaponUtil = require(ReplicatedStorage.shared.utilities.weaponUtil)
local zap = require(ReplicatedStorage.zap)

local e = React.createElement

local function weaponFrame(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(69, 179, 237),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.491, 1.99),
		Size = UDim2.fromScale(0.982, 0.237),
		LayoutOrder = props.order,
	}, {
		uICorner6 = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),

		uIStroke11 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(46, 123, 162),
			Thickness = 2,
		}),

		button3 = e("TextButton", {
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
			uICorner7 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			uIStroke12 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(92, 214, 47),
				Thickness = 2,
			}),

			uIGradient2 = e("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.936, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.939, Color3.fromRGB(173, 173, 173)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(173, 173, 173)),
				}),
				Rotation = 90,
			}),

			price = e("TextLabel", {
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
				Text = `${props.price}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke13 = e("UIStroke", {
					Color = Color3.fromRGB(78, 182, 40),
					Thickness = 2,
				}),
			}),
		}),

		title1 = e("TextLabel", {
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
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, {
			uIStroke14 = e("UIStroke", {
				Color = Color3.fromRGB(46, 123, 162),
				Thickness = 2,
			}),
		}),

		icon = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = props.iconImageId,
			Position = UDim2.fromScale(0.06, 0.5),
			Size = UDim2.fromScale(0.125, 0.874),
		}, {
			uIAspectRatioConstraint = e("UIAspectRatioConstraint"),
		}),

		description = e("TextLabel", {
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
			Text = props.description,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		}, {
			uITextSizeConstraint = e("UITextSizeConstraint", {
				MaxTextSize = 18,
			}),
		}),
	})
end

return function(props)
	local displayedWeapons, setWeapons = React.useState({})

	local function updateDisplayedWeapons(type)
		local weaponTypes = shopConfig[type]

		local state = {}

		for name, info in weaponTypes do
			state[name] = weaponFrame({
				description = info.description,
				iconImageId = info.imageId,
				name = name,
				price = info.price,
				order = info.order,
			})
		end

		state.uiLayout = e("UIListLayout", {
			Padding = UDim.new(0.03, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		setWeapons(state)
	end

	React.useEffect(function()
		if props.open then
			updateDisplayedWeapons("gun")
		end
	end, { props.open })

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

		bar = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(227, 227, 227),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.112),
			Size = UDim2.fromScale(0.929, 0.0983),
		}, {
			uIStroke3 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(208, 208, 208),
				Thickness = 2,
			}),

			uICorner2 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			button = e("TextButton", {
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
				LayoutOrder = 1,
				[React.Event.MouseButton1Click] = function()
					updateDisplayedWeapons("gun")
				end,
			}, {
				uICorner3 = e("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),

				uIStroke4 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				textLabel = e("TextLabel", {
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
					Text = "GUNS",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					LayoutOrder = 1,
				}, {
					uIStroke5 = e("UIStroke", {
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),
				}),
			}),

			uIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			button1 = e("TextButton", {
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
				LayoutOrder = 2,
				[React.Event.MouseButton1Click] = function()
					updateDisplayedWeapons("melee")
				end,
			}, {
				uICorner4 = e("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),

				uIStroke6 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				textLabel1 = e("TextLabel", {
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

					LayoutOrder = 2,
				}, {
					uIStroke7 = e("UIStroke", {
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),
				}),
			}),

			button2 = e("TextButton", {
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
				LayoutOrder = 3,
				[React.Event.MouseButton1Click] = function()
					updateDisplayedWeapons("equipment")
				end,
			}, {
				uICorner5 = e("UICorner", {
					CornerRadius = UDim.new(0.05, 0),
				}),

				uIStroke8 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(46, 123, 162),
					Thickness = 2,
				}),

				textLabel2 = e("TextLabel", {
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
					Text = "EQUIPMENT",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					LayoutOrder = 3,
				}, {
					uIStroke9 = e("UIStroke", {
						Color = Color3.fromRGB(46, 123, 162),
						Thickness = 2,
					}),
				}),
			}),
		}),

		frameContainer = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(227, 227, 227),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.5, 0.573),
			Size = UDim2.fromScale(0.929, 0.751),
		}, {
			uIStroke10 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(208, 208, 208),
				Thickness = 2,
			}),

			frame = e("ScrollingFrame", {
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
			}, displayedWeapons),

			gradient = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.893),
				Size = UDim2.fromScale(1, 0.213),
				ZIndex = 3,
			}, {
				uIGradient3 = e("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
			}),
		}),

		closeButton = e("TextButton", {
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

			[React.Event.MouseButton1Click] = function()
				props.onClose()
			end,
		}, {
			uICorner8 = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke15 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(33, 90, 118),
				Thickness = 2,
			}),

			uIAspectRatioConstraint1 = e("UIAspectRatioConstraint"),
		}),
	})
end
