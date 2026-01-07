local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'The Intruder script. Location:Home. By Likegenm Team',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local PT = Window:AddTab('LocalPlayer')

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local SGB = PT:AddLeftGroupbox('SpeedHack')

local velocitySpeed = 16
local velocityEnabled = false
local velocityConnection

local function SetupVelocityMovement(speed)
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
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
            mv.X * speed,
            HumanoidRootPart.Velocity.Y,
            mv.Z * speed
        )
    end
end

SGB:AddSlider('Speedhack', {
    Text = 'Speed:',
    Default = 16,
    Min = 12,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        velocitySpeed = Value
    end
})

SGB:AddToggle('SpeedToggle', {
    Text = 'Enable Speed',
    Default = false,
    Tooltip = 'Toggle velocity movement',
    Callback = function(Value)
        velocityEnabled = Value
        
        if Value then
            velocityConnection = RunService.Heartbeat:Connect(function()
                if velocityEnabled then
                    SetupVelocityMovement(velocitySpeed)
                end
            end)
        else
            if velocityConnection then
                velocityConnection:Disconnect()
                velocityConnection = nil
            end
        end
    end
})

local FGB = PT:AddRightGroupbox('Fly')

local flySpeed = 40
local flyEnabled = false
local flyConnection
local flyTween

local function SetupFly(speed)
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
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
        targetVelocity = targetVelocity.Unit * speed
    end
    
    if flyTween then
        flyTween:Cancel()
    end
    
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        0.1,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    flyTween = TweenService:Create(humanoidRootPart, tweenInfo, {Velocity = targetVelocity})
    flyTween:Play()
end

FGB:AddSlider('FlySpeed', {
    Text = 'Fly Speed:',
    Default = 40,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        flySpeed = Value
    end
})

