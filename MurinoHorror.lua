local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Murino Horror",
    SubTitle = "by Likegenm + Vicinly",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift 
})

local LocalPlayerTab = Window:AddTab({ Title = "LocalPlayer", Icon = "user" })
local GameTab = Window:AddTab({ Title = "Game", Icon = "sword" })
local VisualTab = Window:AddTab({ Title = "Visual", Icon = "eye" })
local CreditsTab = Window:AddTab({ Title = "Credits", Icon = "info" })

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local speedEnabled = false
local originalSpeed = humanoid.WalkSpeed
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local infiniteJumpEnabled = false
local bodyVelocity = nil
local longJumpEnabled = false
local originalJumpPower = humanoid.JumpPower
local originalHipHeight = humanoid.HipHeight
local antiBunnyEnabled = false
local lastJumpTime = 0
local speedLoop = nil
local currentSpeedValue = 16

local fullbrightEnabled = false
local originalBrightness = game.Lighting.Brightness
local originalOutdoorAmbient = game.Lighting.OutdoorAmbient
local originalGlobalShadows = game.Lighting.GlobalShadows
local originalFogEnd = game.Lighting.FogEnd
local originalFogStart = game.Lighting.FogStart

local freeCamEnabled = false
local freeCamCamera = nil
local freeCamPart = nil
local originalCameraSubject = nil
local freeCamConnection = nil
local freeCamSpeed = 3
local originalWalkSpeed = nil

local invisEnabled = false
local invisChair = nil
local invisToggleObject = nil

local floatEnabled = false
local floatBodyVelocity = nil
local floatConnection = nil

-- AntiRush переменные
local antiRushEnabled = false
local antiRushLoop = nil
local isInRushInvis = false
local rushInvisChair = nil

-- Anti Bunny/Stun переменные
local isFrozen = false
local frozenSpeed = nil
local frozenJump = nil

local function setCharacterTransparency(transparency)
    pcall(function()
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = transparency
                end
            end
        end
    end)
end

-- Функция для фриза (останавливает игрока)
local function freezePlayer()
    if isFrozen then return end
    isFrozen = true
    
    pcall(function()
        frozenSpeed = humanoid.WalkSpeed
        frozenJump = humanoid.JumpPower
        
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.PlatformStand = true
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Anti Bunny",
            Duration = 2,
            Text = "❄️ Frozen for 5 seconds"
        })
    end)
end

-- Функция для разморозки
local function unfreezePlayer()
    if not isFrozen then return end
    isFrozen = false
    
    pcall(function()
        if frozenSpeed then humanoid.WalkSpeed = frozenSpeed end
        if frozenJump then humanoid.JumpPower = frozenJump end
        humanoid.PlatformStand = false
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Anti Bunny",
            Duration = 2,
            Text = "✅ Unfrozen"
        })
    end)
end

-- Функция проверки на зайца (DontMove) и фриза
local function checkAndFreeze()
    if not antiBunnyEnabled then return end
    
    pcall(function()
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            local dontMove = playerGui:FindFirstChild("DontMove")
            if dontMove then
                local tick = dontMove:FindFirstChild("Tick")
                if tick then
                    local playing = tick:FindFirstChild("Playing")
                    if playing and playing:IsA("BoolValue") and playing.Value == true then
                        if not isFrozen then
                            freezePlayer()
                            task.wait(5)
                            unfreezePlayer()
                        end
                    end
                end
            end
        end
    end)
end

-- AntiRush функция (невидимость пока есть Skvorec)
local function startRushInvis()
    if isInRushInvis then return end
    isInRushInvis = true
    
    pcall(function()
        local savedPos = rootPart.CFrame
        local invisPos = Vector3.new(-25.95, 84, 3537.55)
        character:MoveTo(invisPos)
        task.wait(0.15)
        
        rushInvisChair = Instance.new("Seat")
        rushInvisChair.Name = "rush_invischair"
        rushInvisChair.Anchored = false
        rushInvisChair.CanCollide = false
        rushInvisChair.Transparency = 1
        rushInvisChair.Position = invisPos
        rushInvisChair.Parent = workspace
        
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            local weld = Instance.new("Weld", rushInvisChair)
            weld.Part0 = rushInvisChair
            weld.Part1 = torso
        end
        
        task.wait()
        rushInvisChair.CFrame = savedPos
        setCharacterTransparency(0.5)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "AntiRush",
            Duration = 3,
            Text = "⚠️ Rush detected! Invisibility until Skvorec disappears"
        })
    end)
