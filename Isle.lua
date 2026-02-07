local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Isle Script",
    Footer = "by Likegenm",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
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
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local speedEnabled = false
local speedValue = 50
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local flyBodyGyro
local noclipEnabled = false
local spinEnabled = false
local spinSpeed = 30
local fullbrightEnabled = false

local MainTab = Window:AddTab("Main", "zap")

local MovementBox = MainTab:AddLeftGroupbox("Movement")

local SpeedToggle = MovementBox:AddToggle("SpeedToggle", {
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

local FlyToggle = MovementBox:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
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

MovementBox:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        flySpeed = value
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
    Text = "Save Pos",
    Func = function()
        _G.pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        Library:Notify("Position saved!", 3)
    end
})

TeleportBox:AddButton({
    Text = "Teleport to SavePos",
    Func = function()
        if _G.pos and Character and HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(_G.pos)
            Library:Notify("Teleported to saved position!", 3)
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
    
    if spinEnabled and Character and HumanoidRootPart then
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

local TeleportTab = Window:AddTab("Teleport", "map-pin")

local ImportantBox = TeleportTab:AddLeftGroupbox("Important Locations")

local importantTeleports = {
    {"Lair", Vector3.new(-1677.50, -16.46, -517.84)},
    {"LightHouse", Vector3.new(-1545.85, 226.78, -198.82)},
    {"Facility", Vector3.new(-1617.14, -41.38, -1534.31)},
    {"Facility v2", Vector3.new(-1786.97, -193.03, -1368.30)},
    {"Ship", Vector3.new(-340.64, 12.05, 894.64)},
    {"Ship v2", Vector3.new(-344.97, 28.78, 844.50)},
    {"Observatory", Vector3.new(467.98, 150.34, -1216.91)},
    {"Dome", Vector3.new(-812.90, 303.50, -1373.33)},
    {"Hangar", Vector3.new(-1618.50, 22.02, -2373.56)}
}

for _, btn in pairs(importantTeleports) do
    ImportantBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local ArtifactsBox = TeleportTab:AddRightGroupbox("Artifacts")

local artifactTeleports = {
    {"Artifact A", Vector3.new(-1347.18, -456.25, -1568.46)},
    {"Artifact B", Vector3.new(1405.43, -249.38, -1851.34)},
    {"Artifact C", Vector3.new(-753.34, 126.10, -3172.48)},
    {"Artifact D", Vector3.new(-1767.44, -190.47, -1296.23)}
}

for _, btn in pairs(artifactTeleports) do
    ArtifactsBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local BuildingsBox = TeleportTab:AddLeftGroupbox("Buildings")

local buildingTeleports = {
    {"Military Camp", Vector3.new(-1069.08, 265.76, -1820.14)},
    {"Docks", Vector3.new(-2003.32, 6.12, -1554.91)},
    {"Generators", Vector3.new(548.08, -3.36, -543.73)},
    {"Radio Station", Vector3.new(-1061.86, 499.19, -1391.46)},
    {"GreenHouse", Vector3.new(-1365.93, 305.96, -1217.68)},
    {"Hunting House", Vector3.new(-664.69, 139.33, -296.46)},
    {"WareHouse", Vector3.new(-826.02, 62.19, -562.24)}
}

for _, btn in pairs(buildingTeleports) do
    BuildingsBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local ItemsBox = TeleportTab:AddRightGroupbox("Items & Misc")

local itemTeleports = {
    {"Drone", Vector3.new(-95.67, 233.37, -2790.43)},
    {"Ballistic Vest", Vector3.new(-714.69, -5.38, 869.87)},
    {"Gatling Room", Vector3.new(-1375.45, 179.03, -1501.44)}
}

for _, btn in pairs(itemTeleports) do
    ItemsBox:AddButton({
        Text = btn[1],
        Func = function()
            if Character and HumanoidRootPart then
                HumanoidRootPart.CFrame = CFrame.new(btn[2])
                Library:Notify("Teleported to " .. btn[1], 3)
            end
        end
    })
end

local VisualTab = Window:AddTab("Visual", "eye")

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
                    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    Lighting.Brightness = 2
                    task.wait(0.1)
                end
            end)
        else
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(0.5, 0.5, 0.5)
            Lighting.Brightness = 1
        end
    end
})

local FPSBox = VisualTab:AddRightGroupbox("FPS Boost")

FPSBox:AddButton({
    Text = "Remove Textures",
    Func = function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if part:FindFirstChildWhichIsA("Decal") then
                    for _, decal in pairs(part:GetChildren()) do
                        if decal:IsA("Decal") then
                            decal:Destroy()
                        end
                    end
                end
                if part:FindFirstChildOfClass("Texture") then
                    part.Texture = ""
                end
                part.Material = Enum.Material.Plastic
                part.Color = Color3.fromRGB(150, 150, 150)
            end
        end
        Library:Notify("Textures removed!", 3)
    end
})

FPSBox:AddButton({
    Text = "Low Graphics",
    Func = function()
        settings().Rendering.QualityLevel = 1
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Technology = Enum.Technology.Legacy
        Library:Notify("Low graphics enabled!", 3)
    end
})

local EffectsBox = VisualTab:AddLeftGroupbox("Remove Effects")

EffectsBox:AddButton({
    Text = "Remove Blur/Water",
    Func = function()
        task.spawn(function()
            while task.wait(0.1) do
                if Camera then
                    Camera.Blur.Enabled = false
                    Camera.DepthOfField.Enabled = false
                end
                
                if workspace.Terrain then
                    workspace.Terrain.WaterWaveSize = 0
                    workspace.Terrain.WaterWaveSpeed = 0
                    workspace.Terrain.WaterReflectance = 0
                    workspace.Terrain.WaterTransparency = 1
                end
            end
        end)
        Library:Notify("Blur/Water effects removed!", 3)
    end
})

EffectsBox:AddButton({
    Text = "ESP Players",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yahahahau/Ultimate-Esp-v1/refs/heads/main/Ultimate%20esp%20v1.lua"))()
        Library:Notify("ESP loaded!", 3)
    end
})

local MiscTab = Window:AddTab("Misc", "code")

local ScriptsBox = MiscTab:AddLeftGroupbox("Scripts")

ScriptsBox:AddButton({
    Text = "Dex Explorer",
    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/RobloxianRoblox3200/Scripts_Roblox/refs/heads/main/Dex_Explorer_V4.lua'))()
        Library:Notify("Dex Explorer loaded!", 3)
    end
})

Library:Notify("Isle script (by Likegenm) Press RightCTRL to open UI", 5)
