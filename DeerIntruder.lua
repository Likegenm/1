local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = "The Intruder: location: OAK Deer INN",
    SubTitle = "by Likegenm",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftAlt
}

local LPTab = Window:CreateTab{
    Title = "LocalPlayer",
    Icon = "user"
}

local GTab = Window:CreateTab{
    Title = "Gameplay",
    Icon = "sword"
}

local VTab = Window:CreateTab{
    Title = "Visual",
    Icon = "eye"
}

local TTab = Window:CreateTab{
    Title = "Teleport",
    Icon = "map"
}

local SettingsTab = Window:CreateTab{
    Title = "Settings",
    Icon = "settings"
}

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}

InterfaceManager:SetFolder("TheIntruder")
SaveManager:SetFolder("TheIntruder/configs")

InterfaceManager:BuildInterfaceSection(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)

local speed = 50
local speedhackEnabled = false
local flyEnabled = false
local flySpeed = 40
local flyConnection
local flyTween

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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

LPTab:CreateSlider("SpeedSlider", {
    Title = "Speed",
    Description = "Speed value 1-100",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        speed = Value
    end
})

LPTab:CreateToggle("SpeedhackToggle", {
    Title = "Speedhack",
    Description = "Toggle speedhack on/off",
    Default = false,
    Callback = function(Value)
        speedhackEnabled = Value
        if Value and flyEnabled then
            flyEnabled = false
            if Humanoid then
                Humanoid.PlatformStand = false
            end
        end
    end
})

local function SetupFly()
    if not Character or not HumanoidRootPart then return end
    
    local camera = workspace.CurrentCamera
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    local targetVelocity = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        targetVelocity = targetVelocity + lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        targetVelocity = targetVelocity - lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        targetVelocity = targetVelocity - rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        targetVelocity = targetVelocity + rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        targetVelocity = targetVelocity + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        targetVelocity = targetVelocity + Vector3.new(0, -1, 0)
    end
    
    if targetVelocity.Magnitude > 0 then
        targetVelocity = targetVelocity.Unit * flySpeed
    end
    
    if flyTween then
        flyTween:Cancel()
    end
    
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    flyTween = TweenService:Create(HumanoidRootPart, tweenInfo, {Velocity = targetVelocity})
    flyTween:Play()
end

