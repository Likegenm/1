--[[
██╗     ██╗██╗██╗  ██╗███████╗ ██████╗ ███████╗███╗   ██╗███╗   ███╗
██║     ██║██║██║ ██╔╝██╔════╝██╔════╝ ██╔════╝████╗  ██║████╗ ████║
██║     ██║██║█████╔╝ █████╗  ██║  ███╗█████╗  ██╔██╗ ██║██╔████╔██║
██║     ██║██║██╔═██╗ ██╔══╝  ██║   ██║██╔══╝  ██║╚██╗██║██║╚██╔╝██║
███████╗██║██║██║  ██╗███████╗╚██████╔╝███████╗██║ ╚████║██║ ╚═╝ ██║
╚══════╝╚═╝╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝

Likegenm scripts (LS) Project scp 2.0

by likegenm
]]

repeat task.wait() until game:IsLoaded()

local StarterGui = game:GetService("StarterGui")

local function checkExecutor()
    local executors = {
        ["Delta"] = is_sirhurt_closure,
        ["Synapse X"] = is_synapse_function,
        ["ProtoSmasher"] = pebc_instance,
        ["Krnl"] = KRNL_LOADED,
        ["ScriptWare"] = isexecutorclosure,
        ["Xeno"] = identifyexecutor,
        ["Solara"] = is_solara,
        ["Wave"] = is_wave,
        ["Cryptic"] = is_cryptic
    }
    
    for name, check in pairs(executors) do
        if check then
           StarterGui:SetCore("SendNotification", {
                Title = "Cheat Engine",
                Text = "Ur executor 90>ur executor",
                Icon = "",
                Duration = 5,
                Button1 = "OK",
                Callback = function()
                end
           })
           return
        end
    end
end

checkExecutor()

--[[
██╗     ██╗██╗██╗  ██╗███████╗ ██████╗ ███████╗███╗   ██╗███╗   ███╗
██║     ██║██║██║ ██╔╝██╔════╝██╔════╝ ██╔════╝████╗  ██║████╗ ████║
██║     ██║██║█████╔╝ █████╗  ██║  ███╗█████╗  ██╔██╗ ██║██╔████╔██║
██║     ██║██║██╔═██╗ ██╔══╝  ██║   ██║██╔══╝  ██║╚██╗██║██║╚██╔╝██║
███████╗██║██║██║  ██╗███████╗╚██████╔╝███████╗██║ ╚████║██║ ╚═╝ ██║
╚══════╝╚═╝╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "PSCP",
    Footer = "v2.0 (by Likegenm)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true,
    NotifySide = "Right",
    ShowCustomCursor = false,
    MobileButtonsSide = "Left"
})

local MainTab = Window:AddTab("Main", "home")

local LeftGroupbox = MainTab:AddLeftGroupbox("LocalPlayer")
local RightGroupbox = MainTab:AddRightGroupbox("Players")
