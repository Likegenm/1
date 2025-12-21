loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/DownoloadLiblary.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Test/refs/heads/main/Irina.lua"))()

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "TSB Script",
    Author = "Likegenm",
    Folder = "ftgshub",
    Icon = "code",
    IconSize = 22,
    NewElements = true,
    
    OpenButton = {
        Title = "Open TSB Script",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        
        Color = ColorSequence.new(
            Color3.fromHex("#800080"), 
            Color3.fromHex("#0000FF")
        )
    },

        game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        Window:Toggle()
    end
end)
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Desc = "LocalPlayer Settings",
    Icon = "user",
    IconColor = Color3.fromHex("#FF0000"),
})

local SpeedSection = PlayerTab:Section({
    Title = "Speed Hack"
})

local speedMultiplier = 1
local speedEnabled = false
local speedConnection

SpeedSection:Slider({
    Title = "Speed Multiplier",
    Desc = "1 = 50, 2 = 100, etc.",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 1,
    },
    Callback = function(value)
        speedMultiplier = value
        if speedEnabled then
            updateSpeed()
        end
    end
})

local function updateSpeed()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if speedEnabled then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 50 * speedMultiplier
        end
        
        speedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 50 * speedMultiplier
            end
        end)
    else
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
    end
end

SpeedSection:Toggle({
    Title = "Enable Speed Hack",
    Icon = "zap",
    Callback = function(state)
        speedEnabled = state
        updateSpeed()
    end
})

SpeedSection:Space()

local FlySection = PlayerTab:Section({
    Title = "Fly Hack"
})

local flySpeed = 80
local flyEnabled = false
local flyThread
local flying = false

FlySection:Slider({
    Title = "Fly Speed",
    Step = 1,
    Value = {
        Min = 20,
        Max = 200,
        Default = 80,
    },
    Callback = function(value)
        flySpeed = value
    end
})

local function updateFly()
    if flyThread then
        flyThread = nil
    end
    
    if flyEnabled then
        flying = true
        flyThread = task.spawn(function()
            local player = game.Players.LocalPlayer
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            
            while flyEnabled and RunService.Heartbeat:Wait() do
                if not flying then continue end
                
                local character = player.Character
                if not character then continue end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then continue end
                
                local camera = workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                
                local velocity = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    velocity = velocity + lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    velocity = velocity - lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    velocity = velocity - rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    velocity = velocity + rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    velocity = velocity + Vector3.new(0, -1, 0)
                end
                
                if velocity.Magnitude > 0 then
                    velocity = velocity.Unit * flySpeed
                end
                
                humanoidRootPart.Velocity = velocity
            end
        end)
    end
end

