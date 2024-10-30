local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

ReplicatedFirst:RemoveDefaultLoadingScreen()

local loadingScreen = Instance.new("ScreenGui")
loadingScreen.Name = "LoadingScreen"
loadingScreen.IgnoreGuiInset = true
loadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local screen = Instance.new("Frame")
screen.Name = "loadingScreen"
screen.AnchorPoint = Vector2.new(0.5, 0.5)
screen.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
screen.BorderColor3 = Color3.fromRGB(0, 0, 0)
screen.BorderSizePixel = 0
screen.Position = UDim2.fromScale(0.5, 0.5)
screen.Size = UDim2.fromScale(1, 1)
screen.ZIndex = 100

local bG = Instance.new("Frame")
bG.Name = "BG"
bG.AnchorPoint = Vector2.new(0.5, 0.5)
bG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bG.BackgroundTransparency = 0.7
bG.BorderColor3 = Color3.fromRGB(0, 0, 0)
bG.BorderSizePixel = 0
bG.Position = UDim2.fromScale(0.5, 0.856)
bG.Size = UDim2.fromScale(0.544, 0.0327)

local uICorner = Instance.new("UICorner")
uICorner.Name = "UICorner"
uICorner.CornerRadius = UDim.new(1, 0)
uICorner.Parent = bG

local bar = Instance.new("Frame")
bar.Name = "progressBar"
bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
bar.BorderSizePixel = 0
bar.ClipsDescendants = true
bar.Size = UDim2.fromScale(0.5, 1)

local uICorner1 = Instance.new("UICorner")
uICorner1.Name = "UICorner"
uICorner1.CornerRadius = UDim.new(1, 0)
uICorner1.Parent = bar

local uIGradient = Instance.new("UIGradient")
uIGradient.Name = "UIGradient"
uIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(69, 198, 13)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(96, 5, 223)),
})
uIGradient.Parent = bar

bar.Parent = bG

