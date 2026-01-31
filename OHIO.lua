local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
	Title = "Likegenm scripts",
	Footer = "OHIO script",
	Icon = 95816097006870,
	ToggleKeybind = Enum.KeyCode.RightAlt,
	NotifySide = "Right",
	ShowCustomCursor = false,
})

local LPTab = Window:AddTab("LocalPlayer", "user")

local Tabbox = LPTab:AddLeftTabbox("Humanoid functions")
local Tab1 = Tabbox:AddTab("Speedhack")

local speedEnabled = false
local speedValue = 16

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character
local HumanoidRootPart

local function setupCharacter()
    if LocalPlayer.Character then
        Character = LocalPlayer.Character
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    end
end

setupCharacter()

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

Tab1:AddToggle("Speed Enabled", {
    Text = "Enable Speed Hack",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
    end
})

Tab1:AddSlider("Speed Value", {
    Text = "Speed:",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        speedValue = Value
    end
})

RunService.Heartbeat:Connect(function()
    if not speedEnabled then return end
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
            mv.X * speedValue,
            HumanoidRootPart.Velocity.Y,
            mv.Z * speedValue
        )
    end
end)

local Tab2 = Tabbox:AddTab("Jumphack")

local jumpPowerValue = 50
local infiniteJumpEnabled = false

Tab2:AddSlider("Jump Power", {
    Text = "Jump Height:",
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        jumpPowerValue = Value
        
        if Character then
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end
})

