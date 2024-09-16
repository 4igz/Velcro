local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)

-- Function to create individual money gain text
local function moneyGain(newFeed)
	return React.createElement("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		FontFace = Font.new(
			"rbxasset://fonts/families/SourceSansPro.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Normal
		),
		Size = UDim2.fromScale(0.2, 0.15),
		Text = `+${newFeed.amtGain} {newFeed.reason}`,
		TextColor3 = Color3.fromRGB(53, 255, 30),
		TextSize = 16,
	})
end

-- Function to create individual XP gain text
local function xpGain(newFeed)
	return React.createElement("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		FontFace = Font.new(
			"rbxasset://fonts/families/SourceSansPro.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Normal
		),
		Size = UDim2.fromScale(0.2, 0.1),
		Text = `+{newFeed.amtGain} {newFeed.reason}`,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
	})
end

-- Function to create the container for the feeds
local function gainUi(children)
	return React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.06, 0.7),
		Size = UDim2.fromScale(0.2, 0.205),
	}, children)
end

-- newFeed props == "type", "amtGain", "reason", "id"
return function(newFeed)
	-- State to manage active feeds
	local feed, setFeed = React.useState({})

	-- Add new feed and remove after a delay
	React.useEffect(function()
		if newFeed then
			-- Create a new feed for display
			local newFeedElement
			if newFeed.type == "money" then
				newFeedElement = moneyGain(newFeed)
			elseif newFeed.type == "xp" then
				newFeedElement = xpGain(newFeed)
			end

			-- Add new feed with a unique ID
			setFeed(function(prevFeeds)
				local updatedFeeds = { unpack(prevFeeds) }
				table.insert(updatedFeeds, { element = newFeedElement, id = newFeed.id })
				return updatedFeeds
			end)

			-- Remove the feed after 2 seconds
			task.delay(1, function()
				setFeed(function(prevFeeds)
					-- Filter out the feed with the specific id to ensure proper removal
					local updatedFeeds = Sift.Dictionary.filter(prevFeeds, function(feedItem)
						return feedItem.id ~= newFeed.id
					end)
					return updatedFeeds
				end)
			end)
		end
	end, { newFeed }) -- Trigger effect whenever newFeed changes

	-- List layout for proper ordering
	local layout = React.createElement("UIListLayout", {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
	})

	-- Create feed elements based on the current state
	local feedElements = { layout }
	for _, feedItem in feed do
		table.insert(feedElements, feedItem.element)
	end

	return gainUi(feedElements)
end