end

local function stopRushInvis()
    if not isInRushInvis then return end
    isInRushInvis = false
    
    pcall(function()
        if rushInvisChair then
            rushInvisChair:Destroy()
            rushInvisChair = nil
        end
        setCharacterTransparency(0)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "AntiRush",
            Duration = 2,
            Text = "✅ Skvorec gone, invisibility off"
        })
    end)
end

-- Запуск AntiRush
local function startAntiRush()
    if antiRushLoop then antiRushLoop:Disconnect() end
    antiRushLoop = game:GetService("RunService").Stepped:Connect(function()
        if not antiRushEnabled then return end
        
        pcall(function()
            local hb = workspace:FindFirstChild("Hitboxes")
            local skvorec = hb and hb:FindFirstChild("Skvorec")
            
            if skvorec and skvorec.Parent == hb then
                if not isInRushInvis then
                    startRushInvis()
                end
            else
                if isInRushInvis then
                    stopRushInvis()
                end
            end
        end)
    end)
end

local function stopAntiRush()
    if antiRushLoop then
        antiRushLoop:Disconnect()
        antiRushLoop = nil
    end
    if isInRushInvis then
        stopRushInvis()
    end
end

local function toggleInvisibility()
    if isInRushInvis then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisibility",
            Duration = 2,
            Text = "Can't toggle while AntiRush is active"
        })
        return
    end
    
    invisEnabled = not invisEnabled

    if invisEnabled then
        local savedPos = rootPart.CFrame
        local invisPos = Vector3.new(-25.95, 84, 3537.55)

        character:MoveTo(invisPos)
        task.wait(0.15)

        invisChair = Instance.new("Seat")
        invisChair.Name = "invischair"
        invisChair.Anchored = false
        invisChair.CanCollide = false
        invisChair.Transparency = 1
        invisChair.Position = invisPos
        invisChair.Parent = workspace

        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso then
            local weld = Instance.new("Weld", invisChair)
            weld.Part0 = invisChair
            weld.Part1 = torso
        end

        task.wait()
        invisChair.CFrame = savedPos
        setCharacterTransparency(0.5)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisibility",
            Duration = 2,
            Text = "Invisibility ON"
        })
    else
        if invisChair then
            invisChair:Destroy()
            invisChair = nil
        end
        setCharacterTransparency(0)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisibility",
            Duration = 2,
            Text = "Invisibility OFF"
        })
    end
    
    if invisToggleObject then
        invisToggleObject:SetValue(invisEnabled)
    end
end

local function toggleFloat()
    floatEnabled = not floatEnabled

    if floatEnabled then
        floatBodyVelocity = Instance.new("BodyVelocity")
        floatBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        floatBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        floatBodyVelocity.Parent = rootPart

        local UIS = game:GetService("UserInputService")

        floatConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if floatEnabled and floatBodyVelocity and rootPart then
                local verticalMove = 0
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    verticalMove = 20
                elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    verticalMove = -20
                end

                local camera = workspace.CurrentCamera
                local forward = camera.CFrame.LookVector
                local right = camera.CFrame.RightVector

                local moveDirection = Vector3.new(0, 0, 0)

                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right end

                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * currentSpeedValue
                end

                floatBodyVelocity.Velocity = Vector3.new(moveDirection.X, verticalMove, moveDirection.Z)
            end
        end)

        game.StarterGui:SetCore("SendNotification", {
            Title = "Float",
            Duration = 2,
            Text = "Float ON (WASD = Move, Space = Up, Shift = Down)"
        })
    else
        if floatBodyVelocity then
            floatBodyVelocity:Destroy()
            floatBodyVelocity = nil
        end
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end

        game.StarterGui:SetCore("SendNotification", {
            Title = "Float",
            Duration = 2,
            Text = "Float OFF"
        })
    end
