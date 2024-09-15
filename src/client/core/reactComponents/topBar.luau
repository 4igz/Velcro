local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local React = require(ReplicatedStorage.sharedPackages.React)

local wave = 1
local zombies = 0
local waveTillBoss = 10
local gameActive = false

return function(props)
	-- Initialize state
	local timeLeft, setTimeLeft = React.useState(0)

	-- Set timeLeft from props after component mounts
	React.useEffect(function()
		if props.timeLeft then
			setTimeLeft(props.timeLeft)
		end
	end, { props.timeLeft })

	-- Update other variables from props
	wave = props.wave or wave
	zombies = props.zombies or zombies
	waveTillBoss = props.waveTillBoss or waveTillBoss
	gameActive = props.gameActive or gameActive

	-- Effect to handle the timer
	React.useEffect(function()
		if gameActive and timeLeft > 0 then
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

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Enabled = true,
	}, {
		waveCount = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(36, 36, 36),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.5, 0.0488),
			Size = UDim2.fromScale(0.117, 0.032),
			ZIndex = 2,
		}, {
			uICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),

			uIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 153, 153)),
				}),
				Rotation = 90,
			}),

			textLabel = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.487, 0.5),
				Size = UDim2.fromScale(0.911, 0.746),
				Text = `WAVE: {wave}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}),
		}),

		zombiesRemaining = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(36, 36, 36),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.501, 0.00926),
			Size = UDim2.fromScale(0.15, 0.0345),
			ZIndex = 2,
		}, {
			uICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),

			uIGradient1 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 153, 153)),
				}),
				Rotation = 90,
			}),

			textLabel1 = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.921, 0.746),
				Text = `ZOMBIES REMAINING: {zombies}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				ZIndex = 2,
			}),
		}),

		backgroundFrame = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(36, 36, 36),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.5, 0.0246),
			Size = UDim2.fromScale(0.197, 0.0454),
		}, {
			uIGradient2 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 153, 153)),
				}),
				Rotation = 90,
			}),

			uICorner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),

			uIStroke = React.createElement("UIStroke"),
		}),

		wavesTillBoss = React.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(36, 36, 36),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.348, 0.00926),
			Size = UDim2.fromScale(0.15, 0.0345),
			ZIndex = 2,
		}, {
			textLabel2 = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.921, 0.746),
				Text = `WAVES TILL BOSS: {waveTillBoss}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}),

			uIGradient3 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 153, 153)),
				}),
				Rotation = 90,
			}),

			uICorner3 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),
		}),

		backgroundFrame1 = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(36, 36, 36),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.501, 0.0629),
			Size = UDim2.fromScale(0.102, 0.0602),
		}, {
			uIGradient4 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 153, 153)),
				}),
				Rotation = 90,
			}),

			uICorner4 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),

			uIStroke1 = React.createElement("UIStroke"),

			textLabel3 = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.63),
				Size = UDim2.fromScale(0.597, 0.586),
				Text = `{math.round(timeLeft)}`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}),
		}),
	})
end
