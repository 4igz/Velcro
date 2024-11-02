local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local gameStateService = require(script.Parent.gameStateService)
local fogCycle = {}

local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local zombieFolder = workspace:WaitForChild("Zombies")
local vfxFolder = ServerStorage:WaitForChild("VFX")
local redEyesHolder = vfxFolder:WaitForChild("RedEyesHolder")

fogCycle.fogEnabled = false

function fogCycle.setFogDensity(density)
	if fogCycle.fogEnabled then
		TweenService:Create(Lighting.Blur, tweenInfo, { Size = 3 }):Play()
		TweenService
			:Create(Lighting.Atmosphere, tweenInfo, { Haze = 5, Glare = 0.3, Density = density })
			:Play()
	else
		TweenService
			:Create(Lighting.Atmosphere, tweenInfo, { Haze = 2.35, Glare = 3, Density = density })
			:Play()
		TweenService:Create(Lighting.Blur, tweenInfo, { Size = 1.2 }):Play()
	end
end

function fogCycle.setFogEnabled(enabled)
	fogCycle.fogEnabled = enabled
end

function fogCycle.start()
	local con = nil
	gameStateService.startingRound:Connect(function(roundNum)
		if roundNum > 0 and roundNum % 5 == 0 then
			-- The Fog is Coming
			fogCycle.setFogEnabled(true)
			fogCycle.setFogDensity(0.75)

			local function eyeHelper(zombie)
				local head = zombie:FindFirstChild("Head")
				if not head then
					return
				end

				for _, child in redEyesHolder:GetChildren() do
					child:Clone().Parent = head
				end
			end

			for _, zombie in zombieFolder:GetChildren() do
				eyeHelper(zombie)
			end

			con = zombieFolder.ChildAdded:Connect(function(zombie)
				eyeHelper(zombie)
			end)
		else
			if con then
				con:Disconnect()
			end
			fogCycle.setFogEnabled(false)
			fogCycle.setFogDensity(0.4)
		end
	end)
end

return fogCycle