local loadingText = Instance.new("TextLabel")
loadingText.Name = "loadingText"
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingText.BackgroundTransparency = 1
loadingText.BorderColor3 = Color3.fromRGB(0, 0, 0)
loadingText.BorderSizePixel = 0
loadingText.FontFace = Font.new(
	"rbxasset://fonts/families/GothamSSm.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)
loadingText.Position = UDim2.fromScale(0.5, -0.9)
loadingText.Size = UDim2.fromScale(0.335, 1.77)
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.TextWrapped = true

local uIStroke = Instance.new("UIStroke")
uIStroke.Name = "UIStroke"
uIStroke.Thickness = 2
uIStroke.Parent = loadingText

loadingText.Parent = bG

local tipText = Instance.new("TextLabel")
tipText.Name = "tipText"
tipText.AnchorPoint = Vector2.new(0.5, 0.5)
tipText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tipText.BackgroundTransparency = 1
tipText.BorderColor3 = Color3.fromRGB(0, 0, 0)
tipText.BorderSizePixel = 0
tipText.FontFace = Font.new(
	"rbxasset://fonts/families/GothamSSm.json",
	Enum.FontWeight.SemiBold,
	Enum.FontStyle.Italic
)
tipText.Position = UDim2.fromScale(0.5, 1.4)
tipText.Size = UDim2.fromScale(0.815, 0.686)
tipText.Text = "Tip: Zombies can be killed with guns"
tipText.TextColor3 = Color3.fromRGB(255, 255, 255)
tipText.TextScaled = true
tipText.TextSize = 14
tipText.TextTransparency = 0.7
tipText.TextWrapped = true

local uIStroke1 = Instance.new("UIStroke")
uIStroke1.Name = "UIStroke"
uIStroke1.Thickness = 2
uIStroke1.Parent = tipText

tipText.Parent = bG

local image = Instance.new("ImageLabel")
image.Name = "barImage"
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
image.BackgroundTransparency = 1
image.BorderColor3 = Color3.fromRGB(0, 0, 0)
image.BorderSizePixel = 0
image.Image = "rbxassetid://138792290893624"
image.ImageColor3 = Color3.fromRGB(0, 0, 0)
image.ImageTransparency = 0.8
image.Position = UDim2.fromScale(0.5, 0.5)
image.ScaleType = Enum.ScaleType.Crop
image.Size = UDim2.fromScale(1, 1)

local uICorner2 = Instance.new("UICorner")
uICorner2.Name = "UICorner"
uICorner2.CornerRadius = UDim.new(1, 0)
uICorner2.Parent = image

image.Parent = bG

local progressText = Instance.new("TextLabel")
progressText.Name = "progressText"
progressText.AnchorPoint = Vector2.new(0.5, 0.5)
progressText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressText.BackgroundTransparency = 1
progressText.BorderColor3 = Color3.fromRGB(0, 0, 0)
progressText.BorderSizePixel = 0
progressText.FontFace = Font.new(
	"rbxasset://fonts/families/GothamSSm.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)
progressText.Position = UDim2.fromScale(0.163, 0.5)
progressText.Size = UDim2.fromScale(0.294, 1)
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(255, 255, 255)
progressText.TextScaled = true
progressText.TextSize = 14
progressText.TextWrapped = true
progressText.TextXAlignment = Enum.TextXAlignment.Left

local uIStroke2 = Instance.new("UIStroke")
uIStroke2.Name = "UIStroke"
uIStroke2.Color = Color3.fromRGB(22, 22, 22)
uIStroke2.Thickness = 2
uIStroke2.Transparency = 0.2
uIStroke2.Parent = progressText

progressText.Parent = bG

bG.Parent = screen

local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "ImageLabel"
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
imageLabel.BackgroundTransparency = 1
imageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
imageLabel.BorderSizePixel = 0
imageLabel.Image = ""
imageLabel.Position = UDim2.fromScale(0.5, 0.416)
imageLabel.ScaleType = Enum.ScaleType.Fit
imageLabel.Size = UDim2.fromScale(0.369, 0.362)
imageLabel.Parent = screen

local imageLabel1 = Instance.new("ImageLabel")
imageLabel1.Name = "ImageLabel"
imageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
imageLabel1.BackgroundTransparency = 1
imageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
imageLabel1.BorderSizePixel = 0
imageLabel1.Image = "rbxassetid://14993235015"
imageLabel1.ImageTransparency = 0.97
imageLabel1.Position = UDim2.fromScale(0.5, 0.5)
imageLabel1.ScaleType = Enum.ScaleType.Crop
imageLabel1.Size = UDim2.fromScale(1, 1)
imageLabel1.ZIndex = 0
imageLabel1.Parent = screen

screen.Parent = loadingScreen

loadingScreen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- List of assets to preload
local assets = table.unpack({ SoundService:GetDescendants(), ReplicatedStorage:GetDescendants() })
local numAssets = #assets
local preloadedAssets = 0

-- Rotate Tips (Optional Enhancement)
local tips = {
	"Tip: Team up with friends for better survival",
	"Tip: Zombies can be killed with guns",
	"Tip: Upgrade your skills",
	"Tip: Specialize in a skill in the skill tree",
}

local isLoading = true
task.spawn(function()
	while isLoading do
		tipText.Text = tips[math.random(1, #tips)]
		task.wait(3)
	end
end)

-- Function to Update Progress
local function updateProgress()
	preloadedAssets = preloadedAssets + 1
	local progress = preloadedAssets / numAssets
	progress = math.clamp(progress, 0, 1)

	-- Animate Progress Bar
	bar:TweenSize(
		UDim2.new(progress, 0, 1, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.3,
		false
	)

	-- Update Progress Text
	local percentage = math.floor(progress * 100)
	loadingText.Text = string.format("Loading... %d%%", percentage)
	progressText.Text = string.format("%d%%", percentage)
end

-- Start Preloading with Callback
ContentProvider:PreloadAsync(assets, function()
	updateProgress()
end)

repeat
	task.wait()
until _G.loaded and game:IsLoaded()

bar:TweenSize(
	UDim2.new(1, 0, 1, 0),
	Enum.EasingDirection.Out,
	Enum.EasingStyle.Quad,
	0.3,
	true,
	function()
		loadingScreen:Destroy()
		isLoading = false
	end
)
