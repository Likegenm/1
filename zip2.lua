--[[
██╗     ██╗██╗██╗  ██╗███████╗ ██████╗ ███████╗███╗   ██╗███╗   ███╗
██║     ██║██║██║ ██╔╝██╔════╝██╔════╝ ██╔════╝████╗  ██║████╗ ████║
██║     ██║██║█████╔╝ █████╗  ██║  ███╗█████╗  ██╔██╗ ██║██╔████╔██║
██║     ██║██║██╔═██╗ ██╔══╝  ██║   ██║██╔══╝  ██║╚██╗██║██║╚██╔╝██║
███████╗██║██║██║  ██╗███████╗╚██████╔╝███████╗██║ ╚████║██║ ╚═╝ ██║
╚══════╝╚═╝╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝
]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Test/refs/heads/main/Irina.lua"))()

local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

local Window = Luna:CreateWindow({
    Name = "PSCP script",
    Subtitle = nil,
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "PSCP Rewrite",
    LoadingSubtitle = "by Likegenm",

    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "PSCP Rewrite"
    },

    KeySystem = false, 
})

local LPTab = Window:CreateTab({
    Name = "LocalPlayer",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})
