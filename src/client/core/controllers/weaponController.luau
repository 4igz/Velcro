local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local shared = ReplicatedStorage.shared
local packages = ReplicatedStorage.sharedPackages

local localPlayer = Players.LocalPlayer

local CameraShaker = require(ReplicatedStorage.CameraShaker) :: ModuleScript
local Input = require(packages.Input)
local OTS = require(ReplicatedStorage.OTS) :: ModuleScript
local PartCache = require(shared.utilities.PartCache)
local React = require(packages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local damageNumberContainer =
	require(ReplicatedStorage.client.reactComponents.damageNumberContainer)
local uiController = require(script.Parent.uiController)
local weaponConfig = require(shared.configurations.weaponConfig)
local weaponSettings = require(shared.configurations.weaponConfig)
local weaponUtil = require(ReplicatedStorage.shared.utilities.weaponUtil)
local zap = require(ReplicatedStorage.zap)

local RAYCAST_BEAM_DURATION = 0.05
local HITMARKER_DURATION = 0.05
local HIT_PARTICLE_DURATION = 0.5
local DAMAGE_DISPLAY_LIFETIME = 2
-- The keys of the control keys to their names in ContextActionService
-- List of controls for cross platform compatibilty
local CONTROLS = {
	activation = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }, -- Aka attack, shoot, swing, throw, etc
}

local otsEnabled = true
local cameraShakeEnabled = true
local damageNumbersEnabled = true
local othersRayEnabled = true

local camera = workspace.CurrentCamera
local mouse = localPlayer:GetMouse()
local playerGui = localPlayer:WaitForChild("PlayerGui")
local mouseInput = Input.Mouse.new()
local cameraShaker = CameraShaker.new(Enum.RenderPriority.Last.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)

cameraShaker:Start()

local hitmarkerRoot = ReactRoblox.createRoot(uiController.getUi("Hitmarker"))
local hitmarkerSound = SoundService.Weapons.Hitsound1
local killSound = SoundService.Weapons.Kill

local damageNumberUi = uiController.getUi("DamageNumberContainer")
local damageNumberRoot = ReactRoblox.createRoot(damageNumberUi)

-- Create the params just once at the top for increased performance.
local params = RaycastParams.new()
params.FilterDescendantsInstances = { workspace.RaycastIgnore }
params.FilterType = Enum.RaycastFilterType.Exclude

-- Initial instance for beam cache
local beam = Instance.new("Beam")
beam.Width0 = 0.1
beam.Width1 = 0.1
beam.LightEmission = 1
beam.LightInfluence = 1
beam.FaceCamera = true

local hitParticle1 = Instance.new("ParticleEmitter") -- Particles
hitParticle1.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
hitParticle1.Lifetime = NumberRange.new(0.3, HIT_PARTICLE_DURATION)
local hitParticle2 = Instance.new("ParticleEmitter") -- Smoke
hitParticle2.Lifetime = NumberRange.new(0.3, HIT_PARTICLE_DURATION)
hitParticle2.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))

local WEAPON_CACHE_SIZE = 50
-- Create a cache of attachments and beams that are reused for optimal performance.
local attachmentCache =
	PartCache.new(Instance.new("Attachment"), WEAPON_CACHE_SIZE * 2, workspace.Terrain)
local beamCache = PartCache.new(beam, WEAPON_CACHE_SIZE, workspace.Terrain)

