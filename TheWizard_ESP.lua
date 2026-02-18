--[[
    ████████╗██╗  ██╗███████╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ 
    ╚══██╔══╝██║  ██║██╔════╝    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗
       ██║   ███████║█████╗      ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║
       ██║   ██╔══██║██╔══╝      ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║
       ██║   ██║  ██║███████╗    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝
       ╚═╝   ╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
                                    
                            Universal Script v1.0
                          Aimbot • ESP • GodMode • Troll
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variables
local Connections = {}
local ESPCache = {}
local Settings = {
    -- Aimbot
    AimbotEnabled = false,
    AimbotKey = Enum.UserInputType.MouseButton2,
    AimbotFOV = 150,
    AimbotSmooth = 0.15,
    AimbotPrediction = 0.165,
    AimbotPart = "Head",
    AimbotTeamCheck = true,
    AimbotWallCheck = true,
    AimbotShowFOV = true,
    
    -- ESP
    ESPEnabled = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTeamCheck = true,
    ESPColor = Color3.fromRGB(255, 50, 50),
    
    -- Player
    GodMode = false,
    InfiniteJump = false,
    Noclip = false,
    Fly = false,
    Speed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    
    -- Visuals
    Fullbright = false,
    NoFog = false,
    
    -- Troll
    Annoy = false,
    AnnoyTarget = "",
    Spin = false,
    SpinSpeed = 10,
    Fling = false,
}

-- Utility Functions
local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function Disconnect(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

local function IsTeammate(player)
    if not Settings.AimbotTeamCheck then return false end
    if not LocalPlayer.Team or not player.Team then return false end
    return LocalPlayer.Team == player.Team
end

local function IsVisible(part)
    if not Settings.AimbotWallCheck then return true end
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {GetCharacter(), Camera}
    local result = workspace:Raycast(origin, (part.Position - origin).Unit * 2000, params)
    if result then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

local function GetPlayers()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not IsTeammate(player) then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local head = char:FindFirstChild("Head")
                    if hum and root and head and hum.Health > 0 then
                        table.insert(players, {
                            Player = player,
                            Character = char,
                            Humanoid = hum,
                            Root = root,
                            Head = head,
                        })
                    end
                end
            end
        end
    end
    return players
end

local function GetClosestPlayer()
    local closest = nil
    local closestDist = Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, data in pairs(GetPlayers()) do
        local part = data.Character:FindFirstChild(Settings.AimbotPart) or data.Head
        if not part then continue end
        if not IsVisible(part) then continue end
        
        local vel = data.Root.Velocity
        local predicted = part.Position + (vel * Settings.AimbotPrediction)
        local screen, onScreen = Camera:WorldToViewportPoint(predicted)
        
        if onScreen then
            local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = {
                    Data = data,
                    Part = part,
                    Predicted = predicted,
                    Screen = Vector2.new(screen.X, screen.Y),
                }
            end
        end
    end
    
    return closest
end

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "TheWizard",
    Icon = "wand-2",
    LoadingTitle = "TheWizard",
    LoadingSubtitle = "Universal Script",
    Theme = "Amethyst",
    
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TheWizard",
        FileName = "Config"
    },
    
    KeySystem = true,
    KeySettings = {
        Title = "TheWizard - Key System",
        Subtitle = "Authentification requise",
        Note = "Clé: TheWizardBest",
        FileName = "TheWizardKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"TheWizardBest"}
    }
})

-- ══════════════════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ══════════════════════════════════════════════════════════════════════════════

local AimbotTab = Window:CreateTab("Aimbot", "crosshair")

local AimbotSection = AimbotTab:CreateSection("Principal")

AimbotTab:CreateToggle({
    Name = "Activer Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(v)
        Settings.AimbotEnabled = v
    end,
})

