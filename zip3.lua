local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Troll is a pinning 2",
    Footer = "v1.0.0 by likegenm (хайп прошел но ладно)",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})
local MainTab = Window:AddTab("Main", "home")

local PlayerGroupbox = MainTab:AddLeftGroupbox("Players")

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
	if not Value then
		print("Toggle infjump")
	end
})