FGB:AddToggle('FlyToggle', {
    Text = 'Enable Fly',
    Default = false,
    Tooltip = 'Toggle fly',
    Callback = function(Value)
        flyEnabled = Value
        
        if Value then
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled then
                    SetupFly(flySpeed)
                end
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            if flyTween then
                flyTween:Cancel()
                flyTween = nil
            end
            
            local character = Players.LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

local GameplayTab = Window:AddTab('Gameplay')

local InteractGB = GameplayTab:AddLeftGroupbox('Interact click')

InteractGB:AddToggle('Interact click', {
    Text = 'Interact click',
    Default = false,
    Tooltip = 'cd: 0',
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/InteractClickIntruderHome.lua"))()
        end
    end
})

local VisualGB = GameplayTab:AddRightGroupbox('Visual')

local fullBrightEnabled = false
local fullBrightConnection

local function ApplyFullBright()
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.new(1, 1, 1)
    lighting.Brightness = 2
    lighting.GlobalShadows = false
    lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    lighting.FogEnd = 100000
    lighting.FogStart = 0
end

local function ResetLighting()
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    lighting.Brightness = 1
    lighting.GlobalShadows = true
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    lighting.FogEnd = 100000
    lighting.FogStart = 100
end

VisualGB:AddToggle('FullBrightToggle', {
    Text = 'FullBright',
    Default = false,
    Tooltip = 'Toggle FullBright',
    Callback = function(Value)
        fullBrightEnabled = Value
        
        if Value then
            fullBrightConnection = RunService.Heartbeat:Connect(function()
                if fullBrightEnabled then
                    ApplyFullBright()
                end
            end)
            ApplyFullBright()
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            ResetLighting()
        end
    end
})

local MusicGB = GameplayTab:AddLeftGroupbox('Music')

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

MusicGB:AddToggle('Menu Music', {
    Text = 'Menu Music',
    Default = false,
    Tooltip = 'Play menu music',
    Callback = function(Value)
        menuMusicEnabled = Value
        
        if Value then
            PlayMenuMusic()
        else
            StopMenuMusic()
        end
    end
})

MusicGB:AddSlider('MusicVolume', {
    Text = 'Music Volume',
    Default = 0.5,
    Min = 0.1,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        musicVolume = Value
        UpdateMusicSettings()
    end
})

MusicGB:AddSlider('MusicSpeed', {
    Text = 'Music Speed',
    Default = 1.0,
    Min = 0.1,
    Max = 2.0,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        musicSpeed = Value
        UpdateMusicSettings()
    end
})

local AntiFeaturesGB = GameplayTab:AddRightGroupbox('Anti Features')

local antiAnxietyEnabled = false
local antiAwarenessEnabled = false

local function DestroyAntiAnxiety()
    if game.workspace.Events:FindFirstChild("Anxiety") then
        game.workspace.Events.Anxiety:Destroy()
    end
    if game.workspace.Events:FindFirstChild("AnxietyAmount") then
        game.workspace.Events.AnxietyAmount:Destroy()
    end
    if Players.LocalPlayer.PlayerGui:FindFirstChild("Anxiety") then
        Players.LocalPlayer.PlayerGui.Anxiety:Destroy()
    end
end

local function DestroyAntiAwareness()
    if game.workspace.Events:FindFirstChild("AwarenessValue") then
        game.workspace.Events.AwarenessValue:Destroy()
    end
    if Players.LocalPlayer.PlayerGui:FindFirstChild("IntruderAwareness") then
        Players.LocalPlayer.PlayerGui.IntruderAwareness:Destroy()
    end
    if game.workspace.Events:FindFirstChild("IntruderAwareness") then
        game.workspace.Events.IntruderAwareness:Destroy()
    end
end

AntiFeaturesGB:AddToggle('AntiAnxiety', {
    Text = 'Anti Anxiety',
    Default = false,
    Tooltip = 'Remove anxiety mechanics',
    Callback = function(Value)
        antiAnxietyEnabled = Value
        
        if Value then
            DestroyAntiAnxiety()
        end
    end
})

AntiFeaturesGB:AddToggle('AntiAwareness', {
    Text = 'Anti Awareness',
    Default = false,
    Tooltip = 'Remove awareness mechanics',
    Callback = function(Value)
        antiAwarenessEnabled = Value
        
        if Value then
            DestroyAntiAwareness()
        end
    end
})

local IntruderGB = GameplayTab:AddLeftGroupbox('Intruder')

IntruderGB:AddButton({
    Text = 'Intruder Pos',
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/HomePosIntruder.lua"))()
    end,
    DoubleClick = false,
    Tooltip = 'Show intruder position'
})

local TeleportTab = Window:AddTab('Teleport')

local TeleportGB = TeleportTab:AddLeftGroupbox('Teleport Locations')

local function TeleportTo(position)
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    humanoidRootPart.CFrame = CFrame.new(position)
end

TeleportGB:AddButton({
    Text = 'Closet',
    Func = function()
        TeleportTo(Vector3.new(-6.14, 4.14, 1.97))
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to Closet'
})

TeleportGB:AddButton({
    Text = 'Box',
    Func = function()
        TeleportTo(Vector3.new(16.13, 4.14, -5.49))
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to Box'
})

TeleportGB:AddButton({
    Text = 'Electricity',
    Func = function()
        TeleportTo(Vector3.new(12.22, 4.14, 22.22))
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to Electricity'
})

TeleportGB:AddButton({
    Text = 'Phone',
    Func = function()
        TeleportTo(Vector3.new(13.38, 4.14, 1.81))
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to Phone'
})

TeleportGB:AddButton({
    Text = 'PC',
    Func = function()
        TeleportTo(Vector3.new(8.45, 4.14, 9.78))
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to PC'
})

TeleportGB:AddButton({
    Text = 'LightSwitcher',
    Func = function()
        TeleportTo(Vector3.new(11.26, 4.14, -8.52))
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to LightSwitcher'
})

local UITab = Window:AddTab('UI Settings')
local MenuGroup = UITab:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload',
    Func = function()
        if velocityConnection then velocityConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        if flyTween then flyTween:Cancel() end
        StopMenuMusic()
        ResetLighting()
        Library:Unload() 
    end,
    DoubleClick = false,
    Tooltip = 'Unload script'
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { 
    Default = 'RightShift', 
    NoUI = true, 
    Text = 'Menu keybind' 
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('IntruderScript')

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:SetFolder('IntruderScript/game')

SaveManager:BuildConfigSection(UITab)
ThemeManager:ApplyToTab(UITab)
SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('Intruder Script:Home | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if velocityConnection then velocityConnection:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
    if fullBrightConnection then fullBrightConnection:Disconnect() end
    if flyTween then flyTween:Cancel() end
    StopMenuMusic()
    ResetLighting()
    Library.Unloaded = true
end)
