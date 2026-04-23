local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Granny: Chapter 1",
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

local scanItems = function()
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

local createESP = function(obj)
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

local clearESP = function()
   for _, h in pairs(espObjects) do
      h:Destroy()
   end
   espObjects = {}
end

local applyESP = function()
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
      if Value then applyESP() else clearESP() end
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

local TracerSection = Tab:CreateSection("Item Tracers")

local tracers = {}

local createTracer = function(obj)
   local tracer = Drawing.new("Line")
   tracer.Visible = true
   tracer.Color = tracerColor
   tracer.Thickness = 1
   tracer.Transparency = 1
   table.insert(tracers, {tracer = tracer, target = obj})
   return tracer
end

local clearTracers = function()
   for _, t in pairs(tracers) do
      t.tracer:Remove()
   end
   tracers = {}
end

local applyTracers = function()
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
   Name = "Item Tracers",
   CurrentValue = false,
   Flag = "ItemTracers",
   Callback = function(Value)
      tracersEnabled = Value
      if Value then applyTracers() else clearTracers() end
   end
})

Tab:CreateToggle({
   Name = "Rainbow Tracers",
   CurrentValue = false,
   Flag = "RainbowItemTracers",
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

local VisualTab = Window:CreateTab("Visual", 4483362458)

local VisualSection = VisualTab:CreateSection("Visuals")

VisualTab:CreateSlider({
   Name = "FOV Changer",
   Range = {30, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOV",
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end
})

local grannyESPObjects = {}
local grannyESPColor = Color3.fromRGB(255, 0, 0)
local grannyESPEnabled = false
local rainbowGrannyESP = false

local clearGrannyESP = function()
   for _, h in pairs(grannyESPObjects) do
      h:Destroy()
   end
   grannyESPObjects = {}
end

local applyGrannyESP = function()
   clearGrannyESP()
   if not grannyESPEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local granny = locks:FindFirstChild("Granny")
            if granny then
               local highlight = Instance.new("Highlight")
               highlight.Parent = granny
               highlight.Adornee = granny
               highlight.FillColor = grannyESPColor
               highlight.FillTransparency = 0.5
               highlight.OutlineColor = grannyESPColor
               highlight.OutlineTransparency = 0
               table.insert(grannyESPObjects, highlight)
            end
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Granny ESP",
   CurrentValue = false,
   Flag = "GrannyESP",
   Callback = function(Value)
      grannyESPEnabled = Value
      if Value then applyGrannyESP() else clearGrannyESP() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Granny ESP",
   CurrentValue = false,
   Flag = "RainbowGrannyESP",
   Callback = function(Value)
      rainbowGrannyESP = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Granny ESP Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "GrannyESPColor",
   Callback = function(Value)
      grannyESPColor = Value
      for _, h in pairs(grannyESPObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local slendrinaESPObjects = {}
local slendrinaESPColor = Color3.fromRGB(255, 0, 255)
local slendrinaESPEnabled = false
local rainbowSlendrinaESP = false

local clearSlendrinaESP = function()
   for _, h in pairs(slendrinaESPObjects) do
      h:Destroy()
   end
   slendrinaESPObjects = {}
end

local applySlendrinaESP = function()
   clearSlendrinaESP()
   if not slendrinaESPEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local slendrina = locks:FindFirstChild("SlendrinaMother")
            if slendrina then
               local highlight = Instance.new("Highlight")
               highlight.Parent = slendrina
               highlight.Adornee = slendrina
               highlight.FillColor = slendrinaESPColor
               highlight.FillTransparency = 0.5
               highlight.OutlineColor = slendrinaESPColor
               highlight.OutlineTransparency = 0
               table.insert(slendrinaESPObjects, highlight)
            end
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "SlendrinaMother ESP",
   CurrentValue = false,
   Flag = "SlendrinaESP",
   Callback = function(Value)
      slendrinaESPEnabled = Value
      if Value then applySlendrinaESP() else clearSlendrinaESP() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Slendrina ESP",
   CurrentValue = false,
   Flag = "RainbowSlendrinaESP",
   Callback = function(Value)
      rainbowSlendrinaESP = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Slendrina ESP Color",
   Color = Color3.fromRGB(255, 0, 255),
   Flag = "SlendrinaESPColor",
   Callback = function(Value)
      slendrinaESPColor = Value
      for _, h in pairs(slendrinaESPObjects) do
         h.FillColor = Value
         h.OutlineColor = Value
      end
   end
})

local thirdPersonEnabled = false

VisualTab:CreateToggle({
   Name = "Third Person",
   CurrentValue = false,
   Flag = "ThirdPerson",
   Callback = function(Value)
      thirdPersonEnabled = Value
      if Value then
         player.CameraMinZoomDistance = 0.5
         player.CameraMaxZoomDistance = 20
      else
         player.CameraMinZoomDistance = 0.5
         player.CameraMaxZoomDistance = 0.5
      end
   end
})

local fullbrightEnabled = false
local defaultLighting = {}

VisualTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
      fullbrightEnabled = Value
      local lighting = game:GetService("Lighting")
      if Value then
         defaultLighting.Brightness = lighting.Brightness
         defaultLighting.ClockTime = lighting.ClockTime
         defaultLighting.FogEnd = lighting.FogEnd
         defaultLighting.GlobalShadows = lighting.GlobalShadows
         defaultLighting.OutdoorAmbient = lighting.OutdoorAmbient
         
         lighting.Brightness = 2
         lighting.ClockTime = 14
         lighting.FogEnd = 100000
         lighting.GlobalShadows = false
         lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
      else
         lighting.Brightness = defaultLighting.Brightness
         lighting.ClockTime = defaultLighting.ClockTime
         lighting.FogEnd = defaultLighting.FogEnd
         lighting.GlobalShadows = defaultLighting.GlobalShadows
         lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
      end
   end
})

