local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local gamepassUiController = require(ReplicatedStorage.client.controllers.gamepassUiController)
local mainMenuController = require(ReplicatedStorage.client.controllers.mainMenuController)
local missionsController = require(ReplicatedStorage.client.controllers.missionsController)
local settingsController = require(ReplicatedStorage.client.controllers.settingsController)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local skillUiController = require(ReplicatedStorage.client.controllers.skillUiController)
local e = React.createElement

local uiSounds = SoundService:WaitForChild("UI")

local openMenu = nil -- Track the currently open menu

local closedUi = sharedInfo.UISignals.closedUi

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

	React.useEffect(function()
		local connection
		connection = closedUi:Connect(function(closedMenuName)
			openMenu = nil

			if closedMenuName == "Shop" then
				mainMenuController.changeMenu("none", { fromSidebar = true })
			end
		end)

		-- Cleanup the connection when the component unmounts
		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, {})

	local moving = false

	local function handleMenuToggle(menuName, openFunction, closeFunction)
		-- Close the currently open menu, if any
		if openMenu then
			uiSounds.CloseMenu:Play()
			if openMenu == "Gamepass" then
				gamepassUiController.setGamepassShopOpen(false)
			elseif openMenu == "Shop" then
				mainMenuController.changeMenu("none", { fromSidebar = true })
			elseif openMenu == "Skills" then
				skillUiController.toggleUi(false)
			elseif openMenu == "Missions" then
				missionsController.close()
			elseif openMenu == "Settings" then
				settingsController.close()
			end
		end

		if openMenu ~= menuName then
			uiSounds.Click:Play()
			openFunction(true)
			openMenu = menuName
		else
			openMenu = nil
		end
	end

	local function handleButtonClick(buttonName)
		if buttonName == "Gamepass" then
			handleMenuToggle(
				"Gamepass",
				gamepassUiController.setGamepassShopOpen,
				gamepassUiController.setGamepassShopOpen
			)
		elseif buttonName == "Shop" then
			handleMenuToggle("Shop", function()
				mainMenuController.changeMenu("shop", { fromSidebar = true })
			end, function()
				mainMenuController.changeMenu("none", { fromSidebar = true })
			end)
		elseif buttonName == "Skills" then
			handleMenuToggle(
				"Skills",
				skillUiController.toggleUi, -- Assuming toggleUi handles both open and close
				skillUiController.toggleUi
			)
		elseif buttonName == "Missions" then
			handleMenuToggle("Missions", missionsController.open, missionsController.close)
		elseif buttonName == "Settings" then
			handleMenuToggle("Settings", settingsController.open, settingsController.close)
		end
	end

	return e("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
		Text = "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,

		Position = styles.alpha2:map(function(alpha)
			return UDim2.fromScale(0.765, 0.19):Lerp(UDim2.fromScale(3.4, 0.25), alpha)
		end),
		Size = styles.alpha:map(function(alpha)
			return (props.startingSize or (if not UserInputService.TouchEnabled
				then UDim2.fromScale(0.657, 0.168)
				else UDim2.fromScale(0.9, 3))):Lerp(UDim2.fromScale(0.8, 0.27), alpha)
		end),
		[React.Event.MouseEnter] = function()
			if not UserInputService.TouchEnabled then
				uiSounds.Hover:Play()
			end

			if not moving then
				api.start({ alpha = 1 })
			end
		end,
		[React.Event.MouseLeave] = function()
			api.start({ alpha = 0 })
		end,
		[React.Event.Activated] = function()
			uiSounds.Click:Play()
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

		notification = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 32, 32),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.974, 0.12),
			Size = UDim2.fromScale(0.482, 0.482),
			Text = "!",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			ZIndex = 2,
			Visible = props.showNotification or false,
		}, {
			uICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),
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
