local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local settingsConfig = require(ReplicatedStorage.shared.configurations.settingsConfig)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)

local e = React.createElement

local function toggleTemplate(props)
	local XImage = "rbxassetid://10747384394"
	local CheckImage = "rbxassetid://1202200114"

	local isOn, setIsOn = React.useState(props.settingInfo.default)

	local function toggleState()
		props.settingInfo.value = not isOn
		props.settingInfo.stepFunction(not isOn)
		setIsOn(not isOn)

		-- We don't want the AFK setting to be saved because
		-- they might forget then think the game is broken
		if props.name == "AFK" then
			return
		end
		zap.updateSettings.Fire({
			setting = props.name,
			value = not isOn,
			category = props.category,
		})
	end

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.0922),
		Size = UDim2.fromScale(0.984, 0.184),
		LayoutOrder = props.settingInfo.order or math.huge,
	}, {
		frame1 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.8,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.985, 0.88),
		}, {
			uIStroke5 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(9, 9, 9),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 3,
			}),

			header4 = e("TextLabel", {
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
				Position = UDim2.fromScale(0.194, 0.367),
				Size = UDim2.fromScale(0.346, 0.464),
				Text = props.name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),

			description = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Position = UDim2.fromScale(0.193, 0.7),
				Size = UDim2.fromScale(0.344, 0.368),
				Text = props.settingInfo.description or "",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),

			box = e("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = isOn and CheckImage or XImage,
				Position = UDim2.fromScale(0.958, 0.5),
				Size = UDim2.fromScale(0.06, 0.774),

				[React.Event.Activated] = function()
					toggleState()
				end,
			}, {
				uIStroke6 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(8, 8, 8),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 3,
				}),

				uIAspectRatioConstraint = e("UIAspectRatioConstraint"),
			}),
		}),
	})
end

local function sliderTemplate(props)
	local settingInfo = props.settingInfo
	local sliderRef = React.useRef(nil)
	local dragging, setDragging = React.useState(false)
	local sliderPosition, setSliderPosition = React.useState(
		UDim2.fromScale(
			(settingInfo.default - settingInfo.min) / (settingInfo.max - settingInfo.min),
			0.5
		)
	)

	local function calculateValue(position)
		local normalizedPosition = position.X.Scale
		local range = settingInfo.max - settingInfo.min
		local value = math.floor((normalizedPosition * range + settingInfo.min) / settingInfo.step)
			* settingInfo.step
		return math.clamp(value, settingInfo.min, settingInfo.max)
	end

	local function onMouseDown()
		setDragging(true)
	end

	local function onMouseMove(input)
		if dragging then
			local sliderBounds = sliderRef.current.AbsolutePosition
			local sliderWidth = sliderRef.current.AbsoluteSize.X

			-- Calculate the precise position relative to the slider bounds
			local relativePosition = (input.Position.X - sliderBounds.X) / sliderWidth
			local clampedPosition = math.clamp(relativePosition, 0, 1)

			-- Set the slider position and update the value
			setSliderPosition(UDim2.new(clampedPosition, 0, 0.5, 0))
			props.settingInfo.value = calculateValue(UDim2.new(clampedPosition, 0, 0.5, 0))
			props.settingInfo.stepFunction(props.settingInfo.value)
		end
	end

	local function onMouseUp()
		setDragging(false)

		zap.updateSettings.Fire({
			setting = props.name,
			value = settingInfo.value,
			category = props.category,
		})
	end

	React.useEffect(function()
		if dragging then
			local moveConn = game:GetService("UserInputService").InputChanged:Connect(onMouseMove)
			local endConn = game:GetService("UserInputService").InputEnded:Connect(onMouseUp)

			return function()
				moveConn:Disconnect()
				endConn:Disconnect()
			end
		end
		return
	end, { dragging })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.0922),
		Size = UDim2.fromScale(0.984, 0.184),
		LayoutOrder = settingInfo.order or math.huge,
	}, {
		frame2 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.8,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.985, 0.88),
		}, {
			uIStroke7 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(9, 9, 9),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 3,
			}),

			header5 = e("TextLabel", {
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
				Position = UDim2.fromScale(0.194, 0.367),
				Size = UDim2.fromScale(0.346, 0.464),
				Text = props.name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
			}),

			description1 = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
				Position = UDim2.fromScale(0.193, 0.7),
				Size = UDim2.fromScale(0.344, 0.368),
				Text = props.settingInfo.description or "",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
			}),

			frame3 = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.775, 0.492),
				Size = UDim2.fromScale(0.2, 0.175),
				ref = sliderRef,
			}, {
				uICorner3 = e("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				slider = e("TextButton", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
					Position = sliderPosition,
					Size = UDim2.fromScale(0.13, 2.1),
					Text = "",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextSize = 14,
					ZIndex = 2,

					[React.Event.MouseButton1Down] = onMouseDown,
				}, {
					uIAspectRatioConstraint1 = e("UIAspectRatioConstraint"),

					uICorner4 = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				var_05Divider = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(47, 47, 47),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.015, 1.3),
					ZIndex = 0,
				}, {
					uICorner5 = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				var_10Divider = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(47, 47, 47),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromScale(0.03, 1.5),
					ZIndex = 0,
				}, {
					uICorner6 = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				var_00Divider = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(47, 47, 47),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromScale(0.03, 1.5),
					ZIndex = 0,
				}, {
					uICorner7 = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				var_075Divider = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(47, 47, 47),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.75, 0.5),
					Size = UDim2.fromScale(0.015, 1.3),
					ZIndex = 0,
				}, {
					uICorner8 = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				var_025Divider = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(47, 47, 47),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.25, 0.5),
					Size = UDim2.fromScale(0.015, 1.3),
					ZIndex = 0,
				}, {
					uICorner9 = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				var_0 = e("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
					Position = UDim2.fromScale(-0.005, 2.5),
					Size = UDim2.fromScale(0.202, 1.53),
					Text = settingInfo.min,
					TextColor3 = Color3.fromRGB(58, 58, 58),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),

				var_100 = e("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
					Position = UDim2.fromScale(1, 2.5),
					Size = UDim2.fromScale(0.202, 1.53),
					Text = settingInfo.max,
					TextColor3 = Color3.fromRGB(58, 58, 58),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),

				input = e("TextBox", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
					PlaceholderText = string.format(
						"%.1f",
						settingInfo.value or settingInfo.default
					),
					Position = UDim2.fromScale(1.36, 0.668),
					Size = UDim2.fromScale(0.409, 2.63),
					Text = "",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,

					[React.Event.FocusLost] = function(entered)
						if entered then
							props.settingInfo.value = tonumber(props.settingInfo.value)
							if not props.settingInfo.value then
								props.settingInfo.value = props.settingInfo.default
							end
							setSliderPosition(
								UDim2.fromScale(
									(props.settingInfo.value - settingInfo.min)
										/ (settingInfo.max - settingInfo.min),
									0.5
								)
							)
							props.settingInfo.stepFunction(props.settingInfo.value)
						end
					end,
				}, {
					uIStroke8 = e("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(9, 9, 9),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 3,
					}),
				}),
			}),
		}),
	})
