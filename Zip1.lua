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
    }
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        Window:Toggle()
    end
end)

local PlayerTab = Window:Tab({
    Title = "Player",
    Desc = "LocalPlayer Settings",
    Icon = "user",
    IconColor = Color3.fromHex("#FF0000"),
})

local VelocitySpeedSection = PlayerTab:Section({
    Title = "Velocity Speed"
})

local velocitySpeedEnabled = false
local velocitySpeedThread = nil
local velocitySpeedValue = 30
local velocitySpeedMax = 1000
local velocitySavedWalkSpeed = 16

local function updateVelocitySpeed()
    if velocitySpeedThread then
        velocitySpeedThread = nil
    end
    
    if velocitySpeedEnabled then
        local player = game.Players.LocalPlayer
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        
        -- Сохраняем оригинальную скорость ходьбы
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            velocitySavedWalkSpeed = character.Humanoid.WalkSpeed
            character.Humanoid.WalkSpeed = 0 -- Отключаем стандартное движение
        end
        
        velocitySpeedThread = task.spawn(function()
            while velocitySpeedEnabled do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local mv = Vector3.new(0, 0, 0)
                    local hrp = player.Character.HumanoidRootPart
                    
                    -- Проверяем нажатые клавиши
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        mv = mv + hrp.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        mv = mv - hrp.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        mv = mv - hrp.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        mv = mv + hrp.CFrame.RightVector
                    end
                    
                    if mv.Magnitude > 0 then
                        -- Применяем скорость через Velocity
                        hrp.Velocity = Vector3.new(
                            mv.Unit.X * velocitySpeedValue,
                            hrp.Velocity.Y, -- Сохраняем вертикальную скорость
                            mv.Unit.Z * velocitySpeedValue
                        )
                    end
                end
                RunService.Heartbeat:Wait()
            end
            
            -- Возвращаем стандартную скорость ходьбы
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = velocitySavedWalkSpeed
            end
        end)
        
        WindUI:Notify({
            Title = "Velocity Speed",
            Content = "Velocity speed enabled! Speed: " .. velocitySpeedValue,
            Icon = "zap"
        })
    else
        -- Возвращаем стандартную скорость ходьбы
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = velocitySavedWalkSpeed
        end
        
        WindUI:Notify({
            Title = "Velocity Speed",
            Content = "Velocity speed disabled!",
            Icon = "x"
        })
    end
end

VelocitySpeedSection:Toggle({
    Title = "Velocity Speed",
    Desc = "Control movement through Velocity instead of WalkSpeed",
    Icon = "zap",
    Callback = function(state)
        velocitySpeedEnabled = state
        updateVelocitySpeed()
    end
})

VelocitySpeedSection:Slider({
    Title = "Velocity Speed Value",
    Desc = "Speed value (1-1000)",
    Step = 1,
    Value = {
        Min = 1,
        Max = velocitySpeedMax,
        Default = 30,
    },
    Callback = function(value)
        velocitySpeedValue = value
        if velocitySpeedEnabled then
            WindUI:Notify({
                Title = "Velocity Speed",
                Content = "Velocity speed updated to: " .. velocitySpeedValue,
                Icon = "settings"
            })
        end
    end
})

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

local FreezeSection = PlayerTab:Section({
    Title = "Freeze"
})

local frozen = false
local freezeCF = nil
local freezeThread = nil

