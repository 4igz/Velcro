local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local numberUtil = require(ReplicatedStorage.shared.utilities.numberUtil)

local function player(props)
	return React.createElement("Frame", {
		Active = true,
		BackgroundColor3 = Color3.fromRGB(49, 150, 86),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Selectable = true,
		Size = UDim2.fromScale(1, 0.05),
		LayoutOrder = props.rank,
	}, {
		info = React.createElement("TextLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Size = UDim2.fromScale(1, 1),
			Text = `{props.rank} | {props.name} | {props.stat}`,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			BackgroundTransparency = 1,
		}),
	})
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
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}

		for i, playerData in props.lbData do
			table.insert(
				newPlayers,
				React.createElement(player, {
					rank = i,
					name = playerData.playerName,
					stat = numberUtil.simplifyNumber(playerData.score),
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
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, {
		bG = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Rotation = 90,
			Size = UDim2.fromScale(1.4, 0.7),
		}, {
			title = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(255, 108, 34),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.01),
				Size = UDim2.fromScale(0.9, 0.2),
			}, {
				uICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0.5, 0),
				}),

				titleText = React.createElement("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
					Size = UDim2.fromScale(1, 1),
					Text = `Rank | Name | {trackingStat}`,
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
				}),
			}),

			uICorner1 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.25, 0),
			}),

			playerScroller = React.createElement("ScrollingFrame", {
				Active = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0, 0.2),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.fromScale(1, 0.8),
			}, lbPlayers),
		}),
	})
end
