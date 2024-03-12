local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local useState = React.useState
local useEffect = React.useEffect
local createElement = React.createElement

return function(props)
	local function handleClick()
		if props.onClick then
			props.onClick() -- Call the parent's onClick handler, if provided
		end
	end

	-- Return a Roblox GUI element representation
	-- Assuming createElement works similarly to React's, abstracting Roblox's UI creation
	return createElement("TextButton", {
		Text = props.text,
		TextScaled = true,
		Size = UDim2.new(0.25, 0, 0.15, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = props.position,
		BackgroundColor3 = props.color,
		[React.Event.MouseButton1Click] = handleClick,
	})
end
