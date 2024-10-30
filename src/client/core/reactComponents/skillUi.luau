local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local React = require(ReplicatedStorage.sharedPackages.React)
local Sift = require(ReplicatedStorage.sharedPackages.Sift)
local sharedInfo = require(ReplicatedStorage.shared.sharedInfo)
local skillConfig = require(ReplicatedStorage.shared.configurations.skillConfig)
local zap = require(ReplicatedStorage.zap)
local e = React.createElement

local uiSounds = SoundService:WaitForChild("UI")

local function createReq(props)
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = if props.unlocked
			then Color3.fromRGB(255, 255, 255)
			else Color3.fromRGB(90, 90, 90),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = props.position,
		Rotation = 45,
		Size = UDim2.fromScale(0.129, 0.513),
	}, {
		uIAspectRatioConstraint4 = e("UIAspectRatioConstraint"),

		level = e("TextLabel", {
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
			Position = UDim2.fromScale(0.5, 0.47),
			Rotation = -45,
			Size = UDim2.fromScale(0.975, 0.881),
			Text = props.cost,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),
	})
end

local function createSkillButton(props)
	local requirements, setRequirements = React.useState({})

	local function updateRequirement()
		-- Start with base requirements like icon and divider
		local newRequirements = {
			icon1 = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = if props.unlocked
					then "rbxassetid://93655432801513"
					else "rbxassetid://6088994136",
				Position = UDim2.fromScale(0.166, 0.455),
				ScaleType = Enum.ScaleType.Crop,
				Size = if props.unlocked
					then UDim2.fromScale(0.108, 0.45)
					else UDim2.fromScale(0.4, 0.6),
			}, {
				uIAspectRatioConstraint2 = e("UIAspectRatioConstraint"),
			}),

			divider = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.274, 0.485),
				Size = UDim2.fromScale(0.006, 0.8),
			}),
		}

		-- Now add each requirement in the loop without reinitializing the table
		for i = 1, math.min(3, #props.requirements) do
			local cost = props.requirements[i]
			table.insert(
				newRequirements,
				createReq({
					cost = cost, -- Pass the cost directly
					unlocked = props.unlocked and i == 1 and props.level > 0, -- Assume the first requirement is unlocked
					order = i,
					position = UDim2.fromScale(0.43 + (0.22 * (i - 1)), 0.5),
					requirementText = string.format("Cost: %s essence", cost), -- Display the cost
				})
			)
		end

		-- Update the state with the full list of requirements
		setRequirements(newRequirements)
	end

	React.useEffect(function()
		updateRequirement()
	end, { props.requirements })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.508, 0.137),
		Size = UDim2.fromScale(0.98, 0.275),
	}, {
		frame1 = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.6,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 0.93),
		}, {
			frame2 = e("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.6,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.988, 0.887),
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
				[React.Event.MouseButton1Click] = function()
					props.onClick()
					uiSounds.Click:Play()
				end,
			}, {
				name = e("TextLabel", {
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
					Position = UDim2.fromScale(0.26, 0.5),
					Size = UDim2.fromScale(0.395, 0.427),
					Text = props.skillName,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),

				icon = e("ImageLabel", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Image = "rbxassetid://12194143054",
					Position = UDim2.fromScale(0.03, 0.5),
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromScale(0.0574, 0.543),
				}, {
					uIAspectRatioConstraint = e("UIAspectRatioConstraint"),
				}),

				requirements = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.799, 0.522),
					Size = UDim2.fromScale(0.402, 0.956),
				}, requirements),
			}),
		}),
	})
end

