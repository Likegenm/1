local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "BloxStrike",
    Footer = "by Likegenm",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local InfoTab = Window:AddTab("Info", "info")

local LeftBox = InfoTab:AddLeftGroupbox("Player Info")

local playerId = LocalPlayer.UserId
local playerName = LocalPlayer.Name
local playerDisplayName = LocalPlayer.DisplayName
local accountAge = LocalPlayer.AccountAge

-- Картинка игрока большая
local imageHolder = LeftBox:AddLabel("")
imageHolder.TextLabel.Size = UDim2.new(1, 0, 0, 200)
imageHolder.TextLabel.Text = ""

local image = Instance.new("ImageLabel")
image.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerId .. "&width=720&height=720&format=png"
image.Size = UDim2.new(0, 200, 0, 200)
image.Position = UDim2.new(0.5, -100, 0, 0)
image.BackgroundTransparency = 1
image.Parent = imageHolder.TextLabel

LeftBox:AddDivider()

local idLabel = LeftBox:AddLabel("Player ID: " .. playerId)
idLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local nameLabel = LeftBox:AddLabel("Username: " .. playerName)
nameLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local displayNameLabel = LeftBox:AddLabel("Display Name: " .. playerDisplayName)
displayNameLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local ageLabel = LeftBox:AddLabel("Account Age: " .. accountAge .. " days")
ageLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

LeftBox:AddDivider()

local ping = 0
local fps = 0
local lastIteration, frameCount = tick(), 0

local pingLabel = LeftBox:AddLabel("Ping: " .. ping .. " ms")
pingLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

local fpsLabel = LeftBox:AddLabel("FPS: " .. fps)
fpsLabel.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    
    if tick() - lastIteration >= 1 then
        fps = frameCount
        frameCount = 0
        lastIteration = tick()
        
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        
        pingLabel.TextLabel.Text = "Ping: " .. ping .. " ms"
        fpsLabel.TextLabel.Text = "FPS: " .. fps
    end
end)

LeftBox:AddDivider()

local RightBox = InfoTab:AddRightGroupbox("Credits")

local creditsLabel = RightBox:AddLabel("Credits:")
creditsLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local allLabel = RightBox:AddLabel("All: Likegenm")
allLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

local discordLabel = RightBox:AddLabel("Discord: https://discord.gg/K3nnT6yt")
discordLabel.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

RightBox:AddButton({
    Text = "Copy Discord Link",
    Func = function()
        setclipboard("https://discord.gg/K3nnT6yt")
        Library:Notify("Discord link copied!", 2)
    end
})

local LPTab = Window:AddTab("Combat", "sword")

local VTab = Window:AddTab("Blatant", "zap")

local CTab = Window:AddTab("Render", "eye")

local WTab = Window:AddTab("World", "moon")

local MTab = Window:AddTab("Mics", "box")

Library:Notify("BloxStrike script (by Likegenm) Press RightCTRL to open UI", 5)
