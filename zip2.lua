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


local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()
local function checkExecutor()
    local executors = {
        ["Delta"] = is_sirhurt_closure,
        ["Synapse X"] = is_synapse_function,
        ["ProtoSmasher"] = pebc_instance,
        ["Krnl"] = KRNL_LOADED,
        ["ScriptWare"] = isexecutorclosure,
        ["Xeno"] = identifyexecutor,
        ["Solara"] = is_solara
        ["Wave"] = is_wave
        ['Cryptic'] = is_cryptic
    }
    
    for name, check in pairs(executors) do
        if check then
            Library:Notify({
                Title = "Cheat Engine",
                Description = "Ur executor is 90>" name, " UNC"
                Time = 5
            })
            return
        end
    end
end

checkExecutor()

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

local 
