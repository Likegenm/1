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

Tab6:AddDivider()
Tab6:AddLabel("Mouse Teleport Controls:")
Tab6:AddLabel("- Enable toggle above")
Tab6:AddLabel("- Left click to teleport")
Tab6:AddLabel("- Or use button")

local Tabbox3 = LPTab:AddLeftTabbox("Fling Functions")
local Tab7 = Tabbox3:AddTab("Touch Fling")
local Tab8 = Tabbox3:AddTab("Anti Fling")

local touchFlingEnabled = false
local touchFlingThread

Tab7:AddToggle("Touch Fling", {
    Text = "Enable Touch Fling",
    Default = false,
    Callback = function(Value)
        touchFlingEnabled = Value
        
        if Value then
            Library:Notify("Touch Fling", "Enabled - Touch players to fling them", 3)
            
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
        else
            Library:Notify("Touch Fling", "Disabled", 2)
        end
    end
})

Tab7:AddButton("Reset Fling", {
    Text = "Reset Fling Velocity",
    Func = function()
        if Character and HumanoidRootPart then
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            Library:Notify("Touch Fling", "Velocity reset", 2)
        end
    end
})

Tab7:AddDivider()
Tab7:AddLabel("Touch Fling Info:")
Tab7:AddLabel("- Touch players to fling them")
Tab7:AddLabel("- Use reset button if stuck")
Tab7:AddLabel("- Turn off when not needed")

local antiFlingEnabled = false
local LastPosition = nil

Tab8:AddToggle("Anti Fling", {
    Text = "Enable Anti Fling",
    Default = false,
    Callback = function(Value)
        antiFlingEnabled = Value
        
        if Value then
            Library:Notify("Anti Fling", "Enabled - Protection active", 3)
        else
            Library:Notify("Anti Fling", "Disabled", 2)
        end
    end
})

Tab8:AddLabel("Protects against fling exploits")

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
                
                Library:Notify("Anti Fling", "Fling detected and neutralized", 2)
            elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude < 50 then
                LastPosition = PrimaryPart.CFrame
            end
        end
    end)
end)

local otherAntiFlingEnabled = false

Tab8:AddToggle("Anti Others Fling", {
    Text = "Anti Other Players Fling",
    Default = false,
    Callback = function(Value)
        otherAntiFlingEnabled = Value
        
        if Value then
            Library:Notify("Anti Fling", "Protecting against other players", 3)
            
            for i, v in ipairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    local Detected = false
                    local OtherCharacter
                    local OtherPrimaryPart
                    
                    local function CharacterAdded(NewCharacter)
                        OtherCharacter = NewCharacter
                        repeat
                            wait()
                            OtherPrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
                        until OtherPrimaryPart
                        Detected = false
                    end
                    
                    CharacterAdded(v.Character or v.CharacterAdded:Wait())
                    v.CharacterAdded:Connect(CharacterAdded)
                    
                    RunService.Heartbeat:Connect(function()
                        if otherAntiFlingEnabled and OtherCharacter and OtherCharacter:IsDescendantOf(workspace) and 
                           OtherPrimaryPart and OtherPrimaryPart:IsDescendantOf(OtherCharacter) then
                            if OtherPrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or OtherPrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                                if not Detected then
                                    Library:Notify("Anti Fling", "Fling detected: " .. v.Name, 2)
                                end
                                Detected = true
                                
                                for i, part in ipairs(OtherCharacter:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    end
                                end
                                
                                OtherPrimaryPart.CanCollide = false
                                OtherPrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                OtherPrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end)
                end
            end
        else
            Library:Notify("Anti Fling", "Other players protection disabled", 2)
        end
    end
})

Library:Notify("OHIO Script", "Loaded successfully!", 5)

Library:SelectTab(LPTab)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

ThemeManager:SetFolder("LikegenmThemes")
SaveManager:SetFolder("LikegenmSaves")

ThemeManager:ApplyToTab(LPTab)

SaveManager:LoadAutoloadConfig()
