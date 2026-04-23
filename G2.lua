local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Granny: Multiplayer; Chapter: 2",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Likegenm",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local Tab = Window:CreateTab("Items", 4483362458)
local player = game.Players.LocalPlayer
local allItems = {}

local espObjects = {}
local espColor = Color3.fromRGB(255, 255, 255)
local tracerColor = Color3.fromRGB(255, 255, 255)
local rainbowESP = false
local rainbowTracers = false
local espEnabled = false
local tracersEnabled = false

local function scanItems()
   allItems = {}
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") then
               table.insert(allItems, obj.Name)
            end
         end
      end
   end
end

scanItems()

local selectedItem = ""

local GrabSection = Tab:CreateSection("Item Grabber")

local dropdown = Tab:CreateDropdown({
   Name = "Select Item",
   Options = allItems,
   CurrentOption = "",
   Flag = "SelectItem",
   Callback = function(Value)
      selectedItem = Value
   end
})

Tab:CreateButton({
   Name = "Refresh Items",
   Callback = function()
      scanItems()
      dropdown:Refresh(allItems)
   end
})

Tab:CreateButton({
   Name = "Get Selected Item",
   Callback = function()
      if selectedItem == "" then return end
      for i = 1, 10 do
         local preset = workspace:FindFirstChild("Preset" .. i)
         if preset then
            local obj = preset:FindFirstChild(selectedItem)
            if obj and obj:FindFirstChild("InteractRemote") then
               obj.InteractRemote:FireServer(player)
            end
         end
      end
   end
})

Tab:CreateButton({
   Name = "Get All Items",
   Callback = function()
      for i = 1, 10 do
         local preset = workspace:FindFirstChild("Preset" .. i)
         if preset then
            for _, obj in pairs(preset:GetChildren()) do
               if obj:FindFirstChild("InteractRemote") then
                  obj.InteractRemote:FireServer(player)
               end
            end
         end
      end
   end
})

local ESPSection = Tab:CreateSection("Item ESP")

local function createESP(obj)
   local highlight = Instance.new("Highlight")
   highlight.Parent = obj
   highlight.Adornee = obj
   highlight.FillColor = espColor
   highlight.FillTransparency = 0.5
   highlight.OutlineColor = espColor
   highlight.OutlineTransparency = 0
   table.insert(espObjects, highlight)
   return highlight
end

local function clearESP()
   for _, h in pairs(espObjects) do
      h:Destroy()
   end
   espObjects = {}
end

local function applyESP()
   clearESP()
   if not espEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") then
               createESP(obj)
            end
         end
      end
   end
end

Tab:CreateToggle({
   Name = "Item ESP",
   CurrentValue = false,
   Flag = "ItemESP",
   Callback = function(Value)
      espEnabled = Value
      if Value then
         applyESP()
      else
         clearESP()
      end
   end
})

Tab:CreateToggle({
   Name = "Rainbow ESP",
   CurrentValue = false,
   Flag = "RainbowESP",
   Callback = function(Value)
      rainbowESP = Value
   end
})

Tab:CreateColorPicker({
   Name = "ESP Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "ESPColor",
   Callback = function(Value)
      espColor = Value
      for _, h in pairs(espObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local TracerSection = Tab:CreateSection("Tracers")

local tracers = {}

local function createTracer(obj)
   local tracer = Drawing.new("Line")
   tracer.Visible = true
   tracer.Color = tracerColor
   tracer.Thickness = 1
   tracer.Transparency = 1
   table.insert(tracers, {tracer = tracer, target = obj})
   return tracer
end

local function clearTracers()
   for _, t in pairs(tracers) do
      t.tracer:Remove()
   end
   tracers = {}
end

local function applyTracers()
   clearTracers()
   if not tracersEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         for _, obj in pairs(preset:GetChildren()) do
            if obj:FindFirstChild("InteractRemote") and obj:IsA("BasePart") then
               createTracer(obj)
            end
         end
      end
   end
end

Tab:CreateToggle({
   Name = "Tracers",
   CurrentValue = false,
   Flag = "Tracers",
   Callback = function(Value)
      tracersEnabled = Value
      if Value then
         applyTracers()
      else
         clearTracers()
      end
   end
})

Tab:CreateToggle({
   Name = "Rainbow Tracers",
   CurrentValue = false,
   Flag = "RainbowTracers",
   Callback = function(Value)
      rainbowTracers = Value
   end
})

Tab:CreateColorPicker({
   Name = "Tracer Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "TracerColor",
   Callback = function(Value)
      tracerColor = Value
      for _, t in pairs(tracers) do
         t.tracer.Color = Value
      end
   end
})

game:GetService("RunService").RenderStepped:Connect(function()
   local cam = workspace.CurrentCamera
   local hue = tick() % 5 / 5
   local rainbowColor = Color3.fromHSV(hue, 1, 1)
   
   if rainbowESP then
      for _, h in pairs(espObjects) do
         h.FillColor = rainbowColor
         h.OutlineColor = rainbowColor
      end
   end
   
   if tracersEnabled then
      for _, t in pairs(tracers) do
         if t.target and t.target.Parent then
            local screenPos, onScreen = cam:WorldToViewportPoint(t.target.Position)
            if onScreen then
               t.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
               t.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
               t.tracer.Visible = true
            else
               t.tracer.Visible = false
            end
            if rainbowTracers then
               t.tracer.Color = rainbowColor
            end
         else
            t.tracer.Visible = false
         end
      end
   end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
   task.wait(0.5)
   if espEnabled then applyESP() end
   if tracersEnabled then applyTracers() end
end)
