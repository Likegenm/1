local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

local Window = Luna:CreateWindow({
    Name = "Isle script", 
    Subtitle = nil,
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "Likegenm script",
    LoadingSubtitle = "by Likegenm",

    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "Isle Hub"
    },

    KeySystem = true,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter...",
        Note = "Key: 123",
        SaveInRoot = false,
        SaveKey = true,
        Key = {"123"},
        SecondAction = {
            Enabled = true, 
            Type = "Link", 
            Parameter = ""
        }
    }
})

Luna:Notification({ 
    Title = "Welcome",
    Icon = "sparkle",
    ImageSource = "Material",
    Content = "K to Open/Close UI"
})

local LPT = Window:CreateTab({
    Name = "LocalPlayer",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})

local VT = Window:CreateTab({
    Name = "Visual",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})

local TT = Window:CreateTab({
    Name = "Teleport",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})

local CT = Window:CreateTab({
    Name = "Credits",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})

Tab:CreateSection("Speedhack"):CreateSlider({
        Name = "Speed",
        Range = {0, 200},
        Increment = 0.1,
        CurrentValue = 100,
        Flag = "Slider",
    })

