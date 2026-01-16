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

local PT = Window:AddTab('Player')

PT:AddLeftGroupbox('Gravity'):AddSlider('Gravity', {
    Text = 'Gravity',
    Default = 196,
    Min = 0,
    Max = 196,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
      game.workspace.Gravity =  Value
    end
  })

PT:AddLeftGroupbox('Speed'):AddSlider('Speed', {
    Text = 'Speed',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
  })


local MenuGroup = Window:AddTab:['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
