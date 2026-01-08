local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'The Intruder script. Location:Mine. By Likegenm Team',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local PT = Window:AddTab('LocalPlayer')

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local SGB = PT:AddLeftGroupbox('SpeedHack')

local velocitySpeed = 16
local velocityEnabled = false
local velocityConnection

local function SetupVelocityMovement(speed)
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not Character or not HumanoidRootPart then return end
    
    local cameraCFrame = Camera.CFrame
    local lookVector = cameraCFrame.LookVector
    local rightVector = cameraCFrame.RightVector
    
    local mv = Vector3.new(0, 0, 0)

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        mv = mv + Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        mv = mv - Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        mv = mv - Vector3.new(rightVector.X, 0, rightVector.Z).Unit
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        mv = mv + Vector3.new(rightVector.X, 0, rightVector.Z).Unit
    end
    
    if mv.Magnitude > 0 then
        HumanoidRootPart.Velocity = Vector3.new(
            mv.X * speed,
            HumanoidRootPart.Velocity.Y,
            mv.Z * speed
        )
    end
end

SGB:AddSlider('Speedhack', {
    Text = 'Speed:',
    Default = 16,
    Min = 12,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        velocitySpeed = Value
    end
})

SGB:AddToggle('SpeedToggle', {
    Text = 'Enable Speed',
    Default = false,
    Tooltip = 'Toggle velocity movement',
    Callback = function(Value)
        velocityEnabled = Value
        
        if Value then
            velocityConnection = RunService.Heartbeat:Connect(function()
                if velocityEnabled then
                    SetupVelocityMovement(velocitySpeed)
                end
            end)
        else
            if velocityConnection then
                velocityConnection:Disconnect()
                velocityConnection = nil
            end
        end
    end
})

local FGB = PT:AddRightGroupbox('Fly')

local flySpeed = 40
local flyEnabled = false
local flyConnection
local flyTween

local function SetupFly(speed)
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local camera = workspace.CurrentCamera
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    local targetVelocity = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        targetVelocity = targetVelocity + lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        targetVelocity = targetVelocity - lookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        targetVelocity = targetVelocity - rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        targetVelocity = targetVelocity + rightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        targetVelocity = targetVelocity + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        targetVelocity = targetVelocity + Vector3.new(0, -1, 0)
    end
    
    if targetVelocity.Magnitude > 0 then
        targetVelocity = targetVelocity.Unit * speed
    end
    
    if flyTween then
        flyTween:Cancel()
    end
    
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        0.1,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    flyTween = TweenService:Create(humanoidRootPart, tweenInfo, {Velocity = targetVelocity})
    flyTween:Play()
end

FGB:AddSlider('FlySpeed', {
    Text = 'Fly Speed:',
    Default = 40,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        flySpeed = Value
    end
})

FGB:AddToggle('FlyToggle', {
    Text = 'Enable Fly',
    Default = false,
    Tooltip = 'Toggle fly',
    Callback = function(Value)
        flyEnabled = Value
        
        if Value then
            flyConnection = RunService.Heartbeat:Connect(function()
                if flyEnabled then
                    SetupFly(flySpeed)
                end
            end)
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            
            if flyTween then
                flyTween:Cancel()
                flyTween = nil
            end
            
            local character = Players.LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

local VisualTab = Window:AddTab('Visual')

local AmbientGB = VisualTab:AddLeftGroupbox('Ambient')

local ambientEnabled = false
local ambientColor = Color3.new(1, 0, 0)
local ambientRainbow = false
local ambientConnection
local ambientRainbowConnection

local function ApplyAmbient()
    local lighting = game:GetService("Lighting")
    lighting.OutdoorAmbient = ambientColor
    lighting.Ambient = ambientColor
end

local function ResetAmbient()
    local lighting = game:GetService("Lighting")
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
end

AmbientGB:AddToggle('AmbientToggle', {
    Text = 'Ambient',
    Default = false,
    Tooltip = 'Toggle ambient color',
    Callback = function(Value)
        ambientEnabled = Value
        
        if Value then
            ambientConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if ambientEnabled then
                    ApplyAmbient()
                end
            end)
            ApplyAmbient()
        else
            if ambientConnection then
                ambientConnection:Disconnect()
                ambientConnection = nil
            end
            ResetAmbient()
        end
    end
})

AmbientGB:AddLabel('Ambient Color'):AddColorPicker('AmbientColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'Ambient Color',
    Transparency = 0,
    
    Callback = function(Value)
        ambientColor = Value
        if ambientEnabled then
            ApplyAmbient()
        end
    end
})

