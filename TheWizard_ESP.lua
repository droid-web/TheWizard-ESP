--[[
    TheWizard Hub v2.0
    Universal FPS Suite
]]

-- Debug: Check if script starts
print("[TheWizard Hub] Starting...")

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("[TheWizard Hub] Failed to load Rayfield: " .. tostring(Rayfield))
    
    -- Try alternative URL
    success, Rayfield = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
    end)
    
    if not success or not Rayfield then
        warn("[TheWizard Hub] Alternative also failed. Check your executor.")
        return
    end
end

print("[TheWizard Hub] Rayfield loaded successfully")

local Window = Rayfield:CreateWindow({
    Name = "TheWizard Hub",
    LoadingTitle = "TheWizard Hub",
    LoadingSubtitle = "by TheWizard",
    Theme = "Ocean",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "TheWizardConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "TheWizard Hub",
        Subtitle = "Key System",
        Note = "Enter key to access",
        FileName = "TheWizardKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"WIZARD2026TOP"}
    }
})

print("[TheWizard Hub] Window created")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local AimbotEnabled = false
local AimbotFOV = 150
local AimbotSmooth = 0.15
local TargetPart = "Head"
local TeamCheck = true
local ESPEnabled = false
local TriggerEnabled = false
local GodModeEnabled = false

local FOVCircle = nil

pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(100, 180, 255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.7
    FOVCircle.NumSides = 60
    FOVCircle.Radius = AimbotFOV
    FOVCircle.Visible = false
end)

local function IsAlive(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function IsEnemy(plr)
    if not TeamCheck then return true end
    if not plr.Team or not LocalPlayer.Team then return true end
    return plr.Team ~= LocalPlayer.Team
end

local function GetTarget()
    local closest, dist = nil, AimbotFOV
    local mPos = UserInputService:GetMouseLocation()
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAlive(plr) and IsEnemy(plr) then
            local part = plr.Character:FindFirstChild(TargetPart) or plr.Character:FindFirstChild("Head")
            if part then
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    local d = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                    if d < dist then
                        closest = part
                        dist = d
                    end
                end
            end
        end
    end
    return closest
end

local function RefreshESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local old = plr.Character:FindFirstChild("WESP")
            if old then old:Destroy() end
            
            if ESPEnabled and IsAlive(plr) and IsEnemy(plr) then
                local hl = Instance.new("Highlight")
                hl.Name = "WESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = plr.Character
            end
        end
    end
end

-- COMBAT TAB
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Aimbot")

CombatTab:CreateToggle({
    Name = "Aimbot Enabled",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(v)
        AimbotEnabled = v
        if FOVCircle then FOVCircle.Visible = v end
    end
})

CombatTab:CreateSlider({
    Name = "FOV",
    Range = {50, 400},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOV",
    Callback = function(v)
        AimbotFOV = v
        if FOVCircle then FOVCircle.Radius = v end
    end
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.05, 0.5},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.15,
    Flag = "Smooth",
    Callback = function(v)
        AimbotSmooth = v
    end
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = {"Head"},
    Flag = "Part",
    Callback = function(v)
        TargetPart = v[1]
    end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "Team",
    Callback = function(v)
        TeamCheck = v
    end
})

CombatTab:CreateSection("Triggerbot")

CombatTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Trigger",
    Callback = function(v)
        TriggerEnabled = v
    end
})

-- VISUALS TAB
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v)
        ESPEnabled = v
        RefreshESP()
    end
})

VisualsTab:CreateSection("World")

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Bright",
    Callback = function(v)
        if v then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 10000
            Lighting.GlobalShadows = true
        end
    end
})

VisualsTab:CreateSlider({
    Name = "Camera FOV",
    Range = {70, 120},
    Increment = 1,
    Suffix = "",
    CurrentValue = 70,
    Flag = "Cam",
    Callback = function(v)
        Camera.FieldOfView = v
    end
})

-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement")

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 150},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "Speed",
    Callback = function(v)
        if LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = v end
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 150},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "Jump",
    Callback = function(v)
        if LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.JumpPower = v end
        end
    end
})

PlayerTab:CreateSection("Survival")

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "God",
    Callback = function(v)
        GodModeEnabled = v
    end
})

-- SETTINGS TAB
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("Info")
SettingsTab:CreateLabel("TheWizard Hub v2.0")
SettingsTab:CreateLabel("Universal FPS Suite")

SettingsTab:CreateButton({
    Name = "Destroy Script",
    Callback = function()
        if FOVCircle then pcall(function() FOVCircle:Remove() end) end
        ESPEnabled = false
        RefreshESP()
        Rayfield:Destroy()
    end
})

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if FOVCircle then
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end
    
    -- Aimbot
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetTarget()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), AimbotSmooth)
        end
    end
    
    -- Triggerbot
    if TriggerEnabled then
        local hit = Mouse.Target
        if hit then
            local plr = Players:GetPlayerFromCharacter(hit.Parent) or Players:GetPlayerFromCharacter(hit.Parent.Parent)
            if plr and plr ~= LocalPlayer and IsEnemy(plr) then
                task.wait(0.1)
                mouse1click()
            end
        end
    end
    
    -- God Mode
    if GodModeEnabled and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.MaxHealth = math.huge
            h.Health = math.huge
        end
    end
end)

-- ESP on new players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        RefreshESP()
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        RefreshESP()
    end)
end

print("[TheWizard Hub] Fully loaded!")

Rayfield:Notify({
    Title = "TheWizard Hub",
    Content = "Loaded - Hold RMB for aimbot",
    Duration = 4
})
