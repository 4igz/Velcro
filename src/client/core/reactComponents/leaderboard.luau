local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)

-- Helper function to create a player row
local function playerFrame(props)
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(121, 199, 244),
		BackgroundTransparency = 0.3,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Position = UDim2.fromScale(0.593, 0.0997),
		Size = UDim2.fromScale(1.19, 0.0439),
	}, {
		uICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		username = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.178, 0.5),
			Size = UDim2.fromScale(0.305, 0.65),
			Text = props.username,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextWrapped = true,
		}),

		kills = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.461, 0.5),
			Size = UDim2.fromScale(0.26, 0.65),
			Text = tostring(props.money),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextWrapped = true,
		}),

		levelFrame = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.715, 0.5),
			Size = UDim2.fromScale(0.252, 1),
		}, {
			level = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.27, 0.65),
				Text = tostring(props.level),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextWrapped = true,
			}),
		}),

		uIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(93, 170, 212),
			Transparency = 0.7,
		}),
	})
end

local function topFrame()
	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.8,
		Position = UDim2.fromScale(0.525, 0.0137),
		Size = UDim2.fromScale(1.05, 0.0274),
	}, {
		textLabel = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.202, 0.492),
			Size = UDim2.fromScale(0.345, 0.983),
			Text = "Username",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextTransparency = 0.3,
		}),
		textLabel1 = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.519, 0.492),
			Size = UDim2.fromScale(0.291, 0.983),
			Text = "Money",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextTransparency = 0.3,
		}),
		textLabel2 = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.809, 0.492),
			Size = UDim2.fromScale(0.289, 0.983),
			Text = "Level",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextTransparency = 0.3,
		}),
	})
end

return function(props)
	local lbState, setLbState = React.useState({})

	-- Function to update leaderboard state and sort by level
	local function updateLeaderboard()
		local newState = {
			uIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0.002, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			uIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0.003, 0),
				PaddingTop = UDim.new(0.002, 0),
			}),
			topFrame = topFrame(),
		}
		local players = {}

		for _, player in Players:GetPlayers() do
			local leaderstats = player:FindFirstChild("leaderstats")
			if leaderstats then
				local money = leaderstats:FindFirstChild("Money")
				local level = leaderstats:FindFirstChild("Level")
				if money and level then
					table.insert(players, {
						username = player.Name,
						money = money.Value,
						level = level.Value,
					})
				end
			end
		end

		-- Sort players by level in descending order
		table.sort(players, function(a, b)
			return a.level > b.level
		end)

		-- Check if the new state is different from the current state
		local hasChanged = false
		for i, playerData in ipairs(players) do
			local existingPlayerFrame = lbState[i] -- Changed to numeric index

			if
				not existingPlayerFrame
				or existingPlayerFrame.props.level ~= playerData.level
				or existingPlayerFrame.props.money ~= playerData.money
			then
				hasChanged = true
				break
			end
		end

		if hasChanged then
			-- Create new player frames based on sorted players
			for i, playerData in ipairs(players) do
				newState[i] = playerFrame({
					username = playerData.username,
					money = playerData.money,
					level = playerData.level,
					layoutOrder = i, -- Assign layout order based on index in sorted table
				})
			end
			setLbState(newState)
		end
	end

	-- Effect to initialize and update leaderboard
	React.useEffect(function()
		updateLeaderboard()

		local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
			local leaderstats = player:WaitForChild("leaderstats")
			for _, value: IntValue in leaderstats:GetChildren() do
				value.Changed:Connect(updateLeaderboard)
			end
			updateLeaderboard()
		end)

		local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
			updateLeaderboard()
		end)

		-- Also attach leaderstats change listeners for players already in the game
		for _, player in Players:GetPlayers() do
			local leaderstats = player:WaitForChild("leaderstats")
			if leaderstats then
				for _, value: IntValue in leaderstats:GetChildren() do
					value.Changed:Connect(updateLeaderboard)
				end
				updateLeaderboard()
			end
		end

		-- Cleanup connections on unmount
		return function()
			playerAddedConnection:Disconnect()
			playerRemovingConnection:Disconnect()
		end
	end, {})

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.fromScale(0.307, 0.67),
	}, {
		scrollingFrame = React.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			Size = UDim2.fromScale(1, 1),
		}, lbState),
	})
end
