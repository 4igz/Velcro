local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local ReactSpring = require(ReplicatedStorage.sharedPackages.ReactSpring)
local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local gamepass = require(script.Parent.gamepass)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local e = React.createElement

return function(menuRef)
	local gps = {}

	gps.Layout = e("UIGridLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		CellPadding = UDim2.new(0.000, 5, 0.000, 5),
		CellSize = UDim2.new(0.500, -5, 0.2, 0),
	})

	for name, id in sharedInfo.Gamepasses do
		local gpInfo = MarketplaceService:GetProductInfo(id, Enum.InfoType.GamePass)
		gps[name] = e(gamepass, {
			gpName = name,
			price = gpInfo.PriceInRobux,
			gpImage = `rbxassetid://{gpInfo.IconImageAssetId}`,
			gpId = id,
		})
	end

	return e("Frame", {
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		Size = UDim2.new(1.000, 0, 1.000, 0),
		BorderSizePixel = 1,
		BackgroundColor3 = Color3.fromRGB(163, 162, 165),
		ref = menuRef,
	}, {
		menuName = e("TextLabel", {
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			Text = "Gamepasses",
			AnchorPoint = Vector2.new(0.500, 0.000),
			Font = Enum.Font.GothamBold,
			BackgroundTransparency = 0.5,
			Position = UDim2.new(0.500, 0, 0.000, 0),
			BorderSizePixel = 1,
			Size = UDim2.new(1.000, 0, 0.150, 0),
			TextScaled = true,
			BackgroundColor3 = Color3.fromRGB(165, 39, 39),
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.100, 0),
			}),
		}),

		gamepasses = e("ScrollingFrame", {
			ClipsDescendants = true,
			BorderColor3 = Color3.fromRGB(27, 42, 53),
			Transparency = 1,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.000, 0, 0.200, 0),
			Size = UDim2.new(1, 0, 0.800, 0),
			BackgroundColor3 = Color3.fromRGB(165, 30, 30),
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0.000, 0, 2.000, 0),
			ScrollBarThickness = 0,
		}, gps),
	})
end
