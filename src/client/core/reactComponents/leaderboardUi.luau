local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local numberUtil = require(ReplicatedStorage.shared.utilities.numberUtil)
local playerUtil = require(ReplicatedStorage.shared.utilities.playerUtil)

function separatePascalCase(text)
	-- Add a space before each uppercase letter, except the first one
	local separatedText = text:gsub("(%u)", " %1")

	-- Trim leading space if it exists
	return separatedText:match("^%s*(.-)%s*$")
end

local function player(props)
	local rankingColors = {
		ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(223, 105, 2)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 149, 0)),
		}),
		ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 149, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(121, 204, 212)),
		}),
		ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(143, 61, 13)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(109, 45, 0)),
		}),
	}

	local rankingIcons = {
		"rbxassetid://78028969200743",
		"rbxassetid://85134388403783",
		"rbxassetid://74596736696290",
	}

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.fromScale(0.99, 0.3),
	}, {
		ranking = React.createElement("TextLabel", {
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
			Position = UDim2.fromScale(0.1, 0.5),
			Size = UDim2.fromScale(0.15, 0.8),
			Text = props.rank,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}, {
			uIStroke1 = React.createElement("UIStroke", {
				Thickness = 2,
				Transparency = 0.2,
			}),
		}),

		username = React.createElement("TextLabel", {
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
			LayoutOrder = 2,
			Position = UDim2.fromScale(0.44, 0.4),
			Size = UDim2.fromScale(0.4, 0.5),
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, {
			uIStroke2 = React.createElement("UIStroke", {
				Thickness = 3,
				Transparency = 0.2,
			}),
		}),

		statistic = React.createElement("TextLabel", {
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
			LayoutOrder = 3,
			Position = UDim2.fromScale(0.405, 0.75),
			Size = UDim2.fromScale(0.3, 0.5),
			Text = props.stat,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, {
			uIStroke3 = React.createElement("UIStroke", {
				Thickness = 2,
				Transparency = 0.2,
			}),
		}),

		uIGradient1 = React.createElement("UIGradient", {
			Color = rankingColors[props.rank] or ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.568),
				NumberSequenceKeypoint.new(0.00406, 1),
				NumberSequenceKeypoint.new(0.0311, 0.891),
				NumberSequenceKeypoint.new(0.0595, 0.732),
				NumberSequenceKeypoint.new(0.0771, 0.24),
				NumberSequenceKeypoint.new(0.1, 0),
				NumberSequenceKeypoint.new(0.124, 0.246),
				NumberSequenceKeypoint.new(0.145, 0.727),
				NumberSequenceKeypoint.new(0.204, 0.918),
				NumberSequenceKeypoint.new(0.705, 1),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),

		pfp = React.createElement("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = playerUtil.avatarImage(
				props.userId,
				Enum.ThumbnailSize.Size180x180,
				Enum.ThumbnailType.HeadShot
			),
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.15, 0),
			Size = UDim2.fromScale(0.1, 0.9),
		}, {
			uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

			uICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),

		icon = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = rankingIcons[props.rank] or "",
			LayoutOrder = 1,
			Position = UDim2.fromScale(0.9, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(0.1, 0.5),
		}, {
			uIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),

			uICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),
	})
end

local function getCurrentMonthName()
	local months = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	}

	local currentMonth = os.date("*t").month
	return months[currentMonth]
end

return function(props)
	-- Sample data for leaderboard; replace this with actual data as needed.
	-- local leaderboardData = {
	-- 	{ Rank = 1, Player = "Player1", Score = 1500 },
	-- 	{ Rank = 2, Player = "Player2", Score = 1200 },
	-- 	{ Rank = 3, Player = "Player3", Score = 1100 },
	-- }
	local lbPlayers, setLbPlayers = React.useState({})
	local trackingStat, setTrackingStat = React.useState("")

	local function updatePlayers()
		local newPlayers = {
			uIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.008, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Wraps = true,
			}),
		}

		if not props.lbData then
			setLbPlayers(newPlayers)
			return
		end

		for i, playerData in props.lbData do
			table.insert(
				newPlayers,
				React.createElement(player, {
					rank = i,
					name = playerData.playerName,
					stat = numberUtil.simplifyNumber(playerData.score),
					userId = playerData.userId,
				})
			)
		end

		setLbPlayers(newPlayers)
	end

	React.useEffect(function()
		setTrackingStat(props.trackingStat)
	end, {})

	React.useEffect(function()
		updatePlayers()
	end, { props.lbData })

	return React.createElement("SurfaceGui", {
		ClipsDescendants = true,
		Face = Enum.NormalId.Top,
		LightInfluence = 1,
		MaxDistance = 1e+03,
		PixelsPerStud = 75,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, {
		header = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.8,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.945, 0.5),
			Rotation = 90,
			Size = UDim2.fromScale(1.3, 0.08),
		}, {
			text = React.createElement("TextLabel", {
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
				Size = UDim2.fromScale(1, 1),
				Text = separatePascalCase(trackingStat),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke = React.createElement("UIStroke", {
					Thickness = 8,
				}),
			}),

			uIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.548, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.501, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),

		scrollingFrame = React.createElement("ScrollingFrame", {
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.47, 0.505),
			Rotation = 90,
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 6,
			Size = UDim2.fromScale(1.4, 0.41),
			ClipsDescendants = true,
		}, lbPlayers),

		bg = React.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://16369067958",
			ImageTransparency = 0.86,
			Position = UDim2.fromScale(0.5, 0.5),
			Rotation = 90,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1.41, 0.71),
			ZIndex = 0,
		}),

		frame = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 106, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.83, 0.5),
			Rotation = 90,
			Size = UDim2.fromScale(1.3, 0.06),
		}, {
			month = React.createElement("TextLabel", {
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
				Size = UDim2.fromScale(1, 0.8),
				Text = getCurrentMonthName(),
				TextColor3 = Color3.fromRGB(255, 149, 0),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke13 = React.createElement("UIStroke", {
					Thickness = 7,
				}),
			}),

			uIGradient5 = React.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.863, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(0.936, Color3.fromRGB(216, 216, 216)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(191, 191, 191)),
				}),
				Rotation = 90,
			}),

			uICorner7 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
		}),
	})
end