FlySection:Toggle({
    Title = "Enable Fly",
    Desc = "Press Y to toggle flying",
    Icon = "bird",
    Callback = function(state)
        flyEnabled = state
        updateFly()
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Y and flyEnabled then
        flying = not flying
    end
end)

FlySection:Space()

local JumpSection = PlayerTab:Section({
    Title = "Infinite Jump"
})

local jumpCooldown = 0.1
local jumpEnabled = false
local jumpThread

JumpSection:Input({
    Title = "Jump Cooldown",
    Desc = "Seconds between jumps (0.1-5)",
    Value = "0.1",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0.1 and num <= 5 then
            jumpCooldown = num
        end
    end
})

local function updateJump()
    if jumpThread then
        jumpThread = nil
    end
    
    if jumpEnabled then
        jumpThread = task.spawn(function()
            local player = game.Players.LocalPlayer
            local UserInputService = game:GetService("UserInputService")
            
            while jumpEnabled and task.wait(jumpCooldown) do
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        local currentVelocity = character.HumanoidRootPart.Velocity
                        character.HumanoidRootPart.Velocity = Vector3.new(
                            currentVelocity.X,
                            50,
                            currentVelocity.Z
                        )
                    end
                end
            end
        end)
    end
end

JumpSection:Toggle({
    Title = "Enable Infinite Jump",
    Icon = "arrow-up",
    Callback = function(state)
        jumpEnabled = state
        updateJump()
    end
})

JumpSection:Space()

local MouseTeleportSection = PlayerTab:Section({
    Title = "Mouse Teleport"
})

local mouseTeleportEnabled = false
local mouseTeleportThread = nil

MouseTeleportSection:Toggle({
    Title = "Mouse Teleport",
    Desc = "Press T to teleport to mouse cursor",
    Icon = "mouse-pointer",
    Callback = function(state)
        mouseTeleportEnabled = state
        
        if mouseTeleportThread then
            mouseTeleportThread = nil
        end
        
        if state then
            mouseTeleportThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local UserInputService = game:GetService("UserInputService")
                
                while mouseTeleportEnabled do
                    if UserInputService:IsKeyDown(Enum.KeyCode.T) then
                        local character = player.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local mouse = player:GetMouse()
                            local hit = mouse.Hit
                            character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
                            task.wait(0.2)
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local mouse = player:GetMouse()
            local hit = mouse.Hit
            character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- Orbit Section
local OrbitSection = PlayerTab:Section({
    Title = "Orbit"
})

local orbitSpeed = 50
local orbitDistance = 10
local orbitTargetPlayer = nil
local orbitEnabled = false
local orbitThread = nil
local savedOrbitPosition = nil

OrbitSection:Slider({
    Title = "Orbit Speed",
    Desc = "Rotation speed multiplier",
    Step = 1,
    Value = {
        Min = 1,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        orbitSpeed = value
    end
})

OrbitSection:Slider({
    Title = "Orbit Distance",
    Desc = "Distance from target",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 10,
    },
    Callback = function(value)
        orbitDistance = value
    end
})

local function getClosestPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local closest = nil
    local closestDist = math.huge
    local myPos = character.HumanoidRootPart.Position
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = p
            end
        end
    end
    
    return closest
end

local function toggleOrbit()
    if orbitEnabled then
        orbitEnabled = false
        if orbitThread then
            orbitThread = nil
        end
        
        if savedOrbitPosition then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(savedOrbitPosition)
            end
            savedOrbitPosition = nil
        end
        
        orbitTargetPlayer = nil
        WindUI:Notify({
            Title = "Orbit",
            Content = "Orbit disabled!",
            Icon = "x"
        })
    else
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            savedOrbitPosition = character.HumanoidRootPart.Position
            
            orbitTargetPlayer = getClosestPlayer()
            if not orbitTargetPlayer then
                WindUI:Notify({
                    Title = "Orbit",
                    Content = "No nearby players found!",
                    Icon = "x"
                })
                return
            end
            
            orbitEnabled = true
            WindUI:Notify({
                Title = "Orbit",
                Content = "Orbiting around " .. orbitTargetPlayer.Name .. "!",
                Icon = "orbit"
            })
            
            orbitThread = task.spawn(function()
                local RunService = game:GetService("RunService")
                local angle = 0
                
                while orbitEnabled do
                    if not game.Players:FindFirstChild(orbitTargetPlayer.Name) then
                        WindUI:Notify({
                            Title = "Orbit",
                            Content = "Target player left the game!",
                            Icon = "x"
                        })
                        orbitEnabled = false
                        break
                    end
                    
                    local myCharacter = player.Character
                    local targetCharacter = orbitTargetPlayer.Character
                    
                    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then
                        break
                    end
                    
                    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
                        task.wait(0.1)
                        continue
                    end
                    
                    local myHRP = myCharacter.HumanoidRootPart
                    local targetPos = targetCharacter.HumanoidRootPart.Position
                    
                    angle = angle + (RunService.Heartbeat:Wait() * (orbitSpeed / 10))
                    
                    local x = math.cos(angle) * orbitDistance
                    local z = math.sin(angle) * orbitDistance
                    
                    myHRP.CFrame = CFrame.new(
                        targetPos.X + x,
                        targetPos.Y + 5,
                        targetPos.Z + z
                    )
                end
                
                if savedOrbitPosition then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(savedOrbitPosition)
                    end
                    savedOrbitPosition = nil
                end
                
                orbitTargetPlayer = nil
            end)
        else
            WindUI:Notify({
                Title = "Orbit",
                Content = "No character found!",
                Icon = "x"
            })
        end
    end
end

OrbitSection:Button({
    Title = "Toggle Orbit",
    Desc = "Orbit around closest player",
    Icon = "orbit",
    Color = Color3.fromHex("#AA00FF"),
    Justify = "Center",
    Callback = toggleOrbit
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.H then
        toggleOrbit()
    end
end)

local ExploitsSection = PlayerTab:Section({
    Title = "Player Exploits"
})

local antiFreezeEnabled = false
local antiFreezeThread

ExploitsSection:Toggle({
    Title = "Anti-Freeze",
    Icon = "snowflake",
    Callback = function(state)
        antiFreezeEnabled = state
        if antiFreezeThread then
            antiFreezeThread = nil
        end
        if state then
            antiFreezeThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while antiFreezeEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local freeze = character:FindFirstChild("Freeze")
                        if freeze then freeze:Destroy() end
                    end
                end
            end)
        end
    end
})

ExploitsSection:Space()

local antiSlowEnabled = false
local antiSlowThread

ExploitsSection:Toggle({
    Title = "Anti-Slow",
    Icon = "turtle",
    Callback = function(state)
        antiSlowEnabled = state
        if antiSlowThread then
            antiSlowThread = nil
        end
        if state then
            antiSlowThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while antiSlowEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local slowed = character:FindFirstChild("Slowed")
                        if slowed then slowed:Destroy() end
                    end
                end
            end)
        end
    end
})
    
local TeleportPlusSection = PlayerTab:Section({
    Title = "Teleport+"
})

local teleportX = 0
local teleportY = 0
local teleportZ = 0

TeleportPlusSection:Slider({
    Title = "X Offset",
    Step = 1,
    Value = {
        Min = -500,
        Max = 500,
        Default = 0,
    },
    Callback = function(value)
        teleportX = value
    end
})

TeleportPlusSection:Slider({
    Title = "Y Offset",
    Step = 1,
    Value = {
        Min = -500,
        Max = 500,
        Default = 0,
    },
    Callback = function(value)
        teleportY = value
    end
})

TeleportPlusSection:Slider({
    Title = "Z Offset",
    Step = 1,
    Value = {
        Min = -500,
        Max = 500,
        Default = 0,
    },
    Callback = function(value)
        teleportZ = value
    end
})

TeleportPlusSection:Button({
    Title = "Teleport with Offset",
    Desc = "Teleport to current position + offset",
    Icon = "map-pin-plus",
    Color = Color3.fromHex("#55AAFF"),
    Justify = "Center",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local offset = Vector3.new(teleportX, teleportY, teleportZ)
            hrp.CFrame = CFrame.new(hrp.Position + offset)
        end
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local offset = Vector3.new(teleportX, teleportY, teleportZ)
            hrp.CFrame = CFrame.new(hrp.Position + offset)
        end
    end
end)

TeleportPlusSection:Space()

TeleportPlusSection:Button({
    Title = "Reset Offsets",
    Desc = "Set all offsets to 0",
    Icon = "refresh-cw",
    Color = Color3.fromHex("#5555FF"),
    Justify = "Center",
    Callback = function()
        teleportX = 0
        teleportY = 0
        teleportZ = 0
        WindUI:Notify({
            Title = "Teleport+",
            Content = "Offsets reset to 0!",
            Icon = "check"
        })
    end
})

local MicsTab = Window:Tab({
    Title = "Mics",
    Desc = "Miscellaneous Features",
    Icon = "lock",
    IconColor = Color3.fromHex("#FFA500"),
})

local PlatformSection = MicsTab:Section({
    Title = "Platform"
})

local platformEnabled = false
local rainbowPlatform = false
local platformColor = Color3.fromHex("#FFFFFF")
local platformSize = 10
local platformTransparency = 0
local platformType = "Normal"
local platformPart = nil
local platformThread = nil

PlatformSection:Colorpicker({
    Title = "Platform Color",
    Default = platformColor,
    Callback = function(color)
        platformColor = color
        if platformPart then
            platformPart.Color = rainbowPlatform and Color3.fromHSV(tick() % 5 / 5, 1, 1) or platformColor
        end
    end
})

PlatformSection:Toggle({
    Title = "Rainbow Color",
    Icon = "rainbow",
    Callback = function(state)
        rainbowPlatform = state
    end
})

PlatformSection:Dropdown({
    Title = "Platform Type",
    Values = {"Normal", "Velocity"},
    Value = "Normal",
    Callback = function(value)
        platformType = value
    end
})

PlatformSection:Slider({
    Title = "Platform Size",
    Step = 1,
    Value = {
        Min = 1000,
        Max = 1000000,
        Default = 10000,
    },
    Callback = function(value)
        platformSize = value
        if platformPart then
            platformPart.Size = Vector3.new(platformSize, 1, platformSize)
        end
    end
})

PlatformSection:Slider({
    Title = "Platform Transparency",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0,
    },
    Callback = function(value)
        platformTransparency = value
        if platformPart then
            platformPart.Transparency = platformTransparency
        end
    end
})

PlatformSection:Toggle({
    Title = "Enable Platform",
    Icon = "square",
    Callback = function(state)
        platformEnabled = state
        
        if platformThread then
            platformThread = nil
        end
        
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
        
        if state then
            platformThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local RunService = game:GetService("RunService")
                
                platformPart = Instance.new("Part")
                platformPart.Name = "PlayerPlatform"
                platformPart.Anchored = true
                platformPart.CanCollide = true
                platformPart.Transparency = platformTransparency
                platformPart.Size = Vector3.new(platformSize, 1, platformSize)
                platformPart.Color = platformColor
                platformPart.Material = Enum.Material.Neon
                platformPart.Parent = workspace
                
                platformPart.Position = Vector3.new(0, -500, 0)
                
                local lastVelocity = Vector3.new(0, 0, 0)
                
                while platformEnabled and RunService.Heartbeat:Wait() do
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = character.HumanoidRootPart
                        
                        platformPart.Position = Vector3.new(
                            rootPart.Position.X,
                            -500,
                            rootPart.Position.Z
                        )
                        
                        if rainbowPlatform then
                            platformPart.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        end
                        
                        if platformType == "Velocity" then
                            local currentVelocity = rootPart.Velocity
                            
                            if currentVelocity.Y < -50 then
                                lastVelocity = currentVelocity
                            end
                            
                            local distanceToPlatform = (rootPart.Position.Y - (-1000))
                            if distanceToPlatform <= 1001 then
                                if lastVelocity.Y < 0 then
                                    rootPart.Velocity = Vector3.new(
                                        lastVelocity.X * 0.5,
                                        math.abs(lastVelocity.Y) * 0.8,
                                        lastVelocity.Z * 0.5
                                    )
                                    lastVelocity = Vector3.new(0, 0, 0)
                                end
                            end
                        end
                    end
                end
                
                if platformPart then
                    platformPart:Destroy()
                    platformPart = nil
                end
            end)
        end
    end
})

PlatformSection:Space()

PlatformSection:Button({
    Title = "Delete Platform",
    Icon = "trash",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        platformEnabled = false
        
        if platformThread then
            platformThread = nil
        end
        
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
        
        WindUI:Notify({
            Title = "Platform",
            Content = "Platform deleted!",
            Icon = "check"
        })
    end
})

local OtherSection = MicsTab:Section({
    Title = "Other"
})

OtherSection:Button({
    Title = "FixCam",
    Desc = "Reset camera to default settings",
    Icon = "camera",
    Color = Color3.fromHex("#55AAFF"),
    Justify = "Center",
    Callback = function()
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        
        camera.CameraType = Enum.CameraType.Custom
        camera.FieldOfView = 70
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                camera.CameraSubject = humanoid
            end
        end
        
        WindUI:Notify({
            Title = "FixCam",
            Content = "Camera reset to default!",
            Icon = "check"
        })
    end
})

OtherSection:Space()

OtherSection:Button({
    Title = "Dex",
    Desc = "Load Dex Explorer",
    Icon = "folder-open",
    Color = Color3.fromHex("#FFAA00"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MassiveHubs/loadstring/refs/heads/main/DexXenoAndRezware'))()
        WindUI:Notify({
            Title = "Dex",
            Content = "Dex Explorer loaded!",
            Icon = "check"
        })
    end
})

OtherSection:Space()

OtherSection:Button({
    Title = "Inf Yield",
    Desc = "Load Infinite Yield",
    Icon = "zap",
    Color = Color3.fromHex("#00FFAA"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        WindUI:Notify({
            Title = "Inf Yield",
            Content = "Infinite Yield loaded!",
            Icon = "check"
        })
    end
})

OtherSection:Space()

OtherSection:Button({
    Title = "Dex v2",
    Desc = "Load Dex Explorer v2",
    Icon = "folder",
    Color = Color3.fromHex("#AA00FF"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
        WindUI:Notify({
            Title = "Dex v2",
            Content = "Dex Explorer v2 loaded!",
            Icon = "check"
        })
    end
})

local FightTab = Window:Tab({
    Title = "Fight",
    Desc = "Combat Features",
    Icon = "sword",
    IconColor = Color3.fromHex("#FFFF00"),
})

local KillauraSection = FightTab:Section({
    Title = "Killaura"
})

local killauraRange = 50
local killauraKeybinds = {"1"}
local killauraVisualColor = Color3.fromHex("#FF0000")
local killauraRainbowVisual = false
local killauraEnabled = false
local killauraThread = nil
local killauraVisual = nil

KillauraSection:Slider({
    Title = "Range",
    Step = 1,
    Value = {
        Min = 1,
        Max = 1000,
        Default = 50,
    },
    Callback = function(value)
        killauraRange = value
        updateKillauraVisual()
    end
})

KillauraSection:Dropdown({
    Title = "Keybinds",
    Desc = "Select multiple keys",
    Values = {"1", "2", "3", "4", "M1"},
    Value = {"1"},
    Multi = true,
    Callback = function(values)
        killauraKeybinds = values
    end
})

KillauraSection:Colorpicker({
    Title = "Range Visual Color",
    Default = killauraVisualColor,
    Callback = function(color)
        killauraVisualColor = color
        updateKillauraVisual()
    end
})

KillauraSection:Toggle({
    Title = "Rainbow Range Visual",
    Callback = function(state)
        killauraRainbowVisual = state
        updateKillauraVisual()
    end
})

local function updateKillauraVisual()
    if killauraVisual then
        killauraVisual:Destroy()
        killauraVisual = nil
    end
    
    if killauraEnabled then
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            killauraVisual = Instance.new("Part")
            killauraVisual.Name = "KillauraRange"
            killauraVisual.Shape = Enum.PartType.Cylinder
            killauraVisual.Size = Vector3.new(1, killauraRange * 2, killauraRange * 2)
            killauraVisual.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
            killauraVisual.Anchored = true
            killauraVisual.CanCollide = false
            killauraVisual.Transparency = 0.7
            killauraVisual.Color = killauraRainbowVisual and Color3.fromHSV(tick() % 5 / 5, 1, 1) or killauraVisualColor
            killauraVisual.Material = Enum.Material.Neon
            killauraVisual.Parent = workspace
            
            if killauraRainbowVisual then
                task.spawn(function()
                    while killauraVisual and killauraEnabled do
                        killauraVisual.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        task.wait()
                    end
                end)
            end
        end
    end
end

local function isKeyPressed(key)
    local UserInputService = game:GetService("UserInputService")
    
    if key == "M1" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    else
        local keyCode
        if key == "1" then keyCode = Enum.KeyCode.One
        elseif key == "2" then keyCode = Enum.KeyCode.Two
        elseif key == "3" then keyCode = Enum.KeyCode.Three
        elseif key == "4" then keyCode = Enum.KeyCode.Four
        end
        
        if keyCode then
            return UserInputService:IsKeyDown(keyCode)
        end
    end
    
    return false
end

local function getClosestPlayer()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local closest = nil
    local closestDist = math.huge
    local myPos = character.HumanoidRootPart.Position
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
            if dist <= killauraRange and dist < closestDist then
                closestDist = dist
                closest = p
            end
        end
    end
    
    return closest
end

KillauraSection:Toggle({
    Title = "ON",
    Callback = function(state)
        killauraEnabled = state
        
        if killauraThread then
            killauraThread = nil
        end
        
        if killauraVisual then
            killauraVisual:Destroy()
            killauraVisual = nil
        end
        
        if state then
            killauraThread = task.spawn(function()
                while killauraEnabled do
                    updateKillauraVisual()
                    
                    local anyKeyPressed = false
                    for _, key in ipairs(killauraKeybinds) do
                        if isKeyPressed(key) then
                            anyKeyPressed = true
                            break
                        end
                    end
                    
                    if anyKeyPressed then
                        local closestPlayer = getClosestPlayer()
                        if closestPlayer then
                            local character = game.Players.LocalPlayer.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                local root = character.HumanoidRootPart
                                local targetRoot = closestPlayer.Character.HumanoidRootPart
                                
                                root.CFrame = targetRoot.CFrame
                                task.wait(0.1)
                                root.CFrame = CFrame.new(root.Position)
                            end
                        end
                    end
                    
                    task.wait()
                end
                
                if killauraVisual then
                    killauraVisual:Destroy()
                    killauraVisual = nil
                end
            end)
        end
    end
})

local AntiFlingSection = PlayerTab:Section({
    Title = "AntiFling"
})

local antiFlingEnabled = false

local function updateAntiFling()
    if antiFlingEnabled then
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            end
        end
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if antiFlingEnabled and game.Players.LocalPlayer.Character then
                local character = game.Players.LocalPlayer.Character
                
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(character) then
                        if part.AssemblyLinearVelocity.Magnitude > 3 or part.AssemblyAngularVelocity.Magnitude > 3 then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end

AntiFlingSection:Toggle({
    Title = "AntiFling",
    Desc = "K key to toggle + anti-sit",
    Icon = "shield",
    Callback = function(state)
        antiFlingEnabled = state
        updateAntiFling()
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        antiFlingEnabled = not antiFlingEnabled
        updateAntiFling()
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if antiFlingEnabled then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        end
    end
end)

local ReachSection = FightTab:Section({
    Title = "Reach"
})

local reachRange = 50
local reachTeleportDist = 2
local reachVisualColor = Color3.fromHex("#00FF00")
local reachRainbowVisual = false
local reachEnabled = false
local reachThread = nil
local reachVisual = nil

ReachSection:Slider({
    Title = "Range",
    Step = 1,
    Value = {
        Min = 1,
        Max = 1000,
        Default = 50,
    },
    Callback = function(value)
        reachRange = value
        updateReachVisual()
    end
})

ReachSection:Slider({
    Title = "Teleport",
    Desc = "Distance behind player",
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 5,
        Default = 2,
    },
    Callback = function(value)
        reachTeleportDist = value
    end
})

ReachSection:Colorpicker({
    Title = "Visualer Color",
    Default = reachVisualColor,
    Callback = function(color)
        reachVisualColor = color
        updateReachVisual()
    end
})

ReachSection:Toggle({
    Title = "Rainbow Visualer",
    Callback = function(state)
        reachRainbowVisual = state
        updateReachVisual()
    end
})

local function updateReachVisual()
    if reachVisual then
        reachVisual:Destroy()
        reachVisual = nil
    end
    
    if reachEnabled then
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            reachVisual = Instance.new("Part")
            reachVisual.Name = "ReachRange"
            reachVisual.Shape = Enum.PartType.Cylinder
            reachVisual.Size = Vector3.new(1, reachRange * 2, reachRange * 2)
            reachVisual.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0, math.rad(90))
            reachVisual.Anchored = true
            reachVisual.CanCollide = false
            reachVisual.Transparency = 0.7
            reachVisual.Color = reachRainbowVisual and Color3.fromHSV(tick() % 5 / 5, 1, 1) or reachVisualColor
            reachVisual.Material = Enum.Material.Neon
            reachVisual.Parent = workspace
            
            if reachRainbowVisual then
                task.spawn(function()
                    while reachVisual and reachEnabled do
                        reachVisual.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        task.wait()
                    end
                end)
            end
        end
    end
end

local function getClosestPlayerInReach()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local closest = nil
    local closestDist = math.huge
    local myPos = character.HumanoidRootPart.Position
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
            if dist <= reachRange and dist < closestDist then
                closestDist = dist
                closest = p
            end
        end
    end
    
    return closest
end

local function teleportBehindWithDistance(targetPlayer, distance)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local targetChar = targetPlayer.Character
    
    if character and character:FindFirstChild("HumanoidRootPart") and 
       targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
       
        local targetCFrame = targetChar.HumanoidRootPart.CFrame
        local behindOffset = targetCFrame.LookVector * -distance
        
        character.HumanoidRootPart.CFrame = CFrame.new(
            targetChar.HumanoidRootPart.Position + behindOffset + Vector3.new(0, 3, 0)
        )
    end
end

ReachSection:Toggle({
    Title = "Toggle",
    Desc = "Mouse1 to teleport behind closest player",
    Callback = function(state)
        reachEnabled = state
        
        if reachThread then
            reachThread = nil
        end
        
        if reachVisual then
            reachVisual:Destroy()
            reachVisual = nil
        end
        
        if state then
            reachThread = task.spawn(function()
                local UserInputService = game:GetService("UserInputService")
                local RunService = game:GetService("RunService")
                
                while reachEnabled do
                    updateReachVisual()
                    
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        local closestPlayer = getClosestPlayerInReach()
                        if closestPlayer then
                            teleportBehindWithDistance(closestPlayer, reachTeleportDist)
                        end
                    end
                    
                    RunService.Heartbeat:Wait()
                end
                
                if reachVisual then
                    reachVisual:Destroy()
                    reachVisual = nil
                end
            end)
        end
    end
})

local SkillBringSection = FightTab:Section({
    Title = "SkillBring"
})

local skillBringKey = "1"
local skillBringEnabled = false
local skillBringThread = nil
local skillBringSavedPos = nil

SkillBringSection:Dropdown({
    Title = "Keybind",
    Values = {"1", "2", "3", "4", "M1"},
    Value = "1",
    Callback = function(value)
        skillBringKey = value
    end
})

local function isSkillBringKeyPressed()
    local UserInputService = game:GetService("UserInputService")
    
    if skillBringKey == "M1" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    else
        local keyCode
        if skillBringKey == "1" then keyCode = Enum.KeyCode.One
        elseif skillBringKey == "2" then keyCode = Enum.KeyCode.Two
        elseif skillBringKey == "3" then keyCode = Enum.KeyCode.Three
        elseif skillBringKey == "4" then keyCode = Enum.KeyCode.Four
        end
        
        if keyCode then
            return UserInputService:IsKeyDown(keyCode)
        end
    end
    
    return false
end

local function getPlayerInRange(range)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPos = character.HumanoidRootPart.Position
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
            if distance <= range then
                return p
            end
        end
    end
    
    return nil
end

SkillBringSection:Toggle({
    Title = "SkillBring",
    Desc = "Teleport player to void and back",
    Icon = "arrow-right-left",
    Callback = function(state)
        skillBringEnabled = state
        
        if skillBringThread then
            skillBringThread = nil
        end
        
        if state then
            skillBringThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local TweenService = game:GetService("TweenService")
                
                while skillBringEnabled do
                    if isSkillBringKeyPressed() then
                        local targetPlayer = getPlayerInRange(5)
                        if targetPlayer then
                            local myChar = player.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local hrp = myChar.HumanoidRootPart
                                
                                task.wait(1)
                                skillBringSavedPos = hrp.Position
                                
                                local voidPos = Vector3.new(-81.32, -496.50, -313.57)
                                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
                                local voidTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(voidPos)})
                                voidTween:Play()
                                voidTween.Completed:Wait()
                                
                                task.wait(3)
                                
                                if skillBringSavedPos then
                                    local returnTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(skillBringSavedPos)})
                                    returnTween:Play()
                                    returnTween.Completed:Wait()
                                    skillBringSavedPos = nil
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})