local function skillInfo(props)
	local selectedSkill = props.selectedSkill

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.7,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.865, 0.61),
		Size = UDim2.fromScale(0.222, 0.695),
		Visible = props ~= nil,
	}, {
		uICorner4 = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),

		preview = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.226),
			Size = UDim2.fromScale(0.84, 0.359),
		}, {
			uIStroke7 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(9, 9, 9),
				Thickness = 3,
			}),

			icon2 = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://12194143054",
				Position = UDim2.fromScale(0.5, 0.55),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.603, 0.94),
			}, {
				uIAspectRatioConstraint6 = e("UIAspectRatioConstraint"),
			}),

			name1 = e("TextLabel", {
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
				Position = UDim2.fromScale(0.5, 0.144),
				Size = UDim2.fromScale(0.906, 0.227),
				Text = if props then string.upper(props.info.name) else "",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIStroke8 = e("UIStroke", {
					Color = Color3.fromRGB(9, 9, 9),
					Thickness = 2,
				}),

				uIGradient1 = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 218, 69)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 119, 0)),
					}),
					Rotation = 90,
				}),
			}),
		}),

		desc1 = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Position = UDim2.fromScale(0.5, 0.78),
			RichText = true,
			Size = UDim2.fromScale(0.845, 0.202),
			Text = if props then props.info.description else "",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextDirection = Enum.TextDirection.LeftToRight,
			TextScaled = true,
			TextSize = 14,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		}, {
			uITextSizeConstraint = e("UITextSizeConstraint", {
				MaxTextSize = 17,
			}),
		}),

		button6 = e("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Position = UDim2.fromScale(0.5, 0.518),
			Size = UDim2.fromScale(0.84, 0.119),
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14,
			[React.Event.MouseButton1Click] = function()
				zap.upgradeSkill.Fire({ skill = props.id, weapon = selectedSkill })

				if props.data.unlocked then
					uiSounds.Upgrade:Play()
				else
					uiSounds.Unlock:Play()
				end
			end,
		}, {
			uIStroke9 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(9, 9, 9),
				Thickness = 3,
			}),

			text5 = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.SemiBold,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.3),
				Size = UDim2.fromScale(0.825, 0.538),
				Text = props and (props.data.unlocked and "UPGRADE" or "UNLOCK"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}),

			cost = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxassetid://11702779517",
					Enum.FontWeight.Light,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.761),
				Size = UDim2.fromScale(0.825, 0.383),
				Text = if props.data.unlocked
					then if not props.info.costs[props.data.level + 1]
						then "MAX LEVEL"
						else `-{props and props.info.costs[props.data.level + 1]} ESSENCE`
					else `-1 Skill Point`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIGradient2 = e("UIGradient", {
					Color = if props.data.unlocked
						then ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(163, 111, 111)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 0, 0)),
						})
						else ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(107, 255, 28)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 125)),
						}),
					Rotation = 90,
				}),
			}),
		}),

		level1 = e("TextLabel", {
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
			Position = UDim2.fromScale(0.5, 0.635),
			Size = UDim2.fromScale(0.845, 0.06),
			Text = `LEVEL {props and props.data.level}`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		}),
	})
end

local function treeSwitcherButton(props)
	return e("TextButton", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.7,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
		Position = UDim2.fromScale(-0.0893, 0.5),
		Size = UDim2.fromScale(0.179, 0.768),
		LayoutOrder = props.order,
		Text = "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,
		[React.Event.MouseButton1Click] = function()
			props.setSelectedSkill(string.lower(props.name))
		end,
	}, {
		uIStroke1 = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(9, 9, 9),
			LineJoinMode = Enum.LineJoinMode.Miter,
			Thickness = 3,
		}),

		text = e("TextLabel", {
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
			LineHeight = 0.63,
			Position = UDim2.fromScale(0.602, 0.488),
			Size = UDim2.fromScale(1.77, 1.9),
			Text = props.bgText,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextTransparency = 0.97,
			TextWrapped = true,
			ZIndex = 1,
		}),

		header = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.SemiBold,
				Enum.FontStyle.Normal
			),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.749, 0.491),
			Text = props.name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
		}),
	})
end

local rampageEssence = 0
local skillPoints = 0

