local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.sharedPackages.React)
local gamepassShop = require(script.Parent.gamepassShop)
local playerUtil = require(ReplicatedStorage.shared.utilities.playerUtil)
local e = React.createElement

return function(props)
	-- Store the health, maxHealth, xp, and xpMax as state
	local health, setHealth = React.useState(props.health or 100)
	local maxHealth, setMaxHealth = React.useState(props.maxHealth or 100)
	local xp, setXp = React.useState(props.xp or 0)
	local xpMax, setXpMax = React.useState(props.xpMax or 1)
	local level, setLevel = React.useState(props.xpMax or 1)

	local leaderstats = Players.LocalPlayer:WaitForChild("leaderstats")
	local money: IntValue = leaderstats:WaitForChild("Money")
	local moneyV, setMoney = React.useState(money.Value)

	money.Changed:Connect(function()
		setMoney(money.Value)
	end)

	-- Update the state if new props are passed
	React.useEffect(function()
		if props.health then
			setHealth(props.health)
		end
		if props.level then
			setLevel(props.level)
		end
		if props.maxHealth then
			setMaxHealth(props.maxHealth)
		end
		if props.xp then
			setXp(props.xp)
		end
		if props.xpMax then
			setXpMax(props.xpMax)
		end
	end, { props.health, props.maxHealth, props.xp, props.xpMax, props.level, props.visible })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
	}, {
		bottom = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.861),
			Size = UDim2.fromScale(1, 0.276),
		}, {
			playerinfo = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.231, 0.557),
				Size = UDim2.fromScale(0.425, 0.664),
			}, {
				info = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.514, 0.411),
					Size = UDim2.fromScale(0.552, 0.821),
					ZIndex = 2,
				}, {
					username = React.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxassetid://11702779517",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						Position = UDim2.fromScale(0.507, 0.244),
						Size = UDim2.fromScale(0.987, 0.211),
						Text = Players.LocalPlayer.Name,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
					}),

					experience = React.createElement("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(22, 22, 22),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.507, 0.76),
						Size = UDim2.fromScale(0.987, 0.17),
					}, {
						bar = React.createElement("Frame", {
							BackgroundColor3 = Color3.fromRGB(255, 119, 0),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.fromScale(0, 1):Lerp(UDim2.fromScale(1, 1), xp / xpMax),
						}, {
							uIGradient = React.createElement("UIGradient", {
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(198, 198, 198)),
								}),
							}),
						}),

						uIStroke = React.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(15, 15, 15),
							LineJoinMode = Enum.LineJoinMode.Miter,
							Thickness = 2,
						}),

						levelXP = React.createElement("TextLabel", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
							Position = UDim2.fromScale(0.79, 0.5),
							RichText = true,
							Size = UDim2.fromScale(0.418, 1),
							Text = `<b>{xp}</b><font transparency="0.5">/{xpMax} </font>`,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Right,
							ZIndex = 2,
						}),

						level = React.createElement("TextLabel", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
							Position = UDim2.fromScale(0.18, 0.5),
							RichText = true,
							Size = UDim2.fromScale(0.32, 1),
							Text = `Level <b>{level}</b>`,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 2,
						}),
					}),

					health = React.createElement("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(22, 22, 22),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.507, 0.49),
						Size = UDim2.fromScale(0.987, 0.17),
					}, {
						bar1 = React.createElement("Frame", {
							BackgroundColor3 = Color3.fromRGB(189, 0, 0),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							Size = UDim2.fromScale(0, 1)
								:Lerp(UDim2.fromScale(1, 1), health / maxHealth),
						}, {
							uIGradient1 = React.createElement("UIGradient", {
								Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(198, 198, 198)),
								}),
							}),
						}),
						amount = React.createElement("TextLabel", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							FontFace = Font.new(
								"rbxasset://fonts/families/GothamSSm.json",
								Enum.FontWeight.Bold,
								Enum.FontStyle.Normal
							),
							Position = UDim2.fromScale(0.508, 0.5),
							Size = UDim2.fromScale(0.964, 1),
							Text = `{health} HP`,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextScaled = true,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						uIStroke1 = React.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(15, 15, 15),
							LineJoinMode = Enum.LineJoinMode.Miter,
							Thickness = 2,
						}),
					}),
				}),

				avatar = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.1, 0.59),
					Rotation = 45,
					Size = UDim2.fromScale(0.152, 0.574),
					ZIndex = 1,
				}, {
					uIStroke2 = React.createElement("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(15, 15, 15),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 3,
					}),

					uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

					pfp = React.createElement("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = playerUtil.avatarImage(
							Players.LocalPlayer.UserId,
							Enum.ThumbnailSize.Size420x420,
							Enum.ThumbnailType.HeadShot
						),
						Position = UDim2.fromScale(0.5, 0.5),
						Rotation = -45,
						Size = UDim2.fromScale(1.02, 1.02),
						ZIndex = 2,
					}),
				}),

				coins = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.518, 0.875),
					Size = UDim2.fromScale(0.545, 0.22),
					ZIndex = 2,
				}, {
					uIStroke3 = React.createElement("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(15, 15, 15),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 2,
					}),

					amount1 = React.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						Position = UDim2.fromScale(0.437, 0.5),
						Size = UDim2.fromScale(0.821, 0.761),
						Text = `${moneyV}`,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 3,
					}),

					button = React.createElement("TextButton", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 0.7,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
						Position = UDim2.fromScale(0.945, 0.5),
						Size = UDim2.fromScale(0.0904, 0.832),
						Text = "+",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						ZIndex = 3,
					}, {
						uIAspectRatioConstraint1 = React.createElement("UIAspectRatioConstraint"),

						uIStroke4 = React.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = Color3.fromRGB(8, 8, 8),
							LineJoinMode = Enum.LineJoinMode.Miter,
						}),
					}),
				}),

				divider = React.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(15, 15, 15),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.218, 0.583),
					Size = UDim2.fromScale(0.005, 0.9),
				}),
			}),

			tab = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.971, 0.521),
				Size = UDim2.fromScale(0.0455, 0.705),
			}, {
				skill3 = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Position = UDim2.fromScale(0.508, 0.146),
					Size = UDim2.fromScale(0.679, 0.291),
				}, {
					uIAspectRatioConstraint2 = e("UIAspectRatioConstraint"),

					uIStroke5 = e("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(15, 15, 15),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 3,
					}),

					key = e("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Medium,
							Enum.FontStyle.Normal
						),
						Position = UDim2.fromScale(0.85, 0.9),
						Size = UDim2.fromScale(0.533, 0.524),
						Text = "F",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Right,
						ZIndex = 3,
					}, {
						uIStroke6 = e("UIStroke", {
							Color = Color3.fromRGB(70, 70, 70),
							Thickness = 2,
						}),
					}),

					icon = e("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = "rbxassetid://16042089544",
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1.01, 0.97),
					}, {
						uIAspectRatioConstraint3 = e("UIAspectRatioConstraint"),
					}),
				}),

				shieldSkill = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(22, 22, 22),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Position = UDim2.fromScale(0.508, 0.146),
					Size = UDim2.fromScale(0.679, 0.291),
				}, {
					uIAspectRatioConstraint2 = e("UIAspectRatioConstraint"),

					uIStroke5 = e("UIStroke", {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Color3.fromRGB(15, 15, 15),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 3,
					}),

					key = e("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Medium,
							Enum.FontStyle.Normal
						),
						Position = UDim2.fromScale(0.85, 0.9),
						Size = UDim2.fromScale(0.533, 0.524),
						Text = "R",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextSize = 14,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Right,
						ZIndex = 3,
					}, {
						uIStroke6 = e("UIStroke", {
							Color = Color3.fromRGB(70, 70, 70),
							Thickness = 2,
						}),
					}),

					icon = e("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = "rbxassetid://5647507800",
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1.01, 0.97),
					}, {
						uIAspectRatioConstraint3 = e("UIAspectRatioConstraint"),
					}),
				}),

				uIListLayout = e("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0.075, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
				}),
			}),
		}),
	})
end
