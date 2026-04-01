local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Slap Battle",
    Footer = "by Likegenm + Vicinly",
    ToggleKeybind = Enum.KeyCode.LeftControl,
    Center = true,
    AutoShow = true,
    Cursor = false
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
local KGB = MainTab:AddRightGroupbox("Killaura")
local AKGB = MainTab:AddRightGroupbox("AutoClicker")
local NCDGB = MainTab:AddRightGroupbox("No Click Delay")

local SpeedToggle = SGB:AddToggle("Speed Hack", {
    Text = "Enable Speed Hack",
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if Value then
                    humanoid.WalkSpeed = SpeedSlider.Value
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
})

local SpeedSlider = SGB:AddSlider("Speed Value", {
    Text = "Speed:",
    Min = 16,
    Max = 100,
    Default = 25,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if SpeedToggle.Value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Value
                end
            end
        end
    end
})

local HipToggle = HGB:AddToggle("Hip Height", {
    Text = "Enable Hip Height",
    Default = false,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if Value then
                    humanoid.HipHeight = HipSlider.Value
                else
                    humanoid.HipHeight = 0
                end
            end
        end
    end
})

local HipSlider = HGB:AddSlider("Hip Height Value", {
    Text = "Hip Height:",
    Default = 0,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if HipToggle.Value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.HipHeight = Value
                end
            end
        end
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    local humanoid = character:FindFirstChild("Humanoid")
    
    if SpeedToggle.Value and humanoid then
        humanoid.WalkSpeed = SpeedSlider.Value
    end
    
    if HipToggle.Value and humanoid then
        humanoid.HipHeight = HipSlider.Value
    end
end)
