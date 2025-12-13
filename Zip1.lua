local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "TSB Script",
    Author = "Likegenm",
    Folder = "ftgshub",
    Icon = "code",
    IconSize = 44,
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

local OrbitSection = PlayerTab:Section({
    Title = "Orbit"
})

local orbitSpeed = 50
local orbitDistance = 10
local orbitTargetMode = "Mouse"
local orbitEnabled = false
local orbitThread
local orbitLockedTarget = nil

OrbitSection:Slider({
    Title = "Orbit Speed",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        orbitSpeed = value
    end
})

OrbitSection:Slider({
    Title = "Orbit Distance",
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

OrbitSection:Dropdown({
    Title = "Target Mode",
    Values = {"Mouse", "Nearest Player", "Locked Target"},
    Value = "Mouse",
    Callback = function(value)
        orbitTargetMode = value
    end
})

local function getOrbitTarget()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    if orbitTargetMode == "Locked Target" and orbitLockedTarget then
        return orbitLockedTarget
    end
    
    if orbitTargetMode == "Mouse" then
        local mouse = player:GetMouse()
        return mouse.Hit.Position
    end
    
    if orbitTargetMode == "Nearest Player" then
        local players = game.Players:GetPlayers()
        local closest = nil
        local closestDist = math.huge
        
        for _, p in pairs(players) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = p.Character.HumanoidRootPart.Position
                end
            end
        end
        
        return closest
    end
    
    return nil
end

OrbitSection:Toggle({
    Title = "Enable Orbit",
    Icon = "orbit",
    Callback = function(state)
        orbitEnabled = state
        if orbitThread then
            orbitThread = nil
        end
        if state then
            orbitThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local RunService = game:GetService("RunService")
                local time = 0
                
                while orbitEnabled and RunService.Heartbeat:Wait() do
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then
                        continue
                    end
                    
                    local targetPos = getOrbitTarget()
                    if not targetPos then
                        continue
                    end
                    
                    time = time + RunService.Heartbeat:Wait() * (orbitSpeed / 100)
                    
                    local x = math.cos(time) * orbitDistance
                    local z = math.sin(time) * orbitDistance
                    
                    character.HumanoidRootPart.CFrame = CFrame.new(
                        targetPos.X + x,
                        targetPos.Y + 5,
                        targetPos.Z + z
                    )
                end
            end)
        else
            orbitLockedTarget = nil
        end
    end
})

OrbitSection:Space()

OrbitSection:Button({
    Title = "Lock Current Target",
    Icon = "lock",
    IconColor = Color3.fromHex("#AA00FF"),
    Justify = "Center",
    Callback = function()
        local target = getOrbitTarget()
        if target then
            orbitLockedTarget = target
            orbitTargetMode = "Locked Target"
            WindUI:Notify({
                Title = "Orbit",
                Content = "Target locked!",
                Icon = "lock"
            })
        end
    end
})

OrbitSection:Button({
    Title = "Unlock Target",
    Icon = "unlock",
    Justify = "Center",
    Callback = function()
        orbitLockedTarget = nil
        orbitTargetMode = "Mouse"
        WindUI:Notify({
            Title = "Orbit",
            Content = "Target unlocked!",
            Icon = "unlock"
        })
    end
})

local MouseTPSection = PlayerTab:Section({
    Title = "Mouse TP"
})

local mouseTPEnabled = false
local mouseTPThread

MouseTPSection:Toggle({
    Title = "Enable Mouse TP",
    Desc = "Press T to teleport",
    Icon = "mouse-pointer",
    Callback = function(state)
        mouseTPEnabled = state
        if mouseTPThread then
            mouseTPThread = nil
        end
        if state then
            mouseTPThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local UserInputService = game:GetService("UserInputService")
                local mouse = player:GetMouse()
                
                while mouseTPEnabled and task.wait() do
                    if UserInputService:IsKeyDown(Enum.KeyCode.T) then
                        local character = player.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local hit = mouse.Hit
                            character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end
})

MouseTPSection:Space()

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

ExploitsSection:Space()

local alwaysBlockEnabled = false
local alwaysBlockThread

ExploitsSection:Toggle({
    Title = "Always Block",
    Icon = "shield",
    Callback = function(state)
        alwaysBlockEnabled = state
        if alwaysBlockThread then
            alwaysBlockThread = nil
        end
        if state then
            alwaysBlockThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while alwaysBlockEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local NB = character:FindFirstChild("NoBlock")
                        if NB then NB:Destroy() end
                    end
                end
            end)
        end
    end
})

ExploitsSection:Space()

local antiDebrisEnabled = false
local antiDebrisThread

ExploitsSection:Toggle({
    Title = "Anti-Debris",
    Icon = "trash",
    Callback = function(state)
        antiDebrisEnabled = state
        if antiDebrisThread then
            antiDebrisThread = nil
        end
        if state then
            antiDebrisThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                while antiDebrisEnabled and task.wait(0.01) do
                    local character = player.Character
                    if character then
                        local AD = character:FindFirstChild("Small Debris")
                        if AD then AD:Destroy() end
                    end
                end
            end)
        end
    end
})

ExploitsSection:Space()

local lagHackEnabled = false
local lagHackThread

ExploitsSection:Toggle({
    Title = "Lag Hack",
    Icon = "wifi-off",
    Callback = function(state)
        lagHackEnabled = state
        if lagHackThread then
            lagHackThread = nil
        end
        if state then
            lagHackThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                
                while lagHackEnabled do
                    local waitTime = math.random(13, 75)
                    task.wait(waitTime)
                    
                    if not lagHackEnabled then break end
                    
                    local effects = {"AntiFreeze", "AntiSlow", "AntiDebris"}
                    local randomEffect = effects[math.random(1, 3)]
                    
                    local effectDuration = math.random(12, 24)
                    local effectStart = tick()
                    
                    while tick() - effectStart < effectDuration and lagHackEnabled do
                        local character = player.Character
                        if character then
                            if randomEffect == "AntiFreeze" then
                                local freeze = character:FindFirstChild("Freeze")
                                if freeze then freeze:Destroy() end
                            elseif randomEffect == "AntiSlow" then
                                local slowed = character:FindFirstChild("Slowed")
                                if slowed then slowed:Destroy() end
                            elseif randomEffect == "AntiDebris" then
                                local AD = character:FindFirstChild("Small Debris")
                                if AD then AD:Destroy() end
                            end
                        end
                        task.wait(0.01)
                    end
                    
                    if not lagHackEnabled then break end
                    
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local savedPosition = character.HumanoidRootPart.Position
                        local teleportCount = math.random(20, 50)
                        
                        for i = 1, teleportCount do
                            if not lagHackEnabled then break end
                            task.wait(math.random(1, 3))
                            
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
                            end
                        end
                    end
                end
            end)
        end
    end
})

ExploitsSection:Space()

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

local function teleportBehindPlayer(targetPlayer)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local targetChar = targetPlayer.Character
    
    if character and character:FindFirstChild("HumanoidRootPart") and 
       targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
       
        local targetCFrame = targetChar.HumanoidRootPart.CFrame
        local behindOffset = targetCFrame.LookVector * -5
        
        character.HumanoidRootPart.CFrame = CFrame.new(
            targetChar.HumanoidRootPart.Position + behindOffset + Vector3.new(0, 3, 0)
        )
    end
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
                            teleportBehindPlayer(closestPlayer)
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
