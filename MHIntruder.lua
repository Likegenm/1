local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'The Intruder script. Location:Mental Hospital. By Likegenm Team',
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

local APGB = GameplayTab:AddLeftGroupbox('Anti')

APGB:AddButton({
    Text = 'AntiPuzzles',
    Func = function()
        game.workspace.CellRoom.Puzzle:Destroy()
        game.workspace.CellRoom.Puzzle2:Destroy()
    end,
    DoubleClick = false,
    Tooltip = 'Destroy Doors'
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

APGB:AddButton({
    Text = 'Interact click',
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/MHInteractClick.lua"))()
    end,
    DoubleClick = false,
    Tooltip = 'cooldown = 0'
})

local IGB = GameplayTab:AddRightGroupbox('Intruder')

IGB:AddButton({
    Text = 'Intruder Pos',
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/MHintruderPos.lua"))()
    end,
    DoubleClick = false,
    Tooltip = 'Position Intruders'
})


local VisualTab = Window:AddTab('Visual')

local AmbientGB = VisualTab:AddLeftGroupbox('Ambient')

local ambientEnabled = false
local ambientColor = Color3.new(1, 0, 0)
local ambientRainbow = false
local ambientConnection
local ambientRainbowConnection

local function ApplyAmbient()
    local lighting = game:GetService("Lighting")
    lighting.OutdoorAmbient = ambientColor
    lighting.Ambient = ambientColor
end

local function ResetAmbient()
    local lighting = game:GetService("Lighting")
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
end

AmbientGB:AddToggle('AmbientToggle', {
    Text = 'Ambient',
    Default = false,
    Tooltip = 'Toggle ambient color',
    Callback = function(Value)
        ambientEnabled = Value
        
        if Value then
            ambientConnection = game:GetService("RunService").Heartbeat:Connect(function()
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

AmbientGB:AddLabel('Ambient Color'):AddColorPicker('AmbientColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'Ambient Color',
    Transparency = 0,
    
    Callback = function(Value)
        ambientColor = Value
        if ambientEnabled then
            ApplyAmbient()
        end
    end
})

AmbientGB:AddToggle('AmbientRainbow', {
    Text = 'Rainbow Ambient',
    Default = false,
    Tooltip = 'Toggle rainbow ambient color',
    Callback = function(Value)
        ambientRainbow = Value
        
        if Value then
            ambientRainbowConnection = game:GetService("RunService").Heartbeat:Connect(function()
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

local FullBrightGB = VisualTab:AddRightGroupbox('FullBright')

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

FullBrightGB:AddToggle('FullBrightToggle', {
    Text = 'FullBright',
    Default = false,
    Tooltip = 'Toggle FullBright',
    Callback = function(Value)
        fullBrightEnabled = Value
        
        if Value then
            fullBrightConnection = game:GetService("RunService").Heartbeat:Connect(function()
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

local UITab = Window:AddTab('UI Settings')
local MenuGroup = UITab:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload',
    Func = function()
            print("ok")
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

    Library:SetWatermark(('Intruder Script:Mental Hospital | %s fps | %s ms'):format(
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