Tab2:AddToggle("Infinite Jump", {
    Text = "Enable Infinite Jump",
    Default = false,
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        if Character then
            local humanoid = Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local Tab3 = Tabbox:AddTab("Fly")

local flyEnabled = false
local flySpeed = 50

Tab3:AddToggle("Fly Enabled", {
    Text = "Enable Fly",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
    end
})

Tab3:AddSlider("Fly Speed", {
    Text = "Fly Speed:",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        flySpeed = Value
    end
})

local flying = false
local flyVelocity = Vector3.new(0, 0, 0)
local flyBV = nil
local flyBG = nil

RunService.Heartbeat:Connect(function()
    if not flyEnabled then
        if flying then
            if flyBV then
                flyBV:Destroy()
                flyBV = nil
            end
            if flyBG then
                flyBG:Destroy()
                flyBG = nil
            end
            flying = false
        end
        return
    end
    
    if not Character or not HumanoidRootPart then return end
    
    if not flying then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "FlyBodyVelocity"
        flyBV.P = 10000
        flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = HumanoidRootPart
        
        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "FlyBodyGyro"
        flyBG.P = 10000
        flyBG.MaxTorque = Vector3.new(10000, 10000, 10000)
        flyBG.CFrame = HumanoidRootPart.CFrame
        flyBG.Parent = HumanoidRootPart
        
        flying = true
    end
    
    flyVelocity = Vector3.new(0, 0, 0)
    
    local cameraCFrame = Camera.CFrame
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        flyVelocity = flyVelocity + (cameraCFrame.LookVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        flyVelocity = flyVelocity - (cameraCFrame.LookVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        flyVelocity = flyVelocity - (cameraCFrame.RightVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        flyVelocity = flyVelocity + (cameraCFrame.RightVector * flySpeed)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        flyVelocity = flyVelocity + Vector3.new(0, flySpeed, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        flyVelocity = flyVelocity - Vector3.new(0, flySpeed, 0)
    end
    
    if flyVelocity.Magnitude > 0 then
        flyVelocity = flyVelocity.Unit * flySpeed
    else
        flyVelocity = Vector3.new(0, 0, 0)
    end
    
    if flyBV then
        flyBV.Velocity = flyVelocity
    end
    
    if flyBG then
        flyBG.CFrame = cameraCFrame
    end
end)

local Tabbox2 = LPTab:AddRightTabbox("Utility functions")
local Tab4 = Tabbox2:AddTab("Noclip")
local Tab5 = Tabbox2:AddTab("Spin")
local Tab6 = Tabbox2:AddTab("Mouse Teleport")

local noclipEnabled = false

Tab4:AddToggle("Noclip Enabled", {
    Text = "Enable Noclip",
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
    end
})

RunService.Stepped:Connect(function()
    if not noclipEnabled then return end
    if not Character then return end
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

local spinEnabled = false
local spinSpeed = 5

Tab5:AddToggle("Spin Enabled", {
    Text = "Enable Spin",
    Default = false,
    Callback = function(Value)
        spinEnabled = Value
    end
})

Tab5:AddSlider("Spin Speed", {
    Text = "Spin Speed:",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        spinSpeed = Value
    end
})

RunService.Heartbeat:Connect(function()
    if not spinEnabled then return end
    if not Character or not HumanoidRootPart then return end
    
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360 * spinSpeed * 0.01), 0)
end)

local mouseTpEnabled = false

Tab6:AddToggle("Mouse Teleport", {
    Text = "Enable Mouse Teleport",
    Default = false,
    Callback = function(Value)
        mouseTpEnabled = Value
    end
})

Tab6:AddButton("Teleport to Mouse", {
    Text = "Click to Teleport",
    Func = function()
        if not Character or not HumanoidRootPart then return end
        
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Hit.Position
        
        HumanoidRootPart.CFrame = CFrame.new(target)
    end
})

UserInputService.InputBegan:Connect(function(input)
    if not mouseTpEnabled then return end
    if not Character or not HumanoidRootPart then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Hit.Position + Vector3.new(0, 3, 0)
        
        HumanoidRootPart.CFrame = CFrame.new(target)
    end
end)

local Tabbox3 = LPTab:AddLeftTabbox("Fling Functions")
local Tab7 = Tabbox3:AddTab("Touch Fling")
local Tab8 = Tabbox3:AddTab("Anti Fling")
local Tab9 = Tabbox3:AddTab("Safe Zone")

local touchFlingEnabled = false
local touchFlingThread

Tab7:AddToggle("Touch Fling", {
    Text = "Enable Touch Fling",
    Default = false,
    Callback = function(Value)
        touchFlingEnabled = Value
        
        if Value then
            touchFlingThread = coroutine.create(function()
                local hiddenfling = true
                
                while hiddenfling and touchFlingEnabled do
                    RunService.Heartbeat:Wait()
                    local c = LocalPlayer.Character
                    local hrp = c and c:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        local vel = hrp.Velocity
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        RunService.RenderStepped:Wait()
                        hrp.Velocity = vel
                        RunService.Stepped:Wait()
                        hrp.Velocity = vel + Vector3.new(0, 0.1, 0)
                    end
                end
            end)
            
            coroutine.resume(touchFlingThread)
        end
    end
})

Tab7:AddButton("Reset Fling", {
    Text = "Reset Fling Velocity",
    Func = function()
        if Character and HumanoidRootPart then
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
})

local antiFlingEnabled = false
local LastPosition = nil

Tab8:AddToggle("Anti Fling", {
    Text = "Enable Anti Fling",
    Default = false,
    Callback = function(Value)
        antiFlingEnabled = Value
    end
})

RunService.Heartbeat:Connect(function()
    if not antiFlingEnabled then return end
    
    pcall(function()
        local PrimaryPart = Character and Character.PrimaryPart
        if PrimaryPart then
            if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                
                if LastPosition then
                    PrimaryPart.CFrame = LastPosition
                end
            elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude < 50 then
                LastPosition = PrimaryPart.CFrame
            end
        end
    end)
end)

local safeZoneEnabled = false
local safeZonePlatform = nil
local savedPosition = nil
local platformSize = 500
local teleportingToSaved = false

Tab9:AddToggle("Safe Zone", {
    Text = "Enable Safe Zone",
    Default = false,
    Callback = function(Value)
        safeZoneEnabled = Value
        
        if Value then
            createSafeZone()
        else
            removeSafeZone()
        end
    end
})

Tab9:AddSlider("Platform Size", {
    Text = "Platform Size:",
    Default = 500,
    Min = 100,
    Max = 1000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        platformSize = Value
        if safeZoneEnabled and safeZonePlatform then
            safeZonePlatform.Size = Vector3.new(platformSize, 1, platformSize)
        end
    end
})

Tab9:AddButton("Save Current Position", {
    Text = "Save Position",
    Func = function()
        if Character and HumanoidRootPart then
            savedPosition = HumanoidRootPart.Position
        end
    end
})

Tab9:AddButton("Teleport to Saved", {
    Text = "Teleport to Saved",
    Func = function()
        if Character and HumanoidRootPart and savedPosition then
            teleportingToSaved = true
            HumanoidRootPart.CFrame = CFrame.new(savedPosition)
            teleportingToSaved = false
        end
    end
})

Tab9:AddButton("Teleport to Platform", {
    Text = "Teleport to Platform",
    Func = function()
        if Character and HumanoidRootPart and safeZonePlatform then
            local platformPos = safeZonePlatform.Position
            HumanoidRootPart.CFrame = CFrame.new(platformPos.X, platformPos.Y + 5, platformPos.Z)
        end
    end
})

local function createSafeZone()
    if safeZonePlatform then
        safeZonePlatform:Destroy()
    end
    
    safeZonePlatform = Instance.new("Part")
    safeZonePlatform.Name = "SafeZonePlatform"
    safeZonePlatform.Size = Vector3.new(platformSize, 1, platformSize)
    safeZonePlatform.Anchored = true
    safeZonePlatform.CanCollide = true
    safeZonePlatform.Transparency = 0.7
    safeZonePlatform.Color = Color3.new(0, 0, 0)
    safeZonePlatform.Material = Enum.Material.Neon
    safeZonePlatform.Parent = workspace
    
    RunService.Heartbeat:Connect(function()
        if not safeZoneEnabled then return end
        if not Character or not HumanoidRootPart then return end
        if not safeZonePlatform then return end
        
        local playerPos = HumanoidRootPart.Position
        safeZonePlatform.Position = Vector3.new(playerPos.X, -100, playerPos.Z)
    end)
end

local function removeSafeZone()
    if safeZonePlatform then
        safeZonePlatform:Destroy()
        safeZonePlatform = nil
    end
end

local function saveOnTeleport()
    local lastSavedPos = nil
    
    RunService.Heartbeat:Connect(function()
        if not Character or not HumanoidRootPart then return end
        if not safeZoneEnabled then return end
        if teleportingToSaved then return end
        
        local currentPos = HumanoidRootPart.Position
        
        if lastSavedPos then
            local distance = (currentPos - lastSavedPos).Magnitude
            if distance > 50 then
                savedPosition = lastSavedPos
                lastSavedPos = currentPos
            end
        else
            lastSavedPos = currentPos
        end
    end)
end

saveOnTeleport()

local VisualsTab = Window:AddTab("Visuals", "eye")

local ESPTabbox = VisualsTab:AddLeftTabbox("ESP Functions")
local ESPTab = ESPTabbox:AddTab("ESP")

local ChamsTabbox = VisualsTab:AddRightTabbox("Chams Functions")
local ChamsTab = ChamsTabbox:AddTab("Chams")

local LightingTabbox = VisualsTab:AddLeftTabbox("Lighting Functions")
local LightingTab = LightingTabbox:AddTab("Lighting")

local CrosshairTabbox = VisualsTab:AddRightTabbox("Crosshair Functions")
local CrosshairTab = CrosshairTabbox:AddTab("Crosshair")

local espPlayers = {}
local espEnabled = false
local boxEsp = false
local tracerEsp = false
local nameEsp = false
local distanceEsp = false
local espColor = Color3.new(1, 0, 0)
local espDistance = 500

ESPTab:AddToggle("ESP Enabled", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if Value then
            startESP()
        else
            clearESP()
        end
    end
})

ESPTab:AddToggle("Box ESP", {
    Text = "Box ESP",
    Default = false,
    Callback = function(Value)
        boxEsp = Value
    end
})

ESPTab:AddToggle("Tracer ESP", {
    Text = "Tracer ESP",
    Default = false,
    Callback = function(Value)
        tracerEsp = Value
    end
})

ESPTab:AddToggle("Name ESP", {
    Text = "Name ESP",
    Default = false,
    Callback = function(Value)
        nameEsp = Value
    end
})

ESPTab:AddToggle("Distance ESP", {
    Text = "Distance ESP",
    Default = false,
    Callback = function(Value)
        distanceEsp = Value
    end
})

ESPTab:AddSlider("ESP Distance", {
    Text = "Max Distance:",
    Default = 500,
    Min = 100,
    Max = 2000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        espDistance = Value
    end
})

ESPTab:AddLabel("ESP Color"):AddColorPicker("ESPColorPicker", {
    Default = Color3.new(1, 0, 0),
    Title = "ESP Color",
    Transparency = 0,
    Callback = function(Value)
        espColor = Value
    end
})

local function startESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            setupPlayerESP(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            setupPlayerESP(player)
        end
    end)
end

local function setupPlayerESP(player)
    local esp = {}
    
    player.CharacterAdded:Connect(function(char)
        if not espEnabled then return end
        
        wait(1)
        
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")
        
        if boxEsp then
            esp.box = createBox(char, hrp)
        end
        
        if tracerEsp then
            esp.tracer = createTracer(char, hrp)
        end
        
        if nameEsp or distanceEsp then
            esp.label = createLabel(char, hrp, humanoid, player)
        end
        
        espPlayers[player] = esp
        
        RunService.RenderStepped:Connect(function()
            if not espEnabled then return end
            if not char or not hrp then return end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
            
            if distance > espDistance then
                if esp.box then esp.box.Visible = false end
                if esp.tracer then esp.tracer.Visible = false end
                if esp.label then esp.label.Visible = false end
                return
            end
            
            if onScreen then
                if esp.box and boxEsp then
                    updateBox(esp.box, char, hrp, screenPos)
                end
                
                if esp.tracer and tracerEsp then
                    updateTracer(esp.tracer, screenPos)
                end
                
                if esp.label and (nameEsp or distanceEsp) then
                    updateLabel(esp.label, char, hrp, humanoid, player, screenPos, distance)
                end
            else
                if esp.box then esp.box.Visible = false end
                if esp.tracer then esp.tracer.Visible = false end
                if esp.label then esp.label.Visible = false end
            end
        end)
    end)
end

local function createBox(char, hrp)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = espColor
    box.Thickness = 2
    box.Filled = false
    return box
end

local function updateBox(box, char, hrp, screenPos)
    local size = char:GetExtentsSize()
    box.Size = Vector2.new(2000 / screenPos.Z, 3000 / screenPos.Z)
    box.Position = Vector2.new(screenPos.X - box.Size.X/2, screenPos.Y - box.Size.Y/2)
    box.Visible = true
end

local function createTracer(char, hrp)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = espColor
    tracer.Thickness = 1
    return tracer
end

local function updateTracer(tracer, screenPos)
    tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
    tracer.Visible = true
end

local function createLabel(char, hrp, humanoid, player)
    local label = Drawing.new("Text")
    label.Visible = false
    label.Color = espColor
    label.Size = 14
    label.Font = 2
    return label
end

local function updateLabel(label, char, hrp, humanoid, player, screenPos, distance)
    local text = ""
    if nameEsp then
        text = player.Name
    end
    if distanceEsp then
        if nameEsp then
            text = text .. " (" .. math.floor(distance) .. ")"
        else
            text = math.floor(distance) .. " studs"
        end
    end
    if humanoid.Health then
        text = text .. "\nHP: " .. math.floor(humanoid.Health)
    end
    
    label.Text = text
    label.Position = Vector2.new(screenPos.X - label.TextBounds.X/2, screenPos.Y - 50)
    label.Visible = true
end

local function clearESP()
    for _, esp in pairs(espPlayers) do
        if esp.box then esp.box:Remove() end
        if esp.tracer then esp.tracer:Remove() end
        if esp.label then esp.label:Remove() end
    end
    espPlayers = {}
end

local chamsEnabled = false
local chamsColor = Color3.new(0, 1, 0)
local chamsTransparency = 0.5
local chamsPlayers = {}

ChamsTab:AddToggle("Chams Enabled", {
    Text = "Enable Chams",
    Default = false,
    Callback = function(Value)
        chamsEnabled = Value
        if Value then
            startChams()
        else
            clearChams()
        end
    end
})

ChamsTab:AddLabel("Chams Color"):AddColorPicker("ChamsColorPicker", {
    Default = Color3.new(0, 1, 0),
    Title = "Chams Color",
    Transparency = 0.5,
    Callback = function(Value)
        chamsColor = Value
        updateChamsColor()
    end
})

ChamsTab:AddSlider("Chams Transparency", {
    Text = "Transparency:",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        chamsTransparency = Value
        updateChamsTransparency()
    end
})

local function startChams()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            setupPlayerChams(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            setupPlayerChams(player)
        end
    end)
end

local function setupPlayerChams(player)
    player.CharacterAdded:Connect(function(char)
        if not chamsEnabled then return end
        
        wait(1)
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ChamsHighlight"
        highlight.FillColor = chamsColor
        highlight.FillTransparency = chamsTransparency
        highlight.OutlineColor = chamsColor
        highlight.OutlineTransparency = 0
        highlight.Adornee = char
        highlight.Parent = char
        
        chamsPlayers[player] = highlight
    end)
end

local function updateChamsColor()
    for _, highlight in pairs(chamsPlayers) do
        if highlight then
            highlight.FillColor = chamsColor
            highlight.OutlineColor = chamsColor
        end
    end
end

local function updateChamsTransparency()
    for _, highlight in pairs(chamsPlayers) do
        if highlight then
            highlight.FillTransparency = chamsTransparency
        end
    end
end

local function clearChams()
    for _, highlight in pairs(chamsPlayers) do
        if highlight then
            highlight:Destroy()
        end
    end
    chamsPlayers = {}
end

local ambientEnabled = false
local ambientColor = Color3.new(0.5, 0.5, 0.5)
local outdoorAmbientColor = Color3.new(0.5, 0.5, 0.5)
local rainbowAmbient = false
local fullbrightEnabled = false

LightingTab:AddToggle("Ambient Enabled", {
    Text = "Enable Ambient",
    Default = false,
    Callback = function(Value)
        ambientEnabled = Value
        if Value then
            updateAmbient()
        else
            resetAmbient()
        end
    end
})

LightingTab:AddLabel("Ambient Color"):AddColorPicker("AmbientColorPicker", {
    Default = Color3.new(0.5, 0.5, 0.5),
    Title = "Ambient Color",
    Transparency = 0,
    Callback = function(Value)
        ambientColor = Value
        if ambientEnabled then
            game.Lighting.Ambient = Value
        end
    end
})

LightingTab:AddLabel("Outdoor Ambient"):AddColorPicker("OutdoorAmbientColorPicker", {
    Default = Color3.new(0.5, 0.5, 0.5),
    Title = "Outdoor Ambient",
    Transparency = 0,
    Callback = function(Value)
        outdoorAmbientColor = Value
        if ambientEnabled then
            game.Lighting.OutdoorAmbient = Value
        end
    end
})

LightingTab:AddToggle("Rainbow Ambient", {
    Text = "Rainbow Ambient",
    Default = false,
    Callback = function(Value)
        rainbowAmbient = Value
        if Value then
            startRainbowAmbient()
        end
    end
})

LightingTab:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
    Callback = function(Value)
        fullbrightEnabled = Value
        if Value then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.GlobalShadows = true
        end
    end
})

local function updateAmbient()
    if not ambientEnabled then return end
    
    if rainbowAmbient then
        startRainbowAmbient()
    else
        game.Lighting.Ambient = ambientColor
        game.Lighting.OutdoorAmbient = outdoorAmbientColor
    end
end

local function resetAmbient()
    game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    game.Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
end

local function startRainbowAmbient()
    spawn(function()
        while rainbowAmbient and ambientEnabled do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            
            game.Lighting.Ambient = color
            game.Lighting.OutdoorAmbient = color
            
            wait(0.1)
        end
    end)
end

local crosshairEnabled = false
local crosshairSize = 10
local crosshairThickness = 1
local crosshairColor = Color3.new(1, 1, 1)
local crosshairGui = nil

CrosshairTab:AddToggle("Crosshair", {
    Text = "Enable Crosshair",
    Default = false,
    Callback = function(Value)
        crosshairEnabled = Value
        if Value then
            createCrosshair()
        else
            removeCrosshair()
        end
    end
})

CrosshairTab:AddSlider("Crosshair Size", {
    Text = "Crosshair Size:",
    Default = 10,
    Min = 5,
    Max = 30,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        crosshairSize = Value
        updateCrosshair()
    end
})

CrosshairTab:AddSlider("Crosshair Thickness", {
    Text = "Thickness:",
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        crosshairThickness = Value
        updateCrosshair()
    end
})

CrosshairTab:AddLabel("Crosshair Color"):AddColorPicker("CrosshairColorPicker", {
    Default = Color3.new(1, 1, 1),
    Title = "Crosshair Color",
    Transparency = 0,
    Callback = function(Value)
        crosshairColor = Value
        updateCrosshair()
    end
})

local function createCrosshair()
    if crosshairGui then
        crosshairGui:Destroy()
    end
    
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "CrosshairGUI"
    crosshairGui.Parent = game.CoreGui
    
    local centerFrame = Instance.new("Frame")
    centerFrame.Name = "CenterDot"
    centerFrame.Size = UDim2.new(0, 4, 0, 4)
    centerFrame.Position = UDim2.new(0.5, -2, 0.5, -2)
    centerFrame.BackgroundColor3 = crosshairColor
    centerFrame.BorderSizePixel = 0
    centerFrame.Parent = crosshairGui
    
    local horizontalLine = Instance.new("Frame")
    horizontalLine.Name = "HorizontalLine"
    horizontalLine.Size = UDim2.new(0, crosshairSize * 2, 0, crosshairThickness)
    horizontalLine.Position = UDim2.new(0.5, -crosshairSize, 0.5, -crosshairThickness/2)
    horizontalLine.BackgroundColor3 = crosshairColor
    horizontalLine.BorderSizePixel = 0
    horizontalLine.Parent = crosshairGui
    
    local verticalLine = Instance.new("Frame")
    verticalLine.Name = "VerticalLine"
    verticalLine.Size = UDim2.new(0, crosshairThickness, 0, crosshairSize * 2)
    verticalLine.Position = UDim2.new(0.5, -crosshairThickness/2, 0.5, -crosshairSize)
    verticalLine.BackgroundColor3 = crosshairColor
    verticalLine.BorderSizePixel = 0
    verticalLine.Parent = crosshairGui
end

local function updateCrosshair()
    if not crosshairEnabled or not crosshairGui then return end
    
    local centerDot = crosshairGui:FindFirstChild("CenterDot")
    local horizontalLine = crosshairGui:FindFirstChild("HorizontalLine")
    local verticalLine = crosshairGui:FindFirstChild("VerticalLine")
    
    if centerDot then
        centerDot.BackgroundColor3 = crosshairColor
        centerDot.Size = UDim2.new(0, 4, 0, 4)
        centerDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    end
    
    if horizontalLine then
        horizontalLine.BackgroundColor3 = crosshairColor
        horizontalLine.Size = UDim2.new(0, crosshairSize * 2, 0, crosshairThickness)
        horizontalLine.Position = UDim2.new(0.5, -crosshairSize, 0.5, -crosshairThickness/2)
    end
    
    if verticalLine then
        verticalLine.BackgroundColor3 = crosshairColor
        verticalLine.Size = UDim2.new(0, crosshairThickness, 0, crosshairSize * 2)
        verticalLine.Position = UDim2.new(0.5, -crosshairThickness/2, 0.5, -crosshairSize)
    end
end

local function removeCrosshair()
    if crosshairGui then
        crosshairGui:Destroy()
        crosshairGui = nil
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
        Library:ToggleUI()
    end
end)

Library:SelectTab(LPTab)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

ThemeManager:SetFolder("LikegenmThemes")
SaveManager:SetFolder("LikegenmSaves")

ThemeManager:ApplyToTab(LPTab)

SaveManager:LoadAutoloadConfig()
