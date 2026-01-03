local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'MM2',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local PT = Window:AddTab('Player')

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local SGB = PT:AddLeftGroupbox('Speedhack')

local walkSpeedConnection
local currentWalkSpeed = 16
local speedKeybindEnabled = false

SGB:AddSlider('Speedhack', {
    Text = 'Speed:',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentWalkSpeed = Value
        if walkSpeedConnection then
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                if speedKeybindEnabled then
                    character.Humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

SGB:AddToggle('SpeedToggle', {
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

SGB:AddLabel('Speed Keybind (V)'):AddKeyPicker('SpeedKeybind', {
    Default = 'V',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Speed Boost',
    NoUI = false,
    
    Callback = function(Value)
        speedKeybindEnabled = Value
        
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            if Toggles.SpeedToggle.Value then
                if Value then
                    character.Humanoid.WalkSpeed = currentWalkSpeed
                else
                    character.Humanoid.WalkSpeed = 16
                end
            end
        end
    end
})

local JGB = PT:AddRightGroupbox('JumpPower')

local jumpPowerConnection
local currentJumpPower = 50
local jumpKeybindEnabled = false

JGB:AddSlider('JumpPower', {
    Text = 'JumpPower',
    Default = 50,
    Min = 50,
    Max = 1000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        currentJumpPower = Value
        if jumpPowerConnection then
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                if jumpKeybindEnabled then
                    character.Humanoid.JumpPower = Value
                end
            end
        end
    end
})

JGB:AddToggle('JumpToggle', {
    Text = 'Enable JumpPower',
    Default = false,
    Tooltip = 'Toggle jump power hack',
    Callback = function(Value)
        if Value then
            jumpPowerConnection = RunService.Heartbeat:Connect(function()
                local character = Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.JumpPower = currentJumpPower
                end
            end)
            
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = currentJumpPower
            end
        else
            if jumpPowerConnection then
                jumpPowerConnection:Disconnect()
                jumpPowerConnection = nil
            end
            
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = 50
            end
        end
    end
})

JGB:AddLabel('Jump Keybind (J)'):AddKeyPicker('JumpKeybind', {
    Default = 'J',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Jump Boost',
    NoUI = false,
    
    Callback = function(Value)
        jumpKeybindEnabled = Value
        
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            if Toggles.JumpToggle.Value then
                if Value then
                    character.Humanoid.JumpPower = currentJumpPower
                else
                    character.Humanoid.JumpPower = 50
                end
            end
        end
    end
})

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

    Library:SetWatermark(('MM2 Likegenm | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library.KeybindFrame.Visible = true

local UITab = Window:AddTab('UI Settings')

local MenuGroup = UITab:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() 
    if walkSpeedConnection then walkSpeedConnection:Disconnect() end
    if jumpPowerConnection then jumpPowerConnection:Disconnect() end
    Library:Unload() 
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { 
    Default = 'LeftAlt', 
    NoUI = true, 
    Text = 'Menu keybind' 
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('MM2Likegenm')

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:SetFolder('MM2Likegenm/game')

SaveManager:BuildConfigSection(UITab)
ThemeManager:ApplyToTab(UITab)
SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if walkSpeedConnection then walkSpeedConnection:Disconnect() end
    if jumpPowerConnection then jumpPowerConnection:Disconnect() end
    Library.Unloaded = true
end)
