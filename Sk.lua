local player = game.Players.LocalPlayer
local savedPosition = nil

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Survive the Killer",
    Footer = "v1.0(Likegenm scripts)",
    ToggleKeybind = Enum.KeyCode.RightAlt,
    Center = true,
    AutoShow = true
})

local MainTab = Window:AddTab("Main", "home")

local M1Tabbox = MainTab:AddLeftTabbox("AutoWin")
local Tab1 = M1Tabbox:AddTab("Killer")
local Tab2 = M1Tabbox:AddTab("Survive")

Tab2:AddButton({
    Text = "Save Position",
    Func = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedPosition = player.Character.HumanoidRootPart.CFrame
        end
    end,
    DoubleClick = false
})

Tab2:AddButton({
    Text = "Return to Saved",
    Func = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and savedPosition then
            player.Character.HumanoidRootPart.CFrame = savedPosition
        end
    end,
    DoubleClick = false
})

Tab2:AddButton({
    Text = "Teleport to Safe Position",
    Func = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-4.82, 260.57, 17.02)
        end
    end,
    DoubleClick = false
})