AmbientGB:AddToggle('AmbientRainbow', {
    Text = 'Rainbow Ambient',
    Default = false,
    Tooltip = 'Toggle rainbow ambient color',
    Callback = function(Value)
        ambientRainbow = Value
        
        if Value then
            ambientRainbowConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not ambientRainbow then return end
                
                local hue = tick() % 5 / 5
                ambientColor = Color3.fromHSV(hue, 1, 1)
                
                if ambientEnabled then
                    ApplyAmbient()
                end
            end)
        else
            if ambientRainbowConnection then
                ambientRainbowConnection:Disconnect()
                ambientRainbowConnection = nil
            end
        end
    end
})

local FullBrightGB = VisualTab:AddRightGroupbox('FullBright')

local fullBrightEnabled = false
local fullBrightConnection

local function ApplyFullBright()
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.new(1, 1, 1)
    lighting.Brightness = 2
    lighting.GlobalShadows = false
    lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    lighting.FogEnd = 100000
    lighting.FogStart = 0
end

local function ResetLighting()
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    lighting.Brightness = 1
    lighting.GlobalShadows = true
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    lighting.FogEnd = 100000
    lighting.FogStart = 100
end

FullBrightGB:AddToggle('FullBrightToggle', {
    Text = 'FullBright',
    Default = false,
    Tooltip = 'Toggle FullBright',
    Callback = function(Value)
        fullBrightEnabled = Value
        
        if Value then
            fullBrightConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if fullBrightEnabled then
                    ApplyFullBright()
                end
            end)
            ApplyFullBright()
        else
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end
            ResetLighting()
        end
    end
})

local IntruderGB = VisualTab:AddLeftGroupbox('Intruder')

local intruderChamsEnabled = false
local intruderNameEnabled = false
local intruderDistanceEnabled = false
local intruderTracersEnabled = false
local intruderRainbow = false
local intruderChamsColor = Color3.new(1, 0, 0)
local intruderChamsHighlight = nil
local intruderBillboard = nil
local intruderTracer = nil
local intruderUpdateConnection = nil
local intruderRainbowConnection = nil

