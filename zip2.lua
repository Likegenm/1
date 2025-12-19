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

local blacklistedExecutors = {
    "Fluxus",
    "Delta", 
    "Krnl",
    "Synapse X"
}

local function checkExecutor()
local Players = game:GetService("Players")

if fluxus then
    Players.LocalPlayer:Kick("Fluxus is blacklisted")
    return
end

if is_sirhurt_closure then
    Players.LocalPlayer:Kick("Delta is blacklisted")
    return
end

if KRNL_LOADED then
    Players.LocalPlayer:Kick("Krnl is blacklisted")
    return
end

if is_synapse_function then
    Players.LocalPlayer:Kick("Synapse X is blacklisted")
    return
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LikegenmMessage"
screenGui.Parent = player:WaitForChild("PlayerGui")

local blackScreen = Instance.new("Frame")
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.Position = UDim2.new(0, 0, 0, 0)
blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
blackScreen.BackgroundTransparency = 1
blackScreen.ZIndex = 10
blackScreen.Parent = screenGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
textLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Likegenm scripts"
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextSize = 72
textLabel.TextTransparency = 1
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextStrokeTransparency = 0.5
textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
textLabel.ZIndex = 11
textLabel.Parent = screenGui

local function showAnimation()
    local tweenInfoIn = TweenInfo.new(
        1.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local blackTweenIn = TweenService:Create(blackScreen, tweenInfoIn, {BackgroundTransparency = 0})
    blackTweenIn:Play()
    
    local textTweenIn = TweenService:Create(textLabel, tweenInfoIn, {TextTransparency = 0})
    textTweenIn:Play()
    
    blackTweenIn.Completed:Wait()
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 0, 255)
    }
    
    local colorIndex = 1
    local startTime = tick()
    
    while tick() - startTime < 4 do
        textLabel.TextColor3 = colors[colorIndex]
        colorIndex = colorIndex + 1
        if colorIndex > #colors then
            colorIndex = 1
        end
        
        local tweenInfoColor = TweenInfo.new(
            0.5,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        local colorTween = TweenService:Create(textLabel, tweenInfoColor, {TextColor3 = colors[colorIndex]})
        colorTween:Play()
        
        wait(0.5)
    end
    
    local tweenInfoOut = TweenInfo.new(
        1.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local blackTweenOut = TweenService:Create(blackScreen, tweenInfoOut, {BackgroundTransparency = 1})
    blackTweenOut:Play()
    
    local textTweenOut = TweenService:Create(textLabel, tweenInfoOut, {TextTransparency = 1})
    textTweenOut:Play()
    
    blackTweenOut.Completed:Wait()
    
    screenGui:Destroy()
end

showAnimation()






task.wait(0.1)
print("Wait")
task.wait(0.1)
    
loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/DownoloadLiblary.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Test/refs/heads/main/Irina.lua"))()

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
