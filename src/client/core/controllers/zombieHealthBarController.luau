local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.sharedPackages.ReactRoblox)
local uiController = require(script.Parent.uiController)
local zombieHealthBar = require(ReplicatedStorage.client.reactComponents.zombieHealthBar)
local healthBarController = {}

local zombieFolder = workspace:WaitForChild("Zombies")

local function app(props)
	return React.createElement(zombieHealthBar, props)
end

function healthBarController.start()
	zombieFolder.ChildAdded:Connect(function(zombie)
		local head = zombie:WaitForChild("Head", 5)
		local humanoid: Humanoid = zombie:WaitForChild("Humanoid", 5)
		local ui = uiController.getUi("ZombieOverhead")
		local root = ReactRoblox.createRoot(ui)
		if humanoid and head then
			root:render(app({
				adornee = head,
				zombieName = zombie.Name,
				health = humanoid.Health,
				maxHealth = humanoid.MaxHealth,
			}))

			humanoid.HealthChanged:Connect(function()
				root:render(app({
					adornee = head,
					zombieName = zombie.Name,
					health = humanoid.Health,
					maxHealth = humanoid.MaxHealth,
				}))
			end)

			humanoid.Died:Connect(function()
				root:unmount()
			end)
		end
	end)
end

return healthBarController
