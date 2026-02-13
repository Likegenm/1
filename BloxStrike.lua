local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Likegenm",
    Footer = "BloxStike",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local LPTab = Window:AddTab("LocalPlayer", "user")

local VisualTab = Window:AddTab("Visual", "eye")

local ExploitsTab = Window:AddTab("Exploits", "zap")

local Tabbox1 = LPTab:AddLeftTabbox("Speed + JumpPower")

local Tab1 = Tabbox1:AddTab("Speed")

local Tab2 = Tabbox1:AddTab("Jump")