AimbotTab:CreateDropdown({
    Name = "Touche",
    Options = {"Clic Droit", "Clic Gauche", "Shift", "Ctrl", "E", "Q"},
    CurrentOption = {"Clic Droit"},
    Flag = "AimbotKey",
    Callback = function(opt)
        local keys = {
            ["Clic Droit"] = Enum.UserInputType.MouseButton2,
            ["Clic Gauche"] = Enum.UserInputType.MouseButton1,
            ["Shift"] = Enum.KeyCode.LeftShift,
            ["Ctrl"] = Enum.KeyCode.LeftControl,
            ["E"] = Enum.KeyCode.E,
            ["Q"] = Enum.KeyCode.Q,
        }
        Settings.AimbotKey = keys[opt[1]] or Enum.UserInputType.MouseButton2
    end,
})

AimbotTab:CreateDropdown({
    Name = "Partie visée",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = {"Head"},
    Flag = "AimbotPart",
    Callback = function(opt)
        Settings.AimbotPart = opt[1]
    end,
})

local FOVSection = AimbotTab:CreateSection("FOV")

AimbotTab:CreateSlider({
    Name = "Taille FOV",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "AimbotFOV",
    Callback = function(v)
        Settings.AimbotFOV = v
    end,
})

AimbotTab:CreateToggle({
    Name = "Afficher FOV",
    CurrentValue = true,
    Flag = "ShowFOV",
    Callback = function(v)
        Settings.AimbotShowFOV = v
    end,
})

local PrecisionSection = AimbotTab:CreateSection("Précision")

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.15,
    Flag = "AimbotSmooth",
    Callback = function(v)
        Settings.AimbotSmooth = v
    end,
})

AimbotTab:CreateSlider({
    Name = "Prédiction",
    Range = {0.1, 0.3},
    Increment = 0.005,
    CurrentValue = 0.165,
    Flag = "AimbotPrediction",
    Callback = function(v)
        Settings.AimbotPrediction = v
    end,
})

local FiltersSection = AimbotTab:CreateSection("Filtres")

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "AimbotTeamCheck",
    Callback = function(v)
        Settings.AimbotTeamCheck = v
    end,
})

AimbotTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = true,
    Flag = "AimbotWallCheck",
    Callback = function(v)
        Settings.AimbotWallCheck = v
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP TAB
-- ══════════════════════════════════════════════════════════════════════════════

local ESPTab = Window:CreateTab("ESP", "eye")

local ESPMainSection = ESPTab:CreateSection("Principal")

ESPTab:CreateToggle({
    Name = "Activer ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(v)
        Settings.ESPEnabled = v
        if not v then
            for _, esp in pairs(ESPCache) do
                if esp.Billboard then esp.Billboard.Enabled = false end
                if esp.Highlight then esp.Highlight.Enabled = false end
            end
        end
    end,
})

ESPTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "ESPTeamCheck",
    Callback = function(v)
        Settings.ESPTeamCheck = v
    end,
})

ESPTab:CreateColorPicker({
    Name = "Couleur ESP",
    Color = Color3.fromRGB(255, 50, 50),
    Flag = "ESPColor",
    Callback = function(c)
        Settings.ESPColor = c
    end,
})

local ESPOptionsSection = ESPTab:CreateSection("Options")

ESPTab:CreateToggle({
    Name = "Box / Highlight",
    CurrentValue = true,
    Flag = "ESPBox",
    Callback = function(v)
        Settings.ESPBox = v
    end,
})

ESPTab:CreateToggle({
    Name = "Nom",
    CurrentValue = true,
    Flag = "ESPName",
    Callback = function(v)
        Settings.ESPName = v
    end,
})

ESPTab:CreateToggle({
    Name = "Barre de vie",
    CurrentValue = true,
    Flag = "ESPHealth",
    Callback = function(v)
        Settings.ESPHealth = v
    end,
})