end

-- GUI ЭЛЕМЕНТЫ
LocalPlayerTab:AddSlider("Speed", {
    Title = "Speed",
    Description = "Change walk speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        pcall(function()
            currentSpeedValue = value
            if speedEnabled and humanoid and humanoid.Parent then
                humanoid.WalkSpeed = value
            end
        end)
    end
})

LocalPlayerTab:AddToggle("SpeedToggle", {
    Title = "Enable Speed",
    Default = false,
    Callback = function(value)
        pcall(function()
            speedEnabled = value
            if speedLoop then speedLoop:Disconnect() end
            if value then
                originalSpeed = humanoid.WalkSpeed
                speedLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if speedEnabled and humanoid and humanoid.Parent then
                        if humanoid.WalkSpeed ~= currentSpeedValue then
                            humanoid.WalkSpeed = currentSpeedValue
                        end
                    end
                end)
            else
                if humanoid then humanoid.WalkSpeed = originalSpeed end
            end
        end)
    end
})

LocalPlayerTab:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Description = "Adjust fly movement speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        pcall(function() flySpeed = value end)
    end
})

LocalPlayerTab:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Callback = function(value)
        pcall(function()
            flyEnabled = value
            if value then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = rootPart
                
                local flyConnection
                flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if flyEnabled then
                        local camera = workspace.CurrentCamera
                        local forward = camera.CFrame.LookVector
                        local right = camera.CFrame.RightVector
                        local up = camera.CFrame.UpVector
                        
                        local move = Vector3.new(0, 0, 0)
                        local UIS = game:GetService("UserInputService")
                        
                        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + up end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - up end
                        
                        if move.Magnitude > 0 then move = move.Unit * flySpeed end
                        bodyVelocity.Velocity = move
                        humanoid.PlatformStand = true
                    else
                        if bodyVelocity then bodyVelocity:Destroy() end
                        humanoid.PlatformStand = false
                        if flyConnection then flyConnection:Disconnect() end
                    end
                end)
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                humanoid.PlatformStand = false
            end
        end)
    end
})

LocalPlayerTab:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(value)
        pcall(function() infiniteJumpEnabled = value end)
    end
})

LocalPlayerTab:AddSlider("LongJump", {
    Title = "Long Jump Power",
    Description = "Set jump power",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        pcall(function()
            if longJumpEnabled and humanoid then humanoid.JumpPower = value end
        end)
    end
})

LocalPlayerTab:AddToggle("LongJumpToggle", {
    Title = "Long Jump",
    Default = false,
    Callback = function(value)
        pcall(function()
            longJumpEnabled = value
            if value then
                originalJumpPower = humanoid.JumpPower
                humanoid.JumpPower = LocalPlayerTab:GetSlider("LongJump").Value
            else
                if humanoid then humanoid.JumpPower = originalJumpPower end
            end
        end)
    end
})

LocalPlayerTab:AddSlider("HipHeight", {
    Title = "Hip Height",
    Description = "Change hip height",
    Default = 0,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        pcall(function() humanoid.HipHeight = value end)
    end
})

LocalPlayerTab:AddToggle("HipHeightToggle", {
    Title = "Enable Hip Height",
    Default = false,
    Callback = function(value)
        pcall(function()
            if value then
                originalHipHeight = humanoid.HipHeight
                humanoid.HipHeight = LocalPlayerTab:GetSlider("HipHeight").Value
            else
                humanoid.HipHeight = originalHipHeight
            end
        end)
    end
})

LocalPlayerTab:AddToggle("Noclip", {
    Title = "Noclip",
    Default = false,
    Callback = function(value)
        pcall(function()
            noclipEnabled = value
            if value then
                game:GetService("RunService").Stepped:Connect(function()
                    if noclipEnabled and character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end)
            else
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end)
    end
})

invisToggleObject = LocalPlayerTab:AddToggle("Invisibility", {
    Title = "Invisibility",
    Description = "Make your character invisible",
    Default = false,
    Callback = function(value)
        pcall(function()
            if value and not invisEnabled then toggleInvisibility()
            elseif not value and invisEnabled then toggleInvisibility() end
        end)
    end
})

