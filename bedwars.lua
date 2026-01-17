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

IT:AddLeftGroupbox('Credits'):AddLabel('Main:Likegenm')

IT:AddLeftGroupbox('Credits'):AddLabel('Scripter:Likegenm')