local function UpdateIntruderESP()
    local intruder = workspace:FindFirstChild("Intruder")
    local localPlayer = game:GetService("Players").LocalPlayer
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if intruderChamsEnabled and intruder then
        if not intruderChamsHighlight then
            intruderChamsHighlight = Instance.new("Highlight")
            intruderChamsHighlight.Name = "IntruderChams"
            intruderChamsHighlight.FillColor = intruderChamsColor
            intruderChamsHighlight.OutlineColor = Color3.new(1, 1, 0)
            intruderChamsHighlight.FillTransparency = 0.3
            intruderChamsHighlight.OutlineTransparency = 0
            intruderChamsHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            intruderChamsHighlight.Adornee = intruder
            intruderChamsHighlight.Parent = intruder
        else
            intruderChamsHighlight.Adornee = intruder
            intruderChamsHighlight.Parent = intruder
        end
    else
        if intruderChamsHighlight then
            intruderChamsHighlight:Destroy()
            intruderChamsHighlight = nil
        end
    end
    
    if intruderNameEnabled and intruder then
        if not intruderBillboard then
            intruderBillboard = Instance.new("BillboardGui")
            intruderBillboard.Name = "IntruderName"
            intruderBillboard.Size = UDim2.new(0, 200, 0, 50)
            intruderBillboard.StudsOffset = Vector3.new(0, 5, 0)
            intruderBillboard.AlwaysOnTop = true
            intruderBillboard.MaxDistance = 500
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "INTRUDER"
            textLabel.TextColor3 = Color3.new(1, 0, 0)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 16
            textLabel.Parent = intruderBillboard
            
            intruderBillboard.Parent = intruder
        else
            intruderBillboard.Parent = intruder
            
            local textLabel = intruderBillboard:FindFirstChild("TextLabel")
            if textLabel and rootPart then
                local distanceText = "INTRUDER"
                if intruderDistanceEnabled then
                    local intruderPos = intruder:GetPivot().Position
                    local distance = (intruderPos - rootPart.Position).Magnitude
                    distanceText = string.format("INTRUDER [%.1f studs]", distance)
                end
                textLabel.Text = distanceText
            end
        end
    else
        if intruderBillboard then
            intruderBillboard:Destroy()
            intruderBillboard = nil
        end
    end
    
    if intruderTracersEnabled and intruder and rootPart then
        if not intruderTracer then
            intruderTracer = Instance.new("Beam")
            intruderTracer.Name = "IntruderTracer"
            intruderTracer.Color = ColorSequence.new(intruderChamsColor)
            intruderTracer.Width0 = 0.2
            intruderTracer.Width1 = 0.2
            intruderTracer.Texture = "rbxassetid://446111271"
            intruderTracer.TextureLength = 10
            intruderTracer.TextureMode = Enum.TextureMode.Wrap
            intruderTracer.TextureSpeed = 2
            intruderTracer.ZOffset = 1
            
            local intruderAttachment = Instance.new("Attachment")
            intruderAttachment.Name = "TracerAttachment"
            intruderAttachment.Parent = intruder
            
            local localAttachment = Instance.new("Attachment")
            localAttachment.Name = "TracerAttachment"
            localAttachment.Parent = rootPart
            
            intruderTracer.Attachment0 = intruderAttachment
            intruderTracer.Attachment1 = localAttachment
            intruderTracer.Parent = workspace
        else
            intruderTracer.Enabled = true
            local intruderPos = intruder:GetPivot().Position
            intruderTracer.Attachment0.Parent = intruder
            intruderTracer.Attachment1.Parent = rootPart
        end
    else
        if intruderTracer then
            intruderTracer.Enabled = false
        end
    end
    
    if intruderRainbow and intruderChamsHighlight then
        local hue = tick() % 5 / 5
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        intruderChamsHighlight.FillColor = rainbowColor
        
        if intruderTracer then
            intruderTracer.Color = ColorSequence.new(rainbowColor)
        end
        
        if intruderBillboard then
            local textLabel = intruderBillboard:FindFirstChild("TextLabel")
            if textLabel then
                textLabel.TextColor3 = rainbowColor
            end
        end
    elseif not intruderRainbow then
        if intruderChamsHighlight then
            intruderChamsHighlight.FillColor = intruderChamsColor
        end
        if intruderTracer then
            intruderTracer.Color = ColorSequence.new(intruderChamsColor)
        end
        if intruderBillboard then
            local textLabel = intruderBillboard:FindFirstChild("TextLabel")
            if textLabel then
                textLabel.TextColor3 = Color3.new(1, 0, 0)
            end
        end
    end
end

IntruderGB:AddToggle('IntruderChams', {
    Text = 'Intruder Chams',
    Default = false,
    Tooltip = 'Show chams on intruder',
    Callback = function(Value)
        intruderChamsEnabled = Value
        
        if Value or intruderNameEnabled or intruderTracersEnabled then
            if not intruderUpdateConnection then
                intruderUpdateConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    UpdateIntruderESP()
                end)
            end
            UpdateIntruderESP()
        else
            if intruderUpdateConnection then
                intruderUpdateConnection:Disconnect()
                intruderUpdateConnection = nil
            end
            
            if intruderChamsHighlight then
                intruderChamsHighlight:Destroy()
                intruderChamsHighlight = nil
            end
        end
    end
})

IntruderGB:AddToggle('NameIntruder', {
    Text = 'Name Intruder',
    Default = false,
    Tooltip = 'Show name above intruder',
    Callback = function(Value)
        intruderNameEnabled = Value
        
        if Value or intruderChamsEnabled or intruderTracersEnabled then
            if not intruderUpdateConnection then
                intruderUpdateConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    UpdateIntruderESP()
                end)
            end
            UpdateIntruderESP()
        else
            if intruderUpdateConnection then
                intruderUpdateConnection:Disconnect()
                intruderUpdateConnection = nil
            end
            
            if intruderBillboard then
                intruderBillboard:Destroy()
                intruderBillboard = nil
            end
        end
    end
})

IntruderGB:AddToggle('ShowDistance', {
    Text = 'Show Distance',
    Default = false,
    Tooltip = 'Show distance to intruder',
    Callback = function(Value)
        intruderDistanceEnabled = Value
        UpdateIntruderESP()
    end
})

