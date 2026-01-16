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
