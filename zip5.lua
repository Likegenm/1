local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Magic Tulevo script",
    Author = "Likegenm",
    Folder = "AxmedHub",
    Icon = "code",
    IconSize = 22*2,
    NewElements = false,
    HideSearchBar = false,
    OpenButton = {
        Title = "UI",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        
        Color = ColorSequence.new(
            Color3.fromHex("#ff0000"), 
            Color3.fromHex("#ffa500"),
            Color3.fromHex("#ffff00"),
            Color3.fromHex("#008000"),
            Color3.fromHex("#42aaff"),
            Color3.fromHex("#0000ff"),
            Color3.fromHex("#8b00ff")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
    KeySystem = {
        Title = "bot check",
        Note = "Key: 1234",
        KeyValidator = function(EnteredKey)
            return EnteredKey == "1234"
        end
    }
})

-- Радужный таг
local rainbowTag = Window:Tag({
    Title = "1.0.0",
    Icon = "github",
    Color = Color3.fromHex("#ffff00"),
    Border = true,
})

-- Радужный эффект для тага
task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.01) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        rainbowTag:SetColor(rainbowColor)
        task.wait(0.05)
    end
end)

-- Таб Player (красный)
local PlayerTab = Window:Tab({
    Title = "Player",
    Desc = "Player Modifications",
    Icon = "user",
    IconColor = Color3.fromHex("#FF0000"),
})

-- Секция SpeedHack
local SpeedHackSection = PlayerTab:Section({
    Title = "SpeedHack",
    Opened = true,
    Box = true
})

local speed = 50
local speedEnabled = false
local speedConnection = nil

-- Слайдер для скорости
SpeedHackSection:Slider({
    Title = "Speed",
    Desc = "Set speed value (1-500)",
    Flag = "speedValue",
    Value = { Min = 1, Max = 500, Default = 50 },
    Callback = function(value)
        speed = value
    end
})

-- Toggle для включения
SpeedHackSection:Toggle({
    Title = "On",
    Desc = "Enable/Disable SpeedHack",
    Flag = "speedToggle",
    Value = false,
    Callback = function(state)
        speedEnabled = state
        
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        if not state then
            WindUI:Notify({
                Title = "SpeedHack",
                Content = "SpeedHack disabled",
                Icon = "x",
                Duration = 2
            })
            return
        end
        
        WindUI:Notify({
            Title = "SpeedHack",
            Content = "SpeedHack enabled (Speed: " .. speed .. ")",
            Icon = "check",
            Duration = 2
        })
        
        -- SpeedHack логика
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        
        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character
        if not Character then
            Character = LocalPlayer.CharacterAdded:Wait()
        end
        
        speedConnection = RunService.Heartbeat:Connect(function()
            if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local mv = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    mv = mv + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    mv = mv - LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    mv = mv - LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    mv = mv + LocalPlayer.Character.HumanoidRootPart.CFrame.RightVector
                end
                
                if mv.Magnitude > 0 then
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(
                        mv.Unit.X * speed,
                        LocalPlayer.Character.HumanoidRootPart.Velocity.Y,
                        mv.Unit.Z * speed
                    )
                end
            end
        end)
    end
})

-- Кнопка открытия окна на правый Alt
local UserInputService = game:GetService("UserInputService")

local function toggleWindow()
    if Window:IsOpen() then
        Window:Hide()
    else
        Window:Show()
    end
end

-- Обработка нажатия правого Alt
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftAlt then
        toggleWindow()
    end
end)

-- Очистка при смене персонажа
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if speedEnabled then
        task.wait(0.5)
        speedEnabled = false
        speedEnabled = true
    end
end)
