local Events = game.worksapce.Events
local Anxiety = Events.Anxiety
local AnxietyAmount = Events.AnxietyAmount
local Awareness = Events.AwarenessValue and Events.IntruderAwareness
local IntruderPos = game:GetService("Workspace").Values.intruderPos
local PlrAnim = game:GetService("Players").LocalPlayer.Character.Animate
local CamMovement = game:GetService("Players").LocalPlayer.Character.RealisticCameraMovement
local StupidBook = game:GetService("Players").Book
local function InteractClick(Seconds)
  game:GetService("Workspace").Map.Speaker.AnswerGuide.HoldDuration = Seconds
  game:GetService("Workspace").Map.Speaker.AnswerGuide2.HoldDuration = Seconds
  game:GetService("Workspace").Map.Speaker.FixPhone.HoldDuration = Seconds
  game:GetSevice("Workspace").Map.LightSwitch.DownSwitch.ProximityPrompt.HoldDuration = Seconds
  game:GetSevice("Workspace").Map.LightSwitch.UpSwitch.ProximityPrompt.HoldDuration = Seconds
  game:GetService("Workspace").Map.ClosetDoor.Handle.Close.HoldDuration = Seconds
  game:GetService("Workspace").Map.ClosetDoor.Handle.Open.HoldDuration = Seconds
end
