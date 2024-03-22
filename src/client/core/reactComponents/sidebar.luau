local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local openingUi = require(script.Parent.openingUi)
local e = React.createElement

local function createButton(props, refs, target)
	local styles, api = ReactSpring.useSpring(function()
		return {
			alpha = 0,
			alpha2 = 0,
			alpha3 = 0,
			t = 2,
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
				local ui = openingUi(target, { bgColor = props.uiColor or Color3.new(1, 1, 1) })
				task.wait(4)
				refs.list.current.Parent = oldParent
				refs.container.current.Visible = true
				btn.current.Parent = refs.list.current.Parent
				ui()
				label.current.Visible = true
				api.start({ alpha2 = 0, alpha3 = 0, t = 2 }):andThen(function()
					moving = false
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
				-- Transparency = styles.alpha3,
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

local function app(props)
	local refs = {
		list = React.useRef(),
		container = React.useRef(),
	}

	return e("Frame", {
		AnchorPoint = Vector2.new(0.500, 0.500),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.073, 0, 0.619, 0),
		Size = UDim2.new(0.147, 0, 0.763, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		container = e("Frame", {
			AnchorPoint = Vector2.new(0.500, 0.500),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.248, 0, 0.419, 0),
			Size = UDim2.new(0.495, 0, 0.756, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ref = refs.container,
		}, {
			UIListLayout = e("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.010, 0),
				SortOrder = Enum.SortOrder.Name,
				ref = refs.list,
			}),

			pets = createButton({ text = "Pets", image = "" }, refs, props.target),

			gamepass = createButton({
				text = "Gamepass",
				image = "rbxassetid://16809903957",
				buttonImage = "rbxassetid://16809872201",
				startingSize = UDim2.fromScale(0.657, 0.19),
			}, refs, props.target),

			setting = createButton({
				text = "Settings",
				image = "rbxassetid://16809921789",
				iconSize = UDim2.fromScale(1.266, 1.266),
			}, refs, props.target),

			shop = createButton({
				text = "Shop",
				image = "rbxassetid://16809890167",
				iconSize = UDim2.fromScale(1.132, 1.132),
			}, refs, props.target),
		}),
	})
end

return function(target)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app, { target = target }),
	}, target))

	return function()
		root:unmount()
	end
end