return function(props)
	local skills, setSkills = React.useState({})
	local selectedSkill, setSelectedSkill = React.useState("pistol")
	local shownSkill, setShownSkill = React.useState(nil)
	local visible, setVisible = React.useState(false)

	local function updateSkillTree(skillTree)
		skillTree = skillTree or props.skillTree
		local newSkills = {
			uIListLayout1 = e("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}

		local skillsForSelected = skillTree[selectedSkill]

		-- Iterate over the skills for the selected skill tree
		for i, skillData in skillsForSelected do
			local skillInfo = skillConfig[selectedSkill][i]
			if skillInfo then
				table.insert(
					newSkills,
					e(createSkillButton, {
						skillName = skillInfo.name,
						unlocked = skillData.unlocked,
						level = skillData.level or 0,
						requirements = Sift.Array.slice(
							skillInfo.costs,
							(skillData.level or 0) + 1,
							#skillInfo.costs
						),
						onClick = function()
							setSelectedSkill(selectedSkill)
							setShownSkill({
								info = skillInfo,
								data = skillData,
								id = i,
								weapon = selectedSkill, -- Correct weapon context
							})
						end,
					})
				)
			end
		end

		setSkills(newSkills)
	end

	React.useEffect(function()
		if props.rampageEssence then
			rampageEssence = props.rampageEssence
		end
		if props.skillPoints then
			skillPoints = props.skillPoints
		end
	end, { props.rampageEssence, props.skillPoints })

	-- Update the skills when the skillTree prop changes
	React.useEffect(function()
		if props.skillTree then
			local selectedSkillData = props.skillTree[selectedSkill]
			if selectedSkillData and shownSkill then
				setShownSkill({
					info = skillConfig[selectedSkill][shownSkill.id],
					data = selectedSkillData[shownSkill.id],
					id = shownSkill.id,
					weapon = selectedSkill,
				})
			end
			updateSkillTree()
		end
	end, { props.skillTree, selectedSkill })

	React.useEffect(function()
		setVisible(props.visible)
	end, { props.visible })

	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.45),
		Size = UDim2.fromScale(0.742, 0.683),
		Visible = visible,
	}, {
		uIStroke = e("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(15, 15, 15),
			Thickness = 2,
		}),

		uICorner = e("UICorner", {
			CornerRadius = UDim.new(0.01, 0),
		}),

		bar = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.131),
			Size = UDim2.fromScale(0.952, 0.182),
		}, {
			uICorner1 = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),

			uIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0.02, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			pistolButton = treeSwitcherButton({
				name = "PISTOL",
				bgText = "PISTOLPISTOL ISTOLPISTOL PISTOLPISTO",
				order = 1,
				setSelectedSkill = setSelectedSkill,
			}),
			sniperButton = treeSwitcherButton({
				name = "SNIPER",
				bgText = "NIPERSNIPER SNIPERSNPER SNIPERSNIPE",
				order = 2,
				setSelectedSkill = setSelectedSkill,
			}),
			smgButton = treeSwitcherButton({
				name = "SMG",
				bgText = "SMGSMGSM SMGSMG SMGSMGSMG",
				order = 3,
				setSelectedSkill = setSelectedSkill,
			}),
			rifleButton = treeSwitcherButton({
				name = "RIFLE",
				bgText = "RIFLERIFLE FLERIFLE IFLERIFL",
				order = 4,
				setSelectedSkill = setSelectedSkill,
			}),
			shotgunButton = treeSwitcherButton({
				name = "SHOTGUN",
				bgText = "SHOGUNSHOTGU HOTGUSHOTGUN SHOTGSHOTGU",
				order = 5,
				setSelectedSkill = setSelectedSkill,
			}),
		}),

		container = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.381, 0.661),
			Size = UDim2.fromScale(0.715, 0.593),
		}, {
			uICorner2 = e("UICorner", {
				CornerRadius = UDim.new(0.017, 0),
			}),

			frame = e("ScrollingFrame", {
				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
				CanvasSize = UDim2.new(),
				Position = UDim2.fromScale(0.5, 0.5),
				ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
				ScrollBarThickness = 4,
				Size = UDim2.fromScale(0.966, 0.912),
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			}, skills),

			gradient = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(15, 15, 15),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.93),
				Size = UDim2.fromScale(1, 0.139),
			}, {
				uIGradient = e("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.777, 0.0383),
						NumberSequenceKeypoint.new(1, 0),
					}),
				}),
			}),
		}),

		closeButton = e("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Bold,
				Enum.FontStyle.Normal
			),
			Interactable = true,
			Position = UDim2.fromScale(1, 0.00405),
			Size = UDim2.fromScale(0.049, 0.0728),
			Text = "X",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			TextSize = 14,
			TextWrapped = true,
			[React.Event.MouseButton1Click] = function()
				uiSounds.CloseMenu:Play()
				sharedInfo.UISignals.closedUi:Fire()
				props.onClose()
			end,
		}, {
			uIAspectRatioConstraint5 = e("UIAspectRatioConstraint"),

			uICorner3 = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0),
			}),

			uIStroke6 = e("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(15, 15, 15),
				Thickness = 2,
			}),
		}),

		skill = if shownSkill
			then e(skillInfo, {
				info = shownSkill.info,
				data = shownSkill.data,
				id = shownSkill.id,
				selectedSkill = selectedSkill,
			}, selectedSkill)
			else nil,

		essenceDisplay = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.435, 0.307),
			Size = UDim2.fromScale(0.269, 0.0878),
		}, {
			count = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.ExtraLight,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.5),
				RichText = true,
				Size = UDim2.fromScale(0.856, 0.75),
				Text = `<b>{rampageEssence}</b> ESSENCE`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIGradient3 = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(163, 111, 111)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 0, 0)),
					}),
					Rotation = 90,
				}),
			}),
		}),

		skillPointsDisplay = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.7,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.158, 0.308),
			Size = UDim2.fromScale(0.269, 0.0883),
		}, {
			count1 = e("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.ExtraLight,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.5, 0.5),
				RichText = true,
				Size = UDim2.fromScale(0.856, 0.75),
				Text = `<b>{skillPoints}</b> POINTS`,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}, {
				uIGradient4 = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(107, 255, 28)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 125)),
					}),
					Rotation = 90,
				}),
			}),
		}),
	})
end
