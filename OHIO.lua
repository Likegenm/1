local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
	Title = "Likegenm scripts",
	Footer = "OHIO script",
	ToggleKeybind = Enum.KeyCode.RightAlt,
	Icon = 95816097006870,
	NotifySide = "Right",
	ShowCustomCursor = false,
})

local LPTab = Window:AddTab("LocalPlayer", "user")

local Tabbox = LPTab:AddLeftTabbox("Humanoid functions")
local Tab1 = Tabbox:AddTab("Speedhack")

local speedEnabled = false
local speedValue = 16

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character
local HumanoidRootPart

local function setupCharacter()
    if LocalPlayer.Character then
        Character = LocalPlayer.Character
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    end
end

setupCharacter()

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

Tab1:AddToggle("Speed Enabled", {
    Text = "Enable Speed Hack",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
    end
})

Tab1:AddSlider("Speed Value", {
    Text = "Speed:",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        speedValue = Value
    end
})

RunService.Heartbeat:Connect(function()
    if not speedEnabled then return end
    if not Character or not HumanoidRootPart then return end
    
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
end)

local Tab2 = Tabbox:AddTab("Jumphack")

local jumpPowerValue = 50
local infiniteJumpEnabled = false

Tab2:AddSlider("Jump Power", {
    Text = "Jump Height:",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        jumpPowerValue = Value
        
        if Character then
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end
})

Tab2:AddToggle("Infinite Jump", {
    Text = "Enable Infinite Jump",
    Default = false,
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        if Character then
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local Tab3 = Tabbox:AddTab("Fly")

local flyEnabled = false
local flySpeed = 50

Tab3:AddToggle("Fly Enabled", {
    Text = "Enable Fly",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
    end
})

Tab3:AddSlider("Fly Speed", {
    Text = "Fly Speed:",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        flySpeed = Value
    end
})

local flying = false
local flyVelocity = Vector3.new(0, 0, 0)
local flyBV = nil
local flyBG = nil

RunService.Heartbeat:Connect(function()
    if not flyEnabled then
        if flying then
            if flyBV then
                flyBV:Destroy()
                flyBV = nil
            end
            if flyBG then
                flyBG:Destroy()
                flyBG = nil
            end
            flying = false
        end
        return
    end
    
    if not Character or not HumanoidRootPart then return end
    
    if not flying then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "FlyBodyVelocity"
        flyBV.P = 10000
        flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = HumanoidRootPart
        
        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "FlyBodyGyro"
        flyBG.P = 10000
        flyBG.MaxTorque = Vector3.new(10000, 10000, 10000)
        flyBG.CFrame = HumanoidRootPart.CFrame
        flyBG.Parent = HumanoidRootPart
        
        flying = true
    end
    
    flyVelocity = Vector3.new(0, 0, 0)
    
    local cameraCFrame = Camera.CFrame
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        flyVelocity = flyVelocity + (cameraCFrame.LookVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        flyVelocity = flyVelocity - (cameraCFrame.LookVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        flyVelocity = flyVelocity - (cameraCFrame.RightVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        flyVelocity = flyVelocity + (cameraCFrame.RightVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        flyVelocity = flyVelocity + Vector3.new(0, flySpeed, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        flyVelocity = flyVelocity - Vector3.new(0, flySpeed, 0)
    end
    
    if flyVelocity.Magnitude > 0 then
        flyVelocity = flyVelocity.Unit * flySpeed
    else
        flyVelocity = Vector3.new(0, 0, 0)
    end
    
    if flyBV then
        flyBV.Velocity = flyVelocity
    end
    
    if flyBG then
        flyBG.CFrame = cameraCFrame
    end
end)

Library:Notify("OHIO Script", "Loaded successfully!", 5)

Library:SelectTab(LPTab)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

ThemeManager:SetFolder("LikegenmThemes")
SaveManager:SetFolder("LikegenmSaves")

ThemeManager:ApplyToTab(LPTab)

SaveManager:LoadAutoloadConfig()
