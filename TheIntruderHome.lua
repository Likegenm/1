local Events = game.worksapce.Events
local Anxiety = Events.Anxiety
local AnxietyAmount = Events.AnxietyAmount
local Awareness = Events.AwarenessValue and Events.IntruderAwareness
local IntruderPos = game:GetService("Workspace").Values.intruderPos
local PlrAnim = game:GetService("Players").LocalPlayer.Character.Animate
local CamMovement = game:GetService("Players").LocalPlayer.Character.RealisticCameraMovement
local StupidBook = game:GetService("Players").Book
local function InteractClick()
  game.workspace.Map.Speaker.AnswerGuide.HoldDuration = 0
  game.workspace.Map.Speaker.AnswerGuide2.HoldDuration = 0
  game.workspace.Map.Speaker.FixPhone.HoldDuration = 0
  game.workspace.Map.LightSwitch.DownSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.Map.LightSwitch.UpSwitch.ProximityPrompt.HoldDuration = 0
  game.workspace.Map.ClosetDoor.Handle.Close.HoldDuration = 0
  game.workspace.Map.ClosetDoor.Handle.Open.HoldDuration = 0
end
