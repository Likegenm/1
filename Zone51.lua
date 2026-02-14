local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Likegenm",
    Footer = "Zone 51",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab("Main", "zap")

local BITab = Window:AddTab("BringItems", "box")

local CombatTab = Window:AddTab("Combat", "sword")

local VisualTab = Window:AddTab("Visual", "eye")