ESPTab:CreateToggle({
    Name = "Distance",
    CurrentValue = true,
    Flag = "ESPDistance",
    Callback = function(v)
        Settings.ESPDistance = v
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- PLAYER TAB
-- ══════════════════════════════════════════════════════════════════════════════

local PlayerTab = Window:CreateTab("Player", "user")

local MovementSection = PlayerTab:CreateSection("Mouvement")

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "Speed",
    Callback = function(v)
        Settings.Speed = v
        local hum = GetHumanoid()
        if hum then hum.WalkSpeed = v end
    end,
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(v)
        Settings.JumpPower = v
        local hum = GetHumanoid()
        if hum then hum.JumpPower = v end
    end,
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(v)
        Settings.InfiniteJump = v
        Disconnect("InfiniteJump")
        if v then
            Connections["InfiniteJump"] = UserInputService.JumpRequest:Connect(function()
                local hum = GetHumanoid()
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(v)
        Settings.Noclip = v
        Disconnect("Noclip")
        if v then
            Connections["Noclip"] = RunService.Stepped:Connect(function()
                local char = GetCharacter()
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local char = GetCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local FlySection = PlayerTab:CreateSection("Vol")

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(v)
        Settings.Fly = v
        Disconnect("Fly")
        local root = GetRootPart()
        
        if v and root then
            local bg = Instance.new("BodyGyro")
            bg.Name = "WizardGyro"
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = root.CFrame
            bg.Parent = root
            
            local bv = Instance.new("BodyVelocity")
            bv.Name = "WizardVelocity"
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = root
            
            Connections["Fly"] = RunService.RenderStepped:Connect(function()
                if Settings.Fly and root then
                    local g = root:FindFirstChild("WizardGyro")
                    local vel = root:FindFirstChild("WizardVelocity")
                    if g and vel then
                        g.cframe = Camera.CFrame
                        local dir = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
                        vel.Velocity = dir * Settings.FlySpeed
                    end
                end
            end)
        else
            if root then
                local g = root:FindFirstChild("WizardGyro")
                local vel = root:FindFirstChild("WizardVelocity")
                if g then g:Destroy() end
                if vel then vel:Destroy() end
            end
        end
        
        Rayfield:Notify({
            Title = "Fly",
            Content = v and "Activé (WASD + Space/Ctrl)" or "Désactivé",
            Duration = 3,
            Image = "navigation",
        })
    end,
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(v)
        Settings.FlySpeed = v
    end,
})

local GodSection = PlayerTab:CreateSection("Protection")

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(v)
        Settings.GodMode = v
        Disconnect("GodMode")
        local hum = GetHumanoid()
        
        if v then
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
            Connections["GodMode"] = RunService.Heartbeat:Connect(function()
                local h = GetHumanoid()
                if h and Settings.GodMode then
                    h.MaxHealth = math.huge
                    h.Health = math.huge
                end
            end)
        else
            if hum then
                hum.MaxHealth = 100
                hum.Health = 100
            end
        end
        
        Rayfield:Notify({
            Title = "God Mode",
            Content = v and "Invincibilité activée!" or "Désactivé",
            Duration = 3,
            Image = "shield",
        })
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ══════════════════════════════════════════════════════════════════════════════

local VisualsTab = Window:CreateTab("Visuals", "sun")

local EnvironmentSection = VisualsTab:CreateSection("Environnement")

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
}

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(v)
        Settings.Fullbright = v
        if v then
            Lighting.Brightness = 10
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        else
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            Lighting.Ambient = OriginalLighting.Ambient
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(v)
        Settings.NoFog = v
        if v then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        else
            Lighting.FogEnd = OriginalLighting.FogEnd
            Lighting.FogStart = OriginalLighting.FogStart
        end
    end,
})

VisualsTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(v)
        Camera.FieldOfView = v
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- TROLL TAB
-- ══════════════════════════════════════════════════════════════════════════════

local TrollTab = Window:CreateTab("Troll", "skull")

local TrollSection = TrollTab:CreateSection("Troll")

TrollTab:CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Flag = "Spin",
    Callback = function(v)
        Settings.Spin = v
        Disconnect("Spin")
        if v then
            Connections["Spin"] = RunService.RenderStepped:Connect(function()
                local root = GetRootPart()
                if root and Settings.Spin then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
                end
            end)
        end
    end,
})

