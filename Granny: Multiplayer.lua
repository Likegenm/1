local workspace = game:GetService("Workspace")

local function findPreset()
    for i = 1, 10 do
        local preset = workspace:FindFirstChild("Preset" .. i)
        if preset then
            local locks = preset:FindFirstChild("Locks")
            if locks then
                if locks:FindFirstChild("SlendrinaMother") then
                    return 1
                elseif locks:FindFirstChild("Grandpa") then
                    return 2
                end
            end
            
            if preset:FindFirstChild("Slendrina") then
                return 3
            end
        end
    end
    return nil
end

local chapter = findPreset()

if chapter == 1 then
    print("Chapter 1")
elseif chapter == 2 then
    print("Chapter 2")
elseif chapter == 3 then
    print("Chapter 3")
else
    print("Chapter not found")
end
