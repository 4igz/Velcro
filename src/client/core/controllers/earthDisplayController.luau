local CollectionService = game:GetService("CollectionService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local earthDisplayController = {}

local EARTH_TAG = "Earth"
local TWEEN_INFO = TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local SPIN_SPEED = 1 / 240
local EARTH_HEIGHT = NumberRange.new(18, 22)

function earthDisplayController.start()
	--
	CollectionService:GetInstanceAddedSignal(EARTH_TAG):Connect(function(instance)
		earthDisplayController.beginMovement(instance)
	end)
end

function earthDisplayController.beginMovement(earth: BasePart)
	task.spawn(function()
		while task.wait() do
			earth.CFrame = earth.CFrame * CFrame.Angles(0, -SPIN_SPEED, 0)

			if earth.CFrame.Y >= EARTH_HEIGHT.Max then
				earth.CFrame = earth.CFrame - Vector3.new(0, SPIN_SPEED, 0)
			else
				earth.CFrame = earth.CFrame - Vector3.new(0, SPIN_SPEED, 0)
			end
		end
	end)
end

return earthDisplayController
