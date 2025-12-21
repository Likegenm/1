--[[
██╗     ██╗██╗██╗  ██╗███████╗ ██████╗ ███████╗███╗   ██╗███╗   ███╗
██║     ██║██║██║ ██╔╝██╔════╝██╔════╝ ██╔════╝████╗  ██║████╗ ████║
██║     ██║██║█████╔╝ █████╗  ██║  ███╗█████╗  ██╔██╗ ██║██╔████╔██║
██║     ██║██║██╔═██╗ ██╔══╝  ██║   ██║██╔══╝  ██║╚██╗██║██║╚██╔╝██║
███████╗██║██║██║  ██╗███████╗╚██████╔╝███████╗██║ ╚████║██║ ╚═╝ ██║
╚══════╝╚═╝╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝

Likegenm scripts (LS) Project scp 2.0

by likegenm
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LikegenmMessage"
screenGui.Parent = player:WaitForChild("PlayerGui")

local blackScreen = Instance.new("Frame")
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.Position = UDim2.new(0, 0, 0, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.BackgroundTransparency = 1
blackScreen.ZIndex = 10
blackScreen.Parent = screenGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
textLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Likegenm scripts"
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextSize = 72
textLabel.TextTransparency = 1
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextStrokeTransparency = 0.5
textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
textLabel.ZIndex = 11
textLabel.Parent = screenGui

local function showAnimation()
    local tweenInfoIn = TweenInfo.new(
        1.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local blackTweenIn = TweenService:Create(blackScreen, tweenInfoIn, {BackgroundTransparency = 0})
    blackTweenIn:Play()
    
    local textTweenIn = TweenService:Create(textLabel, tweenInfoIn, {TextTransparency = 0})
    textTweenIn:Play()
    
    blackTweenIn.Completed:Wait()
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 0, 255)
    }
    
    local colorIndex = 1
    local startTime = tick()
    
    while tick() - startTime < 4 do
        textLabel.TextColor3 = colors[colorIndex]
        colorIndex = colorIndex + 1
        if colorIndex > #colors then
            colorIndex = 1
        end
        
        local tweenInfoColor = TweenInfo.new(
            0.5,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        local colorTween = TweenService:Create(textLabel, tweenInfoColor, {TextColor3 = colors[colorIndex]})
        colorTween:Play()
        
        wait(0.5)
    end
    
    local tweenInfoOut = TweenInfo.new(
        1.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local blackTweenOut = TweenService:Create(blackScreen, tweenInfoOut, {BackgroundTransparency = 1})
    blackTweenOut:Play()
    
    local textTweenOut = TweenService:Create(textLabel, tweenInfoOut, {TextTransparency = 1})
    textTweenOut:Play()
    
    blackTweenOut.Completed:Wait()
    
    screenGui:Destroy()
end

showAnimation()






task.wait(0.1)
print("Wait")
task.wait(0.1)
    
loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/DownoloadLiblary.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Test/refs/heads/main/Irina.lua"))()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "PSCP",
    Footer = "v2.0 (by Likegenm)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true,
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Left"
})

local MainTab = Window:AddTab("Main", "home")

local LeftGroupbox = MainTab:AddLeftGroupbox("LocalPlayer")
local RightGroupbox = MainTab:AddRightGroupbox("Players")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local teleportEnabled = false
local teleportSpeed = 0.02

local SpeedToggle = LeftGroupbox:AddToggle("SpeedBoost", {
    Text = "SpeedBoost (Teleport)",
    Default = false,
    Tooltip = "Teleport in movement direction",
    Callback = function(Value)
        teleportEnabled = Value
        if Value then
            Library:Notify({
                Title = "SpeedBoost",
                Description = "Teleport movement enabled",
                Time = 3
            })
        end
    end
})

SpeedToggle:OnChanged(function(Value)
    teleportEnabled = Value
end)

local SpeedSlider = LeftGroupbox:AddSlider("SpeedValue", {
    Text = "Teleport Speed",
    Default = 0.02,
    Min = 0.01,
    Max = 1.0,
    Rounding = 3,
    Suffix = " studs",
    Callback = function(Value)
        teleportSpeed = Value
    end
})

RunService.Heartbeat:Connect(function()
    if teleportEnabled and player.Character then
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            local moveDirection = humanoid.MoveDirection
            
            if moveDirection.Magnitude > 0 then
                local direction = moveDirection.Unit
                local newPosition = rootPart.Position + (direction * teleportSpeed)
                rootPart.CFrame = CFrame.new(newPosition)
            end
        end
    end
end)

local doubleJumpEnabled = false
local maxJumps = 2
local currentJumps = 0
local jumpPower = 50

local DoubleJumpToggle = LeftGroupbox:AddToggle("DoubleJump", {
    Text = "Double Jump",
    Default = false,
    Tooltip = "Double jump in air",
    Callback = function(Value)
        doubleJumpEnabled = Value
        currentJumps = 0
        
        if Value then
            Library:Notify({
                Title = "Double Jump",
                Description = "Double jump enabled",
                Time = 3
            })
        end
    end
})

DoubleJumpToggle:OnChanged(function(Value)
    doubleJumpEnabled = Value
    currentJumps = 0
end)

local JumpPowerSlider = LeftGroupbox:AddSlider("JumpPower", {
    Text = "Jump Power",
    Default = 50,
    Min = 20,
    Max = 100,
    Rounding = 0,
    Suffix = " power",
    Callback = function(Value)
        jumpPower = Value
    end
})

RunService.Heartbeat:Connect(function()
    if doubleJumpEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            currentJumps = 0
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space and doubleJumpEnabled then
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        if currentJumps < maxJumps then
            currentJumps = currentJumps + 1
            rootPart.Velocity = Vector3.new(
                rootPart.Velocity.X,
                jumpPower,
                rootPart.Velocity.Z
            )
        end
    end
end)
