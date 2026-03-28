local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Murino Horror",
    SubTitle = "by Likegenm + Vicinly",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift 
})

local LT Window:AddTab({ Title = "LocalPlayer", Icon = "user" })

local GT Window:AddTab({ Title = "Game", Icon = "sword" })

local VT Window:AddTab({ Title = "Visual", Icon = "eye" })

local IT Window:AddTab({ Title = "Credits", Icon = "info" })