LocalPlayerTab:AddToggle("Float", {
    Title = "Float",
    Description = "Float in air (WASD = Move, Space = Up, Shift = Down)",
    Default = false,
    Callback = function(value)
        pcall(function()
            if value and not floatEnabled then toggleFloat()
            elseif not value and floatEnabled then toggleFloat() end
        end)
    end
})

GameTab:AddToggle("AntiRush", {
    Title = "AntiRush",
    Description = "Auto invis while Skvorec exists in Hitboxes",
    Default = false,
    Callback = function(value)
        pcall(function()
            antiRushEnabled = value
            if value then
                startAntiRush()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "AntiRush",
                    Duration = 2,
                    Text = "AntiRush ON - Invis while Skvorec present"
                })
            else
                stopAntiRush()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "AntiRush",
                    Duration = 2,
                    Text = "AntiRush OFF"
                })
            end
        end)
    end
})

-- Anti Bunny теперь включает и фриз от DontMove
GameTab:AddToggle("AntiBunny", {
    Title = "Anti Bunny/Stun",
    Description = "Prevent bunny + Freeze when DontMove.Tick.Playing is active",
    Default = false,
    Callback = function(value)
        pcall(function()
            antiBunnyEnabled = value
            if not value and isFrozen then
                unfreezePlayer()
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "Anti Bunny/Stun",
                Duration = 2,
                Text = value and "ON - Will prevent bunny and freeze on DontMove" or "OFF"
            })
        end)
    end
})

-- Запуск проверки на зайца и фриза (раз в 0.1 секунду)
game:GetService("RunService").Stepped:Connect(function()
    checkAndFreeze()
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    pcall(function()
        if infiniteJumpEnabled and not floatEnabled and not isFrozen then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if antiBunnyEnabled then
            local currentTime = tick()
            if currentTime - lastJumpTime < 0.5 then
                humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
                return
            end
            lastJumpTime = currentTime
        end
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    pcall(function()
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.T and not isFrozen then
            local mouse = player:GetMouse()
            local targetPos = mouse.Hit.p
            local rayOrigin = targetPos + Vector3.new(0, 10, 0)
            local rayDirection = Vector3.new(0, -20, 0)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if raycastResult then
                rootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, humanoid.HipHeight + 2, 0))
            else
                rootPart.CFrame = CFrame.new(targetPos)
            end
        end
    end)
end)

-- Клавиша Z для инвиза
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z and not isInRushInvis then
        pcall(function() toggleInvisibility() end)
    end
end)

VisualTab:AddSlider("FOV", {
    Title = "Field of View",
    Description = "Change camera FOV",
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 1,
    Callback = function(value)
        pcall(function() workspace.CurrentCamera.FieldOfView = value end)
    end
})

VisualTab:AddToggle("InfZoom", {
    Title = "Infinite Zoom",
    Description = "Set max zoom distance to 1,000,000",
    Default = false,
    Callback = function(value)
        pcall(function()
            if value then player.MaxZoomDistance = 1000000
            else player.MaxZoomDistance = 20 end
        end)
    end
})

VisualTab:AddToggle("Fullbright", {
    Title = "Fullbright",
    Description = "Remove darkness and fog",
    Default = false,
    Callback = function(value)
        pcall(function()
            fullbrightEnabled = value
            if value then
                originalBrightness = game.Lighting.Brightness
                originalOutdoorAmbient = game.Lighting.OutdoorAmbient
                originalGlobalShadows = game.Lighting.GlobalShadows
                originalFogEnd = game.Lighting.FogEnd
                originalFogStart = game.Lighting.FogStart
                
                game.Lighting.Brightness = 2
                game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                game.Lighting.GlobalShadows = false
                game.Lighting.FogEnd = 100000
                game.Lighting.FogStart = 100000
            else
                game.Lighting.Brightness = originalBrightness
                game.Lighting.OutdoorAmbient = originalOutdoorAmbient
                game.Lighting.GlobalShadows = originalGlobalShadows
                game.Lighting.FogEnd = originalFogEnd
                game.Lighting.FogStart = originalFogStart
            end
        end)
    end
})

