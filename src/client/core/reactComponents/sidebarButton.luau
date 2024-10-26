local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local mainMenuController = require(ReplicatedStorage.client.controllers.mainMenuController)
local skillUiController = require(ReplicatedStorage.client.controllers.skillUiController)
local e = React.createElement

local function SidebarButton(props)
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

	local moving = false

	-- Functions for handling button clicks
	local function handleButtonClick(buttonName)
		if buttonName == "Gamepass" then
			props.openGamepassShop(true)
		elseif buttonName == "Shop" then
			mainMenuController.changeMenu("shop", { fromSidebar = true }) -- Open shop menu
		elseif buttonName == "Settings" then
		elseif buttonName == "Skills" then
			skillUiController.toggleUi(true) -- Open skills menu
		end
	end

	return e("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
		Text = props.text,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,

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
				api.start({ alpha = 1 })
			end
		end,
		[React.Event.MouseLeave] = function()
			api.start({ alpha = 0 })
		end,
		[React.Event.MouseButton1Click] = function()
			handleButtonClick(props.text)
		end,
	}, {
		uIStroke = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			Thickness = 3,
		}),

		uICorner = e("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		icon = e("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = props.image,
			Position = UDim2.fromScale(0.5, 0.52),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(0.757, 0.757),
		}, {
			uIAspectRatioConstraint = e("UIAspectRatioConstraint"),
		}),

		uIAspectRatioConstraint1 = e("UIAspectRatioConstraint"),
	})
end

return SidebarButton