local fadeOutBeamTweenInfo =
	TweenInfo.new(RAYCAST_BEAM_DURATION, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

-- Controller state
local weapons = {}
local weaponEngaged = false
local expectingInput = false
local reloading = false
local currentWep = nil
local dead = true
local animTracks = {}
local casActions = {}

local weaponController = {}

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function getMobileAdjustedCenterScreenRay()
	-- Get the center of the screen for mobile shooting
	local viewportSize = camera.ViewportSize
	local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

	-- Adjust the Y value to move the crosshair slightly higher
	local adjustedY = screenCenter.Y - 87 -- Adjust this value to move the crosshair higher or lower

	-- Return the ray cast from the adjusted position
	return camera:ScreenPointToRay(screenCenter.X, adjustedY)
end

-- This stops all weapon animations that could be playing and plays the desired animation.
local function stopAllAndPlay(animName: string)
	-- if not animTracks[animName].IsPlaying then
	for _, anim in animTracks do
		if type(anim) == "table" then
			continue
		end
		anim:Stop()
	end
	if animTracks[animName] then
		animTracks[animName]:Play()
	end
end

-- Whenever an activation key is pressed this function is fired
function casActions.activation(_, state: Enum.UserInputState)
	weaponEngaged = if state == Enum.UserInputState.Begin then true else false
end

-- What to do when the player has equipped a tool that is registered as a weapon in weaponSettings
local function weaponEquipped(tool: Tool)
	-- Reset weapon state to default
	mouse.Icon = "rbxassetid://5992580992"
	stopAllAndPlay("idle")
	currentWep = tool
	expectingInput = true
	local mag = tool:FindFirstChild("Mag")
	if mag then
		mag.Transparency = 0
	end

	if UserInputService.TouchEnabled then
		local mobileUi = playerGui:WaitForChild("MobileUi")
		mobileUi.mobileUI.crosshair.Visible = true
	end
	if UserInputService.TouchEnabled or otsEnabled then
		OTS.SetCharacterAlignment(true)
		OTS.Enable()
	end

	-- Setup controls
	ContextActionService:BindAction("activation", function(...)
		casActions.activation(...)
		return Enum.ContextActionResult.Pass
	end, false, unpack(CONTROLS.activation))
end

local function setupCharacter(character: Model)
	local humanoid = character:WaitForChild("Humanoid")
	local animator: Animator = humanoid:WaitForChild("Animator")

	-- Reset character state
	expectingInput = false
	currentWep = nil
	dead = false
	mouse.Icon = ""
	table.clear(animTracks)
	table.clear(weapons)

	character.ChildAdded:Connect(function(child: Instance)
		if child:IsA("Tool") then
			-- Check that the tool is a weapon
			local exists = weaponConfig.settings[child.Name]
			if not exists then
				return
			end

			local ws = table.clone(exists)

			-- humanoid.WalkSpeed = (ws.walkspeed or 16)
			-- 	* (
			-- 		if monetizationUtil
			-- 				.userOwnsGamepass(localPlayer.UserId, sharedInfo.Gamepasses["Extra Speed!"])
			-- 				:expect()
			-- 			then 1.5
			-- 			else 1
			-- 	)

			-- Initialize weapon if not already
			if not weapons[child] then
				weapons[child] = ws
				ws.bulletsLeft = ws.magSize

				ws.fireCooldown *= zap.getFirerate.Call()
			end

			-- Load weapon animations
			for name, animId in ws.anims do
				if animId == "" then
					continue
				end
				if not animTracks[name] then
					if type(animId) == "table" then
						animTracks[name] = {}
						local animation = Instance.new("Animation")
						for _, id in animId do
							animation.AnimationId = id
							local track = animator:LoadAnimation(animation)
							track.Priority = Enum.AnimationPriority.Action
							track.Looped = false
							table.insert(animTracks[name], track)
						end
						continue
					end
					local animation = Instance.new("Animation")
					animation.AnimationId = animId
					local track = animator:LoadAnimation(animation)
					track.Priority = Enum.AnimationPriority.Action
					track.Looped = false
					animTracks[name] = track
				end
			end

			weaponEquipped(child)
		end
	end)

	-- Listen for anything removed from the player's character and check if it's a weapon
	character.ChildRemoved:Connect(function(child: Instance)
		-- If expectingInput is true, that means the player is holding a weapon.
		if expectingInput and child:IsA("Tool") then
			task.defer(function()
				for _, anim in animTracks do
					if type(anim) == "table" then
						continue
					end
					anim:Stop()
				end
			end)
			mouse.Icon = ""
			expectingInput = false
			currentWep = nil

			if UserInputService.TouchEnabled then
				local mobileUi = playerGui:WaitForChild("MobileUi")
				mobileUi.mobileUI.crosshair.Visible = false
			end
			if UserInputService.TouchEnabled or otsEnabled then
				OTS.Disable()
				OTS.LockMouse(false)
				OTS.SetCharacterAlignment(false)
			end

			-- Disconnect controls
			for name, _ in casActions do
				ContextActionService:UnbindAction(name)
			end
		end
	end)

	character.Humanoid.Died:Connect(function()
		dead = true
		-- TODO: UI action
		OTS.Disable()
	end)
end

local function hitmarker()
	local mousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
	if UserInputService.TouchEnabled then
		mousePosition = Vector2.new(camera.ViewportSize.X / 2, (camera.ViewportSize.Y / 2) - 87)
	end
	return React.createElement("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "http://www.roblox.com/asset/?id=9999783439",
		Size = UDim2.new(0, 25, 0, 25),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(mousePosition.X, mousePosition.Y),
		Name = "Hitmarker",
		Visible = true,
	})
