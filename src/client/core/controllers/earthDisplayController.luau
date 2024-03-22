local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local earthDisplayController = {}

local EARTH_TAG = "Earth"
local spinSpeed = -math.rad(0.1) -- How fast the model spins, higher is faster
local bobSpeed = 0.25 -- How fast the model bobs, higher is faster
local bobHeight = 1 -- The height range for the bobbing effect

local angle = 0 -- Initial angle for spinning

function earthDisplayController.start()
	local earths = CollectionService:GetTagged(EARTH_TAG)
	for _, earth in earths do
		earth.PrimaryPart = earth:FindFirstChild("Earth")
		earthDisplayController.beginMovement(earth)
	end

	CollectionService:GetInstanceAddedSignal(EARTH_TAG):Connect(function(instance)
		earthDisplayController.beginMovement(instance)
	end)
end

function earthDisplayController.beginMovement(earth: Model)
	task.spawn(function()
		local initialY = earth:GetPivot().Y -- Capture the initial Y position of the model

		while task.wait() do
			-- Calculate new angle for spin
			angle = angle + spinSpeed
			if angle >= (2 * math.pi) then
				angle = angle - (2 * math.pi) -- Reset angle to prevent overflow
			end

			-- Calculate new Y position for bob, using a sine wave
			local time = tick() -- Current time in seconds
			local bobY = math.sin(time * bobSpeed) * bobHeight

			local pv = earth:GetPivot()
			-- Apply spin and bob transformations
			local spinCFrame = CFrame.Angles(0, angle, 0)
			local newCFrame = CFrame.new(pv.X, initialY + bobY, pv.Z) * spinCFrame
			-- Apply transformations
			earth:PivotTo(newCFrame)
		end
	end)
end

return earthDisplayController