LPTab:CreateToggle("FlyToggle", {
    Title = "Fly",
    Description = "Toggle fly mode",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if Character and Humanoid then
            if Value then
                Humanoid.PlatformStand = true
                if speedhackEnabled then
                    speedhackEnabled = false
                end
                if flyConnection then
                    flyConnection:Disconnect()
                end
                flyConnection = RunService.Heartbeat:Connect(SetupFly)
            else
                Humanoid.PlatformStand = false
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                if flyTween then
                    flyTween:Cancel()
                end
                if HumanoidRootPart then
                    HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

LPTab:CreateSlider("FlySpeedSlider", {
    Title = "Fly Speed",
    Description = "Fly speed value 1-100",
    Default = 40,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        flySpeed = Value
    end
})

RunService.Heartbeat:Connect(function()
    if Character and HumanoidRootPart and not flyEnabled and speedhackEnabled then
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

local menuMusicEnabled = false
local menuMusicSound = nil
local musicVolume = 0.5
local musicSpeed = 1.0

local function PlayMenuMusic()
    if menuMusicSound then
        menuMusicSound:Stop()
        menuMusicSound:Destroy()
    end
    
    menuMusicSound = Instance.new("Sound")
    menuMusicSound.SoundId = "rbxassetid://1848319100"
    menuMusicSound.Volume = musicVolume
    menuMusicSound.PlaybackSpeed = musicSpeed
    menuMusicSound.Looped = true
    menuMusicSound.Parent = workspace
    
    menuMusicSound:Play()
end

local function StopMenuMusic()
    if menuMusicSound then
        menuMusicSound:Stop()
        menuMusicSound:Destroy()
        menuMusicSound = nil
    end
end

local function UpdateMusicSettings()
    if menuMusicSound then
        menuMusicSound.Volume = musicVolume
        menuMusicSound.PlaybackSpeed = musicSpeed
    end
end

GTab:CreateToggle("MenuMusic", {
    Title = "Menu Music",
    Description = "Play menu music",
    Default = false,
    Callback = function(Value)
        menuMusicEnabled = Value
        if Value then
            PlayMenuMusic()
        else
            StopMenuMusic()
        end
    end
})

GTab:CreateSlider("MusicVolume", {
    Title = "Music Volume",
    Description = "Adjust music volume",
    Default = 0.5,
    Min = 0.1,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        musicVolume = Value
        UpdateMusicSettings()
    end
})

GTab:CreateSlider("MusicSpeed", {
    Title = "Music Speed",
    Description = "Adjust music playback speed",
    Default = 1.0,
    Min = 0.1,
    Max = 2.0,
    Rounding = 2,
    Callback = function(Value)
        musicSpeed = Value
        UpdateMusicSettings()
    end
})

VTab:CreateToggle("ZoomUnlocker", {
    Title = "Zoom Unlocker",
    Description = "Set max zoom distance to 1000000",
    Default = false,
    Callback = function(Value)
        if Value then
            workspace.CurrentCamera.MaxZoomDistance = 1000000
        else
            workspace.CurrentCamera.MaxZoomDistance = 10
        end
    end
})

local fullbrightEnabled = false
local originalBrightness = nil
local originalGlobalShadows = nil

local function ApplyFullbright()
    local lighting = game:GetService("Lighting")
    if not originalBrightness then
        originalBrightness = lighting.Brightness
        originalGlobalShadows = lighting.GlobalShadows
    end
    
    lighting.Brightness = 2
    lighting.GlobalShadows = false
end

local function ResetFullbright()
    local lighting = game:GetService("Lighting")
    if originalBrightness then
        lighting.Brightness = originalBrightness
        lighting.GlobalShadows = originalGlobalShadows
    end
end

VTab:CreateToggle("FullbrightToggle", {
    Title = "Fullbright",
    Description = "Makes the game brighter",
    Default = false,
    Callback = function(Value)
        fullbrightEnabled = Value
        if Value then
            ApplyFullbright()
        else
            ResetFullbright()
        end
    end
})

local ambientEnabled = false
local ambientColor = Color3.new(1, 0, 0)
local ambientRainbow = false
local ambientConnection = nil
local ambientRainbowConnection = nil
local originalAmbient = nil
local originalColorShift_Top = nil
local originalColorShift_Bottom = nil

local function ApplyAmbient()
    local lighting = game:GetService("Lighting")
    if not originalAmbient then
        originalAmbient = lighting.Ambient
        originalColorShift_Top = lighting.ColorShift_Top
        originalColorShift_Bottom = lighting.ColorShift_Bottom
    end
    
    lighting.Ambient = ambientColor
    lighting.ColorShift_Top = ambientColor
    lighting.ColorShift_Bottom = ambientColor
end

local function ResetAmbient()
    local lighting = game:GetService("Lighting")
    if originalAmbient then
        lighting.Ambient = originalAmbient
        lighting.ColorShift_Top = originalColorShift_Top
        lighting.ColorShift_Bottom = originalColorShift_Bottom
    end
end

VTab:CreateToggle("AmbientToggle", {
    Title = "Ambient",
    Description = "Toggle ambient color",
    Default = false,
    Callback = function(Value)
        ambientEnabled = Value
        
        if Value then
            ambientConnection = RunService.Heartbeat:Connect(function()
                if ambientEnabled then
                    ApplyAmbient()
                end
            end)
            ApplyAmbient()
        else
            if ambientConnection then
                ambientConnection:Disconnect()
                ambientConnection = nil
            end
            ResetAmbient()
        end
    end
})

VTab:CreateColorpicker("AmbientColor", {
    Title = "Ambient Color",
    Description = "Choose ambient color",
    Default = Color3.new(1, 0, 0),
    Callback = function(Value)
        ambientColor = Value
        if ambientEnabled then
            ApplyAmbient()
        end
    end
})

VTab:CreateToggle("AmbientRainbow", {
    Title = "Rainbow Ambient",
    Description = "Toggle rainbow ambient color",
    Default = false,
    Callback = function(Value)
        ambientRainbow = Value
        
        if Value then
            ambientRainbowConnection = RunService.Heartbeat:Connect(function()
                if not ambientRainbow then return end
                
                local hue = tick() % 5 / 5
                ambientColor = Color3.fromHSV(hue, 1, 1)
                
                if ambientEnabled then
                    ApplyAmbient()
                end
            end)
        else
            if ambientRainbowConnection then
                ambientRainbowConnection:Disconnect()
                ambientRainbowConnection = nil
            end
        end
    end
})

SaveManager:LoadAutoloadConfig()