end

-- This visualizes casts in a unique way, using beams. It's more performant and much easier to do.
function weaponController.visualizeCast(data)
	-- Using a modified part cache we get our cached instances
	local a0: Attachment = attachmentCache:GetPart()
	local a1: Attachment = attachmentCache:GetPart() --getUnusedCachePart(attachmentCache, "ParticleEmitter")
	local cachedBeam = beamCache:GetPart()
	-- print(data)
	-- cachedBeam.Color = ColorSequence.new(data.beamColor)

	a0.WorldPosition = data.firepoint.WorldPosition
	a1.WorldPosition = data.hit
	cachedBeam.Attachment0 = a0
	cachedBeam.Attachment1 = a1

	task.spawn(function()
		local fadeOutTween = TweenService:Create(cachedBeam, fadeOutBeamTweenInfo, { Width0 = 0 })
		fadeOutTween:Play()
		fadeOutTween.Completed:Wait()
		cachedBeam.Attachment0 = nil
		cachedBeam.Attachment1 = nil
		cachedBeam.Width0 = 0.1
		-- Return instances after we're done with them.
		attachmentCache:ReturnPart(a0)
		attachmentCache:ReturnPart(a1)
		beamCache:ReturnPart(cachedBeam)
	end)
end

-- Perform any client sided actions when a bullet hits something.
function weaponController.replicateBulletHit(data)
	-- local hitPart = data.hitPart

	if damageNumbersEnabled then
		local viewportSize = camera.ViewportSize

		local mp = if UserInputService.TouchEnabled
			then Vector2.new(viewportSize.X / 2, viewportSize.Y / 2 - 87)
			else UserInputService:GetMouseLocation() - GuiService:GetGuiInset()

		damageNumberRoot:render(React.createElement(damageNumberContainer, {
			damage = math.floor(data.damage),
			critical = data.isCritical,
			-- Get mouse position on screen
			position = mp,
			timestamp = tick(),
		}))
	end

	hitmarkerSound:Play()
	hitmarkerRoot:render(hitmarker())
	task.delay(HITMARKER_DURATION, function()
		hitmarkerRoot:unmount()
	end)
end

function weaponController.visualizeKill(zombie)
	if not zombie then
		killSound:Play()

		if cameraShakeEnabled then
			local c = CameraShaker.CameraShakeInstance.new(1, 4, 0, 0.3)
			c.PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
			c.RotationInfluence = Vector3.new(0, 0, 0)
			cameraShaker:Shake(c)
		end
		return
	end

	local character = localPlayer.Character
	if not character or not character.PrimaryPart then
		return
	end
	local shooterPos = character.PrimaryPart.Position
	if not zombie or not zombie.PrimaryPart then
		return
	end
	local zombiePos = zombie.PrimaryPart.Position

	-- Calculate the direction and magnitude of the impulse
	local impulseDirection = (zombiePos - shooterPos).Unit
	local impulseMagnitude = 500 -- Adjust this value for more or less force
	local impulseForce = impulseDirection * impulseMagnitude
	zombie.PrimaryPart:ApplyImpulse(impulseForce)
end