FreezeSection:Button({
    Title = "Freeze",
    Desc = "Freeze/Unfreeze your character",
    Icon = "snowflake",
    Color = Color3.fromHex("#00AAFF"),
    Justify = "Center",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if not frozen then
            -- Freeze
            frozen = true
            freezeCF = hrp.CFrame
            
            -- Anchor character
            hrp.Anchored = true
            
            -- Stop all movement
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 0
                char.Humanoid.JumpPower = 0
            end
            
            freezeThread = task.spawn(function()
                while frozen do
                    if hrp then
                        hrp.CFrame = freezeCF
                        hrp.Velocity = Vector3.new(0,0,0)
                        hrp.RotVelocity = Vector3.new(0,0,0)
                    end
                    task.wait()
                end
            end)
            
            WindUI:Notify({
                Title = "Freeze",
                Content = "Character frozen!",
                Icon = "snowflake"
            })
        else
            -- Unfreeze
            frozen = false
            
            if freezeThread then
                freezeThread = nil
            end
            
            if hrp then
                hrp.Anchored = false
            end
            
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
                char.Humanoid.JumpPower = 50
            end
            
            WindUI:Notify({
                Title = "Freeze",
                Content = "Character unfrozen!",
                Icon = "check"
            })
        end
    end
})

-- Hotkey C to toggle freeze
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        local player = game.Players.LocalPlayer
        local char = player.Character
        
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if not frozen then
            frozen = true
            freezeCF = hrp.CFrame
            hrp.Anchored = true
            
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 0
                char.Humanoid.JumpPower = 0
            end
            
            freezeThread = task.spawn(function()
                while frozen do
                    if hrp then
                        hrp.CFrame = freezeCF
                        hrp.Velocity = Vector3.new(0,0,0)
                        hrp.RotVelocity = Vector3.new(0,0,0)
                    end
                    task.wait()
                end
            end)
        else
            frozen = false
            
            if freezeThread then
                freezeThread = nil
            end
            
            if hrp then
                hrp.Anchored = false
            end
            
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
                char.Humanoid.JumpPower = 50
            end
        end
    end
end)

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

local InvisibleSection = PlayerTab:Section({
    Title = "Invisible"
})

-- Новая кнопка для загрузки внешнего скрипта
InvisibleSection:Button({
    Title = "Load Invisible",
    Desc = "Load Mohamedguguu's invisibility script",
    Icon = "download",
    Color = Color3.fromHex("#00AAFF"),
    Justify = "Center",
    Callback = function()
        -- КОД ДЛЯ ЗАГРУЗКИ ВНЕШНЕГО СКРИПТА
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mohamedguguu/invisible-V1-BY-MU/refs/heads/main/Maincode"))()
        
        -- Уведомление о загрузке
        WindUI:Notify({
            Title = "External Script",
            Content = "Mohamedguguu's invisibility script loaded!",
            Icon = "check"
        })
    end
})

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
local platformSize = 10000
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

local function getClosestPlayerKillaura()
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
                        local closestPlayer = getClosestPlayerKillaura()
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

-- Section 1: Command Input
local ExecuteSection = AdminTab:Section({
    Title = "Execute"
})

local commandInput = ""
local selectedPlayer = ""
local flingCube = nil
local flingSavedPos = nil
local loopThreads = {}
local whitelist = {}

-- Командный инпут
ExecuteSection:Input({
    Title = "Command Bar",
    Desc = "Type commands here",
    Callback = function(value)
        commandInput = value
    end
})

-- Инпут для выбора игрока
ExecuteSection:Input({
    Title = "Player Name",
    Desc = "Enter player name (optional for commands)",
    Callback = function(value)
        selectedPlayer = value
    end
})

-- Кнопка выполнения
ExecuteSection:Button({
    Title = "Execute Command",
    Desc = "Run the typed command",
    Icon = "terminal",
    Color = Color3.fromHex("#FFAA00"),
    Justify = "Center",
    Callback = function()
        executeCommand(commandInput)
    end
})

ExecuteSection:Space()

-- Section 2: Command Buttons
local CommandsSection = AdminTab:Section({
    Title = "Commands"
})

-- Функции для работы с игроками
local function getPlayerByName(name)
    if not name or name == "" then return nil end
    name = name:lower()
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower() == name or 
           player.DisplayName:lower() == name or
           player.Name:lower():find(name, 1, true) or
           player.DisplayName:lower():find(name, 1, true) then
            return player
        end
    end
    return nil
end

local function getAllPlayers()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player)
        end
    end
    return players
end

