local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'MM2 script(By Likegenm)',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Player = Window:AddTab('Player'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

local PlayerTab = Tabs.Player
local UISettingsTab = Tabs['UI Settings']

local GravityGroup = PlayerTab:AddLeftGroupbox('Gravity')

local gravityToggle = GravityGroup:AddToggle('GravityToggle', {
    Text = 'Enable Custom Gravity',
    Default = false
})

local gravitySlider = GravityGroup:AddSlider('GravityValue', {
    Text = 'Gravity',
    Default = 196,
    Min = 0,
    Max = 196,
    Rounding = 1,
    Compact = false
})

local SpeedGroup = PlayerTab:AddRightGroupbox('Speed')

local speedToggle = SpeedGroup:AddToggle('SpeedToggle', {
    Text = 'Enable Speed Hack',
    Default = false
})

local speedSlider = SpeedGroup:AddSlider('SpeedValue', {
    Text = 'Speed',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Compact = false
})

local MenuGroup = UISettingsTab:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(UISettingsTab)
ThemeManager:ApplyToTab(UISettingsTab)
SaveManager:LoadAutoloadConfig()

gravityToggle:OnChanged(function()
    if Toggles.GravityToggle.Value then
        game.Workspace.Gravity = Options.GravityValue.Value
    else
        game.Workspace.Gravity = 196.2
    end
end)

gravitySlider:OnChanged(function()
    if Toggles.GravityToggle.Value then
        game.Workspace.Gravity = Options.GravityValue.Value
    end
end)

speedToggle:OnChanged(function()
    if Toggles.SpeedToggle.Value then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild('Humanoid') then
            player.Character.Humanoid.WalkSpeed = Options.SpeedValue.Value
        end
    else
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild('Humanoid') then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

speedSlider:OnChanged(function()
    if Toggles.SpeedToggle.Value then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild('Humanoid') then
            player.Character.Humanoid.WalkSpeed = Options.SpeedValue.Value
        end
    end
end)
