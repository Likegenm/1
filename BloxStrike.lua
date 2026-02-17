local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "BloxStrike",
    Footer = "by Likegenm",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local LPTab = Window:AddTab("LocalPlayer", "trophy")

local CombatTab = Window:AddTab("Combat", "sword")

local ETab = Window:AddTab("Exploits", "skull")

local WTab = Window:AddTab("Workspace", "moon")

local MicsTab = Window:AddTab("Mics", "crown")