local function teleportToPlayer(targetPlayer)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local targetChar = targetPlayer.Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                targetChar.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
            )
            return true
        end
    end
    return false
end

local function viewPlayer(targetPlayer)
    local camera = workspace.CurrentCamera
    local originalType = camera.CameraType
    camera.CameraType = Enum.CameraType.Scriptable
    
    return task.spawn(function()
        while camera.CameraType == Enum.CameraType.Scriptable do
            local targetChar = targetPlayer.Character
            if targetChar then
                local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    camera.CFrame = CFrame.new(
                        hrp.Position + Vector3.new(0, 5, 10),
                        hrp.Position
                    )
                end
            end
            task.wait()
        end
        camera.CameraType = originalType
    end)
end

local function createFlingCube()
    if flingCube and flingCube.Parent then
        flingCube:Destroy()
    end
    
    flingCube = Instance.new("Part")
    flingCube.Name = "FlingZone"
    flingCube.Size = Vector3.new(1000, 1000, 1000)
    flingCube.Position = Vector3.new(142.33, 440.75, 29.89)
    flingCube.Transparency = 1
    flingCube.CanCollide = false
    flingCube.Anchored = true
    flingCube.Parent = workspace
    
    return flingCube
end

local function isPlayerInCube(player)
    if not flingCube then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local pos = hrp.Position
    local cubePos = flingCube.Position
    local halfSize = flingCube.Size / 2
    
    return math.abs(pos.X - cubePos.X) <= halfSize.X and
           math.abs(pos.Y - cubePos.Y) <= halfSize.Y and
           math.abs(pos.Z - cubePos.Z) <= halfSize.Z
end

