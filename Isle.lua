local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

BlurModule = function() end

local Window = Luna:CreateWindow({
    Name = "Isle Script", 
    Subtitle = nil,
    LogoID = "82795327169782",
    LoadingEnabled = false,
    LoadingTitle = "Likegenm Script",
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

local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})

MainTab:CreateSection("Speed"):CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(state)
        speedEnabled = state
    end
})

MainTab:CreateSection("Speed"):CreateSlider({
    Name = "Speed Value",
    Range = {0, 200},
    Increment = 0.1,
    CurrentValue = 50,
    Flag = "SpeedSlider",
    Callback = function(value)
        speedValue = value
    end
})

MainTab:CreateSection("Movement"):CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(state)
        infJumpEnabled = state
    end
})

MainTab:CreateSection("Movement"):CreateToggle({
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

MainTab:CreateSection("Movement"):CreateSlider({
    Name = "Fly Speed",
    Range = {0, 200},
    Increment = 0.1,
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(value)
        flySpeed = value
    end
})

MainTab:CreateSection("Movement"):CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(state)
        noclipEnabled = state
    end
})

MainTab:CreateSection("Movement"):CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Flag = "SpinToggle",
    Callback = function(state)
        spinEnabled = state
    end
})

MainTab:CreateSection("Movement"):CreateSlider({
    Name = "Spin Speed",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 30,
    Flag = "SpinSpeedSlider",
    Callback = function(value)
        spinSpeed = value
    end
})

MainTab:CreateSection("Teleport"):CreateButton({
    Name = "Mouse Teleport (T)",
    Callback = function()
        if Character and HumanoidRootPart then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Hit.Position
            HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
        end
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T and Character and HumanoidRootPart then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Hit.Position
        HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
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

local VisualTab = Window:CreateTab({
    Name = "Visual",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

VisualTab:CreateSection("Lighting")

VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "FullbrightToggle",
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

VisualTab:CreateSection("Remove Effects")

VisualTab:CreateButton({
    Name = "Remove Blur/Water",
    Callback = function()
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
    end
})

VisualTab:CreateButton({
    Name = "ESP Players",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yahahahau/Ultimate-Esp-v1/refs/heads/main/Ultimate%20esp%20v1.lua"))()
    end
})

local TeleportTab = Window:CreateTab({
    Name = "Teleport",
    Icon = "location_on",
    ImageSource = "Material",
    ShowTitle = true
})

TeleportTab:CreateButton({
    Name = "Save Pos",
    Callback = function()
        _G.pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to SavePos",
    Callback = function()
        if _G.pos then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.pos)
        end
    end
})

TeleportTab:CreateSection("Locations")

local function teleportTo(position)
    if Character and HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

TeleportTab:CreateButton({
    Name = "Lair: -1677.50, -16.46, -517.84",
    Callback = function()
        teleportTo(Vector3.new(-1677.50, -16.46, -517.84))
    end
})

TeleportTab:CreateButton({
    Name = "LightHouse: -1545.85, 226.78, -198.82",
    Callback = function()
        teleportTo(Vector3.new(-1545.85, 226.78, -198.82))
    end
})

TeleportTab:CreateButton({
    Name = "Facility: -1617.14, -41.38, -1534.31",
    Callback = function()
        teleportTo(Vector3.new(-1617.14, -41.38, -1534.31))
    end
})

TeleportTab:CreateButton({
    Name = "Facility v2: -1786.97, -193.03, -1368.30",
    Callback = function()
        teleportTo(Vector3.new(-1786.97, -193.03, -1368.30))
    end
})

TeleportTab:CreateButton({
    Name = "Ship: -340.64, 12.05, 894.64",
    Callback = function()
        teleportTo(Vector3.new(-340.64, 12.05, 894.64))
    end
})

TeleportTab:CreateButton({
    Name = "Ship v2: -344.97, 28.78, 844.50",
    Callback = function()
        teleportTo(Vector3.new(-344.97, 28.78, 844.50))
    end
})

TeleportTab:CreateButton({
    Name = "Generators: 548.08, -3.36, -543.73",
    Callback = function()
        teleportTo(Vector3.new(548.08, -3.36, -543.73))
    end
})

TeleportTab:CreateButton({
    Name = "Observatory: 467.98, 150.34, -1216.91",
    Callback = function()
        teleportTo(Vector3.new(467.98, 150.34, -1216.91))
    end
})

TeleportTab:CreateButton({
    Name = "Dome: -812.90, 303.50, -1373.33",
    Callback = function()
        teleportTo(Vector3.new(-812.90, 303.50, -1373.33))
    end
})

TeleportTab:CreateButton({
    Name = "Hangar: -1618.50, 22.02, -2373.56",
    Callback = function()
        teleportTo(Vector3.new(-1618.50, 22.02, -2373.56))
    end
})

TeleportTab:CreateButton({
    Name = "Military Camp: -1069.08, 265.76, -1820.14",
    Callback = function()
        teleportTo(Vector3.new(-1069.08, 265.76, -1820.14))
    end
})

TeleportTab:CreateButton({
    Name = "Docks: -2003.32, 6.12, -1554.91",
    Callback = function()
        teleportTo(Vector3.new(-2003.32, 6.12, -1554.91))
    end
})

TeleportTab:CreateButton({
    Name = "Drone: -95.67, 233.37, -2790.43",
    Callback = function()
        teleportTo(Vector3.new(-95.67, 233.37, -2790.43))
    end
})

TeleportTab:CreateButton({
    Name = "Ballistic Vest: -714.69, -5.38, 869.87",
    Callback = function()
        teleportTo(Vector3.new(-714.69, -5.38, 869.87))
    end
})

TeleportTab:CreateButton({
    Name = "Artifact A: -1347.18, -456.25, -1568.46",
    Callback = function()
        teleportTo(Vector3.new(-1347.18, -456.25, -1568.46))
    end
})

TeleportTab:CreateButton({
    Name = "Artifact B: 1405.43, -249.38, -1851.34",
    Callback = function()
        teleportTo(Vector3.new(1405.43, -249.38, -1851.34))
    end
})

local MicsTab = Window:CreateTab({
    Name = "Mics",
    Icon = "code",
    ImageSource = "Material",
    ShowTitle = true
})

MicsTab:CreateButton({
    Name = "Dex",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/RobloxianRoblox3200/Scripts_Roblox/refs/heads/main/Dex_Explorer_V4.lua'))()
    end
})
