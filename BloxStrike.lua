local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "BloxStrike script",
    Footer = "v1.0 (By Likegenm)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local PlrTab = Window:AddTab("LocalPlayer", "user")

local HSTbb = PlrTab:AddLeftTabbox("Humanoid Settings")

local Tab1 = HSTbb:AddTab("Speedhack")
local Tab2 = HSTbb:AddTab("Jumphack")

-- Исправленный слайдер для Jumphack
local Jumphack = Tab2:AddSlider("Jumphack", {
    Text = "Jump Power",
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        JUMP_POWER = Value
    end
})

JUMP_POWER = 0

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local currentVelocity = character.HumanoidRootPart.Velocity
            character.HumanoidRootPart.Velocity = Vector3.new(currentVelocity.X, JUMP_POWER, currentVelocity.Z)
        end
    end
end)

local Speedhack = Tab1:AddSlider("Speedhack", {
    Text = "Speed",
    Default = 0,
    Min = 0.1,
    Max = 0.2,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Library:Notify("Speedhack unworking", 5)
    end
})
