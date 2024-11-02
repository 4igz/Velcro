local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local missionsController = require(ReplicatedStorage.client.controllers.missionsController)
local sidebarButton = require(script.Parent.sidebarButton)
local e = React.createElement

local function app(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.500, 0.500),
		BackgroundTransparency = 1,
		Position = if not UserInputService.TouchEnabled
			then UDim2.new(0.042, 0, 0.5, 0)
			else UDim2.new(0.042, 0, 0.4, 0),
		Size = UDim2.new(0.072, 0, 0.45, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, {
		UIListLayout = e("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0.045, 0),
			SortOrder = Enum.SortOrder.Name,
		}),

		-- Sidebar buttons:
		gamepass = sidebarButton({
			text = "Gamepass",
			image = "rbxassetid://17181563489",
			openGamepassShop = props.openGamepassShop,
			onClose = function()
				props.openGamepassShop(false)
			end,
		}),

		missions = sidebarButton({
			text = "Missions",
			close = missionsController.close,
			open = missionsController.open,
			image = "rbxassetid://136327664483697",
			showNotification = false,
		}),

		settings = sidebarButton({
			text = "Settings",
			image = "rbxassetid://126441385489793",
		}),

		shop = sidebarButton({
			text = "Shop",
			image = "rbxassetid://106154331839572",
		}),

		skillUi = sidebarButton({
			text = "Skills",
			image = "rbxassetid://104185914549448",
		}),
		
		spectate = sidebarButton({
			text = "Spectate",
			image = "rbxassetid://95050813349943",
		}),
	})
end

return function(props)
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	root:render(ReactRoblox.createPortal({
		App = e(app, { target = props.gui, openGamepassShop = props.openGamepassShop }),
	}, props.gui))

	return function()
		root:unmount()
	end
end
