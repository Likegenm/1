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

local speedgb = Playertab:AddLeftGroupbox('SpeedHack')

speedgb:AddSlider('SpeedSlider', {
    Text = 'Speed:',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
while task.wait(0.1) do
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
        end
})
