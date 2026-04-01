local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "lap Battle",
    Footer = "by Likegenm + Vicinly",
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab("Main", "home")

local SGB = MainTab:AddLeftGroupbox("Speed")

local SPGB = MainTab:AddLeftGroupbox("Spider")

local JGB = MainTab:AddLeftGroupbox("Jumps")

local AVGB = MainTab:AddLeftGroupbox("Anti Void")

local FGB = MainTab:AddLeftGroupbox("Flight")

local SPRGB = MainTab:AddLeftGroupbox("Sprint")

local SFGB = MainTab:AddLeftGroupbox("SafeWalk")

local IGB = MainTab:AddLeftGroupbox("Invisibility")

local GGB = MainTab:AddLeftGroupbox("AntiHit/Godmode")

local HGB = MainTab:AddLeftGroupbox("Hip")

local DGB = MainTab:AddLeftGroupbox("Dodge")

local AKBGB = MainTab:AddRightGroupbox("Velocity")

local TBGB = MainTab:AddRightGroupbox("Triggerbot")

local KGB MainTab:AddRightGroupbox("Killaura")

local AKGB = MainTab:AddRightGroupbox("AutoCliker")

local NCDGB = MainTab:AddRightGroupbox("No Click Delay")