local VisualTab = Window:Tab({
    Title = "Visual",
    Desc = "Visual Modifications",
    Icon = "eye",
    IconColor = Color3.fromHex("#00FF00"),
})

local ExploitsTab = Window:Tab({
    Title = "Exploits",
    Desc = "Game Exploits",
    Icon = "zap",
    IconColor = Color3.fromHex("#00AAFF"),
})

local TrashcanSection = ExploitsTab:Section({
    Title = "Trashcan"
})

local savedPosition = nil
local trashcanThread = nil
local trashcanEnabled = false
local lastTrashcan = nil
local lastTrashcanTime = 0

local function getRandomTrashcan()
    local map = game.Workspace:FindFirstChild("Map")
    if not map then return nil end
    
    local trash = map:FindFirstChild("Trash")
    if not trash then return nil end
    
    local trashcans = {}
    for _, obj in pairs(trash:GetDescendants()) do
        if obj.Name == "Trashcan" then
            table.insert(trashcans, obj)
        end
    end
    
    if #trashcans == 0 then return nil end
    
    local availableTrashcans = {}
    local currentTime = tick()
    
    for _, trashcan in pairs(trashcans) do
        if trashcan ~= lastTrashcan or (currentTime - lastTrashcanTime) > 60 then
            table.insert(availableTrashcans, trashcan)
        end
    end
    
    if #availableTrashcans == 0 then
        return trashcans[math.random(1, #trashcans)]
    end
    
    return availableTrashcans[math.random(1, #availableTrashcans)]
end

TrashcanSection:Button({
    Title = "Get Trashcan",
    Desc = "Save position and auto-click random trashcan",
    Icon = "trash",
    Color = Color3.fromHex("#FF5500"),
    Justify = "Center",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        savedPosition = character.HumanoidRootPart.Position
        
        local trashcan = getRandomTrashcan()
        if trashcan then
            lastTrashcan = trashcan
            lastTrashcanTime = tick()
            
            character.HumanoidRootPart.CFrame = CFrame.new(trashcan.Position + Vector3.new(0, 1, 0))
            WindUI:Notify({
                Title = "Trashcan",
                Content = "Teleported to random trashcan!",
                Icon = "check"
            })
            
            trashcanEnabled = true
            trashcanThread = task.spawn(function()
                local RunService = game:GetService("RunService")
                local mouse = player:GetMouse()
                
                task.wait(0.5)
                
                mouse.Target = trashcan
                mouse.Hit = CFrame.new(trashcan.Position)
                
                task.wait(0.2)
                
                if trashcanEnabled then
                    mouse.Button1Down:Fire()
                    mouse.Button1Up:Fire()
                    
                    WindUI:Notify({
                        Title = "Trashcan",
                        Content = "Auto-clicked trashcan!",
                        Icon = "check"
                    })
                    
                    task.wait(3)
                    
                    if savedPosition and trashcanEnabled then
                        character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
                        WindUI:Notify({
                            Title = "Trashcan",
                            Content = "Auto-returned to saved position!",
                            Icon = "check"
                        })
                    end
                end
                
                trashcanEnabled = false
            end)
        else
            WindUI:Notify({
                Title = "Trashcan",
                Content = "No trashcans found!",
                Icon = "x"
            })
        end
    end
})

TrashcanSection:Space()

TrashcanSection:Button({
    Title = "Stop Trashcan",
    Desc = "Stop trashcan script",
    Icon = "x",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        trashcanEnabled = false
        if trashcanThread then
            trashcanThread = nil
        end
        WindUI:Notify({
            Title = "Trashcan",
            Content = "Trashcan script stopped!",
            Icon = "check"
        })
    end
})

local WallComboSection = ExploitsTab:Section({
    Title = "WallCombo"
})

local wallComboMode = "WallComboOff"
local wallComboThread = nil
local wallComboParts = {}

WallComboSection:Dropdown({
    Title = "Wall Combo Mode",
    Values = {"WallComboOff", "WallCombo", "WallComboBring"},
    Value = "WallComboOff",
    Callback = function(value)
        wallComboMode = value
        
        if wallComboThread then
            wallComboThread = nil
        end
        
        for _, part in pairs(wallComboParts) do
            if part then
                part:Destroy()
            end
        end
        wallComboParts = {}
        
        if value == "WallCombo" then
            wallComboThread = task.spawn(function()
                while wallComboMode == "WallCombo" do
                    local tunnel = game.Workspace:FindFirstChild("Map")
                    if tunnel then
                        tunnel = tunnel:FindFirstChild("Tunnel")
                        if tunnel then
                            local player = game.Players.LocalPlayer
                            local character = player.Character
                            
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                local hrp = character.HumanoidRootPart
                                local camera = workspace.CurrentCamera
                                
                                local frontDirection = camera.CFrame.LookVector
                                local wallPosition = hrp.Position + (frontDirection * 20)
                                
                                for _, obj in pairs(tunnel:GetDescendants()) do
                                    if (obj:IsA("Part") and obj.Name == "Part") or (obj:IsA("UnionOperation") and obj.Name == "Union") then
                                        local clone = obj:Clone()
                                        clone.Parent = workspace
                                        clone.Position = wallPosition
                                        clone.Transparency = 1
                                        clone.CanCollide = true
                                        clone.Anchored = true
                                        
                                        table.insert(wallComboParts, clone)
                                        
                                        if #wallComboParts > 3 then
                                            local oldest = table.remove(wallComboParts, 1)
                                            if oldest then
                                                oldest:Destroy()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.1)
                end
            end)
        elseif value == "WallComboBring" then
            WindUI:Notify({
                Title = "Wall Combo",
                Content = "WallComboBring mode coming soon!",
                Icon = "info"
            })
        end
    end
})

local AdminTab = Window:Tab({
    Title = "Admin",
    Desc = "Admin Commands",
    Icon = "shield",
    IconColor = Color3.fromHex("#0000FF"),
})

local TeleportTab = Window:Tab({
    Title = "Teleport",
    Desc = "Teleport Features",
    Icon = "map-pin",
    IconColor = Color3.fromHex("#AA00FF"),
})
-- Save Position Section
local SaveSection = TeleportTab:Section({
    Title = "Save Position"
})

local savedPosition = nil

SaveSection:Button({
    Title = "Save Current Position",
    Desc = "Save your current position",
    Icon = "save",
    Color = Color3.fromHex("#FFAA00"),
    Justify = "Center",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            savedPosition = character.HumanoidRootPart.Position
            WindUI:Notify({
                Title = "Position Saved",
                Content = string.format("Saved at: X: %.2f, Y: %.2f, Z: %.2f", 
                    savedPosition.X, savedPosition.Y, savedPosition.Z),
                Icon = "check"
            })
        end
    end
})

SaveSection:Button({
    Title = "Teleport to Saved",
    Desc = "Teleport to saved position",
    Icon = "map-pin",
    Color = Color3.fromHex("#55FF55"),
    Justify = "Center",
    Callback = function()
        if savedPosition then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
                WindUI:Notify({
                    Title = "Teleport",
                    Content = "Teleported to saved position!",
                    Icon = "check"
                })
            end
        else
            WindUI:Notify({
                Title = "Teleport",
                Content = "No position saved!",
                Icon = "x"
            })
        end
    end
})

SaveSection:Space()

-- Locations Section
local LocationsSection = TeleportTab:Section({
    Title = "Locations"
})

local teleportMode = "CFrame"
local locations = {
    ["Arena"] = {X = -164.81, Y = 439.51, Z = -367.23},
    ["Void"] = {X = -81.32, Y = -496.50, Z = -313.67},
    ["Mountain"] = {X = 358.53, Y = 699.10, Z = 358.56},
    ["Corner1"] = {X = 47.70, Y = 440.51, Z = 473.56},
    ["Corner2"] = {X = -248.36, Y = 441.75, Z = -238.39},
    ["Corner3"] = {X = 217.33, Y = 442.17, Z = -435.79},
    ["Corner4"] = {X = 552.33, Y = 441.57, Z = 277.07},
    ["Middle"] = {X = 142.33, Y = 440.75, Z = 29.89},
    ["Jail"] = {X = 438.82, Y = 439.51, Z = -376.02},
    ["BiggerJail"] = {X = 370.61, Y = 439.51, Z = 440.63}
}

LocationsSection:Dropdown({
    Title = "Teleport Mode",
    Values = {"CFrame", "TweenService"},
    Value = "CFrame",
    Callback = function(value)
        teleportMode = value
    end
})

for locationName, coords in pairs(locations) do
    LocationsSection:Button({
        Title = locationName,
        Desc = string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.X, coords.Y, coords.Z),
        Icon = "map-pin",
        Color = Color3.fromHex("#55FF55"),
        Justify = "Center",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local targetPosition = Vector3.new(coords.X, coords.Y, coords.Z)
                
                if teleportMode == "CFrame" then
                    hrp.CFrame = CFrame.new(targetPosition)
                elseif teleportMode == "TweenService" then
                    local TweenService = game:GetService("TweenService")
                    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                    tween:Play()
                end
                
                WindUI:Notify({
                    Title = "Teleport",
                    Content = "Teleported to " .. locationName,
                    Icon = "check"
                })
            end
        end
    })
    
    LocationsSection:Space()
end

local AnimationsTab = Window:Tab({
    Title = "Animations",
    Desc = "Player Animations",
    Icon = "activity",
    IconColor = Color3.fromHex("#FF00AA"),
})

-- Jerk Section
local JerkSection = AnimationsTab:Section({
    Title = "Jerk"
})

JerkSection:Button({
    Title = "Jerk",
    Desc = "Load Universal Jerk Off",
    Icon = "zap",
    Color = Color3.fromHex("#FF5500"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sakupenny/Universal-Jerk-Off/refs/heads/main/Main.lua"))()
        WindUI:Notify({
            Title = "Jerk",
            Content = "Universal Jerk Off loaded!",
            Icon = "check"
        })
    end
})

JerkSection:Space()

-- Follow Player Section
local FollowSection = AnimationsTab:Section({
    Title = "Follow Player"
})

local followTargetName = ""
local followTargetInfo = nil
local followEnabled = false
local followThread = nil
local followDistance = 20
local followHeight = 3

FollowSection:Input({
    Title = "Player Name",
    Desc = "Enter player username to follow",
    Callback = function(value)
        followTargetName = value
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name:lower() == value:lower() then
                followTargetInfo = player
                break
            end
        end
        
        if followTargetInfo then
            WindUI:Notify({
                Title = "Follow",
                Content = "Target: " .. followTargetInfo.Name,
                Icon = "user"
            })
        else
            WindUI:Notify({
                Title = "Follow",
                Content = "Player not found!",
                Icon = "x"
            })
            followTargetInfo = nil
        end
    end
})

FollowSection:Slider({
    Title = "Distance",
    Desc = "Distance behind player (studs)",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 20,
    },
    Callback = function(value)
        followDistance = value
    end
})

FollowSection:Slider({
    Title = "Height",
    Desc = "Height above ground (studs)",
    Step = 1,
    Value = {
        Min = 0,
        Max = 20,
        Default = 3,
    },
    Callback = function(value)
        followHeight = value
    end
})

FollowSection:Toggle({
    Title = "Follow Player",
    Desc = "Constantly stay behind target player",
    Icon = "users",
    Callback = function(state)
        followEnabled = state
        
        if followThread then
            followThread = nil
        end
        
        if state then
            if not followTargetInfo then
                WindUI:Notify({
                    Title = "Follow",
                    Content = "Please select a player first!",
                    Icon = "x"
                })
                followEnabled = false
                return
            end
            
            followThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local RunService = game:GetService("RunService")
                
                while followEnabled do
                    if not game.Players:FindFirstChild(followTargetInfo.Name) then
                        WindUI:Notify({
                            Title = "Follow",
                            Content = "Target player left the game!",
                            Icon = "x"
                        })
                        followEnabled = false
                        break
                    end
                    
                    local targetChar = followTargetInfo.Character
                    local myChar = player.Character
                    
                    if targetChar and myChar then
                        local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
                        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                        
                        if torso and myHRP then
                            local targetPos = torso.Position
                            local direction = torso.CFrame.LookVector
                            local behindPos = targetPos - (direction * followDistance) + Vector3.new(0, followHeight, 0)
                            
                            myHRP.CFrame = CFrame.new(behindPos)
                        end
                    end
                    
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})

FollowSection:Space()

-- TSB Animations Section
local TSBSection = AnimationsTab:Section({
    Title = "TSB Animations"
})

TSBSection:Button({
    Title = "Animations",
    Desc = "Load Strong Guest Animations",
    Icon = "play",
    Color = Color3.fromHex("#AA00FF"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Mautiku/ehh/main/strong%20guest.lua.txt'))()
        WindUI:Notify({
            Title = "Animations",
            Content = "Strong Guest Animations loaded!",
            Icon = "check"
        })
    end
})

local BoxSection = VisualTab:Section({
    Title = "Box"
})

local boxColor = Color3.fromHex("#FF0000")
local boxRainbow = false
local boxEnabled = false
local boxThread = nil
local boxes = {}

BoxSection:Colorpicker({
    Title = "Box Color",
    Default = boxColor,
    Callback = function(color)
        boxColor = color
        updateBoxes()
    end
})

BoxSection:Toggle({
    Title = "Rainbow Box",
    Callback = function(state)
        boxRainbow = state
    end
})

local function updateBoxes()
    for player, box in pairs(boxes) do
        if box and box:FindFirstChild("Box") then
            box.Box.Color = boxRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or boxColor
        end
    end
end

BoxSection:Toggle({
    Title = "Enable Box",
    Callback = function(state)
        boxEnabled = state
        
        if boxThread then
            boxThread = nil
        end
        
        if not state then
            for player, box in pairs(boxes) do
                if box then
                    box:Destroy()
                end
            end
            boxes = {}
            return
        end
        
        boxThread = task.spawn(function()
            local RunService = game:GetService("RunService")
            
            while boxEnabled do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local character = player.Character
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        
                        if humanoidRootPart and not boxes[player] then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Name = "Box"
                            box.Adornee = humanoidRootPart
                            box.Size = Vector3.new(4, 6, 2)
                            box.Color3 = boxRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or boxColor
                            box.Transparency = 0.5
                            box.AlwaysOnTop = true
                            box.ZIndex = 1
                            box.Parent = humanoidRootPart
                            
                            local container = Instance.new("Folder")
                            container.Name = "BoxContainer"
                            container.Parent = workspace
                            box.Parent = container
                            
                            boxes[player] = container
                        elseif boxes[player] and (not character or not humanoidRootPart) then
                            boxes[player]:Destroy()
                            boxes[player] = nil
                        end
                    end
                end
                
                if boxRainbow then
                    updateBoxes()
                end
                
                RunService.Heartbeat:Wait()
            end
        end)
    end
})

BoxSection:Space()

-- Chams Section
local ChamsSection = VisualTab:Section({
    Title = "Chams"
})

local chamsColor = Color3.fromHex("#00FF00")
local chamsRainbow = false
local chamsEnabled = false
local chamsThread = nil
local chamHighlights = {}

ChamsSection:Colorpicker({
    Title = "Chams Color",
    Default = chamsColor,
    Callback = function(color)
        chamsColor = color
        updateChams()
    end
})

ChamsSection:Toggle({
    Title = "Rainbow Chams",
    Callback = function(state)
        chamsRainbow = state
    end
})

local function updateChams()
    for player, highlight in pairs(chamHighlights) do
        if highlight then
            highlight.FillColor = chamsRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or chamsColor
            highlight.OutlineColor = chamsRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or chamsColor
        end
    end
end

ChamsSection:Toggle({
    Title = "Enable Chams",
    Callback = function(state)
        chamsEnabled = state
        
        if chamsThread then
            chamsThread = nil
        end
        
        if not state then
            for player, highlight in pairs(chamHighlights) do
                if highlight then
                    highlight:Destroy()
                end
            end
            chamHighlights = {}
            return
        end
        
        chamsThread = task.spawn(function()
            local RunService = game:GetService("RunService")
            
            while chamsEnabled do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local character = player.Character
                        
                        if not chamHighlights[player] then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ChamsHighlight"
                            highlight.Adornee = character
                            highlight.FillColor = chamsRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or chamsColor
                            highlight.OutlineColor = chamsRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or chamsColor
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = character
                            
                            chamHighlights[player] = highlight
                        elseif chamHighlights[player] and (not character) then
                            chamHighlights[player]:Destroy()
                            chamHighlights[player] = nil
                        end
                    end
                end
                
                if chamsRainbow then
                    updateChams()
                end
                
                RunService.Heartbeat:Wait()
            end
        end)
    end
})

ChamsSection:Space()

-- Fullbright Section
local FullbrightSection = VisualTab:Section({
    Title = "Fullbright"
})

local fullbrightEnabled = false
local originalLighting = {}
local fullbrightThread = nil

FullbrightSection:Toggle({
    Title = "Enable Fullbright",
    Callback = function(state)
        fullbrightEnabled = state
        
        if fullbrightThread then
            fullbrightThread = nil
        end
        
        if state then
            originalLighting = {
                Ambient = game.Lighting.Ambient,
                Brightness = game.Lighting.Brightness,
                GlobalShadows = game.Lighting.GlobalShadows,
                OutdoorAmbient = game.Lighting.OutdoorAmbient
            }
            
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.Brightness = 2
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            if originalLighting.Ambient then
                game.Lighting.Ambient = originalLighting.Ambient
                game.Lighting.Brightness = originalLighting.Brightness
                game.Lighting.GlobalShadows = originalLighting.GlobalShadows
                game.Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            end
        end
    end
})

FullbrightSection:Space()

-- Ambient Section
local AmbientSection = VisualTab:Section({
    Title = "Ambient"
})

local ambientColor = Color3.fromHex("#0000FF")
local ambientRainbow = false
local ambientEnabled = false
local ambientThread = nil

AmbientSection:Colorpicker({
    Title = "Ambient Color",
    Default = ambientColor,
    Callback = function(color)
        ambientColor = color
        if ambientEnabled then
            updateAmbient()
        end
    end
})

AmbientSection:Toggle({
    Title = "Rainbow Ambient",
    Callback = function(state)
        ambientRainbow = state
    end
})

local function updateAmbient()
    local screenGui = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if screenGui then
        local frame = screenGui:FindFirstChild("AmbientFrame")
        if frame then
            frame.BackgroundColor3 = ambientRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or ambientColor
        end
    end
end

AmbientSection:Toggle({
    Title = "Enable Ambient",
    Callback = function(state)
        ambientEnabled = state
        
        if ambientThread then
            ambientThread = nil
        end
        
        if not state then
            local screenGui = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if screenGui then
                local frame = screenGui:FindFirstChild("AmbientFrame")
                if frame then
                    frame:Destroy()
                end
            end
            return
        end
        
        ambientThread = task.spawn(function()
            local player = game.Players.LocalPlayer
            local RunService = game:GetService("RunService")
            
            while ambientEnabled do
                local screenGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
                
                local frame = screenGui:FindFirstChild("AmbientFrame")
                if not frame then
                    frame = Instance.new("Frame")
                    frame.Name = "AmbientFrame"
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.Position = UDim2.new(0, 0, 0, 0)
                    frame.BackgroundColor3 = ambientRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or ambientColor
                    frame.BackgroundTransparency = 0.6
                    frame.BorderSizePixel = 0
                    frame.ZIndex = 1000
                    frame.Parent = screenGui
                end
                
                if ambientRainbow then
                    frame.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                end
                
                RunService.Heartbeat:Wait()
            end
            
            local screenGui = player:FindFirstChildOfClass("PlayerGui")
            if screenGui then
                local frame = screenGui:FindFirstChild("AmbientFrame")
                if frame then
                    frame:Destroy()
                end
            end
        end)
    end
    })

-- Detector Section
local DetectorSection = VisualTab:Section({
    Title = "Detector"
})

local noCameraAnimations = false
local originalCameraAnimations = {}

DetectorSection:Toggle({
    Title = "No Camera Animations",
    Callback = function(state)
        noCameraAnimations = state
        
        if state then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                for _, animator in pairs(character:GetDescendants()) do
                    if animator:IsA("Animator") then
                        for _, animationTrack in pairs(animator:GetPlayingAnimationTracks()) do
                            if animationTrack.Name == "WalkAnim" or animationTrack.Name == "RunAnim" then
                                originalCameraAnimations[animationTrack] = animationTrack.Looped
                                animationTrack:Stop()
                            end
                        end
                    end
                end
            end
        else
            for animationTrack, looped in pairs(originalCameraAnimations) do
                if looped then
                    animationTrack:Play()
                end
            end
            originalCameraAnimations = {}
        end
    end
})

local OtherSection = MicsTab:Section({
    Title = "Other"
})

OtherSection:Button({
    Title = "Dex",
    Desc = "Load Dex Explorer",
    Icon = "folder-open",
    Color = Color3.fromHex("#FFAA00"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/MassiveHubs/loadstring/refs/heads/main/DexXenoAndRezware'))()
        WindUI:Notify({
            Title = "Dex",
            Content = "Dex Explorer loaded!",
            Icon = "check"
        })
    end
})

OtherSection:Space()

OtherSection:Button({
    Title = "Inf Yield",
    Desc = "Load Infinite Yield",
    Icon = "zap",
    Color = Color3.fromHex("#00FFAA"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        WindUI:Notify({
            Title = "Inf Yield",
            Content = "Infinite Yield loaded!",
            Icon = "check"
        })
    end
})

OtherSection:Space()

OtherSection:Button({
    Title = "Dex v2",
    Desc = "Load Dex Explorer v2",
    Icon = "folder",
    Color = Color3.fromHex("#AA00FF"),
    Justify = "Center",
    Callback = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
        WindUI:Notify({
            Title = "Dex v2",
            Content = "Dex Explorer v2 loaded!",
            Icon = "check"
        })
    end
})

local AimassistSection = FightTab:Section({
    Title = "Aimassist"
})

local aimassistRadius = 25
local aimassistSpeed = 5
local aimassistEnabled = false
local aimassistThread = nil

AimassistSection:Slider({
    Title = "Radius",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 25,
    },
    Callback = function(value)
        aimassistRadius = value
    end
})

AimassistSection:Slider({
    Title = "Speed",
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 10,
        Default = 5,
    },
    Callback = function(value)
        aimassistSpeed = value
    end
})

local function getClosestPlayerToCamera()
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local cameraPosition = camera.CFrame.Position
    
    local closest = nil
    local closestDist = math.huge
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local character = p.Character
            local targetPart = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
            
            if targetPart then
                local dist = (cameraPosition - targetPart.Position).Magnitude
                if dist <= aimassistRadius and dist < closestDist then
                    closestDist = dist
                    closest = {player = p, part = targetPart}
                end
            end
        end
    end
    
    return closest
end

AimassistSection:Toggle({
    Title = "On",
    Callback = function(state)
        aimassistEnabled = state
        
        if aimassistThread then
            aimassistThread = nil
        end
        
        if state then
            aimassistThread = task.spawn(function()
                local RunService = game:GetService("RunService")
                
                while aimassistEnabled do
                    local closest = getClosestPlayerToCamera()
                    if closest and closest.part then
                        local camera = workspace.CurrentCamera
                        local targetPosition = closest.part.Position
                        local currentCFrame = camera.CFrame
                        local lookVector = (targetPosition - currentCFrame.Position).Unit
                        
                        local newCFrame = CFrame.lookAt(
                            currentCFrame.Position,
                            currentCFrame.Position:Lerp(
                                currentCFrame.Position + lookVector * 1000,
                                aimassistSpeed * RunService.Heartbeat:Wait()
                            )
                        )
                        
                        camera.CFrame = newCFrame
                    end
                    
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
})


AntiFlingSection:Toggle({
    Title = "Touch Fling",
    Desc = "P key to toggle touch fling",
    Icon = "wind",
    Callback = function(state)
        touchFlingEnabled = state
        
        if touchFlingThread then
            touchFlingThread = nil
        end
        
        if state then
            touchFlingThread = task.spawn(function()
                local lp = game.Players.LocalPlayer
                local c, hrp, vel, movel = nil, nil, nil, 0.1
                
                while touchFlingEnabled do
                    game:GetService("RunService").Heartbeat:Wait()
                    c = lp.Character
                    hrp = c and c:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        vel = hrp.Velocity
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        game:GetService("RunService").RenderStepped:Wait()
                        hrp.Velocity = vel
                        game:GetService("RunService").Stepped:Wait()
                        hrp.Velocity = vel + Vector3.new(0, movel, 0)
                        movel = -movel
                    end
                end
            end)
        end
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        touchFlingEnabled = not touchFlingEnabled
        
        if touchFlingThread then
            touchFlingThread = nil
        end
        
        if touchFlingEnabled then
            touchFlingThread = task.spawn(function()
                local lp = game.Players.LocalPlayer
                local c, hrp, vel, movel = nil, nil, nil, 0.1
                
                while touchFlingEnabled do
                    game:GetService("RunService").Heartbeat:Wait()
                    c = lp.Character
                    hrp = c and c:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        vel = hrp.Velocity
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        game:GetService("RunService").RenderStepped:Wait()
                        hrp.Velocity = vel
                        game:GetService("RunService").Stepped:Wait()
                        hrp.Velocity = vel + Vector3.new(0, movel, 0)
                        movel = -movel
                    end
                end
            end)
        end
    end
end)

local ControlTab = Window:Tab({
    Title = "Control",
    Desc = "Player Control Features",
    Icon = "target",
    IconColor = Color3.fromHex("#FF8800"),
})

-- Player Selection Section
local PlayerSelectSection = ControlTab:Section({
    Title = "Player Selection"
})

local targetPlayerInfo = nil

PlayerSelectSection:Input({
    Title = "Player Name",
    Desc = "Enter player name (partial or display)",
    Callback = function(value)
        local foundPlayer = nil
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.find(player.DisplayName:lower(), value:lower()) or string.find(player.Name:lower(), value:lower()) then
                foundPlayer = player
                break
            end
        end
        
        if foundPlayer then
            targetPlayerInfo = foundPlayer
            
            local starterGui = Instance.new("StarterGui")
            starterGui.Name = "SelectedPlayerInfo"
            starterGui.Parent = game.ReplicatedStorage
            
            local info = Instance.new("StringValue")
            info.Name = "PlayerName"
            info.Value = foundPlayer.Name
            info.Parent = starterGui
            
            local displayName = Instance.new("StringValue")
            displayName.Name = "DisplayName"
            displayName.Value = foundPlayer.DisplayName
            displayName.Parent = starterGui
            
            local userId = Instance.new("IntValue")
            userId.Name = "UserId"
            userId.Value = foundPlayer.UserId
            userId.Parent = starterGui
            
            WindUI:Notify({
                Title = "Player Selected",
                Content = foundPlayer.DisplayName .. " (@" .. foundPlayer.Name .. ")",
                Icon = "user"
            })
        else
            WindUI:Notify({
                Title = "Player Selection",
                Content = "Player not found!",
                Icon = "x"
            })
        end
    end
})

PlayerSelectSection:Space()

-- Fling Section
local FlingSection = ControlTab:Section({
    Title = "Fling"
})

local flingSavedPosition = nil
local flingThread = nil
local loopFlingEnabled = false
local loopFlingThread = nil

FlingSection:Button({
    Title = "Fling",
    Desc = "Teleport and fling player for 3 seconds",
    Icon = "wind",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        if not targetPlayerInfo then
            WindUI:Notify({
                Title = "Fling",
                Content = "Please select a player first!",
                Icon = "x"
            })
            return
        end
        
        local targetPlayer = targetPlayerInfo
        if not targetPlayer.Character then
            WindUI:Notify({
                Title = "Fling",
                Content = "Player has no character!",
                Icon = "x"
            })
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        flingSavedPosition = character.HumanoidRootPart.Position
        
        flingThread = task.spawn(function()
            local targetChar = targetPlayer.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if not targetRoot then return end
            
            local flingStart = tick()
            while tick() - flingStart < 3 do
                character.HumanoidRootPart.CFrame = CFrame.new(targetRoot.Position)
                
                local hrp = character.HumanoidRootPart
                if hrp then
                    local vel = hrp.Velocity
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                end
                
                task.wait(0.01)
            end
            
            if flingSavedPosition then
                character.HumanoidRootPart.CFrame = CFrame.new(flingSavedPosition)
            end
        end)
    end
})

FlingSection:Toggle({
    Title = "Loop Fling",
    Desc = "Continuously fling selected player",
    Icon = "refresh-cw",
    Callback = function(state)
        loopFlingEnabled = state
        
        if loopFlingThread then
            loopFlingThread = nil
        end
        
        if state then
            if not targetPlayerInfo then
                WindUI:Notify({
                    Title = "Loop Fling",
                    Content = "Please select a player first!",
                    Icon = "x"
                })
                loopFlingEnabled = false
                return
            end
            
            local targetPlayer = targetPlayerInfo
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                loopFlingEnabled = false
                return
            end
            
            flingSavedPosition = character.HumanoidRootPart.Position
            
            loopFlingThread = task.spawn(function()
                while loopFlingEnabled do
                    if not game.Players:FindFirstChild(targetPlayer.Name) then
                        WindUI:Notify({
                            Title = "Loop Fling",
                            Content = targetPlayer.DisplayName .. " left the game!",
                            Icon = "x"
                        })
                        loopFlingEnabled = false
                        break
                    end
                    
                    local targetChar = targetPlayer.Character
                    if not targetChar then
                        task.wait(0.1)
                        continue
                    end
                    
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    if not targetRoot then
                        task.wait(0.1)
                        continue
                    end
                    
                    if targetRoot.Velocity.Magnitude > 200 then
                        WindUI:Notify({
                            Title = "Loop Fling",
                            Content = "Player moving too fast, stopping!",
                            Icon = "x"
                        })
                        loopFlingEnabled = false
                        break
                    end
                    
                    character.HumanoidRootPart.CFrame = CFrame.new(targetRoot.Position)
                    
                    local hrp = character.HumanoidRootPart
                    if hrp then
                        local vel = hrp.Velocity
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    end
                    
                    task.wait(0.01)
                end
                
                if flingSavedPosition then
                    character.HumanoidRootPart.CFrame = CFrame.new(flingSavedPosition)
                end
            end)
        end
    end
})

FlingSection:Space()

-- View Section
local ViewSection = ControlTab:Section({
    Title = "View"
})

local viewThread = nil
local loopViewEnabled = false
local loopViewThread = nil

ViewSection:Button({
    Title = "View",
    Desc = "Spectate player for 3 seconds",
    Icon = "eye",
    Color = Color3.fromHex("#55AAFF"),
    Justify = "Center",
    Callback = function()
        if not targetPlayerInfo then
            WindUI:Notify({
                Title = "View",
                Content = "Please select a player first!",
                Icon = "x"
            })
            return
        end
        
        local targetPlayer = targetPlayerInfo
        if not targetPlayer.Character then
            WindUI:Notify({
                Title = "View",
                Content = "Player has no character!",
                Icon = "x"
            })
            return
        end
        
        local camera = workspace.CurrentCamera
        local originalCameraType = camera.CameraType
        camera.CameraType = Enum.CameraType.Scriptable
        
        viewThread = task.spawn(function()
            local viewStart = tick()
            while tick() - viewStart < 3 do
                if not game.Players:FindFirstChild(targetPlayer.Name) then
                    WindUI:Notify({
                        Title = "View",
                        Content = targetPlayer.DisplayName .. " left the game!",
                        Icon = "x"
                    })
                    break
                end
                
                local targetChar = targetPlayer.Character
                if targetChar then
                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        camera.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 5, 10), targetRoot.Position)
                    end
                end
                task.wait()
            end
            
            camera.CameraType = originalCameraType
        end)
    end
})

ViewSection:Toggle({
    Title = "Loop View",
    Desc = "Continuously spectate selected player",
    Icon = "eye",
    Callback = function(state)
        loopViewEnabled = state
        
        if loopViewThread then
            loopViewThread = nil
        end
        
        if state then
            if not targetPlayerInfo then
                WindUI:Notify({
                    Title = "Loop View",
                    Content = "Please select a player first!",
                    Icon = "x"
                })
                loopViewEnabled = false
                return
            end
            
            local targetPlayer = targetPlayerInfo
            
            local camera = workspace.CurrentCamera
            local originalCameraType = camera.CameraType
            camera.CameraType = Enum.CameraType.Scriptable
            
            loopViewThread = task.spawn(function()
                while loopViewEnabled do
                    if not game.Players:FindFirstChild(targetPlayer.Name) then
                        WindUI:Notify({
                            Title = "Loop View",
                            Content = targetPlayer.DisplayName .. " left the game!",
                            Icon = "x"
                        })
                        loopViewEnabled = false
                        break
                    end
                    
                    local targetChar = targetPlayer.Character
                    if targetChar then
                        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            camera.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 5, 10), targetRoot.Position)
                        end
                    end
                    task.wait()
                end
                
                camera.CameraType = originalCameraType
            end)
        end
    end
})

ViewSection:Space()

-- Teleport Section
local TeleportSection = ControlTab:Section({
    Title = "Teleport"
})

local teleportThread = nil
local loopTeleportEnabled = false
local loopTeleportThread = nil

TeleportSection:Button({
    Title = "Teleport",
    Desc = "Teleport to player once",
    Icon = "map-pin",
    Color = Color3.fromHex("#55FF55"),
    Justify = "Center",
    Callback = function()
        if not targetPlayerInfo then
            WindUI:Notify({
                Title = "Teleport",
                Content = "Please select a player first!",
                Icon = "x"
            })
            return
        end
        
        local targetPlayer = targetPlayerInfo
        if not targetPlayer.Character then
            WindUI:Notify({
                Title = "Teleport",
                Content = "Player has no character!",
                Icon = "x"
            })
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local targetChar = targetPlayer.Character
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        
        character.HumanoidRootPart.CFrame = CFrame.new(targetRoot.Position)
    end
})

TeleportSection:Toggle({
    Title = "Loop Teleport",
    Desc = "Continuously teleport to player",
    Icon = "refresh-cw",
    Callback = function(state)
        loopTeleportEnabled = state
        
        if loopTeleportThread then
            loopTeleportThread = nil
        end
        
        if state then
            if not targetPlayerInfo then
                WindUI:Notify({
                    Title = "Loop Teleport",
                    Content = "Please select a player first!",
                    Icon = "x"
                })
                loopTeleportEnabled = false
                return
            end
            
            local targetPlayer = targetPlayerInfo
            
            loopTeleportThread = task.spawn(function()
                while loopTeleportEnabled do
                    if not game.Players:FindFirstChild(targetPlayer.Name) then
                        WindUI:Notify({
                            Title = "Loop Teleport",
                            Content = targetPlayer.DisplayName .. " left the game!",
                            Icon = "x"
                        })
                        loopTeleportEnabled = false
                        break
                    end
                    
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local targetChar = targetPlayer.Character
                        if targetChar then
                            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                character.HumanoidRootPart.CFrame = CFrame.new(targetRoot.Position)
                            end
                        end
                    end
                    task.wait(0.01)
                end
            end)
        end
    end
})

local AutoClickerSection = FightTab:Section({
    Title = "AutoClicker"
})

local clickerDelay = 0.2
local clickerSpamEnabled = false
local clickerAutoM1Enabled = false
local clickerSpamThread = nil
local clickerAutoM1Thread = nil

AutoClickerSection:Slider({
    Title = "Delay",
    Desc = "Click delay in seconds",
    Step = 0.1,
    Value = {
        Min = 0.1,
        Max = 3,
        Default = 0.2,
    },
    Callback = function(value)
        clickerDelay = value
    end
})

AutoClickerSection:Toggle({
    Title = "Spammer",
    Desc = "Spam left click when holding LMB",
    Icon = "mouse-pointer",
    Callback = function(state)
        clickerSpamEnabled = state
        
        if clickerSpamThread then
            clickerSpamThread = nil
        end
        
        if state then
            clickerSpamThread = task.spawn(function()
                local UserInputService = game:GetService("UserInputService")
                local mouse = game.Players.LocalPlayer:GetMouse()
                
                while clickerSpamEnabled do
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        mouse.Button1Down:Fire()
                        mouse.Button1Up:Fire()
                        task.wait(clickerDelay)
                    else
                        task.wait(0.01)
                    end
                end
            end)
        end
    end
})

AutoClickerSection:Toggle({
    Title = "Auto M1",
    Desc = "Auto click when player is within 5 studs",
    Icon = "target",
    Callback = function(state)
        clickerAutoM1Enabled = state
        
        if clickerAutoM1Thread then
            clickerAutoM1Thread = nil
        end
        
        if state then
            clickerAutoM1Thread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local mouse = player:GetMouse()
                local VirtualInputManager = game:GetService("VirtualInputManager")
                
                while clickerAutoM1Enabled do
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local myPos = character.HumanoidRootPart.Position
                        local playerFound = false
                        
                        for _, p in pairs(game.Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local targetPos = p.Character.HumanoidRootPart.Position
                                local distance = (myPos - targetPos).Magnitude
                                
                                if distance <= 5 then
                                    playerFound = true
                                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                    break
                                end
                            end
                        end
                        
                        if playerFound then
                            task.wait(1)
                        else
                            task.wait(0.1)
                        end
                    else
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
})

