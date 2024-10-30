local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)

local function DamageNumber(props)
	-- Track opacity for fade-out effect
	local opacity, setOpacity = React.useState(0)
	local position, setPosition = React.useState(props.position)
	local text = React.useRef(nil)
	local stroke = React.useRef(nil)

	-- Manage the fade-out animation lifecycle
	React.useEffect(function()
		-- Animate position and transparency with TweenService
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local newPos = position + Vector2.new(math.random(-100, 100), math.random(-100, 100))
		local tween = TweenService:Create(
			text.current,
			tweenInfo,
			{ Position = UDim2.fromOffset(newPos.X, newPos.Y) }
		)

		tween:Play()
		tween.Completed:Connect(function()
			-- Trigger removal of this damage number
			tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
			tween = TweenService:Create(text.current, tweenInfo, { TextTransparency = 1 })
			local tween2 = TweenService:Create(stroke.current, tweenInfo, { Thickness = 0.01 })

			tween:Play()
			tween2:Play()

			tween.Completed:Connect(function()
				props.onFadeOut()
			end)
		end)

		-- Cleanup if component unmounts
		return function()
			tween:Cancel()
		end
	end, { props.id })

	-- Render the animated TextLabel as a React element
	return React.createElement("TextLabel", {
		Text = tostring(props.damage),
		Size = UDim2.new(0.05, 0, 0.025, 0),
		Font = Enum.Font.SourceSansBold,
		Position = UDim2.fromOffset(position.X, position.Y),
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 0, 0), -- Red color for damage text
		TextScaled = true,
		TextTransparency = opacity,
		ref = text,
	}, {
		uiStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Color = props.critical and Color3.new(1, 1, 1) or Color3.new(0, 0, 0),
			LineJoinMode = Enum.LineJoinMode.Round,
			Thickness = 2,
			ref = stroke,
		}),
	})
end

local function DamageNumberContainer(props)
	-- Track all active damage numbers
	local damageNumbers, setDamageNumbers = React.useState({})
	local uniqueCounter, setUniqueCounter = React.useState(0)
	local lastDamage = React.useRef(nil)
	local lastPosition = React.useRef(nil)

	-- Function to add a new damage number
	local function addDamageNumber(damage, position, isCritical)
		setUniqueCounter(uniqueCounter + 1)
		setDamageNumbers(function(prevDamageNumbers)
			return Sift.Array.concat(prevDamageNumbers, {
				{
					id = tostring(uniqueCounter), -- Unique ID for each instance
					damage = damage,
					position = position + Vector2.new(math.random(-10, 10), math.random(-10, 10)), -- Small random offset
					critical = isCritical,
				},
			})
		end)
	end

	-- Remove damage number by ID once it fades out
	local function removeDamageNumber(id)
		setDamageNumbers(function(prevDamageNumbers)
			return Sift.Array.filter(prevDamageNumbers, function(damageNumber)
				return damageNumber.id ~= id
			end)
		end)
	end

	React.useEffect(function()
		if props.damage and props.position then
			addDamageNumber(props.damage, props.position, props.critical)
			-- Update refs to store the last rendered values
			lastDamage.current = props.damage
			lastPosition.current = props.position
		end
	end, { props.timestamp })

	-- Render each damage number in a ScreenGui
	return React.createElement("ScreenGui", {}, {
		-- Map each damage number in state to a DamageNumber component
		DamageNumbers = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			},
			Sift.Array.map(damageNumbers, function(damageNumber)
				return React.createElement(DamageNumber, {
					key = damageNumber.id,
					id = damageNumber.id,
					damage = damageNumber.damage,
					position = damageNumber.position,
					critical = damageNumber.critical,
					onFadeOut = function()
						removeDamageNumber(damageNumber.id)
					end,
				})
			end)
		),
		-- Button to simulate adding damage numbers
		-- AddDamageButton = React.createElement("TextButton", {
		-- 	Text = "Add Damage",
		-- 	Position = UDim2.new(0.1, 0, 0.9, 0),
		-- 	Size = UDim2.new(0.1, 0, 0.05, 0),
		-- 	[React.Event.MouseButton1Click] = function()
		-- 		addDamageNumber(math.random(10, 100))
		-- 	end,
		-- }),
	})
end

return DamageNumberContainer
