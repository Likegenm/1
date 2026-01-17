local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Bedwars script(by Likegenm)',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local IT = Window:AddTab('Info')
IT:AddLeftGroupbox('Credits'):AddLabel('Main: Likegenm')
IT:AddLeftGroupbox('Scripter'):AddLabel('Scripter: Likegenm')

local PT = Window:AddTab('Player')

local SpeedGroup = PT:AddLeftGroupbox('Speed')

SpeedGroup:AddToggle('SpeedToggle', {
    Text = 'Enable Speed Hack',
    Default = false,
    Callback = function(enabled)
        Toggles.SpeedToggle.Value = enabled
    end
})

SpeedGroup:AddSlider('SpeedValue', {
    Text = 'Speed Value',
    Default = 19.5,
    Min = 16,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        Options.SpeedValue.Value = value
    end
})

local SettingsTab = Window:AddTab('Settings')
local MenuGroup = SettingsTab:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('BedwarsScript')
SaveManager:SetFolder('BedwarsScript/config')
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()

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
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local speedConnection
local speedActive = false

local function updateSpeedSystem()
    if Toggles.SpeedToggle.Value and not speedActive then
        speedActive = true
        
        speedConnection = RunService.Heartbeat:Connect(function()
            if not Toggles.SpeedToggle.Value then
                speedConnection:Disconnect()
                speedActive = false
                return
            end
            
            if Character and HumanoidRootPart then
                local cameraCFrame = Camera.CFrame
                local lookVector = cameraCFrame.LookVector
                local rightVector = cameraCFrame.RightVector
                
                local mv = Vector3.new(0, 0, 0)
                local speed = Options.SpeedValue.Value

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
        
    elseif not Toggles.SpeedToggle.Value and speedActive then
        if speedConnection then
            speedConnection:Disconnect()
        end
        speedActive = false
    end
end

Toggles.SpeedToggle:OnChanged(updateSpeedSystem)
Options.SpeedValue:OnChanged(function()
    if Toggles.SpeedToggle.Value then
        if speedConnection then
            speedConnection:Disconnect()
        end
        updateSpeedSystem()
    end
end)
