local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local shopConfig = require(ReplicatedStorage.shared.configurations.shopConfig)
local weaponConfig = require(ReplicatedStorage.shared.configurations.weaponConfig)
local weaponUtil = require(ReplicatedStorage.shared.utilities.weaponUtil)
local zap = require(ReplicatedStorage.zap)

local e = React.createElement

local function weaponFrame(weaponName)
	local cfg = weaponUtil.getShopConfig(weaponName)

	return e("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0.11),
		BackgroundTransparency = 1,
	}, {
		buy = e("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json"),
			Text = `${cfg.price}`,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 26,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(59, 238, 27),
			BorderColor3 = Color3.fromRGB(59, 238, 27),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.17, 0.599),
			Size = UDim2.fromScale(0.2, 0.4),

			[React.Event.MouseButton1Click] = function()
				zap.buyWeapon.Fire({ weaponName = weaponName })
			end,
		}, {
			uICorner1 = e("UICorner", {
				CornerRadius = UDim.new(0.3, 0),
			}),

			uIStroke = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(186, 186, 186),
				Thickness = 3,
			}),
		}),

		name = e("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/LuckiestGuy.json"),
			Text = cfg.name,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.17, -0.00844),
			Size = UDim2.fromScale(0.4, 0.5),
		}),

		description = e("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/HighwayGothic.json"),
			Text = cfg.description,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.418, 0.549),
			Size = UDim2.fromScale(0.5, 0.5),
		}),

		weaponView = e("ViewportFrame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0.151, 1),
		}, {
			camera = e("Camera", {
				CFrame = CFrame.new(),
			}),
		}),
	})
end

return function(menuRef)
	local displayedWeapons, setWeapons = React.useState(weaponUtil.getWeaponsByType("gun"))

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		ref = menuRef,
	}, {
		uICorner = e("UICorner"),

		guns = e("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/Merriweather.json"),
			Text = "Guns",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 30,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(0, 255, 94),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.171, 0.0306),
			Size = UDim2.fromScale(0.2, 0.1),
			[React.Event.MouseButton1Click] = function()
				setWeapons(weaponUtil.getWeaponsByType("gun"))
			end,
		}),

		equipment = e("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/Merriweather.json"),
			Text = "Equipment",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 30,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(160, 185, 166),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.629, 0.0306),
			Size = UDim2.fromScale(0.2, 0.1),
			[React.Event.MouseButton1Click] = function()
				setWeapons(weaponUtil.getWeaponsByType("equipment"))
			end,
		}),

		melee = e("TextButton", {
			FontFace = Font.new("rbxasset://fonts/families/Merriweather.json"),
			Text = "Melee",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 30,
			TextWrapped = true,
			BackgroundColor3 = Color3.fromRGB(160, 185, 166),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.402, 0.0306),
			Size = UDim2.fromScale(0.2, 0.1),
			[React.Event.MouseButton1Click] = function()
				setWeapons(weaponUtil.getWeaponsByType("melee"))
			end,
		}),

		container = e("ScrollingFrame", {
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			Active = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 0.259),
			Size = UDim2.fromScale(1, 0.741),
		}, {
			e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder, -- Adjust the sort order as needed
				Padding = UDim.new(0, 10), -- Adjust the padding between elements if needed
			}),

			-- Add the weapon frames
			Sift.Array.map(Sift.Array.reverse(displayedWeapons), function(weaponName)
				return weaponFrame(weaponName)
			end),
		}),
	})
end