local GrannyTracerSection = VisualTab:CreateSection("Granny Tracers")
local grannyTracers = {}
local grannyTracerColor = Color3.fromRGB(255, 0, 0)
local grannyTracersEnabled = false
local rainbowGrannyTracers = false

local createGrannyTracer = function(obj)
   local tracer = Drawing.new("Line")
   tracer.Visible = true
   tracer.Color = grannyTracerColor
   tracer.Thickness = 2
   tracer.Transparency = 1
   table.insert(grannyTracers, {tracer = tracer, target = obj})
   return tracer
end

local clearGrannyTracers = function()
   for _, t in pairs(grannyTracers) do
      t.tracer:Remove()
   end
   grannyTracers = {}
end

local applyGrannyTracers = function()
   clearGrannyTracers()
   if not grannyTracersEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local granny = locks:FindFirstChild("Granny")
            if granny and granny:IsA("BasePart") then
               createGrannyTracer(granny)
            end
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Granny Tracers",
   CurrentValue = false,
   Flag = "GrannyTracers",
   Callback = function(Value)
      grannyTracersEnabled = Value
      if Value then applyGrannyTracers() else clearGrannyTracers() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Granny Tracers",
   CurrentValue = false,
   Flag = "RainbowGrannyTracers",
   Callback = function(Value)
      rainbowGrannyTracers = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Granny Tracer Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "GrannyTracerColor",
   Callback = function(Value)
      grannyTracerColor = Value
      for _, t in pairs(grannyTracers) do
         t.tracer.Color = Value
      end
   end
})

local SlendrinaTracerSection = VisualTab:CreateSection("Slendrina Tracers")
local slendrinaTracers = {}
local slendrinaTracerColor = Color3.fromRGB(255, 0, 255)
local slendrinaTracersEnabled = false
local rainbowSlendrinaTracers = false

local createSlendrinaTracer = function(obj)
   local tracer = Drawing.new("Line")
   tracer.Visible = true
   tracer.Color = slendrinaTracerColor
   tracer.Thickness = 2
   tracer.Transparency = 1
   table.insert(slendrinaTracers, {tracer = tracer, target = obj})
   return tracer
end

local clearSlendrinaTracers = function()
   for _, t in pairs(slendrinaTracers) do
      t.tracer:Remove()
   end
   slendrinaTracers = {}
end

local applySlendrinaTracers = function()
   clearSlendrinaTracers()
   if not slendrinaTracersEnabled then return end
   for i = 1, 10 do
      local preset = workspace:FindFirstChild("Preset" .. i)
      if preset then
         local locks = preset:FindFirstChild("Locks")
         if locks then
            local slendrina = locks:FindFirstChild("SlendrinaMother")
            if slendrina and slendrina:IsA("BasePart") then
               createSlendrinaTracer(slendrina)
            end
         end
      end
   end
end

VisualTab:CreateToggle({
   Name = "Slendrina Tracers",
   CurrentValue = false,
   Flag = "SlendrinaTracers",
   Callback = function(Value)
      slendrinaTracersEnabled = Value
      if Value then applySlendrinaTracers() else clearSlendrinaTracers() end
   end
})

VisualTab:CreateToggle({
   Name = "Rainbow Slendrina Tracers",
   CurrentValue = false,
   Flag = "RainbowSlendrinaTracers",
   Callback = function(Value)
      rainbowSlendrinaTracers = Value
   end
})

VisualTab:CreateColorPicker({
   Name = "Slendrina Tracer Color",
   Color = Color3.fromRGB(255, 0, 255),
   Flag = "SlendrinaTracerColor",
   Callback = function(Value)
      slendrinaTracerColor = Value
      for _, t in pairs(slendrinaTracers) do
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
   
   if rainbowGrannyESP then
      for _, h in pairs(grannyESPObjects) do
         h.FillColor = rainbowColor
         h.OutlineColor = rainbowColor
      end
   end
   
   if rainbowSlendrinaESP then
      for _, h in pairs(slendrinaESPObjects) do
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
   
   if grannyTracersEnabled then
      for _, t in pairs(grannyTracers) do
         if t.target and t.target.Parent then
            local screenPos, onScreen = cam:WorldToViewportPoint(t.target.Position)
            if onScreen then
               t.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
               t.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
               t.tracer.Visible = true
            else
               t.tracer.Visible = false
            end
            if rainbowGrannyTracers then
               t.tracer.Color = rainbowColor
            end
         else
            t.tracer.Visible = false
         end
      end
   end
   
   if slendrinaTracersEnabled then
      for _, t in pairs(slendrinaTracers) do
         if t.target and t.target.Parent then
            local screenPos, onScreen = cam:WorldToViewportPoint(t.target.Position)
            if onScreen then
               t.tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
               t.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
               t.tracer.Visible = true
            else
               t.tracer.Visible = false
            end
            if rainbowSlendrinaTracers then
               t.tracer.Color = rainbowColor
            end
         else
            t.tracer.Visible = false
         end
      end
   end
end)

player.CharacterAdded:Connect(function()
   task.wait(0.5)
   if espEnabled then applyESP() end
   if tracersEnabled then applyTracers() end
   if grannyESPEnabled then applyGrannyESP() end
   if slendrinaESPEnabled then applySlendrinaESP() end
   if grannyTracersEnabled then applyGrannyTracers() end
   if slendrinaTracersEnabled then applySlendrinaTracers() end
end)
