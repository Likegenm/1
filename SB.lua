local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Slap Battle",
    Footer = "by Likegenm + Vicinly",
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Center = true,
    AutoShow = true,
    Cursor = false
})

local MainTab = Window:AddTab("Main", "home")

local SGB = MainTab:AddLeftGroupbox("Speed")
local SPGB = MainTab:AddLeftGroupbox("Spider")
local JGB = MainTab:AddLeftGroupbox("Jumps")
local AVGB = MainTab:AddLeftGroupbox("Anti Void")
local FGB = MainTab:AddLeftGroupbox("Flight")
local NCLGB = MainTab:AddLeftGroupbox("NoClip")
local SPRGB = MainTab:AddLeftGroupbox("Sprint")
local SFGB = MainTab:AddLeftGroupbox("SafeWalk")
local IGB = MainTab:AddLeftGroupbox("Invisibility")
local GGB = MainTab:AddLeftGroupbox("AntiHit/Godmode")
local HGB = MainTab:AddLeftGroupbox("Hip")
local DGB = MainTab:AddLeftGroupbox("Dodge")

local AKBGB = MainTab:AddRightGroupbox("Velocity")
local TBGB = MainTab:AddRightGroupbox("Triggerbot")
local KGB = MainTab:AddRightGroupbox("Killaura")
local AKGB = MainTab:AddRightGroupbox("AutoClicker")
local NCDGB = MainTab:AddRightGroupbox("No Click Delay")

local SpeedToggle = SGB:AddToggle("Speed Hack", {
    Text = "Enable Speed Hack",
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if Value then
                    humanoid.WalkSpeed = SpeedSlider.Value
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
})

local SpeedSlider = SGB:AddSlider("Speed Value", {
    Text = "Speed:",
    Min = 16,
    Max = 100,
    Default = 25,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if SpeedToggle.Value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

local HipToggle = HGB:AddToggle("Hip Height", {
    Text = "Enable Hip Height",
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if Value then
                    humanoid.HipHeight = HipSlider.Value
                else
                    humanoid.HipHeight = 0
                end
            end
        end
    end
})

local HipSlider = HGB:AddSlider("Hip Height Value", {
    Text = "Hip Height:",
    Default = 0,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if HipToggle.Value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.HipHeight = Value
                end
            end
        end
    end
})

local FlyEnabled = false
local NoclipEnabled = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyGyro = nil

local function StopFly()
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    BodyVelocity = nil
    BodyGyro = nil
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

local function StartFly()
    StopFly()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    humanoid.PlatformStand = true
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = rootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = rootPart.CFrame
    BodyGyro.Parent = rootPart
end

local function updateFly()
    if not FlyEnabled then return end
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)
    local uis = game:GetService("UserInputService")
    
    if uis:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + camera.CFrame.LookVector
    end
    if uis:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - camera.CFrame.LookVector
    end
    if uis:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - camera.CFrame.RightVector
    end
    if uis:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + camera.CFrame.RightVector
    end
    if uis:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        moveDirection = moveDirection + Vector3.new(0, -1, 0)
    end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
    end
    
    if BodyVelocity then
        BodyVelocity.Velocity = moveDirection * FlySpeed
    end
    
    if BodyGyro then
        BodyGyro.CFrame = camera.CFrame
    end
end

local function UpdateNoclip()
    if not NoclipEnabled then return end
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local FlyToggleBtn = FGB:AddToggle("Fly", {
    Text = "Enable Fly (Ctrl + F)",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        if Value then
            StartFly()
            FlySpeedSlider.Visible = true
            FlySpeedLabel.Visible = true
        else
            StopFly()
            FlySpeedSlider.Visible = false
            FlySpeedLabel.Visible = false
        end
    end
})

local FlySpeedSlider = FGB:AddSlider("Fly Speed", {
    Text = "Speed:",
    Min = 10,
    Max = 300,
    Default = 50,
    Rounding = 1,
    Compact = false,
    Visible = false,
    Callback = function(Value)
        FlySpeed = Value
        FlySpeedLabel:SetText("Current Speed: " .. Value)
    end
})

local FlySpeedLabel = FGB:AddLabel("Current Speed: 50", {
    Visible = false
})

local NoclipToggle = NCLGB:AddToggle("NoClip", {
    Text = "Enable NoClip",
    Default = false,
    Callback = function(Value)
        NoclipEnabled = Value
        if Value then
            UpdateNoclip()
        else
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        FlyToggleBtn:Set(not FlyEnabled)
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    updateFly()
    if NoclipEnabled then
        UpdateNoclip()
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    local humanoid = character:FindFirstChild("Humanoid")
    
    if SpeedToggle.Value and humanoid then
        humanoid.WalkSpeed = SpeedSlider.Value
    end
    
    if HipToggle.Value and humanoid then
        humanoid.HipHeight = HipSlider.Value
    end
    
    if FlyEnabled then
        task.wait(0.1)
        StartFly()
    end
    
    if NoclipEnabled then
        task.wait(0.1)
        UpdateNoclip()
    end
end)