TrollTab:CreateSlider({
    Name = "Spin Speed",
    Range = {1, 50},
    Increment = 1,
    Suffix = "",
    CurrentValue = 10,
    Flag = "SpinSpeed",
    Callback = function(v)
        Settings.SpinSpeed = v
    end,
})

TrollTab:CreateToggle({
    Name = "Fling",
    CurrentValue = false,
    Flag = "Fling",
    Callback = function(v)
        Settings.Fling = v
        Disconnect("Fling")
        if v then
            Connections["Fling"] = RunService.Heartbeat:Connect(function()
                local root = GetRootPart()
                if root and Settings.Fling then
                    root.Velocity = Vector3.new(math.random(-100, 100), 50, math.random(-100, 100))
                    root.RotVelocity = Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
                end
            end)
        end
    end,
})

local AnnoySection = TrollTab:CreateSection("Annoy")

local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNames, p.Name)
    end
end

TrollTab:CreateDropdown({
    Name = "Target",
    Options = #playerNames > 0 and playerNames or {"Aucun joueur"},
    CurrentOption = {},
    Flag = "AnnoyTarget",
    Callback = function(opt)
        Settings.AnnoyTarget = opt[1]
    end,
})

TrollTab:CreateToggle({
    Name = "Annoy (TP vers cible)",
    CurrentValue = false,
    Flag = "Annoy",
    Callback = function(v)
        Settings.Annoy = v
        Disconnect("Annoy")
        if v then
            Connections["Annoy"] = RunService.Heartbeat:Connect(function()
                if Settings.Annoy and Settings.AnnoyTarget ~= "" then
                    local target = Players:FindFirstChild(Settings.AnnoyTarget)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local root = GetRootPart()
                        if root then
                            root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        end
                    end
                end
            end)
        end
    end,
})

local ActionsSection = TrollTab:CreateSection("Actions")

TrollTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        local char = GetCharacter()
        if char then
            char:BreakJoints()
        end
    end,
})

