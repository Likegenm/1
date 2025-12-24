local function showNotification(titleText, subtitleText)
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local old = PlayerGui:FindFirstChild("Notification")
    if old then old:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Notification"
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 75)
    frame.Position = UDim2.new(1, 10, 1, -110) -- За экраном справа
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 5)
    
    local title = Instance.new("TextLabel", frame)
    title.Text = titleText or "Hello"
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    
    local subtitle = Instance.new("TextLabel", frame)
    subtitle.Text = subtitleText or "Hi"
    subtitle.Size = UDim2.new(1, 0, 0.5, 0)
    subtitle.Position = UDim2.new(0, 0, 0.5, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.new(1, 1, 1)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 20
    
    frame.Parent = screenGui
    screenGui.Parent = PlayerGui
    
    local TweenService = game:GetService("TweenService")
    
    local appear = TweenService:Create(frame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -310, 1, -110) -- В правый нижний угол
        })
    
    local disappear = TweenService:Create(frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 1, -110) -- Обратно за экран
        })
    
    appear:Play()
    

    task.wait(3)
    
    appear:Cancel()
    disappear:Play()
    
    disappear.Completed:Wait()
    screenGui:Destroy()
end

showNotification("System Cheat", "Troll is a pinning tower 2")

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Real-Scripts/refs/heads/main/DownoloadLiblary.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Likegenm/Test/refs/heads/main/Irina.lua"))()
	
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Troll is a pinning tower 2",
    Footer = "v1.0.0 by likegenm (хайп прошел но ладно)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})
local MainTab = Window:AddTab("Main", "home")

local PlayerGroupbox = MainTab:AddLeftGroupbox("Player")

local SpeedHack = PlayerGroupbox:AddInput("SpeedHACK", {
    Text = "SpeedHack",
    Default = "Ur speed",
    Numeric = false,
    Finished = true,
    Placeholder = "Ur speed",
    Callback = function(Value)
     game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

PlayerGroupbox:AddToggle("Infjump", {
	Text = "InfJumps",
	Default = false,
	Tooltip = "Inf",
	Callback = function(Value)
		if Value then
			game:GetService("UserInputService").InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.Space then
					game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		end
	end
})

local floatConnection

local FloatToggle = PlayerGroupbox:AddToggle("Float", {
    Text = "Float",
    Default = false,
    Tooltip = "Float mode / slow fall",
    Callback = function(Value)
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        if Value then
            floatConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                
                local UIS = game:GetService("UserInputService")
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z)
                elseif UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    root.Velocity = Vector3.new(root.Velocity.X, -50, root.Velocity.Z)
                end
            end)
        end
    end
})

local Groupbox = MainTab:AddRightGroupbox("Idk")

local Button = Groupbox:AddButton({
    Text = "Win!",
    Func = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(284.30, 347.25, -34.26)
    end,
    DoubleClick = false
})

local Troll = Window:AddTab("Troll")

local TGB = Troll:AddLeftGroupbox("1Button")

TGB:AddToggle("Troll", {
    Text = "1Button troll",
    Default = false,
    Callback = function(Value)
        teleportActive = Value
        
        if Value then
            local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-14.92, 147.15, -80.60)
				
local point1 = Vector3.new(-14.92, 147.15, -80.60)
local point2 = Vector3.new(-78.37, 148.41, -81.09)
local toPoint2 = true

while true do
    local targetPosition = toPoint2 and point2 or point1
    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(3), {Position = targetPosition})
    tween:Play()
    tween.Completed:Wait()
    toPoint2 = not toPoint2
end
})