end

local function switchTab(props)
	return e("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.7,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
		Position = UDim2.fromScale(0.145, 0.5),
		Size = UDim2.fromScale(0.236, 0.768),
		Text = "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,

		[React.Event.Activated] = function()
			props.setTab(props.tabName)
		end,
	}, {
		uIStroke1 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(9, 9, 9),
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 3,
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
			Text = string.upper(props.tabName),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),
	})
end

local settingsTemplates = {
	boolean = toggleTemplate,
	number = sliderTemplate,
}

return function(props)
	local savedSettings, setSavedSettings = React.useState(props.savedSettings)
	local shownSettings, setShownSettingsUI = React.useState({})
	local enabled, setEnabled = React.useState(true)
	local settingsTab, setTab = React.useState("General")

	React.useEffect(function()
		if props.savedSettings then
			setSavedSettings(props.savedSettings)
		end
	end, {})

	local function updateSettingsList()
		local newSettings = {
			uIListLayout1 = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.017, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}

		for settingName, settingInfo in settingsConfig[settingsTab] do
			-- Apply the server value if it exists
			local categorySettings = savedSettings[settingsTab]
			if categorySettings and categorySettings[settingName] ~= nil then
				settingInfo.default = categorySettings[settingName]
			end
			table.insert(
				newSettings,
				e(settingsTemplates[type(settingInfo.default)], {
					name = settingName,
					category = settingsTab,
					settingInfo = settingInfo,
				})
			)
		end
		setShownSettingsUI(newSettings)
	end

	React.useEffect(function()
		if props.savedSettings then
			setSavedSettings(props.savedSettings)
		end
		updateSettingsList()
	end, { settingsTab })

	React.useEffect(function()
		setEnabled(props.visible)
	end, { props.visible })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.463),
		Size = UDim2.fromScale(0.578, 0.613),
		Visible = enabled,
	}, {
		uIStroke = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			Thickness = 2,
		}),

		uICorner = e("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),

		topbar = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.0938),
			Size = UDim2.fromScale(0.952, 0.107),
		}, {
			uICorner1 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			uIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.012, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			general = switchTab({ tabName = "General", setTab = setTab, settingsTab = settingsTab }),
			graphics = switchTab({
				tabName = "Graphics",
				setTab = setTab,
				settingsTab = settingsTab,
			}),
			sound = switchTab({ tabName = "Sound", setTab = setTab, settingsTab = settingsTab }),
			other = switchTab({ tabName = "Other", setTab = setTab, settingsTab = settingsTab }),
		}),

		container = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.565),
			Size = UDim2.fromScale(0.952, 0.786),
		}, {
			uICorner2 = e("UICorner", {
				CornerRadius = UDim.new(0.01, 0),
			}),

			gradient = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(15, 15, 15),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.93),
				Size = UDim2.fromScale(1, 0.139),
				ZIndex = 2,
			}, {
				uIGradient = e("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.777, 0.0383),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
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
			}, shownSettings),
		}),

		closeButton = e("TextButton", {
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

			[React.Event.Activated] = function()
				props.close()
				sharedInfo.UISignals.closedUi:Fire()
				SoundService.UI.CloseMenu:Play()
			end,
		}, {
			uIAspectRatioConstraint2 = e("UIAspectRatioConstraint"),

			uICorner10 = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke9 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				Thickness = 2,
			}),
		}),
	})
end