local function performSkidFling(targetPlayer)
    local player = game.Players.LocalPlayer
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local rootPart = humanoid and humanoid.RootPart
    
    local tChar = targetPlayer.Character
    local tHumanoid = tChar and tChar:FindFirstChildOfClass("Humanoid")
    local tRootPart = tHumanoid and tHumanoid.RootPart
    local tHead = tChar and tChar:FindFirstChild("Head")
    
    if not char or not humanoid or not rootPart then
        WindUI:Notify({
            Title = "Fling",
            Content = "Your character not found!",
            Icon = "x"
        })
        return false
    end
    
    if not tChar or not tHumanoid or not tRootPart then
        WindUI:Notify({
            Title = "Fling",
            Content = "Target character not found!",
            Icon = "x"
        })
        return false
    end
    
    -- Сохраняем позицию
    flingSavedPos = rootPart.CFrame
    
    -- Проверяем, находится ли игрок в кубе
    if not isPlayerInCube(targetPlayer) then
        WindUI:Notify({
            Title = "Fling",
            Content = "Target not in fling zone!",
            Icon = "x"
        })
        return false
    end
    
    -- Создаем куб если его нет
    if not flingCube then
        createFlingCube()
    end
    
    -- Начинаем флинг
    local oldPos = rootPart.CFrame
    workspace.CurrentCamera.CameraSubject = tHead or tHumanoid
    
    local function fPos(basePart, pos, ang)
        rootPart.CFrame = CFrame.new(basePart.Position) * pos * ang
        rootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        rootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    workspace.FallenPartsDestroyHeight = 0/0
    
    local bv = Instance.new("BodyVelocity")
    bv.Name = "EpixVel"
    bv.Parent = rootPart
    bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
    bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local angle = 0
    local timeToWait = 2
    local startTime = tick()
    
    while tick() - startTime < timeToWait do
        if tRootPart.Velocity.Magnitude < 50 then
            angle = angle + 100
            
            fPos(tRootPart, CFrame.new(0, 1.5, 0) + tHumanoid.MoveDirection * tRootPart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
            
            fPos(tRootPart, CFrame.new(0, -1.5, 0) + tHumanoid.MoveDirection * tRootPart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
            
            fPos(tRootPart, CFrame.new(2.25, 1.5, -2.25) + tHumanoid.MoveDirection * tRootPart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
            
            fPos(tRootPart, CFrame.new(-2.25, -1.5, 2.25) + tHumanoid.MoveDirection * tRootPart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
        else
            fPos(tRootPart, CFrame.new(0, 1.5, tHumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
            task.wait()
            
            fPos(tRootPart, CFrame.new(0, -1.5, -tHumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
            task.wait()
        end
    end
    
    bv:Destroy()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = humanoid
    
    -- Возвращаемся на сохраненную позицию
    while (rootPart.Position - flingSavedPos.p).Magnitude > 25 do
        rootPart.CFrame = flingSavedPos
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
        task.wait()
    end
    
    workspace.FallenPartsDestroyHeight = 500
    return true
end

local function executeCommand(cmd)
    if not cmd or cmd == "" then
        WindUI:Notify({
            Title = "Command",
            Content = "Enter a command!",
            Icon = "x"
        })
        return
    end
    
    local args = {}
    for word in cmd:gmatch("%S+") do
        table.insert(args, word)
    end
    
    local command = args[1]:lower()
    local playerName = selectedPlayer
    
    if #args >= 2 and not playerName then
        playerName = table.concat(args, " ", 2)
    end
    
    if command == "goto" then
        if not playerName then
            WindUI:Notify({
                Title = "Goto",
                Content = "Enter player name!",
                Icon = "x"
            })
            return
        end
        
        local target = getPlayerByName(playerName)
        if target then
            if teleportToPlayer(target) then
                WindUI:Notify({
                    Title = "Goto",
                    Content = "Teleported to " .. target.DisplayName,
                    Icon = "check"
                })
            end
        else
            WindUI:Notify({
                Title = "Goto",
                Content = "Player not found!",
                Icon = "x"
            })
        end
        
    elseif command == "loopgoto" then
        if not playerName then
            WindUI:Notify({
                Title = "LoopGoto",
                Content = "Enter player name!",
                Icon = "x"
            })
            return
        end
        
        local target = getPlayerByName(playerName)
        if not target then
            WindUI:Notify({
                Title = "LoopGoto",
                Content = "Player not found!",
                Icon = "x"
            })
            return
        end
        
        if loopThreads["goto_" .. target.Name] then
            WindUI:Notify({
                Title = "LoopGoto",
                Content = "Already loop-gotoing " .. target.DisplayName,
                Icon = "x"
            })
            return
        end
        
        loopThreads["goto_" .. target.Name] = task.spawn(function()
            while loopThreads["goto_" .. target.Name] do
                teleportToPlayer(target)
                task.wait(0.01)
            end
        end)
        
        WindUI:Notify({
            Title = "LoopGoto",
            Content = "Loop-goto to " .. target.DisplayName,
            Icon = "check"
        })
        
    elseif command == "unloopgoto" then
        if playerName then
            local target = getPlayerByName(playerName)
            if target and loopThreads["goto_" .. target.Name] then
                loopThreads["goto_" .. target.Name] = nil
                WindUI:Notify({
                    Title = "UnLoopGoto",
                    Content = "Stopped loop-goto",
                    Icon = "check"
                })
            end
        else
            -- Останавливаем все loopgoto
            for name, thread in pairs(loopThreads) do
                if name:find("goto_") then
                    loopThreads[name] = nil
                end
            end
            WindUI:Notify({
                Title = "UnLoopGoto",
                Content = "Stopped all loop-gotos",
                Icon = "check"
            })
        end
        
    elseif command == "view" then
        if not playerName then
            WindUI:Notify({
                Title = "View",
                Content = "Enter player name!",
                Icon = "x"
            })
            return
        end
        
        local target = getPlayerByName(playerName)
        if not target then
            WindUI:Notify({
                Title = "View",
                Content = "Player not found!",
                Icon = "x"
            })
            return
        end
        
        if loopThreads["view"] then
            loopThreads["view"] = nil
            task.wait(0.1)
        end
        
        loopThreads["view"] = viewPlayer(target)
        WindUI:Notify({
            Title = "View",
            Content = "Viewing " .. target.DisplayName,
            Icon = "check"
        })
        
    elseif command == "loopview" then
        if not playerName then
            WindUI:Notify({
                Title = "LoopView",
                Content = "Enter player name!",
                Icon = "x"
            })
            return
        end
        
        local target = getPlayerByName(playerName)
        if not target then
            WindUI:Notify({
                Title = "LoopView",
                Content = "Player not found!",
                Icon = "x"
            })
            return
        end
        
        if loopThreads["view"] then
            loopThreads["view"] = nil
            task.wait(0.1)
        end
        
        loopThreads["view"] = viewPlayer(target)
        WindUI:Notify({
            Title = "LoopView",
            Content = "Loop viewing " .. target.DisplayName,
            Icon = "check"
        })
        
    elseif command == "unloopview" then
        if loopThreads["view"] then
            loopThreads["view"] = nil
            WindUI:Notify({
                Title = "UnLoopView",
                Content = "Stopped viewing",
                Icon = "check"
            })
        end
        
    elseif command == "whitelist" then
        if not playerName then
            WindUI:Notify({
                Title = "Whitelist",
                Content = "Enter player name!",
                Icon = "x"
            })
            return
        end
        
        local target = getPlayerByName(playerName)
        if target then
            whitelist[target.Name] = true
            WindUI:Notify({
                Title = "Whitelist",
                Content = target.DisplayName .. " added to whitelist",
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "Whitelist",
                Content = "Player not found!",
                Icon = "x"
            })
        end
        
    elseif command == "unwhitelist" then
        if not playerName then
            WindUI:Notify({
                Title = "UnWhitelist",
                Content = "Enter player name!",
                Icon = "x"
            })
            return
        end
        
        local target = getPlayerByName(playerName)
        if target and whitelist[target.Name] then
            whitelist[target.Name] = nil
            WindUI:Notify({
                Title = "UnWhitelist",
                Content = target.DisplayName .. " removed from whitelist",
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "UnWhitelist",
                Content = "Player not in whitelist!",
                Icon = "x"
            })
        end
        
    elseif command == "fling" then
        if not playerName then
            WindUI:Notify({
                Title = "Fling",
                Content = "Enter player name or 'All'!",
                Icon = "x"
            })
            return
        end
        
        if playerName:lower() == "all" then
            local players = getAllPlayers()
            local flingCount = 0
            
            for _, player in pairs(players) do
                if not whitelist[player.Name] then
                    performSkidFling(player)
                    flingCount = flingCount + 1
                    task.wait(0.5)
                end
            end
            
            WindUI:Notify({
                Title = "Fling All",
                Content = "Flinging " .. flingCount .. " players",
                Icon = "check"
            })
        else
            local target = getPlayerByName(playerName)
            if not target then
                WindUI:Notify({
                    Title = "Fling",
                    Content = "Player not found!",
                    Icon = "x"
                })
                return
            end
            
            if whitelist[target.Name] then
                WindUI:Notify({
                    Title = "Fling",
                    Content = target.DisplayName .. " is whitelisted!",
                    Icon = "x"
                })
                return
            end
            
            if performSkidFling(target) then
                WindUI:Notify({
                    Title = "Fling",
                    Content = "Flinging " .. target.DisplayName,
                    Icon = "check"
                })
            end
        end
        
    elseif command == "loopfling" then
        if not playerName then
            WindUI:Notify({
                Title = "LoopFling",
                Content = "Enter player name or 'All'!",
                Icon = "x"
            })
            return
        end
        
        if playerName:lower() == "all" then
            -- Останавливаем предыдущий loopfling all
            if loopThreads["fling_all"] then
                loopThreads["fling_all"] = nil
            end
            
            loopThreads["fling_all"] = task.spawn(function()
                while loopThreads["fling_all"] do
                    local players = getAllPlayers()
                    for _, player in pairs(players) do
                        if not whitelist[player.Name] and isPlayerInCube(player) then
                            performSkidFling(player)
                        end
                    end
                    task.wait(0.1)
                end
            end)
            
            WindUI:Notify({
                Title = "LoopFling All",
                Content = "Loop flinging all in zone",
                Icon = "check"
            })
        else
            local target = getPlayerByName(playerName)
            if not target then
                WindUI:Notify({
                    Title = "LoopFling",
                    Content = "Player not found!",
                    Icon = "x"
                })
                return
            end
            
            if whitelist[target.Name] then
                WindUI:Notify({
                    Title = "LoopFling",
                    Content = target.DisplayName .. " is whitelisted!",
                    Icon = "x"
                })
                return
            end
            
            local threadName = "fling_" .. target.Name
            if loopThreads[threadName] then
                loopThreads[threadName] = nil
                WindUI:Notify({
                    Title = "LoopFling",
                    Content = "Stopped loop flinging " .. target.DisplayName,
                    Icon = "check"
                })
                return
            end
            
            loopThreads[threadName] = task.spawn(function()
                while loopThreads[threadName] do
                    if isPlayerInCube(target) then
                        performSkidFling(target)
                    end
                    task.wait(0.1)
                end
            end)
            
            WindUI:Notify({
                Title = "LoopFling",
                Content = "Loop flinging " .. target.DisplayName,
                Icon = "check"
            })
        end
        
    else
        WindUI:Notify({
            Title = "Command",
            Content = "Unknown command!",
            Icon = "x"
        })
    end
end

-- Кнопки команд
CommandsSection:Button({
    Title = "Goto (Player)",
    Desc = "Teleport to player",
    Icon = "map-pin",
    Color = Color3.fromHex("#55FF55"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("goto " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "Goto",
                Content = "Enter player name first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "LoopGoto (Player)",
    Desc = "Continuously teleport to player",
    Icon = "refresh-cw",
    Color = Color3.fromHex("#FFAA00"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("loopgoto " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "LoopGoto",
                Content = "Enter player name first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "UnLoopGoto",
    Desc = "Stop loop teleport",
    Icon = "x",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        executeCommand("unloopgoto")
    end
})

CommandsSection:Button({
    Title = "View (Player)",
    Desc = "Spectate player",
    Icon = "eye",
    Color = Color3.fromHex("#55AAFF"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("view " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "View",
                Content = "Enter player name first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "LoopView (Player)",
    Desc = "Continuously spectate",
    Icon = "eye",
    Color = Color3.fromHex("#AA55FF"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("loopview " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "LoopView",
                Content = "Enter player name first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "UnLoopView",
    Desc = "Stop spectating",
    Icon = "eye-off",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        executeCommand("unloopview")
    end
})

CommandsSection:Button({
    Title = "Whitelist (Player)",
    Desc = "Add to whitelist",
    Icon = "shield",
    Color = Color3.fromHex("#00FFAA"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("whitelist " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "Whitelist",
                Content = "Enter player name first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "UnWhitelist (Player)",
    Desc = "Remove from whitelist",
    Icon = "shield-off",
    Color = Color3.fromHex("#FFAA00"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("unwhitelist " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "UnWhitelist",
                Content = "Enter player name first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "Fling (Player)",
    Desc = "Fling player once",
    Icon = "wind",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("fling " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "Fling",
                Content = "Enter player name or 'All' first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Button({
    Title = "LoopFling (Player)",
    Desc = "Continuously fling player",
    Icon = "repeat",
    Color = Color3.fromHex("#FF0000"),
    Justify = "Center",
    Callback = function()
        if selectedPlayer and selectedPlayer ~= "" then
            executeCommand("loopfling " .. selectedPlayer)
        else
            WindUI:Notify({
                Title = "LoopFling",
                Content = "Enter player name or 'All' first!",
                Icon = "x"
            })
        end
    end
})

CommandsSection:Space()

-- Кнопка создания флинг куба
CommandsSection:Button({
    Title = "Create Fling Zone",
    Desc = "Create invisible fling cube",
    Icon = "cube",
    Color = Color3.fromHex("#AA00FF"),
    Justify = "Center",
    Callback = function()
        createFlingCube()
        WindUI:Notify({
            Title = "Fling Zone",
            Content = "Fling zone created at position!",
            Icon = "check"
        })
    end
})

-- Кнопка удаления флинг куба
CommandsSection:Button({
    Title = "Remove Fling Zone",
    Desc = "Remove fling cube",
    Icon = "trash",
    Color = Color3.fromHex("#FF5555"),
    Justify = "Center",
    Callback = function()
        if flingCube then
            flingCube:Destroy()
            flingCube = nil
            WindUI:Notify({
                Title = "Fling Zone",
                Content = "Fling zone removed!",
                Icon = "check"
            })
        end
    end
})

-- Очистка при смене персонажа
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    -- Останавливаем все потоки
    for name, thread in pairs(loopThreads) do
        loopThreads[name] = nil
    end
    
    -- Удаляем флинг куб
    if flingCube then
        flingCube:Destroy()
        flingCube = nil
    end
end)

local TeleportTab = Window:Tab({
    Title = "Teleport",
    Desc = "Teleport Features",
    Icon = "map-pin",
    IconColor = Color3.fromHex("#AA00FF"),
})

local SaveSection = TeleportTab:Section({
    Title = "Save Position"
})

local savedPositionTP = nil

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
            savedPositionTP = character.HumanoidRootPart.Position
            WindUI:Notify({
                Title = "Position Saved",
                Content = string.format("Saved at: X: %.2f, Y: %.2f, Z: %.2f", 
                    savedPositionTP.X, savedPositionTP.Y, savedPositionTP.Z),
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
        if savedPositionTP then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(savedPositionTP)
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
    ["BiggerJail"] = {X = 370.61, Y = 439.51, Z = 440.63},
    ["Dark Cube"] = {X = -68.29, Y = 84.00, Z = 20349.89},
    ["Saitama domain"] = {X = -68.29, Y = 60.00, Z = 20349.89},
    ["???"] = {X = 179925.28, Y = 428.89, Z = 111837.40}
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

local TouchFlingSection = PlayerTab:Section({
    Title = "Touch Fling"
})

local touchFlingEnabled = false
local touchFlingThread = nil

TouchFlingSection:Toggle({
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
                        hrp.Velocity = vel * 100000 + Vector3.new(0, 10000000, 0)
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
                        hrp.Velocity = vel * 100000 + Vector3.new(0, 100000000, 0)
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

-- Создаем таб Info
local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "info",
    Desc = "Info"
})

-- Секция Credits
local CreditsSection = InfoTab:Section({
    Title = "Credits",
    TextSize = 22,
    TextXAlignment = "Center",
    Opened = true,
    Box = true
})

-- Текст с именами разработчиков
CreditsSection:Section({
    Title = "Library: Footagesus",
    TextSize = 16,
    TextXAlignment = "Left"
})

CreditsSection:Divider()

CreditsSection:Section({
    Title = "Главный (Main): Likegenm",
    TextSize = 16,
    TextXAlignment = "Left"
})

CreditsSection:Divider()

CreditsSection:Section({
    Title = "Main scripter: PePel0cHeK",
    TextSize = 16,
    TextXAlignment = "Left"
})

CreditsSection:Divider()

CreditsSection:Section({
    Title = "Second scripter: Likegenm",
    TextSize = 16,
    TextXAlignment = "Left"
})

-- Разделитель
InfoTab:Divider()

-- Секция "How Create tsb script"
local TSBsection = InfoTab:Section({
    Title = "How Create tsb script",
    TextSize = 22,
    TextXAlignment = "Center",
    Opened = true,
    Box = true
})


TSBsection:Code({
    Title = "HelperTSB",
    Code = "https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/HelperTSB.lua",
    Language = "txt",
    OnCopy = function()
        WindUI:Notify({
            Title = "Copy",
            Content = "Paste in google",
            Duration = 2
        })
    end
})
