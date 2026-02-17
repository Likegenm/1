local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "BloxStrike",
    Footer = "by Likegenm",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

Library.ShowCustomCursor = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
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

-- Blatant Fly
local flyEnabled = false
local flyConnection = nil
local keys = {W=false, S=false, A=false, D=false}
local shiftDown = false
local torquePower = 50000
local torque = nil
local hrp = nil

local function setupFly()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    
    if torque then
        torque:Destroy()
    end
    
    torque = Instance.new("Torque")
    torque.Parent = hrp
end

local function startFly()
    if flyEnabled then
        setupFly()
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not hrp or not hrp.Parent then
                return
            end
            
            local moveDir = Vector3.new(0, 0, 0)
            local camCF = Camera.CFrame
            
            if keys.W then moveDir = moveDir + camCF.LookVector end
            if keys.S then moveDir = moveDir - camCF.LookVector end
            if keys.A then moveDir = moveDir - camCF.RightVector end
            if keys.D then moveDir = moveDir + camCF.RightVector end
            
            if shiftDown then
                torque.Torque = Vector3.new(0, 0, torquePower)
                hrp.Velocity = Vector3.new(0, -50, 0)
            elseif moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
                torque.Torque = Vector3.new(0, torquePower, 0)
                hrp.Velocity = moveDir * 50
            else
                torque.Torque = Vector3.new(0, 0, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if torque then
            torque:Destroy()
            torque = nil
        end
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then shiftDown = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then shiftDown = false end
end)

local FlyBox = VTab:AddLeftGroupbox("Fly")

FlyBox:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        startFly()
        Library:Notify("Fly: " .. (state and "ON" or "OFF"), 2)
    end
})

FlyBox:AddSlider("TorquePowerSlider", {
    Text = "Torque Power",
    Default = 50000,
    Min = 10000,
    Max = 100000,
    Rounding = 1,
    Callback = function(value)
        torquePower = value
    end
})

Library:Notify("BloxStrike script (by Likegenm) Press RightCTRL to open UI", 5)
