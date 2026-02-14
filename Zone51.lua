local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Likegenm",
    Footer = "Zone 51",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab("Main", "zap")
local BITab = Window:AddTab("BringItems", "box")
local CombatTab = Window:AddTab("Combat", "sword")
local VisualTab = Window:AddTab("Visual", "eye")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local speedEnabled = false
local speedValue = 50
local infJumpEnabled = false
local noclipEnabled = false
local spinEnabled = false
local spinSpeed = 30
local fullbrightEnabled = false
local fovValue = 70
local ambientEnabled = false
local savedPosition = nil

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local MovementBox = MainTab:AddLeftGroupbox("Movement")

MovementBox:AddToggle("SpeedToggle", {
    Text = "Speed Hack",
    Default = false,
    Callback = function(state)
        speedEnabled = state
    end
})

MovementBox:AddSlider("SpeedSlider", {
    Text = "Speed Value",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        speedValue = value
    end
})

MovementBox:AddToggle("InfJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
    end
})

MovementBox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
    end
})

MovementBox:AddToggle("SpinToggle", {
    Text = "Spin",
    Default = false,
    Callback = function(state)
        spinEnabled = state
    end
})

MovementBox:AddSlider("SpinSpeedSlider", {
    Text = "Spin Speed",
    Default = 30,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        spinSpeed = value
    end
})

local TeleportBox = MainTab:AddRightGroupbox("Teleport")

TeleportBox:AddButton({
    Text = "Mouse Teleport (T)",
    Func = function()
        if Character and HumanoidRootPart then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Hit.Position
            HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
            Library:Notify("Mouse teleport!", 2)
        end
    end
})

TeleportBox:AddButton({
    Text = "Save Position",
    Func = function()
        if Character and HumanoidRootPart then
            savedPosition = HumanoidRootPart.Position
            Library:Notify("Position saved!", 3)
        end
    end
})

TeleportBox:AddButton({
    Text = "Load Position",
    Func = function()
        if savedPosition and Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(savedPosition)
            Library:Notify("Position loaded!", 3)
        end
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T and Character and HumanoidRootPart then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Hit.Position
        HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
        Library:Notify("Mouse teleport!", 2)
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

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
    
    if spinEnabled and Character and HumanoidRootPart then
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

local CameraBox = VisualTab:AddLeftGroupbox("Camera")

CameraBox:AddButton({
    Text = "Inf Zoom",
    Func = function()
        LocalPlayer.CameraMaxZoomDistance = 10000000000
        LocalPlayer.CameraMinZoomDistance = 0
        Library:Notify("Inf Zoom enabled!", 3)
    end
})

CameraBox:AddSlider("FOVSlider", {
    Text = "FOV Changer",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 1,
    Callback = function(value)
        fovValue = value
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
        end
    end
})

local LightingBox = VisualTab:AddLeftGroupbox("Lighting")

LightingBox:AddToggle("FullbrightToggle", {
    Text = "Fullbright",
    Default = false,
    Callback = function(state)
        fullbrightEnabled = state
        if state then
            task.spawn(function()
                while fullbrightEnabled do
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 100000
                    Lighting.Brightness = 2
                    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
                    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                    task.wait(0.1)
                end
            end)
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 50000
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(0.5, 0.5, 0.5)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        end
    end
})

local AmbientBox = VisualTab:AddLeftGroupbox("Ambient")

local ambientEnabled = false

AmbientBox:AddToggle("AmbientToggle", {
    Text = "Custom Ambient",
    Default = false,
    Callback = function(state)
        ambientEnabled = state
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 200, 200)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 200, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 200, 200)
            Lighting.Brightness = 2.5
        else
            Lighting.Ambient = Color3.fromRGB(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 1
        end
    end
})

AmbientBox:AddSlider("RedSlider", {
    Text = "Red",
    Default = 255,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Callback = function(value)
        if ambientEnabled then
            local current = Lighting.Ambient
            Lighting.Ambient = Color3.fromRGB(value, current.G * 255, current.B * 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(value, current.G * 255, current.B * 255)
            Lighting.ColorShift_Top = Color3.fromRGB(value, current.G * 255, current.B * 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(value, current.G * 255, current.B * 255)
        end
    end
})

AmbientBox:AddSlider("GreenSlider", {
    Text = "Green",
    Default = 200,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Callback = function(value)
        if ambientEnabled then
            local current = Lighting.Ambient
            Lighting.Ambient = Color3.fromRGB(current.R * 255, value, current.B * 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(current.R * 255, value, current.B * 255)
            Lighting.ColorShift_Top = Color3.fromRGB(current.R * 255, value, current.B * 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(current.R * 255, value, current.B * 255)
        end
    end
})

AmbientBox:AddSlider("BlueSlider", {
    Text = "Blue",
    Default = 200,
    Min = 0,
    Max = 255,
    Rounding = 0,
    Callback = function(value)
        if ambientEnabled then
            local current = Lighting.Ambient
            Lighting.Ambient = Color3.fromRGB(current.R * 255, current.G * 255, value)
            Lighting.OutdoorAmbient = Color3.fromRGB(current.R * 255, current.G * 255, value)
            Lighting.ColorShift_Top = Color3.fromRGB(current.R * 255, current.G * 255, value)
            Lighting.ColorShift_Bottom = Color3.fromRGB(current.R * 255, current.G * 255, value)
        end
    end
})

RunService.Heartbeat:Connect(function()
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = fovValue
    end
end)

Library:Notify("Script loaded! Press RightCTRL to toggle UI", 5)
