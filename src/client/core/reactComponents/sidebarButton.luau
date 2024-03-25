local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local openingUi = require(script.Parent.openingUi)
local e = React.createElement

local function createButton(props, refs, target)
	local styles, api = ReactSpring.useSpring(function()
		return {
			alpha = 0,
			alpha2 = 0,
			alpha3 = 0,
			config = {
				tension = 300,
			},
		}
	end)

	local btn = React.useRef()
	local label = React.useRef()
	local moving = false

	return e("ImageButton", {
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		Image = props.buttonImage or "rbxassetid://16809870867",
		BackgroundTransparency = 1,
		Position = styles.alpha2:map(function(alpha)
			return UDim2.fromScale(0.765, 0.19):Lerp(UDim2.fromScale(3.4, 0.25), alpha)
		end),
		Size = styles.alpha:map(function(alpha)
			return (props.startingSize or UDim2.fromScale(0.657, 0.168)):Lerp(
				UDim2.fromScale(0.8, 0.27),
				alpha
			)
		end),
		[React.Event.MouseEnter] = function()
			if not moving then
				SoundService:PlayLocalSound(SoundService:FindFirstChild("Hover"))
				api.start({ alpha = 1 })
			end
		end,
		[React.Event.MouseLeave] = function()
			api.start({ alpha = 0 })
		end,
		[React.Event.MouseButton1Click] = function()
			if moving then
				return
			end
			SoundService:PlayLocalSound(SoundService:FindFirstChild("Click"))
			moving = true
			local oldParent = refs.list.current.Parent
			refs.list.current.Parent = nil
			refs.container.current.Visible = false
			label.current.Visible = false
			btn.current.Parent = btn.current.Parent.Parent
			api.start({ alpha2 = 1 }):andThen(function()
				api.start({ alpha = 0, alpha3 = 1 })
				local root, closed = openingUi(
					target,
					{ bgColor = props.uiColor or Color3.new(1, 1, 1), menuName = props.text }
				)

				task.delay(1, function()
					btn.current.Visible = false
					-- Make the button text visible again
					api.start({ alpha2 = 0, alpha3 = 0 }):andThen(function()
						moving = false
					end)

					closed:Once(function()
						-- Make sidebar visible again
						refs.container.current.Visible = true
						label.current.Visible = true
						btn.current.Visible = true
						refs.list.current.Parent = oldParent
						btn.current.Parent = refs.list.current.Parent

						-- Unmount the opened ui
						root:unmount()
					end)
				end)
			end)
		end,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ref = btn,
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {}),

		UICorner = e("UICorner", {
			CornerRadius = UDim.new(1.000, 0),
		}),

		label = e("TextLabel", {
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = props.text,
			AnchorPoint = Vector2.new(0.500, 0.500),
			Font = Enum.Font.BuilderSansBold,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.500, 0, 0.919, 0),
			Size = UDim2.new(1.388, 0, 0.365, 0),
			ZIndex = 2,
			TextScaled = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextTransparency = 0,
			ref = label,
		}, {
			UIStroke = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				LineJoinMode = Enum.LineJoinMode.Round,
				Color = Color3.fromRGB(0, 0, 0),
				Thickness = 2,
			}),
		}),

		icon = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.500, 0.500),
			Image = props.image,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.500, 0, 0.500, 0),
			Size = props.iconSize or UDim2.new(0.702, 0, 0.756, 0),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}),
	})
end

return createButton
