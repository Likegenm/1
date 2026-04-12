loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Scripts/refs/heads/main/BypassVoid.lua"))()

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Troll is a pinning 2 script",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroEnabled = true,
    IntroText = "by Likegenm",
    IntroIcon = nil
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local WSS = Tab:AddSection({
    Name = "WalkSpeed"
})

local WSSlider = Tab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "WalkSpeed",
    Callback = function(Value)
        while task.wait(0.1) do
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
    end    
})


