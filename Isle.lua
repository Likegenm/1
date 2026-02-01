local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

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
    KeySystem = false,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter...",
        Note = "Key: 123",
        SaveInRoot = false,
        SaveKey = true,
        Key = {"123"},
        SecondAction = {
            Enabled = true, 
            Type = "Link", 
            Parameter = ""
        }
    }
})

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
