local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// SETTINGS
local noclipEnabled = false
local infiniteJumpEnabled = false
local noclipConnection

--// GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MovementUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.fromOffset(260, 205)
frame.Position = UDim2.new(0.5, -130, 0.5, -102)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 70, 90)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = frame

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 32)
title.Position = UDim2.fromOffset(15, 12)
title.BackgroundTransparency = 1
title.Text = "Movement"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 20)
subtitle.Position = UDim2.fromOffset(15, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Movement controls"
subtitle.TextColor3 = Color3.fromRGB(155, 160, 175)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = frame

--// Function to create buttons
local function createButton(name, text, yPosition)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -30, 0, 48)
	button.Position = UDim2.fromOffset(15, yPosition)
	button.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(230, 230, 235)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 15
	button.AutoButtonColor = false
	button.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 11)
	corner.Parent = button

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = Color3.fromRGB(70, 75, 95)
	buttonStroke.Thickness = 1
	buttonStroke.Transparency = 0.4
	buttonStroke.Parent = button

	return button
end

--// Noclip button
local noclipButton = createButton(
	"NoclipButton",
	"🧱  Noclip: OFF",
	70
)

--// Infinite Jump button
local jumpButton = createButton(
	"InfiniteJumpButton",
	"🪽  Infinite Jump: OFF",
	128
)

--// Character functions
local function getCharacter()
	return player.Character
end

local function setCollision(character, state)
	if not character then
		return
	end

	for _, object in ipairs(character:GetDescendants()) do
		if object:IsA("BasePart") then
			object.CanCollide = state
		end
	end
end

--// Update Noclip
local function updateNoclip()
	if noclipEnabled then
		noclipButton.Text = "🧱  Noclip: ON"
		noclipButton.BackgroundColor3 = Color3.fromRGB(35, 170, 95)

		local character = getCharacter()
		if character then
			setCollision(character, false)
		end
	else
		noclipButton.Text = "🧱  Noclip: OFF"
		noclipButton.BackgroundColor3 = Color3.fromRGB(35, 38, 50)

		local character = getCharacter()
		if character then
			setCollision(character, true)
		end
	end
end

--// Toggle Noclip
local function toggleNoclip()
	noclipEnabled = not noclipEnabled

	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end

	if noclipEnabled then
		noclipConnection = RunService.Heartbeat:Connect(function()
			local character = getCharacter()

			if character then
				setCollision(character, false)
			end
		end)
	end

	updateNoclip()
end

--// Update Infinite Jump
local function updateInfiniteJump()
	if infiniteJumpEnabled then
		jumpButton.Text = "🪽  Infinite Jump: ON"
		jumpButton.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
	else
		jumpButton.Text = "🪽  Infinite Jump: OFF"
		jumpButton.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
	end
end

--// Toggle Infinite Jump
local function toggleInfiniteJump()
	infiniteJumpEnabled = not infiniteJumpEnabled
	updateInfiniteJump()
end

--// Button connections
noclipButton.MouseButton1Click:Connect(function()
	toggleNoclip()
end)

jumpButton.MouseButton1Click:Connect(function()
	toggleInfiniteJump()
end)

--// Infinite Jump
UserInputService.JumpRequest:Connect(function()
	if not infiniteJumpEnabled then
		return
	end

	local character = getCharacter()
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health > 0 then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

--// Character respawn
player.CharacterAdded:Connect(function(character)
	task.wait(0.2)

	if noclipEnabled then
		setCollision(character, false)
	end
end)

--// Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	-- N = Noclip
	if input.KeyCode == Enum.KeyCode.N then
		toggleNoclip()
	end

	-- J = Infinite Jump
	if input.KeyCode == Enum.KeyCode.J then
		toggleInfiniteJump()
	end
end)

--// Start OFF
updateNoclip()
updateInfiniteJump()
