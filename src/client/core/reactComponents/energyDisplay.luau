local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local e = React.createElement

return function(props)
	return e("TextLabel", {
		Text = props.energy,
		TextScaled = true,
		Size = UDim2.new(0.25, 0, 0.15, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		TextColor3 = Color3.new(1, 1, 1),
		BackgroundColor3 = Color3.new(0.376470, 0.376470, 0.376470),
	})
end
