local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

BlurModule = function() end

local Window = Luna:CreateWindow({
    Name = "Isle script", 
    Subtitle = nil,
    LogoID = "82795327169782",
    LoadingEnabled = false,
    LoadingTitle = "Likegenm script",
    LoadingSubtitle = "by Likegenm",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "Isle Hub"
    },
    KeySystem = false
})

local Lighting = game:GetService("Lighting")
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("DepthOfFieldEffect") or effect:IsA("BlurEffect") then
        effect:Destroy()
    end
end

for _, script in pairs(game:GetDescendants()) do
    if script:IsA("LocalScript") or script:IsA("Script") then
        if script.Name == "BlurModule" or (script.Source and script.Source:find("DepthOfField")) then
            script:Destroy()
        end
    end
end

for _, folder in pairs(workspace.CurrentCamera:GetDescendants()) do
    if folder:IsA("Folder") and (folder.Name == "LunaBlur" or folder.Name:find("Blur")) then
        folder:Destroy()
    end
end

for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("Part") and part.Material == Enum.Material.Glass then
        part:Destroy()
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local speedEnabled = false
local speedValue = 50
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyBodyGyro

local LPT = Window:CreateTab({
    Name = "LocalPlayer",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})

LPT:CreateSection("Speedhack"):CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(state)
        speedEnabled = state
    end
})

LPT:CreateSection("Speedhack"):CreateSlider({
    Name = "Speed Value",
    Range = {0, 200},
    Increment = 0.1,
    CurrentValue = 50,
    Flag = "SpeedSlider",
    Callback = function(value)
        speedValue = value
    end
})

LPT:CreateSection("Jumphack"):CreateToggle({
    Name = "Inf Jumps",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(state)
        infJumpEnabled = state
    end
})

LPT:CreateSection("Movement"):CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(state)
        flyEnabled = state
        if flyEnabled then
            if Character and HumanoidRootPart then
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 10000
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.CFrame = HumanoidRootPart.CFrame
                flyBodyGyro.Parent = HumanoidRootPart
                Humanoid.PlatformStand = true
            end
        else
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            if Character and Humanoid then
                Humanoid.PlatformStand = false
            end
        end
    end
})

LPT:CreateSection("Fly"):CreateSlider({
    Name = "Fly Speed",
    Range = {0, 200},
    Increment = 0.1,
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(value)
        flySpeed = value
    end
})

RunService.Heartbeat:Connect(function()
    if speedEnabled and Character and HumanoidRootPart then
        local cameraCFrame = Camera.CFrame
        local lookVector = cameraCFrame.LookVector
        local rightVector = cameraCFrame.RightVector
        
        local mv = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            mv = mv + Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            mv = mv - Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            mv = mv - Vector3.new(rightVector.X, 0, rightVector.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            mv = mv + Vector3.new(rightVector.X, 0, rightVector.Z).Unit
        end
        
        if mv.Magnitude > 0 then
            HumanoidRootPart.Velocity = Vector3.new(
                mv.X * speedValue,
                HumanoidRootPart.Velocity.Y,
                mv.Z * speedValue
            )
        end
    end
    
    if infJumpEnabled and Character and HumanoidRootPart and Humanoid then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            HumanoidRootPart.Velocity = Vector3.new(
                HumanoidRootPart.Velocity.X,
                50,
                HumanoidRootPart.Velocity.Z
            )
        end
    end
    
    if flyEnabled and Character and HumanoidRootPart and flyBodyGyro then
        local flyVelocity = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            flyVelocity = flyVelocity + (Camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            flyVelocity = flyVelocity - (Camera.CFrame.LookVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            flyVelocity = flyVelocity - (Camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            flyVelocity = flyVelocity + (Camera.CFrame.RightVector * flySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            flyVelocity = flyVelocity + Vector3.new(0, flySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyVelocity = flyVelocity - Vector3.new(0, flySpeed, 0)
        end
        
        HumanoidRootPart.Velocity = flyVelocity
        flyBodyGyro.CFrame = Camera.CFrame
    end
end)

local VT = Window:CreateTab({
    Name = "Visual",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

local TT = Window:CreateTab({
    Name = "Teleport",
    Icon = "location_on",
    ImageSource = "Material",
    ShowTitle = true
})

local ST = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

local uiKeybind = "K"
local uiEnabled = true

ST:CreateSection("UI Settings"):CreateKeybind({
    Name = "Toggle UI Key",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "UIKeybind",
    Callback = function(key)
        uiKeybind = key
    end
})

ST:CreateSection("UI Settings"):CreateToggle({
    Name = "Enable UI Toggle",
    CurrentValue = true,
    Flag = "UIToggle",
    Callback = function(state)
        uiEnabled = state
    end
})

ST:CreateSection("UI Settings"):CreateButton({
    Name = "Hide UI",
    Callback = function()
        Window:Hide()
    end
})

ST:CreateSection("UI Settings"):CreateButton({
    Name = "Show UI",
    Callback = function()
        Window:Show()
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode[uiKeybind] and uiEnabled then
        Window:Toggle()
    end
end)

local CT = Window:CreateTab({
    Name = "Credits",
    Icon = "info",
    ImageSource = "Material",
    ShowTitle = true
})

CT:CreateSection("Credits"):CreateLabel({
    Name = "Script by Likegenm"
})

CT:CreateSection("Credits"):CreateLabel({
    Name = "UI: Luna Library"
})
