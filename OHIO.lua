local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("OHIO script (by Likegenm)", "DarkTheme")

local Tab1 = Window:NewTab("LocalPlayer")

local Section1 = Tab1:NewSection("Speed")

Section:NewSlider("Speed.Velocity", "Speed created with velocity", 500, 0, function(s)
    local speed = s

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

RunService.Heartbeat:Connect(function()
    if Character and HumanoidRootPart then
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
                mv.X * speed,
                HumanoidRootPart.Velocity.Y,
                mv.Z * speed
            )
        end
    end
end)
end)