IntruderGB:AddToggle('IntruderTracers', {
    Text = 'Intruder Tracers',
    Default = false,
    Tooltip = 'Show tracers to intruder',
    Callback = function(Value)
        intruderTracersEnabled = Value
        
        if Value or intruderChamsEnabled or intruderNameEnabled then
            if not intruderUpdateConnection then
                intruderUpdateConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    UpdateIntruderESP()
                end)
            end
            UpdateIntruderESP()
        else
            if intruderUpdateConnection then
                intruderUpdateConnection:Disconnect()
                intruderUpdateConnection = nil
            end
            
            if intruderTracer then
                intruderTracer:Destroy()
                intruderTracer = nil
            end
        end
    end
})

IntruderGB:AddLabel('Chams Color'):AddColorPicker('IntruderChamsColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'Intruder Chams Color',
    Transparency = 0,
    
    Callback = function(Value)
        intruderChamsColor = Value
        if intruderChamsHighlight then
            intruderChamsHighlight.FillColor = Value
        end
        if intruderTracer then
            intruderTracer.Color = ColorSequence.new(Value)
        end
    end
})

IntruderGB:AddToggle('RainbowChams', {
    Text = 'Rainbow Chams',
    Default = false,
    Tooltip = 'Toggle rainbow chams color',
    Callback = function(Value)
        intruderRainbow = Value
        
        if Value then
            intruderRainbowConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not intruderRainbow then return end
                UpdateIntruderESP()
            end)
        else
            if intruderRainbowConnection then
                intruderRainbowConnection:Disconnect()
                intruderRainbowConnection = nil
            end
            UpdateIntruderESP()
        end
    end
})

IntruderGB:AddButton({
    Text = 'Kill Intruder',
    Func = function()
        local intruder = workspace:FindFirstChild("Intruder")
        if intruder then
            intruder:Destroy()
            
            if intruderChamsHighlight then
                intruderChamsHighlight:Destroy()
                intruderChamsHighlight = nil
            end
            
            if intruderBillboard then
                intruderBillboard:Destroy()
                intruderBillboard = nil
            end
            
            if intruderTracer then
                intruderTracer:Destroy()
                intruderTracer = nil
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Destroy intruder'
})

local UITab = Window:AddTab('UI Settings')
local MenuGroup = UITab:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload',
    Func = function()
        if ambientConnection then ambientConnection:Disconnect() end
        if ambientRainbowConnection then ambientRainbowConnection:Disconnect() end
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        if intruderUpdateConnection then intruderUpdateConnection:Disconnect() end
        if intruderRainbowConnection then intruderRainbowConnection:Disconnect() end
        ResetAmbient()
        ResetLighting()
        
        if intruderChamsHighlight then
            intruderChamsHighlight:Destroy()
            intruderChamsHighlight = nil
        end
        
        if intruderBillboard then
            intruderBillboard:Destroy()
            intruderBillboard = nil
        end
        
        if intruderTracer then
            intruderTracer:Destroy()
            intruderTracer = nil
        end
        
        Library:Unload() 
    end,
    DoubleClick = false,
    Tooltip = 'Unload script'
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { 
    Default = 'RightShift', 
    NoUI = true, 
    Text = 'Menu keybind' 
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('IntruderScript')

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:SetFolder('IntruderScript/game')

SaveManager:BuildConfigSection(UITab)
ThemeManager:ApplyToTab(UITab)
SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark(('Intruder Script | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if ambientConnection then ambientConnection:Disconnect() end
    if ambientRainbowConnection then ambientRainbowConnection:Disconnect() end
    if fullBrightConnection then fullBrightConnection:Disconnect() end
    if intruderUpdateConnection then intruderUpdateConnection:Disconnect() end
    if intruderRainbowConnection then intruderRainbowConnection:Disconnect() end
    ResetAmbient()
    ResetLighting()
    
    if intruderChamsHighlight then
        intruderChamsHighlight:Destroy()
        intruderChamsHighlight = nil
    end
    
    if intruderBillboard then
        intruderBillboard:Destroy()
        intruderBillboard = nil
    end
    
    if intruderTracer then
        intruderTracer:Destroy()
        intruderTracer = nil
    end
    
    Library.Unloaded = true
end)
