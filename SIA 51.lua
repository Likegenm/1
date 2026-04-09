local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "SIA 51 script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroEnabled = true,
    IntroText = "by Likegenm"
})

local Tab1 = Window:MakeTab({
    Name = "Game",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Tab2 = Window:MakeTab({
    Name = "LocalPlayer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Tab3 = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        Window:Toggle()
    end
end)

local savedPosition = nil

local TeleportSection = Tab3:AddSection({
    Name = "Teleports"
})

Tab3:AddButton({
    Name = "Save Position",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedPosition = char.HumanoidRootPart.Position
        end
    end    
})

Tab3:AddButton({
    Name = "Teleport To Position",
    Callback = function()
        if savedPosition then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
            end
        end
    end    
})

Tab3:AddButton({
    Name = "Teleport to LXW",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-13.04, 875.00, -46.00)
        end
    end    
})

local WeaponSection = Tab3:AddSection({
    Name = "Weapon Teleports"
})

Tab3:AddButton({
    Name = "Teleport Volcan(weapon)",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-600.26, 964.85, 155.14)
        end
    end    
})

Tab3:AddButton({
    Name = "Teleport Volcan",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-536.87, 994.78, 303.97)
        end
    end    
})

Tab3:AddButton({
    Name = "Teleport to XEN Spitter",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-583.48, 1081.49, 1086.42)
        end
    end    
})

Tab3:AddButton({
    Name = "Teleport to Missle Launcher",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-352.94, 1073.00, 408.77)
        end
    end    
})

local WSSection = Tab2:AddSection({
    Name = "WalkSpeed"
})

local speedEnabled = false
local speedConnection = nil
local SPEED_MULTIPLIER = 16

local function startSpeed()
    speedEnabled = true
    speedConnection = RunService.Stepped:Connect(function()
        if not speedEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            root.AssemblyLinearVelocity = moveDir * SPEED_MULTIPLIER
        end
    end)
end

local function stopSpeed()
    speedEnabled = false
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
end

Tab2:AddToggle({
    Name = "SpeedHack(Velocity)",
    Default = false,
    Callback = function(Value)
        if Value then
            startSpeed()
        else
            stopSpeed()
        end
    end    
})

Tab2:AddSlider({
    Name = "SpeedValue",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        SPEED_MULTIPLIER = Value
    end    
})

local JPSection = Tab2:AddSection({
    Name = "JumpPower"
})

local jumpEnabled = false
local jumpConnection = nil
local JUMP_FORCE = 50

local function startJump()
    jumpEnabled = true
    jumpConnection = RunService.Stepped:Connect(function()
        if not jumpEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            root.AssemblyLinearVelocity = Vector3.new(0, JUMP_FORCE, 0)
        end
    end)
end

local function stopJump()
    jumpEnabled = false
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end

Tab2:AddToggle({
    Name = "JumpPower(Velocity)",
    Default = false,
    Callback = function(Value)
        if Value then
            startJump()
        else
            stopJump()
        end
    end    
})

Tab2:AddSlider({
    Name = "JumpForce",
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 10,
    ValueName = "Force",
    Callback = function(Value)
        JUMP_FORCE = Value
    end    
})

local FlySection = Tab2:AddSection({
    Name = "Fly"
})

local flying = false
local flightConnection = nil
local FLY_SPEED = 50

local function startFlying()
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end
    humanoid.PlatformStand = true
    flying = true
    local currentCF = rootPart.CFrame
    flightConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not flying then return end
        if not rootPart or not rootPart.Parent then
            stopFlying()
            return
        end
        local moveDirection = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection += camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection -= camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection += camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection -= camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.E) then
            moveDirection += Vector3.yAxis
        end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then
            moveDirection -= Vector3.yAxis
        end
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        local newPos = currentCF.Position + (moveDirection * FLY_SPEED * deltaTime)
        currentCF = CFrame.lookAt(newPos, newPos + camera.CFrame.LookVector)
        rootPart.CFrame = currentCF
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function stopFlying()
    flying = false
    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function toggleFly()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end

Tab2:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        if Value then
            startFlying()
        else
            stopFlying()
        end
    end    
})

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        local flyToggle = Tab2:GetToggle("Fly")
        if flyToggle then
            flyToggle:Set(not flying)
        end
        toggleFly()
    end
end)

Tab2:AddSlider({
    Name = "FlySpeed",
    Min = 20,
    Max = 150,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 5,
    ValueName = "Speed",
    Callback = function(Value)
        FLY_SPEED = Value
    end    
})

OrionLib:Init()
