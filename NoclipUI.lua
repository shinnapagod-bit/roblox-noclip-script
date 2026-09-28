local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.08
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Noclip"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -20, 0, 18)
subtitle.Position = UDim2.new(0, 10, 0, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Toggle collision"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = frame

local onButton = Instance.new("TextButton")
onButton.Name = "OnButton"
onButton.Size = UDim2.new(0.4, -12, 0, 40)
onButton.Position = UDim2.new(0, 10, 1, -50)
onButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
onButton.Text = "ON"
onButton.TextColor3 = Color3.fromRGB(255, 255, 255)
onButton.Font = Enum.Font.GothamBold
onButton.TextSize = 18
onButton.Parent = frame

local offButton = Instance.new("TextButton")
offButton.Name = "OffButton"
offButton.Size = UDim2.new(0.4, -12, 0, 40)
offButton.Position = UDim2.new(0.5, 6, 1, -50)
offButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
offButton.Text = "OFF"
offButton.TextColor3 = Color3.fromRGB(255, 255, 255)
offButton.Font = Enum.Font.GothamBold
offButton.TextSize = 18
offButton.Parent = frame

local onCorner = Instance.new("UICorner")
onCorner.CornerRadius = UDim.new(0, 10)
onCorner.Parent = onButton

local offCorner = Instance.new("UICorner")
offCorner.CornerRadius = UDim.new(0, 10)
offCorner.Parent = offButton

local enabled = false
local connection

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function setCollisionForCharacter(character, shouldCollide)
    if not character then
        return
    end

    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = shouldCollide
        end
    end
end

local function updateButtons()
    if enabled then
        onButton.BackgroundColor3 = Color3.fromRGB(30, 180, 90)
        offButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    else
        onButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        offButton.BackgroundColor3 = Color3.fromRGB(180, 35, 52)
    end
end

local function toggleNoclip(state)
    enabled = state

    if enabled then
        local char = getCharacter()
        if char then
            setCollisionForCharacter(char, false)
        end

        if connection then
            connection:Disconnect()
        end

        connection = game:GetService("RunService").Heartbeat:Connect(function()
            local char = getCharacter()
            if char then
                setCollisionForCharacter(char, false)
            end
        end)
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end

        local char = getCharacter()
        if char then
            setCollisionForCharacter(char, true)
        end
    end

    updateButtons()
end

player.CharacterAdded:Connect(function(character)
    if enabled then
        setCollisionForCharacter(character, false)
    else
        setCollisionForCharacter(character, true)
    end
end)

onButton.MouseButton1Click:Connect(function()
    toggleNoclip(true)
end)

offButton.MouseButton1Click:Connect(function()
    toggleNoclip(false)
end)

updateButtons()

if UserInputService.TouchEnabled then
    screenGui.Enabled = true
end

-- Optional: press Shift+N to toggle from keyboard (useful for testing)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.N then
        toggleNoclip(not enabled)
    end
end)

-- Prevent the GUI from being moved accidentally when anchored in the center
frame.Active = true
frame.Draggable = false

-- Default is OFF

toggleNoclip(false)
