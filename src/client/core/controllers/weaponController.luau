local CollectionService = game:GetService("CollectionService")
local ContextActionService = game:GetService("ContextActionService")
local GamePassService = game:GetService("GamePassService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local shared = ReplicatedStorage.shared
local packages = ReplicatedStorage.sharedPackages

local Input = require(packages.Input)
local PartCache = require(shared.utilities.PartCache)
local React = require(packages.React)
local ReactRoblox = require(packages.ReactRoblox)
local contextActionServiceUtil = require(packages.contextActionServiceUtil)
local loader = require(packages.loader)
local monetizationUtil = require(ReplicatedStorage.shared.utilities.monetizationUtil)
local playerUtil = require(shared.utilities.playerUtil)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local util = require(shared.utilities.weaponUtil)
local weaponConfig = require(shared.configurations.weaponConfig)
local weaponSettings = require(shared.configurations.weaponConfig)
local zap = require(ReplicatedStorage.zap)

local RAYCAST_BEAM_DURATION = 0.05
local HITMARKER_DURATION = 0.05
local HIT_PARTICLE_DURATION = 0.5
local SPRINT_SPEED = 21
local DAMAGE_DISPLAY_LIFETIME = 2
-- The keys of the control keys to their names in ContextActionService
-- List of controls for cross platform compatibilty
local CONTROLS = {
	activation = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }, -- Aka attack, shoot, swing, throw, etc
}

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local mouseInput = Input.Mouse.new()

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
local cacheFolder = Instance.new("Folder")
-- Create a cache of attachments and beams that are reused for optimal performance.
local attachmentCache =
	PartCache.new(Instance.new("Attachment"), WEAPON_CACHE_SIZE * 2, workspace.Terrain)
local beamCache = PartCache.new(beam, WEAPON_CACHE_SIZE, workspace.Terrain)
local hp1Cache = PartCache.new(hitParticle1, WEAPON_CACHE_SIZE, cacheFolder)

