--[[
    TheWizard Hub v2.0
    Universal FPS Suite
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "TheWizard Hub",
    Icon = "crosshair",
    LoadingTitle = "TheWizard Hub",
    LoadingSubtitle = "Universal FPS Suite v2.0",
    Theme = "Ocean",
    ToggleUIKeybind = "RightShift",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TheWizardHub",
        FileName = "WizardConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "TheWizard Hub",
        Subtitle = "Authorization Required",
        Note = "Contact TheWizard for access",
        FileName = "TheWizardKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"WIZARD2026TOP"}
    }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 150,
        Smoothness = 0.15,
        TargetPart = "Head",
        TeamCheck = true,
        ShowFOV = true
    },
    Triggerbot = {
        Enabled = false,
        Delay = 0.1
    },
    ESP = {
        Enabled = false,
        TeamCheck = true
    },
    World = {
        Fullbright = false
    },
    Movement = {
        Speed = 16,
        JumpPower = 50
    },
    Player = {
        GodMode = false
    }
}

local Connections = {}
local FOVCircle = nil

local function IsAlive(player)
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    return hum and hum.Health > 0 and root
end

local function IsTeammate(player)
    if not Settings.Aimbot.TeamCheck then return false end
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function GetClosestPlayer()
    local closest = nil
    local shortestDist = Settings.Aimbot.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and not IsTeammate(player) then
            local char = player.Character
            local part = char:FindFirstChild(Settings.Aimbot.TargetPart) or char:FindFirstChild("Head")
            
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        closest = part
                        shortestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(100, 180, 255)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.7
    FOVCircle.NumSides = 60
    FOVCircle.Radius = Settings.Aimbot.FOV
    FOVCircle.Visible = false
end)

local function UpdateESP(enabled)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local existing = player.Character:FindFirstChild("WizardHL")
            if existing then existing:Destroy() end
            
            if enabled and IsAlive(player) then
                if not Settings.ESP.TeamCheck or not IsTeammate(player) then
                    local hl = Instance.new("Highlight")
                    hl.Name = "WizardHL"
                    hl.FillColor = IsTeammate(player) and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = player.Character
                end
            end
        end
    end
end

local CombatTab = Window:CreateTab("Combat", "crosshair")
CombatTab:CreateSection("Aim Assist")

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(v)
        Settings.Aimbot.Enabled = v
        if FOVCircle then FOVCircle.Visible = v and Settings.Aimbot.ShowFOV end
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
        Settings.Aimbot.FOV = v
        if FOVCircle then FOVCircle.Radius = v end
    end
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.15,
    Flag = "Smooth",
    Callback = function(v)
        Settings.Aimbot.Smoothness = v
    end
})

CombatTab:CreateDropdown({
    Name = "Target",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = {"Head"},
    Flag = "Target",
    Callback = function(v)
        Settings.Aimbot.TargetPart = v[1]
    end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(v)
        Settings.Aimbot.TeamCheck = v
    end
})

CombatTab:CreateToggle({
    Name = "Show FOV",
    CurrentValue = true,
    Flag = "ShowFOV",
    Callback = function(v)
        Settings.Aimbot.ShowFOV = v
        if FOVCircle then FOVCircle.Visible = v and Settings.Aimbot.Enabled end
    end
})

CombatTab:CreateSection("Triggerbot")

CombatTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Triggerbot",
    Callback = function(v)
        Settings.Triggerbot.Enabled = v
    end
})

local VisualsTab = Window:CreateTab("Visuals", "eye")
VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v)
        Settings.ESP.Enabled = v
        UpdateESP(v)
    end
})

VisualsTab:CreateToggle({
    Name = "ESP Team Check",
    CurrentValue = true,
    Flag = "ESPTeam",
    Callback = function(v)
        Settings.ESP.TeamCheck = v
        UpdateESP(Settings.ESP.Enabled)
    end
})

VisualsTab:CreateSection("World")

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(v)
        Settings.World.Fullbright = v
        if v then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 10000
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})

VisualsTab:CreateSlider({
    Name = "Camera FOV",
    Range = {70, 120},
    Increment = 1,
    Suffix = "",
    CurrentValue = 70,
    Flag = "CamFOV",
    Callback = function(v)
        Camera.FieldOfView = v
    end
})

local MovementTab = Window:CreateTab("Movement", "zap")
MovementTab:CreateSection("Speed")

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Flag = "Speed",
    Callback = function(v)
        Settings.Movement.Speed = v
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 150},
    Increment = 5,
    CurrentValue = 50,
    Flag = "Jump",
    Callback = function(v)
        Settings.Movement.JumpPower = v
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end
})

local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:CreateSection("Survival")

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(v)
        Settings.Player.GodMode = v
        if v then
            Connections.God = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                end
            end)
        else
            if Connections.God then Connections.God:Disconnect() end
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.MaxHealth = 100
                    hum.Health = 100
                end
            end
        end
    end
})

PlayerTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end
})

local MiscTab = Window:CreateTab("Settings", "settings")
MiscTab:CreateSection("Anti-AFK")

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(v)
        if v then
            local vu = game:GetService("VirtualUser")
            Connections.AFK = LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
            end)
        else
            if Connections.AFK then Connections.AFK:Disconnect() end
        end
    end
})

MiscTab:CreateSection("Info")
MiscTab:CreateLabel("TheWizard Hub v2.0")
MiscTab:CreateLabel("Universal FPS Suite")

MiscTab:CreateButton({
    Name = "Destroy Script",
    Callback = function()
        for _, c in pairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        if FOVCircle then pcall(function() FOVCircle:Remove() end) end
        UpdateESP(false)
        Rayfield:Destroy()
    end
})

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end
    
    if Settings.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            local targetCF = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Aimbot.Smoothness)
        end
    end
    
    if Settings.Triggerbot.Enabled then
        local hit = Mouse.Target
        if hit then
            local player = Players:GetPlayerFromCharacter(hit.Parent) or Players:GetPlayerFromCharacter(hit.Parent.Parent)
            if player and player ~= LocalPlayer and not IsTeammate(player) then
                task.wait(Settings.Triggerbot.Delay)
                mouse1click()
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if Settings.ESP.Enabled then UpdateESP(true) end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if Settings.ESP.Enabled then UpdateESP(true) end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = Settings.Movement.Speed
    hum.JumpPower = Settings.Movement.JumpPower
end)

Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "TheWizard Hub",
    Content = "Script loaded - RMB for aimbot",
    Duration = 4
})
