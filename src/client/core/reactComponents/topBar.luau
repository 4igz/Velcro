local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local React = require(ReplicatedStorage.sharedPackages.React)
local zap = require(ReplicatedStorage.zap)

local wave = 1
local zombies = 0
local waveTillBoss = 10
local gameActive = false

local e = React.createElement

return function(props)
	-- Initialize state
	local timeLeft, setTimeLeft = React.useState(props.timeLeft or 0)
	local playerState, setPlayerState = React.useState("inLobby")

	-- Set timeLeft from props after component mounts
	React.useEffect(function()
		if props.timeLeft then
			setTimeLeft(props.timeLeft)
		end
	end, { props.timeLeft })

	React.useEffect(function()
		setPlayerState(zap.getPlayerState.Call())
	end, { props.playerState })

	-- Update other variables from props
	wave = props.wave or wave
	zombies = props.zombies or zombies
	waveTillBoss = props.waveTillBoss or waveTillBoss
	gameActive = props.gameActive or gameActive

	React.useEffect(function()
		if not props.timeLeft then
			setTimeLeft(zap.getTimeLeft.Call())
		end
	end)

	-- Effect to handle the timer
	React.useEffect(function()
		if timeLeft > 0 then
			local lastUpdateTime = tick() -- Get the current time

			local interval = RunService.Stepped:Connect(function()
				local currentTime = tick()
				if currentTime - lastUpdateTime >= 1 then -- Check if 1 second has passed
					lastUpdateTime = currentTime
					setTimeLeft(function(prevTime)
						return math.max(prevTime - 1, 0)
					end)
				end
			end)

			return function()
				interval:Disconnect()
			end
		end
		return
	end, { gameActive, timeLeft })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.0689),
		Size = UDim2.fromScale(1, 0.138),
	}, {
		info2 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.232),
			Size = UDim2.fromScale(0.297, 0.375),
		}, {
			timer3 = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.312, 0.776),
			}, {
				timer4 = e("TextLabel", {
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
					Size = UDim2.fromScale(0.842, 1),
					Text = string.format("%02d:%02d", math.floor(timeLeft / 60), timeLeft % 60),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),

				uIStroke27 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(8, 8, 8),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 2,
				}),
			}),

			uIStroke28 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 2,
			}),

			number = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Position = UDim2.fromScale(0.166, 0.5),
				Size = UDim2.fromScale(0.307, 0.776),
			}, {
				wave = e("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/Guru.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					Position = UDim2.fromScale(0.5, 0.5),
					RichText = true,
					Size = UDim2.fromScale(0.842, 1),
					Text = `WAVE <font color="#9a0000">{wave}</font>`,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),

				uIStroke29 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(8, 8, 8),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 2,
				}),
			}),

			zombies = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.7,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Position = UDim2.fromScale(0.166, 0.5),
				Size = UDim2.fromScale(0.307, 0.776),
			}, {
				amount3 = e("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new(
						"rbxasset://fonts/families/Guru.json",
						Enum.FontWeight.Bold,
						Enum.FontStyle.Normal
					),
					Position = UDim2.fromScale(0.369, 0.5),
					RichText = true,
					Size = UDim2.fromScale(0.63, 1),
					Text = zombies,
					TextColor3 = Color3.fromRGB(154, 0, 0),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),

				uIStroke30 = e("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Color3.fromRGB(8, 8, 8),
					LineJoinMode = Enum.LineJoinMode.Miter,
					Thickness = 2,
				}),

				icon3 = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://76976173146748",
					Position = UDim2.fromScale(0.823, 0.5),
					Size = UDim2.fromScale(0.347, 0.974),
				}, {
					uIAspectRatioConstraint9 = e("UIAspectRatioConstraint"),
				}),
			}),

			uIListLayout3 = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.025, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		}),
		joinCurrentRound = React.createElement("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/Guru.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.5, 0.7),
			Size = UDim2.fromScale(0.0948, 0.4),
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14,
			Visible = playerState == "inLobby" and gameActive,
			[React.Event.MouseButton1Click] = function()
				zap.joinCurrentRound.Fire()
			end,
		}, {
			text = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.Medium,
					Enum.FontStyle.Italic
				),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.907, 0.92),
				Text = "Join current round",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextTransparency = 0.5,
				TextWrapped = true,
			}),

			uIStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 2,
			}),
		}),
	})
end
