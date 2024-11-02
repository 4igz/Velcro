local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.sharedPackages.Signal)
local zombieUtil = {}

zombieUtil.createShockwave = Signal.new()

function zombieUtil.createRagdoll(character)
	if not character:IsA("Model") then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CanCollide = false
	end

	-- Check if character and humanoid exist
	if not humanoid then
		return
	end

	humanoid.RequiresNeck = false -- Allow neck movement for ragdoll effect

	-- Disable Motor6Ds and replace with BallSocketConstraints
	for _, motor in pairs(character:GetDescendants()) do
		if motor:IsA("Motor6D") then
			-- Create BallSocketConstraint
			local attachment0 = Instance.new("Attachment")
			attachment0.Name = "Attachment0"
			attachment0.CFrame = motor.C0
			attachment0.Parent = motor.Part0

			local attachment1 = Instance.new("Attachment")
			attachment1.Name = "Attachment1"
			attachment1.CFrame = motor.C1
			attachment1.Parent = motor.Part1

			local ballSocket = Instance.new("BallSocketConstraint")
			ballSocket.Name = motor.Name .. "_Ragdoll"
			ballSocket.Attachment0 = attachment0
			ballSocket.Attachment1 = attachment1
			ballSocket.Parent = motor.Part0

			-- Adjust BallSocket properties if necessary (limits, damping)
			ballSocket.TwistLimitsEnabled = true
			ballSocket.TwistLowerAngle = -45
			ballSocket.TwistUpperAngle = 45
			ballSocket.LimitsEnabled = true
			ballSocket.UpperAngle = 90
			ballSocket.Restitution = 0.1
			-- ballSocket.Damping = 0.1

			motor.Enabled = false -- Disable the Motor6D to simulate ragdoll
		end
	end
end

function zombieUtil.getNearbyZombies(zombieData, position, radius)
	local nearbyZombies = {}
	for _, otherZombieData in (zombieData.allZombies and zombieData.allZombies or zombieData) do
		local otherZombie = otherZombieData.model
		if
			otherZombie
			and otherZombie.Parent
			and otherZombie:FindFirstChild("HumanoidRootPart")
		then
			local distance = (otherZombie.HumanoidRootPart.Position - position).Magnitude
			if
				distance <= radius
				and (zombieData.model and otherZombie ~= zombieData.model or true)
			then
				table.insert(nearbyZombies, otherZombie)
			end
		end
	end
	return nearbyZombies
end

return zombieUtil
