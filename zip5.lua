local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Magic Tulevo Script',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Player = Window:AddTab('Player'),
    Visual = Window:AddTab('Visual'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local SpeedGroup = Tabs.Player:AddLeftGroupbox('SpeedHack')

SpeedGroup:AddSlider('SpeedValue', {
    Text = 'Speed',
    Default = 50,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Suffix = ' studs',
    Compact = false,
})

SpeedGroup:AddToggle('SpeedToggle', {
    Text = 'Enable SpeedHack',
    Default = false,
    Tooltip = 'Hold WASD to use speedhack',
})

local speedEnabled = false
local speed = 50
local speedConnection = nil

Options.SpeedValue:OnChanged(function()
    speed = Options.SpeedValue.Value
end)

Toggles.SpeedToggle:OnChanged(function()
    speedEnabled = Toggles.SpeedToggle.Value
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if not speedEnabled then
        return
    end

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
end)

local ChamsGroup = Tabs.Visual:AddLeftGroupbox('Chams')

ChamsGroup:AddToggle('ChamsToggle', {
    Text = 'Enable Chams',
    Default = false,
})

ChamsGroup:AddLabel('Chams Color'):AddColorPicker('ChamsColor', {
    Default = Color3.new(0, 1, 0),
    Title = 'Chams Color',
})

ChamsGroup:AddToggle('ChamsRainbow', {
    Text = 'Rainbow Chams',
    Default = false,
})

local chamsEnabled = false
local chamsRainbow = false
local chamHighlights = {}
local chamsRainbowThread = nil

Toggles.ChamsToggle:OnChanged(function()
    chamsEnabled = Toggles.ChamsToggle.Value

    for player, highlight in pairs(chamHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end
    chamHighlights = {}
    
    if chamsRainbowThread then
        chamsRainbowThread = nil
    end
    
    if not chamsEnabled then
        return
    end

    task.spawn(function()
        while chamsEnabled do
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    if not chamHighlights[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ChamsHighlight"
                        highlight.Adornee = player.Character
                        highlight.FillColor = chamsRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Options.ChamsColor.Value
                        highlight.OutlineColor = chamsRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Options.ChamsColor.Value
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = workspace
                        
                        chamHighlights[player] = highlight
                    end
                elseif chamHighlights[player] then
                    chamHighlights[player]:Destroy()
                    chamHighlights[player] = nil
                end
            end
            task.wait(0.1)
        end
    end)

    if chamsRainbow and chamsEnabled then
        chamsRainbowThread = task.spawn(function()
            while chamsRainbow and chamsEnabled do
                for player, highlight in pairs(chamHighlights) do
                    if highlight then
                        highlight.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        highlight.OutlineColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

Toggles.ChamsRainbow:OnChanged(function()
    chamsRainbow = Toggles.ChamsRainbow.Value
    
    if chamsRainbowThread then
        chamsRainbowThread = nil
    end
    
    if chamsRainbow and chamsEnabled then
        chamsRainbowThread = task.spawn(function()
            while chamsRainbow and chamsEnabled do
                for player, highlight in pairs(chamHighlights) do
                    if highlight then
                        highlight.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        highlight.OutlineColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    end
                end
                task.wait(0.1)
            end
        end)
    end

    if not chamsRainbow and chamsEnabled then
        for player, highlight in pairs(chamHighlights) do
            if highlight then
                highlight.FillColor = Options.ChamsColor.Value
                highlight.OutlineColor = Options.ChamsColor.Value
            end
        end
    end
end)

Options.ChamsColor:OnChanged(function()
    if not chamsRainbow and chamsEnabled then
        for player, highlight in pairs(chamHighlights) do
            if highlight then
                highlight.FillColor = Options.ChamsColor.Value
                highlight.OutlineColor = Options.ChamsColor.Value
            end
        end
    end
end)

local NameGroup = Tabs.Visual:AddLeftGroupbox('Name ESP')

NameGroup:AddToggle('NameToggle', {
    Text = 'Enable Name ESP',
    Default = false,
})

local nameEnabled = false
local nameBillboards = {}
local nameThread = nil

Toggles.NameToggle:OnChanged(function()
    nameEnabled = Toggles.NameToggle.Value
    
    if nameThread then
        nameThread = nil
    end

    for player, billboard in pairs(nameBillboards) do
        if billboard then
            billboard:Destroy()
        end
    end
    nameBillboards = {}
    
    if not nameEnabled then
        return
    end

    nameThread = task.spawn(function()
        local localPlayer = game.Players.LocalPlayer
        
        while nameEnabled do
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    
                    if head then
                        if not nameBillboards[player] then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "NameESP"
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Adornee = head
                            billboard.Parent = head
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.Text = player.Name
                            textLabel.TextColor3 = Color3.new(1, 1, 1)
                            textLabel.TextStrokeTransparency = 0.5
                            textLabel.TextSize = 14
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.Parent = billboard
                            
                            nameBillboards[player] = billboard
                        end
                    end
                elseif nameBillboards[player] then
                    nameBillboards[player]:Destroy()
                    nameBillboards[player] = nil
                end
            end
            task.wait(0.5)
        end
    end)
end)

local DistanceGroup = Tabs.Visual:AddRightGroupbox('Distance ESP')

DistanceGroup:AddToggle('DistanceToggle', {
    Text = 'Enable Distance ESP',
    Default = false,
})

local distanceEnabled = false
local distanceBillboards = {}
local distanceThread = nil

Toggles.DistanceToggle:OnChanged(function()
    distanceEnabled = Toggles.DistanceToggle.Value
    
    if distanceThread then
        distanceThread = nil
    end

    for player, billboard in pairs(distanceBillboards) do
        if billboard then
            billboard:Destroy()
        end
    end
    distanceBillboards = {}
    
    if not distanceEnabled then
        return
    end

    distanceThread = task.spawn(function()
        local localPlayer = game.Players.LocalPlayer
        local localCharacter = localPlayer.Character
        local localHead = localCharacter and localCharacter:FindFirstChild("Head")
        
        while distanceEnabled do
            if localHead then
                local myPosition = localHead.Position
                
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        
                        if head then
                            if not distanceBillboards[player] then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Name = "DistanceESP"
                                billboard.Size = UDim2.new(0, 100, 0, 30)
                                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Adornee = head
                                billboard.Parent = head
                                
                                local textLabel = Instance.new("TextLabel")
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.Text = "0 studs"
                                textLabel.TextColor3 = Color3.new(1, 1, 0)
                                textLabel.TextStrokeTransparency = 0.5
                                textLabel.TextSize = 12
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.Parent = billboard
                                
                                distanceBillboards[player] = billboard
                            end

                            local distance = math.floor((head.Position - myPosition).Magnitude)
                            local billboard = distanceBillboards[player]
                            if billboard then
                                local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                                if textLabel then
                                    textLabel.Text = distance .. " studs"
                                    
                                    -- Меняем цвет в зависимости от расстояния
                                    if distance < 20 then
                                        textLabel.TextColor3 = Color3.new(1, 0, 0)
                                    elseif distance < 50 then
                                        textLabel.TextColor3 = Color3.new(1, 1, 0)
                                    else
                                        textLabel.TextColor3 = Color3.new(0, 1, 0)
                                    end
                                end
                            end
                        end
                    elseif distanceBillboards[player] then
                        distanceBillboards[player]:Destroy()
                        distanceBillboards[player] = nil
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

local AmbientGroup = Tabs.Visual:AddRightGroupbox('Ambient')

AmbientGroup:AddLabel('Ambient Color'):AddColorPicker('AmbientColor', {
    Default = Color3.new(0, 0, 1),
    Title = 'Ambient Color',
})

AmbientGroup:AddToggle('AmbientRainbow', {
    Text = 'Rainbow Ambient',
    Default = false,
})

AmbientGroup:AddToggle('AmbientToggle', {
    Text = 'Enable Ambient',
    Default = false,
})

local ambientEnabled = false
local ambientRainbow = false
local ambientThread = nil
local ambientRainbowThread = nil

Toggles.AmbientToggle:OnChanged(function()
    ambientEnabled = Toggles.AmbientToggle.Value
    
    if ambientThread then
        ambientThread = nil
    end
    
    if ambientRainbowThread then
        ambientRainbowThread = nil
    end
    
    if not ambientEnabled then
        game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        return
    end

    ambientThread = task.spawn(function()
        while ambientEnabled do
            game.Lighting.OutdoorAmbient = ambientRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Options.AmbientColor.Value
            task.wait(0.1)
        end
    end)

    if ambientRainbow and ambientEnabled then
        ambientRainbowThread = task.spawn(function()
            while ambientRainbow and ambientEnabled do
                game.Lighting.OutdoorAmbient = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                task.wait(0.1)
            end
        end)
    end
end)

Toggles.AmbientRainbow:OnChanged(function()
    ambientRainbow = Toggles.AmbientRainbow.Value
    
    if ambientRainbowThread then
        ambientRainbowThread = nil
    end
    
    if ambientRainbow and ambientEnabled then
        ambientRainbowThread = task.spawn(function()
            while ambientRainbow and ambientEnabled do
                game.Lighting.OutdoorAmbient = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                task.wait(0.1)
            end
        end)
    elseif ambientEnabled then
        game.Lighting.OutdoorAmbient = Options.AmbientColor.Value
    end
end)

Options.AmbientColor:OnChanged(function()
    if not ambientRainbow and ambientEnabled then
        game.Lighting.OutdoorAmbient = Options.AmbientColor.Value
    end
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() 
    Library:Unload() 
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { 
    Default = 'End', 
    NoUI = true, 
    Text = 'Menu keybind' 
})

-- Клавиша для показа/скрытия UI (правый Alt)
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
        Library:ToggleUI()
    end
end)

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

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MagicTulevo')
SaveManager:SetFolder('MagicTulevo/' .. game.PlaceId)

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    if chamsRainbowThread then
        chamsRainbowThread = nil
    end
    
    if nameThread then
        nameThread = nil
    end
    
    if distanceThread then
        distanceThread = nil
    end
    
    if ambientThread then
        ambientThread = nil
    end
    
    if ambientRainbowThread then
        ambientRainbowThread = nil
    end
    
    -- Очищаем объекты
    for player, highlight in pairs(chamHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end
    
    for player, billboard in pairs(nameBillboards) do
        if billboard then
            billboard:Destroy()
        end
    end
    
    for player, billboard in pairs(distanceBillboards) do
        if billboard then
            billboard:Destroy()
        end
    end

    game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    
    Library.Unloaded = true
end)
