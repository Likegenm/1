local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "ETFB",
    Footer = "by Likegenm",
    Position = UDim2.fromOffset(6, 6),
    ToggleKeybind = Enum.KeyCode.RightControl,
    NotifySide = "Right",
    ShowCustomCursor = false,
    Font = Enum.Font.Code,
    CornerRadius = 4,
    Resizable = true,
    MobileButtonsSide = "Right",
    Center = true,
    AutoShow = true
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local BVTab = Window:AddTab("Main", "zap")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local bodyVelocityEnabled = false
local bodyVelocityInstance = nil
local velocityX = 0
local velocityY = 0
local velocityZ = 0
local maxForce = 100000

local noclipEnabled = false
local noclipConnection = nil

local flyEnabled = false
local flyConnection = nil
local flySpeed = 50
local keys = {W=false, S=false, A=false, D=false}
local spaceDown = false
local shiftDown = false
local flyBodyVelocity = nil

local function toggleBodyVelocity()
    if bodyVelocityEnabled then
        if Character and HumanoidRootPart then
            bodyVelocityInstance = Instance.new("BodyVelocity")
            bodyVelocityInstance.Parent = HumanoidRootPart
            bodyVelocityInstance.Velocity = Vector3.new(velocityX, velocityY, velocityZ)
            bodyVelocityInstance.MaxForce = Vector3.new(maxForce, maxForce, maxForce)
        end
    else
        if bodyVelocityInstance then
            bodyVelocityInstance:Destroy()
            bodyVelocityInstance = nil
        end
    end
end

local function startNoclip()
    if noclipEnabled then
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        noclipConnection = RunService.Stepped:Connect(function()
            if noclipEnabled and Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function startFly()
    if flyEnabled then
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        if Character and HumanoidRootPart then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Parent = HumanoidRootPart
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            
            Humanoid.PlatformStand = true
        end
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not Character or not HumanoidRootPart then return end
            
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = Camera.CFrame
            
            if keys.W then moveDir = moveDir + camCF.LookVector end
            if keys.S then moveDir = moveDir - camCF.LookVector end
            if keys.A then moveDir = moveDir - camCF.RightVector end
            if keys.D then moveDir = moveDir + camCF.RightVector end
            
            moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * flySpeed
            end
            
            local verticalSpeed = 0
            if spaceDown then verticalSpeed = flySpeed end
            if shiftDown then verticalSpeed = -flySpeed end
            
            flyBodyVelocity.Velocity = Vector3.new(moveDir.X, verticalSpeed, moveDir.Z)
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if Character and Humanoid then
            Humanoid.PlatformStand = false
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then spaceDown = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then shiftDown = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then spaceDown = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then shiftDown = false end
end)

local BVBox = BVTab:AddLeftGroupbox("VectorForce Control")

BVBox:AddToggle("BVToggle", {
    Text = "Enable VectorForce",
    Default = false,
    Callback = function(state)
        bodyVelocityEnabled = state
        toggleBodyVelocity()
        Library:Notify("VectroForce: " .. (state and "ON" or "OFF"), 2)
    end
})

BVBox:AddSlider("VelocityX", {
    Text = "X",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        velocityX = value
        if bodyVelocityInstance then
            bodyVelocityInstance.Velocity = Vector3.new(velocityX, velocityY, velocityZ)
        end
    end
})

BVBox:AddSlider("VelocityY", {
    Text = "Y",
    Default = 0,
    Min = -100,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        velocityY = value
        if bodyVelocityInstance then
            bodyVelocityInstance.Velocity = Vector3.new(velocityX, velocityY, velocityZ)
        end
    end
})

BVBox:AddInput("MaxForce", {
    Text = "Force",
    Default = "100000",
    Numeric = true,
    Placeholder = "Enter max force (0-100000)",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            maxForce = math.clamp(num, 0, 100000)
            if bodyVelocityInstance then
                bodyVelocityInstance.MaxForce = Vector3.new(maxForce, maxForce, maxForce)
            end
        end
    end
})

local NoclipBox = BVTab:AddRightGroupbox("Noclip")

NoclipBox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        startNoclip()
        Library:Notify("Noclip: " .. (state and "ON" or "OFF"), 2)
    end
})

local FlyBox = BVTab:AddLeftGroupbox("Fly")

FlyBox:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        startFly()
        Library:Notify("Fly: " .. (state and "ON" or "OFF"), 2)
    end
})

FlyBox:AddInput("FlySpeedInput", {
    Text = "Fly Speed",
    Default = "50",
    Numeric = true,
    Placeholder = "Enter speed (10-100)",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            flySpeed = math.clamp(num, 10, 100)
        end
    end
})

Library:Notify("ETFB (by Likegenm);(RightCtrl)", 5)