function weaponController.start()
	local lastFire = 0

	-- Listen for input to check if it's game-processed
	-- Set defaults for all weapon types
	for _, settings in weaponSettings.settings do
		for name, setting in weaponSettings.default do
			if not settings[name] then
				settings[name] = setting
			end
		end
	end

	-- Setup settings listeners
	weaponConfig.signals.toggleCameraShake:Connect(function(value)
		cameraShakeEnabled = value
	end)

	weaponConfig.signals.toggleDamageNumbers:Connect(function(value)
		damageNumbersEnabled = value
	end)

	weaponConfig.signals.toggleOthersRays:Connect(function(value)
		othersRayEnabled = value
	end)

	if UserInputService.TouchEnabled then
		local mobileUi = localPlayer.PlayerGui:WaitForChild("MobileUi")
		mobileUi.Enabled = true

		local fireButton: TextButton = mobileUi.mobileUI:WaitForChild("fireButton")
		fireButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				weaponEngaged = true
			end
		end)

		fireButton.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				weaponEngaged = false
			end
		end)
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
			if expectingInput then
				if otsEnabled then
					OTS.Disable()
					OTS.LockMouse(false)
					OTS.SetCharacterAlignment(false)
				else
					OTS.Enable()
					OTS.LockMouse(true)
					OTS.SetCharacterAlignment(true)
				end
				otsEnabled = not otsEnabled
			end
		end
	end)

	-- Do this as soon as the system starts incase the CharacterAdded event is called before the system
	-- has had a chance to start. This is where we initially setup the weapon controller.
	local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	setupCharacter(char)

	RunService.RenderStepped:Connect(function(dt)
		if weaponEngaged and expectingInput and not dead then
			local now = time()
			local currentWs = weapons[currentWep]
			-- Don't fire weapon while reloading and make sure we have a registered weapon equipped.
			if not currentWs or reloading then
				return
			end
			local character = localPlayer.Character
			local hum = (character ~= nil) and character:FindFirstChild("Humanoid")
			if not hum then
				return
			end
			-- Cooldown based on clock
			if (now - lastFire) > currentWs.fireCooldown then
				lastFire = now
				-- Player fired a shot, also make them idle again incase they were running.
				stopAllAndPlay("idle")

				-- Cast a ray to the player's mouse from their head so they can't shoot
				-- through walls but can shoot above walls their head can see over.
				-- This also makes first person more accurate.
				local hitPosition
				local hitInstance

				local function isVisible(instance)
					return instance.Transparency < 1 and instance.CanCollide -- Adjust as needed
				end

				-- TODO: Calculate spread on client
				local function performRaycast(origin, rawDirection, range, params)
					local direction =
						weaponUtil.getSpreadDirectionFromSettings(rawDirection, currentWs)
					local rayOrigin = origin
					local hitPosition, hitInstance
					local maxIterations = 10 -- Limit the number of attempts to avoid infinite loop
					local stepDistance = range / maxIterations -- Step size to move through invisible parts
					local iteration = 0

					while iteration < maxIterations do
						local hit = workspace:Raycast(rayOrigin, direction * stepDistance, params)

						if hit and hit.Instance then
							if isVisible(hit.Instance) then
								-- Found a visible part, return the hit position and instance
								hitPosition = hit.Position
								hitInstance = hit.Instance
								break
							else
								-- Hit an invisible part, move the origin forward by a small step
								rayOrigin = hit.Position + direction * 0.1 -- Small offset to continue
							end
						else
							-- No hit in this iteration; increment the origin by stepDistance
							rayOrigin = rayOrigin + direction * stepDistance
						end

						iteration = iteration + 1
					end

					-- If we haven’t hit anything visible, set hitPosition to the max range position
					if not hitPosition then
						hitPosition = origin + direction * range
					end

					return hitPosition, hitInstance
				end

				params.FilterDescendantsInstances = {
					workspace.RaycastIgnore,
					localPlayer.Character,
					CollectionService:GetTagged("ZombieSpawns"),
					CollectionService:GetTagged("SoundPart"),
				}

				if UserInputService.TouchEnabled then
					-- For mobile: shoot based on the center of the screen
					local ray = getMobileAdjustedCenterScreenRay()
					hitPosition, hitInstance =
						performRaycast(ray.Origin, ray.Direction, currentWs.range, params)
				else
					-- For non-mobile: shoot towards the mouse hit position
					local direction = (mouse.Hit.Position - character.Head.Position).Unit
					hitPosition, hitInstance =
						performRaycast(character.Head.Position, direction, currentWs.range, params)
				end
				-- If the cast doesn't hit anything then let's say they hit somewhere at the
				-- end of the range of their weapon.
				-- Multiple bullets are visualized by the server because each bullets direction is calculated by the server.
				if currentWs.bullets == 1 then
					weaponController.visualizeCast({
						firepoint = currentWep.Handle.Firepoint,
						hit = hitPosition,
						beamColor = currentWs.raycastBeamColor,
					})
				end

				-- TODO: UI

				-- Send a message to the server telling them that we have fired our weapon so that the rest can be handled there.
				zap.fireGun.Fire({ hitPos = hitPosition, rayHit = hitInstance })
			end
		end
	end)

	zap.replicateKill.SetCallback(weaponController.visualizeKill)
	zap.replicateHit.SetCallback(weaponController.replicateBulletHit)
	zap.replicateCast.SetCallback(function(data)
		if not othersRayEnabled then
			return
		end
		weaponController.visualizeCast(data)
	end)
	localPlayer.CharacterAdded:Connect(setupCharacter)
end

return weaponController