local fadeOutBeamTweenInfo =
	TweenInfo.new(RAYCAST_BEAM_DURATION, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

-- Controller state
local weapons = {}
local weaponEngaged = false
local expectingInput = false
local reloading = false
local currentAnim = "idle"
local currentWep = nil
local dead = true
local animTracks = {}
local casActions = {}

local weaponController = {}

local camera = game.Workspace.CurrentCamera
local cameraAngleX = 0
local cameraAngleY = 0

local GOAL_CAMERA_FOVS = { onSprint = 80, onWeaponAim = 45, default = 70 }
local CAMERA_LERP_ALPHAS = { onWeaponAim = 15, onSprint = 8, default = 10 }
local CAMERA_LERP_SPEED = 0.5
local MAX_ZOOM_DISTANCE = 8
local MIN_ZOOM_DISTANCE = 8
local VERTICAL_ANGLE_LIMITS = NumberRange.new(-75, 75)
local CAMERA_IGNORE_INSTANCE_TAG = "CameraCanIgnore"

local isFirstRun = true
local isInputFromUI = false -- Flag to track if input is active

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local weaponCamera = {
	CAMERA_PRIMARY_PART_OFFSET = Vector3.new(2.5, 2.5, 8),
}

local function lerpCameraFOV(goal: number, alpha: number)
	camera.FieldOfView = camera.FieldOfView + (goal - camera.FieldOfView) * alpha
end

local function getMobileAdjustedCenterScreenRay()
	-- Get the center of the screen for mobile shooting
	local viewportSize = camera.ViewportSize
	local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

	-- Adjust the Y value to move the crosshair slightly higher
	local adjustedY = screenCenter.Y - 20 -- Adjust this value to move the crosshair higher or lower

	-- Return the ray cast from the adjusted position
	return camera:ScreenPointToRay(screenCenter.X, adjustedY)
end

local function setCharTransparency(character, transparency: number)
	for _, v in character:GetChildren() do
		if v:IsA("BasePart") then
			if v.Name == "HumanoidRootPart" then
				continue
			end
			v.LocalTransparencyModifier = transparency --lerp(0, 0.95, obstructionDisplacement.Unit.Y)
		elseif v:IsA("Accessory") then
			v.Handle.LocalTransparencyModifier = transparency
		end
	end
end

local function updateCamera(isUiInput)
	-- Function to update the camera position and rotation
	local character = localPlayer.Character
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end
	local primaryPart = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head")

	camera.CameraType = Enum.CameraType.Scriptable
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	humanoid.AutoRotate = false
	localPlayer.CameraMaxZoomDistance = MAX_ZOOM_DISTANCE
	localPlayer.CameraMinZoomDistance = MIN_ZOOM_DISTANCE

	if head and head.LocalTransparencyModifier == 1 then
		for _, v in character:GetChildren() do
			if v:IsA("BasePart") then
				if v.Name == "HumanoidRootPart" then
					continue
				end
				v.LocalTransparencyModifier = 0
			elseif v:IsA("Accessory") then
				v.Handle.LocalTransparencyModifier = 0
			end
		end
	end

	if isFirstRun then
		lerpCameraFOV(GOAL_CAMERA_FOVS.default, CAMERA_LERP_ALPHAS.default)

		local cameraCFrame = workspace.CurrentCamera.CFrame
		cameraAngleY, cameraAngleX = cameraCFrame:ToOrientation()
	end

	-- Change camera angle based on mouse movements
	local mouseDelta = UserInputService:GetMouseDelta() * (isUiInput and 1 or 10) --activeCameraSettings.Sensitivity
	cameraAngleX -= mouseDelta.X / camera.ViewportSize.X
	cameraAngleY -= mouseDelta.Y / camera.ViewportSize.Y
	cameraAngleY = math.rad(
		math.clamp(math.deg(cameraAngleY), VERTICAL_ANGLE_LIMITS.Min, VERTICAL_ANGLE_LIMITS.Max)
	)

	if primaryPart then
		-- Address shoulder direction
		local offset = weaponCamera.CAMERA_PRIMARY_PART_OFFSET
		offset = Vector3.new(offset.X * 1--[[ShoulderDirection]], offset.Y, offset.Z)

		-- Calculate new camera CFrame
		local newCameraCFrame = CFrame.new(primaryPart.Position)
			* CFrame.Angles(0, cameraAngleX, 0)
			* CFrame.Angles(cameraAngleY, 0, 0)
			* CFrame.new(offset)

		newCameraCFrame = camera.CFrame:Lerp(newCameraCFrame, CAMERA_LERP_SPEED)

		-- Raycast for obstructions
		raycastParams.FilterDescendantsInstances = {
			character,
			workspace.RaycastIgnore,
			CollectionService:GetTagged(CAMERA_IGNORE_INSTANCE_TAG),
		}
		local raycastResult = workspace:Raycast(
			primaryPart.Position,
			newCameraCFrame.Position - primaryPart.Position,
			raycastParams
		)

		-- Address obstructions if any
		if raycastResult then
			local obstructionDisplacement = (raycastResult.Position - primaryPart.Position)
			local obstructionPosition = primaryPart.Position
				+ (obstructionDisplacement.Unit * (obstructionDisplacement.Magnitude - 0.1))
			local _, _, _, r00, r01, r02, r10, r11, r12, r20, r21, r22 =
				newCameraCFrame:GetComponents()
			newCameraCFrame = CFrame.new(
				obstructionPosition.x,
				obstructionPosition.y + 1, -- Give a little extra height so you can see over yourself easier
				obstructionPosition.z,
				r00,
				r01,
				r02,
				r10,
				r11,
				r12,
				r20,
				r21,
				r22
			)
			-- Essentially when the player's camera is colliding with something, it becomes hard to see.
			-- so here we make the player's character more and more transparent the closer they get to an obstruction.
			if obstructionDisplacement.Magnitude < 5 then
				local transparency = 1 - math.exp(-3 / obstructionDisplacement.Magnitude)
				setCharTransparency(character, transparency)
			end
			-- If we see that there is a body part with transparency, but there is no obstruction, then set it back.
		elseif character:FindFirstChild("Head").LocalTransparencyModifier > 0 then
			setCharTransparency(character, 0)
		end

		-- Align character with camera
		local newHumanoidRootPartCFrame = CFrame.new(primaryPart.Position)
			* CFrame.Angles(0, cameraAngleX, 0)
		primaryPart.CFrame =
			primaryPart.CFrame:Lerp(newHumanoidRootPartCFrame, CAMERA_LERP_SPEED / 2)

		camera.CFrame = newCameraCFrame
	end
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
	-- end
	currentAnim = animName
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

	-- Setup controls
	for casName, controls in CONTROLS do
		contextActionServiceUtil.bindActionNoInputSink(
			casName,
			casActions[casName],
			true,
			table.unpack(controls)
		)
	end
end

local function setupCharacter(character: Model)
	local humanoid = character:WaitForChild("Humanoid")
	local animator: Animator = humanoid:WaitForChild("Animator")

	-- Reset character state
	expectingInput = false
	currentWep = nil
	dead = false
	mouse.Icon = ""
	currentAnim = "idle"
	table.clear(animTracks)
	table.clear(weapons)

	character.ChildAdded:Connect(function(child: Instance)
		if child:IsA("Tool") then
			-- Check that the tool is a weapon
			local ws = table.clone(weaponConfig.settings[child.Name])
			if not ws then
				return
			end

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

			-- Disconnect controls
			for name, _ in casActions do
				ContextActionService:UnbindAction(name)
			end
		end
	end)

	character.Humanoid.Died:Connect(function()
		dead = true
		-- TODO: UI action
	end)
end

local function hitmarker()
	local mousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
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
	cachedBeam.Color = ColorSequence.new(data.beamColor)
	cachedBeam.Attachment0 = a0
	cachedBeam.Attachment1 = a1

	a0.WorldPosition = data.firepoint.WorldPosition
	a1.WorldPosition = data.hit

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
	local weaponName = data.weaponName
	local victim = data.victim
	-- If a player is hit and this is replicated to the client, make sure that person isn't the client who is being shot.
	local ws = weaponSettings.settings[weaponName]
	assert(ws, `No weapon settings for weapon named {weaponName}`)
	if victim and victim ~= localPlayer.Name then
		local hitmarkerSound = SoundService.Weapons.Hitmarker
		hitmarkerSound:Play()
		-- hitmarkerRoot:render(hitmarker())
		-- task.delay(HITMARKER_DURATION, function()
		-- 	hitmarkerRoot:unmount()
		-- end)

		-- victim = playerUtil.playerFromName(victim)
		-- if not victim and not data.targetHit then
		-- 	return
		-- end
		-- if not data.targetHit and not util.canDamage(localPlayer, victim, ws) then
		-- 	return
		-- end
		-- displayDamage(ws)
	end
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

	-- Do this as soon as the system starts incase the CharacterAdded event is called before the system
	-- has had a chance to start. This is where we initially setup the weapon controller.
	local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	setupCharacter(char)

	-- Detect when player starts interacting with the screen (mouse, touch, etc.)
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		-- If the input is processed by the game UI (joystick or other UI elements), set the flag
		if gameProcessedEvent then
			isInputFromUI = true
		end
	end)

	-- Detect when player stops interacting with the screen
	UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		-- Reset the flag when input ends
		if gameProcessedEvent then
			isInputFromUI = false
		end
	end)

	-- Continuously update the camera while input is active
	RunService.RenderStepped:Connect(function()
		if UserInputService.TouchEnabled then
			updateCamera(isInputFromUI)
		end
	end)

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

				if UserInputService.TouchEnabled then
					-- For mobile: shoot based on the center of the screen
					local ray = getMobileAdjustedCenterScreenRay()
					local hit =
						workspace:Raycast(ray.Origin, ray.Direction * currentWs.range, params)
					if hit then
						hitPosition = hit.Position
						hitInstance = hit.Instance
					else
						-- If no hit, cast the ray outwards to max range
						hitPosition = ray.Origin + ray.Direction * currentWs.range
					end
				else
					-- For non-mobile: shoot towards the mouse hit position
					params.FilterDescendantsInstances =
						{ workspace.RaycastIgnore, localPlayer.Character }
					local hit = workspace:Raycast(
						character.Head.Position,
						(mouse.Hit.Position - character.Head.Position).Unit * currentWs.range,
						params
					)
					hitPosition = if hit then hit.Position else mouseInput:Project(currentWs.range)
					hitInstance = if hit then hit.Instance else nil
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

	zap.replicateHit.SetCallback(weaponController.replicateBulletHit)
	zap.replicateCast.SetCallback(weaponController.visualizeCast)
	localPlayer.CharacterAdded:Connect(setupCharacter)
end

return weaponController
