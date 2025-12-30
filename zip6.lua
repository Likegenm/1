local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = "The Field script",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Playertab = Window:AddTab('Player')

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local speedgb = Playertab:AddLeftGroupbox('SpeedHack')

local walkSpeedConnection
local currentWalkSpeed = 16

speedgb:AddSlider('SpeedSlider', {
    Text = 'Speed:',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentWalkSpeed = Value
        if walkSpeedConnection then
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = Value
            end
        end
    end
})

speedgb:AddToggle('SpeedToggle', {
    Text = 'Enable Speed',
    Default = false,
    Tooltip = 'Toggle speed hack',
    Callback = function(Value)
        if Value then
            walkSpeedConnection = RunService.Heartbeat:Connect(function()
                local character = Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = currentWalkSpeed
                end
            end)
            
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = currentWalkSpeed
            end
        else
            if walkSpeedConnection then
                walkSpeedConnection:Disconnect()
                walkSpeedConnection = nil
            end
            
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

local flygb = Playertab:AddRightGroupbox('Fly')

local flyEnabled = false
local flyTween = nil
local flyConnection = nil
local currentFlySpeed = 40

flygb:AddSlider('FlySlider', {
    Text = 'Fly Speed:',
    Default = 40,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentFlySpeed = Value
    end
})

flygb:AddToggle('FlyOn', {
    Text = 'Fly',
    Default = false,
    Tooltip = 'Toggle fly',
    Callback = function(Value)
        local player = Players.LocalPlayer
        
        if Value then
            flyEnabled = true
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                
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
                    targetVelocity = targetVelocity.Unit * currentFlySpeed
                end
                
                if flyTween then
                    flyTween:Cancel()
                end
                
                local tweenInfo = TweenInfo.new(
                    0.1,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )
                
                flyTween = TweenService:Create(humanoidRootPart, tweenInfo, {Velocity = targetVelocity})
                flyTween:Play()
            end)
            
        else
            flyEnabled = false
            
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            if flyTween then
                flyTween:Cancel()
                flyTween = nil
            end
            
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

flygb:AddLabel('Fly Hotkey'):AddKeyPicker('FlyKeybind', {
    Default = 'F',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Toggle Fly',
    NoUI = false,
    
    Callback = function(Value)
        if Value then
            Toggles.FlyOn:SetValue(not Toggles.FlyOn.Value)
        end
    end,
    
    ChangedCallback = function(New)
        print('Fly keybind changed to:', New)
    end
})

local VTab = Window:AddTab("Visual")

local Ggb = VTab:AddLeftGroupbox("Grafic")

local fogConnection
local dayConnection

Ggb:AddToggle('AlwaysDay', {
    Text = 'AlwaysDay',
    Default = true,
    Tooltip = 'Always day',
    Callback = function(Value)
        local lighting = game:GetService("Lighting")
        if Value then
            dayConnection = RunService.Heartbeat:Connect(function()
                lighting.ClockTime = 14
                lighting.GeographicLatitude = 0
            end)
            lighting.ClockTime = 14
            lighting.GeographicLatitude = 0
        else
            if dayConnection then
                dayConnection:Disconnect()
                dayConnection = nil
            end
        end
    end
})

local UITab = Window:AddTab('UI Settings')
local MenuGroup = UITab:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('TheFieldScript')
SaveManager:SetFolder('TheFieldScript')

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
    
    Library:SetWatermark(('The Field Script | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if fogConnection then
        fogConnection:Disconnect()
    end
    if dayConnection then
        dayConnection:Disconnect()
    end
    Library.Unloaded = true
end)