VisualTab:AddSlider("Brightness", {
    Title = "Brightness",
    Description = "Adjust game brightness",
    Default = 2,
    Min = 0,
    Max = 5,
    Rounding = 2,
    Callback = function(value)
        pcall(function() game.Lighting.Brightness = value end)
    end
})

VisualTab:AddSlider("FreeCamSpeed", {
    Title = "FreeCam Speed",
    Description = "Adjust free camera movement speed",
    Default = 3,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        pcall(function() freeCamSpeed = value end)
    end
})

VisualTab:AddToggle("FreeCam", {
    Title = "FreeCam",
    Description = "Free camera mode",
    Default = false,
    Callback = function(value)
        pcall(function()
            freeCamEnabled = value
            if value then
                originalWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 0
                
                local camera = workspace.CurrentCamera
                originalCameraSubject = camera.CameraSubject
                
                freeCamPart = Instance.new("Part")
                freeCamPart.Name = "FreeCamPart"
                freeCamPart.Transparency = 1
                freeCamPart.CanCollide = false
                freeCamPart.Anchored = true
                freeCamPart.Position = camera.CFrame.Position
                freeCamPart.Parent = workspace
                
                camera.CameraSubject = freeCamPart
                
                freeCamConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if freeCamEnabled then
                        local UIS = game:GetService("UserInputService")
                        local move = Vector3.new(0, 0, 0)
                        local cf = camera.CFrame
                        
                        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
                        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
                        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
                        
                        if move.Magnitude > 0 then
                            move = move.Unit * freeCamSpeed
                            freeCamPart.Position = freeCamPart.Position + move
                        end
                        
                        local mouse = player:GetMouse()
                        if UIS:IsKeyDown(Enum.KeyCode.RightShift) then
                            local newCF = CFrame.new(freeCamPart.Position, freeCamPart.Position + mouse.UnitRay.Direction * 100)
                            freeCamPart.CFrame = newCF
                            camera.CFrame = newCF
                        else
                            camera.CFrame = CFrame.new(freeCamPart.Position, freeCamPart.Position + camera.CFrame.LookVector)
                        end
                    end
                end)
            else
                if freeCamConnection then freeCamConnection:Disconnect() end
                if freeCamPart then freeCamPart:Destroy() end
                if originalCameraSubject then workspace.CurrentCamera.CameraSubject = originalCameraSubject end
                if originalWalkSpeed and humanoid then humanoid.WalkSpeed = originalWalkSpeed end
            end
        end)
    end
})

local CreditsSection = CreditsTab:AddSection("Script Information")
CreditsSection:AddLabel("Likegenm - Scripter")
CreditsSection:AddLabel("Vicinly - Idea + help")
CreditsSection:AddLabel("")

local FeaturesSection = CreditsTab:AddSection("Features")
FeaturesSection:AddLabel("• Speed Hack")
FeaturesSection:AddLabel("• Fly")
FeaturesSection:AddLabel("• Float (WASD/Space/Shift)")
FeaturesSection:AddLabel("• Infinite Jump")
FeaturesSection:AddLabel("• Long Jump")
FeaturesSection:AddLabel("• Noclip")
FeaturesSection:AddLabel("• Invisibility (Z key)")
FeaturesSection:AddLabel("• AntiRush - Invis while Skvorec exists")
FeaturesSection:AddLabel("• Anti Bunny/Stun - Bunny hop + Freeze on DontMove")
FeaturesSection:AddLabel("• FOV Changer")
FeaturesSection:AddLabel("• FreeCam")
FeaturesSection:AddLabel("• Fullbright")

local ControlsSection = CreditsTab:AddSection("Controls")
ControlsSection:AddLabel("T - Teleport to mouse")
ControlsSection:AddLabel("Z - Toggle Invisibility")
ControlsSection:AddLabel("WASD (Float) - Move horizontally")
ControlsSection:AddLabel("Space (Float) - Move up")
ControlsSection:AddLabel("LeftShift (Float) - Move down")
