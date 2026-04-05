local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Qanuir/orion-ui/refs/heads/main/source.lua"))()

local Window = OrionLib:MakeWindow({
 Name = "Survive in zone 51",
 HidePremium = false,
 SaveConfig = true,
 ConfigFolder = "zone 51 test"
})

local Tab1 = Window:MakeTab({
 Name = "LocalPlayer",
 Icon = "rbxassetid://4483345998",
 PremiumOnly = false
})

local Tab2 = Window:MakeTab({
 Name = "Gameplay",
 Icon = "rbxassetid://4483345998",
 PremiumOnly = false
})

local Tab3 = Window:MakeTab({
 Name = "World",
 Icon = "rbxassetid://4483345998",
 PremiumOnly = false
})

local Tab4 = Window:MakeTab({
 Name = "Teleport",
 Icon = "rbxassetid://4483345998",
 PremiumOnly = false
})

local Tab5 = Window:MakeTab({
 Name = "Settings",
 Icon = "rbxassetid://4483345998",
 PremiumOnly = false
})

local SS1 = Tab1:AddSection({
    Name = "Speed"
})

local JS1 = Tab1:AddSection({
    Name = "Jumps"
})

local FS1 = Tab1:AddSection({
    Name = "Flight"
})

local Section = Tab1:AddSection({
    Name = "Noclip"
})

local IS1 = Tab1:AddSection({
    Name = "Invisible"
})

local GS1 = Tab1:AddSection({
    Name = "Godmode"
})
