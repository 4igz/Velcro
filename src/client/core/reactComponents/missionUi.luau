local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local missionConfig = require(ReplicatedStorage.shared.configurations.missionConfig)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local zap = require(ReplicatedStorage.zap)

local e = React.createElement

local function cap(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end

local function missionTemplate(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.7,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.147, 0.183),
		Size = UDim2.fromScale(0.32, 0.48),
	}, {
		uIStroke3 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(8, 8, 8),
			Thickness = 3,
		}),

		uICorner3 = e("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),

		button = e("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Position = UDim2.fromScale(0.5, 0.85),
			Size = UDim2.fromScale(0.859, 0.183),
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14,
			[React.Event.Activated] = function()
				-- MarketplaceService:PromptProductPurchase(Players.LocalPlayer, props.devProduct)
			end,
		}, {
			uIStroke4 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(8, 8, 8),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 3,
			}),

			text1 = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.9, 0.7),
				Text = "SKIP",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}),
		}),

		title = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.5, 0.12),
			Size = UDim2.fromScale(0.898, 0.198),
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),

		desc = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.ExtraLight,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.5, 0.28),
			Size = UDim2.fromScale(0.898, 0.15),
			Text = `{cap(props.requirement)} {props.goalAmt}{""--[[cap(props.type) or "times"]]}`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),

		bar1 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.499, 0.42),
			Size = UDim2.fromScale(0.86, 0.0988),
		}, {
			uIStroke5 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(8, 8, 8),
				LineJoinMode = Enum.LineJoinMode.Miter,
				Thickness = 3,
			}),

			bar2 = e("Frame", {
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(0, 1)
					:Lerp(UDim2.fromScale(1, 1), props.currentAmt / props.goalAmt),
			}),
		}),

		reward = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/Guru.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.5, 0.6),
			RichText = true,
			Size = UDim2.fromScale(0.898, 0.2),
			Text = `<font color="#ffffff">REWARD:</font> {props.rewardAmount} {string.upper(
				props.rewardType
			)}`,
			TextColor3 = Color3.fromRGB(154, 0, 0),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),

		frame = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.15,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			Visible = props.completed or false,
			ZIndex = 2,
		}, {
			text2 = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/Guru.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.513, 0.506),
				Rotation = -25,
				Size = UDim2.fromScale(0.869, 0.356),
				Text = "COMPLETED",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke6 = e("UIStroke", {
					Color = Color3.fromRGB(154, 0, 0),
					Transparency = 0.4,
				}),
			}),
		}),
	})
end

return function(props)
	local missions, setMissions = React.useState({})

	local function updateMissions(missionInfo)
		local newMissions = {
			uIGridLayout = e("UIGridLayout", {
				CellPadding = UDim2.fromScale(0.02, 0.05),
				CellSize = UDim2.fromScale(0.32, 0.48),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
		}

		if not props.missionInfo and not missionInfo then
			return
		end

		for _, mission in props.missionInfo or missionInfo do
			local cfg = missionConfig[mission.missionId]
			table.insert(
				newMissions,
				e(missionTemplate, {
					completed = mission.currentGoalIndex > #cfg.goals,
					goalAmt = cfg.goals[mission.currentGoalIndex],
					name = cfg.name,
					requirement = cfg.requirement,
					currentAmt = mission.progress,
					rewardAmount = cfg.rewards[mission.currentGoalIndex],
					rewardType = cfg.reward,
					type = cfg.type,
					devProduct = cfg.devProduct,
				})
			)
		end

		setMissions(newMissions)
	end

	React.useEffect(function()
		updateMissions()
	end, { props.missionInfo })

	-- React.useEffect(function()
	-- 	local function onMissionUpdated()
	-- 		local missionInfo = zap.getPlayerMissions.Call()
	-- 		setMissions(missionInfo)
	-- 	end

	-- 	zap.missionUpdated.SetCallback(onMissionUpdated)
	-- end, {})

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.46),
		Size = UDim2.fromScale(0.602, 0.6),
		Visible = props.visible,
	}, {
		uICorner = e("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),

		uIStroke = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			Thickness = 2,
		}),

		bar = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.105),
			Size = UDim2.fromScale(0.955, 0.132),
		}, {
			uIStroke1 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(8, 8, 8),
				Thickness = 3,
			}),

			text = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.21, 0.493),
				Size = UDim2.fromScale(0.376, 0.725),
				Text = "MISSIONS",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),

			uICorner1 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
		}),

		container = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.593),
			Size = UDim2.fromScale(0.955, 0.734),
		}, {
			uICorner2 = e("UICorner", {
				CornerRadius = UDim.new(0.01, 0),
			}),

			uIStroke2 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(8, 8, 8),
				Thickness = 3,
			}),

			layout = e("ScrollingFrame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.967, 0.914),
			}, missions),
		}),

		button1 = e("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(1.01, -0.01),
			Size = UDim2.fromScale(0.0446, 0.0866),
			Text = "X",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			[React.Event.Activated] = function()
				props.onClose()
				sharedInfo.UISignals.closedUi:Fire()
			end,
		}, {
			uIAspectRatioConstraint = e("UIAspectRatioConstraint"),

			uICorner4 = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke7 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				Thickness = 2,
			}),
		}),
	})
end