TrollTab:CreateButton({
    Name = "Reset Velocity",
    Callback = function()
        local root = GetRootPart()
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
        end
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- TELEPORT TAB
-- ══════════════════════════════════════════════════════════════════════════════

local TeleportTab = Window:CreateTab("Teleport", "map-pin")

local TPSection = TeleportTab:CreateSection("Téléportation Joueur")

local TPTarget = ""
TeleportTab:CreateInput({
    Name = "Pseudo du joueur",
    CurrentValue = "",
    PlaceholderText = "Entrez un pseudo...",
    Flag = "TPTarget",
    Callback = function(text)
        TPTarget = text
    end,
})

TeleportTab:CreateButton({
    Name = "Téléporter au joueur",
    Callback = function()
        local target = Players:FindFirstChild(TPTarget)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = GetRootPart()
            if root then
                root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                Rayfield:Notify({
                    Title = "Téléportation",
                    Content = "Téléporté vers " .. TPTarget,
                    Duration = 3,
                    Image = "check-circle",
                })
            end
        else
            Rayfield:Notify({
                Title = "Erreur",
                Content = "Joueur introuvable: " .. TPTarget,
                Duration = 3,
                Image = "x-circle",
            })
        end
    end,
})

local CoordsSection = TeleportTab:CreateSection("Coordonnées")

local TPX, TPY, TPZ = 0, 0, 0

TeleportTab:CreateInput({
    Name = "X",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "TPX",
    Callback = function(t) TPX = tonumber(t) or 0 end,
})

TeleportTab:CreateInput({
    Name = "Y",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "TPY",
    Callback = function(t) TPY = tonumber(t) or 0 end,
})

TeleportTab:CreateInput({
    Name = "Z",
    CurrentValue = "0",
    PlaceholderText = "0",
    Flag = "TPZ",
    Callback = function(t) TPZ = tonumber(t) or 0 end,
})

TeleportTab:CreateButton({
    Name = "Téléporter aux coordonnées",
    Callback = function()
        local root = GetRootPart()
        if root then
            root.CFrame = CFrame.new(TPX, TPY, TPZ)
            Rayfield:Notify({
                Title = "Téléportation",
                Content = string.format("TP: %d, %d, %d", TPX, TPY, TPZ),
                Duration = 3,
                Image = "check-circle",
            })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Copier ma position",
    Callback = function()
        local root = GetRootPart()
        if root then
            local pos = root.Position
            local text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            if setclipboard then
                setclipboard(text)
            end
            Rayfield:Notify({
                Title = "Position copiée",
                Content = text,
                Duration = 3,
                Image = "copy",
            })
        end
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ══════════════════════════════════════════════════════════════════════════════

local SettingsTab = Window:CreateTab("Settings", "settings")

local InfoSection = SettingsTab:CreateSection("Informations")

SettingsTab:CreateParagraph({
    Title = "TheWizard",
    Content = "Version: 1.0\nClé: TheWizardBest\nUI: Rayfield"
})

SettingsTab:CreateParagraph({
    Title = "Contrôles",
    Content = "• Clic droit = Aimbot\n• WASD + Space/Ctrl = Fly\n• RightShift = Toggle UI"
})

local ActionsSection2 = SettingsTab:CreateSection("Actions")

SettingsTab:CreateButton({
    Name = "Rejouer",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

SettingsTab:CreateButton({
    Name = "Détruire UI",
    Callback = function()
        for name, conn in pairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        for name, esp in pairs(ESPCache) do
            pcall(function()
                if esp.Billboard then esp.Billboard:Destroy() end
                if esp.Highlight then esp.Highlight:Destroy() end
            end)
        end
        Rayfield:Destroy()
    end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- FOV CIRCLE (ScreenGui)
-- ══════════════════════════════════════════════════════════════════════════════

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "WizardFOV"
FOVGui.ResetOnSpawn = false
FOVGui.Parent = CoreGui

local FOVCircle = Instance.new("ImageLabel")
FOVCircle.Name = "Circle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Image = "rbxassetid://3570695787"
FOVCircle.ImageColor3 = Color3.new(1, 1, 1)
FOVCircle.ImageTransparency = 0.5
FOVCircle.Parent = FOVGui

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP FUNCTIONS
-- ══════════════════════════════════════════════════════════════════════════════

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function Setup(char)
        if not char then return end
        local root = char:WaitForChild("HumanoidRootPart", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        if not root or not hum then return end
        
        -- Clean old
        if ESPCache[player.Name] then
            if ESPCache[player.Name].Billboard then ESPCache[player.Name].Billboard:Destroy() end
            if ESPCache[player.Name].Highlight then ESPCache[player.Name].Highlight:Destroy() end
        end
        
        -- Billboard
        local bb = Instance.new("BillboardGui")
        bb.Name = "WizardESP"
        bb.Size = UDim2.new(0, 150, 0, 50)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = root
        bb.Parent = CoreGui
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.Size = UDim2.new(1, 0, 0, 16)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Settings.ESPColor
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.Text = player.Name
        nameLabel.Parent = bb
        
        local hpBg = Instance.new("Frame")
        hpBg.Name = "HPBg"
        hpBg.Size = UDim2.new(0.7, 0, 0, 5)
        hpBg.Position = UDim2.new(0.15, 0, 0, 18)
        hpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        hpBg.BorderSizePixel = 0
        hpBg.Parent = bb
        
        local hpFill = Instance.new("Frame")
        hpFill.Name = "HPFill"
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        hpFill.BorderSizePixel = 0
        hpFill.Parent = hpBg
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "Dist"
        distLabel.Size = UDim2.new(1, 0, 0, 14)
        distLabel.Position = UDim2.new(0, 0, 0, 26)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextStrokeTransparency = 0
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 11
        distLabel.Parent = bb
        
        -- Highlight
        local hl = Instance.new("Highlight")
        hl.Name = "WizardHL"
        hl.FillTransparency = 0.75
        hl.OutlineTransparency = 0
        hl.FillColor = Settings.ESPColor
        hl.OutlineColor = Settings.ESPColor
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = char
        hl.Parent = CoreGui
        
        ESPCache[player.Name] = {
            Billboard = bb,
            Highlight = hl,
            NameLabel = nameLabel,
            HPFill = hpFill,
            HPBg = hpBg,
            DistLabel = distLabel,
            Character = char,
        }
    end
    
    if player.Character then Setup(player.Character) end
    player.CharacterAdded:Connect(function(c) wait(0.5) Setup(c) end)
end

local function RemoveESP(player)
    if ESPCache[player.Name] then
        if ESPCache[player.Name].Billboard then ESPCache[player.Name].Billboard:Destroy() end
        if ESPCache[player.Name].Highlight then ESPCache[player.Name].Highlight:Destroy() end
        ESPCache[player.Name] = nil
    end
end

-- Init ESP
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN LOOP
-- ══════════════════════════════════════════════════════════════════════════════

local function IsKeyPressed()
    local key = Settings.AimbotKey
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(key)
        else
            return UserInputService:IsKeyDown(key)
        end
    end
    return false
end

Connections["MainLoop"] = RunService.RenderStepped:Connect(function()
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    
    -- FOV Circle
    FOVCircle.Position = UDim2.new(0, cx, 0, cy)
    FOVCircle.Size = UDim2.new(0, Settings.AimbotFOV * 2, 0, Settings.AimbotFOV * 2)
    FOVCircle.Visible = Settings.AimbotEnabled and Settings.AimbotShowFOV
    FOVCircle.ImageColor3 = Color3.new(1, 1, 1)
    
    -- Aimbot
    if Settings.AimbotEnabled and IsKeyPressed() then
        local target = GetClosestPlayer()
        if target then
            FOVCircle.ImageColor3 = Color3.fromRGB(0, 255, 0)
            
            local dx = target.Screen.X - cx
            local dy = target.Screen.Y - cy
            
            Camera.CFrame = Camera.CFrame * CFrame.Angles(
                math.rad(-dy * Settings.AimbotSmooth),
                math.rad(-dx * Settings.AimbotSmooth),
                0
            )
        end
    end
    
    -- ESP Update
    local myRoot = GetRootPart()
    for name, esp in pairs(ESPCache) do
        local player = Players:FindFirstChild(name)
        if not player then continue end
        
        local isTeammate = Settings.ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
        local show = Settings.ESPEnabled and not isTeammate
        
        if esp.Billboard then esp.Billboard.Enabled = show end
        if esp.Highlight then esp.Highlight.Enabled = show and Settings.ESPBox end
        
        if show and esp.Character then
            local hum = esp.Character:FindFirstChildOfClass("Humanoid")
            local root = esp.Character:FindFirstChild("HumanoidRootPart")
            
            if hum and root then
                -- Name
                if esp.NameLabel then
                    esp.NameLabel.Visible = Settings.ESPName
                    esp.NameLabel.TextColor3 = Settings.ESPColor
                end
                
                -- Health
                if esp.HPFill and esp.HPBg then
                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    esp.HPFill.Size = UDim2.new(pct, 0, 1, 0)
                    if pct > 0.6 then
                        esp.HPFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    elseif pct > 0.3 then
                        esp.HPFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        esp.HPFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    end
                    esp.HPBg.Visible = Settings.ESPHealth
                end
                
                -- Distance
                if esp.DistLabel and myRoot then
                    local dist = (myRoot.Position - root.Position).Magnitude
                    esp.DistLabel.Text = math.floor(dist) .. "m"
                    esp.DistLabel.Visible = Settings.ESPDistance
                end
                
                -- Highlight color
                if esp.Highlight then
                    esp.Highlight.FillColor = Settings.ESPColor
                    esp.Highlight.OutlineColor = Settings.ESPColor
                end
            end
        end
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION
-- ══════════════════════════════════════════════════════════════════════════════

Rayfield:Notify({
    Title = "TheWizard",
    Content = "Script chargé avec succès!",
    Duration = 5,
    Image = "check-circle",
})

-- Load config
Rayfield:LoadConfiguration()
