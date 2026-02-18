--[[
    TheWizard Hub v2.0
    FPS Suite - Phantom Forces Edition
    Theme: Dark Ocean
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "TheWizard Hub",
    Icon = "crosshair",
    LoadingTitle = "TheWizard Hub",
    LoadingSubtitle = "Phantom Forces Suite v2.0",
    Theme = "Ocean",
    ToggleUIKeybind = "RightShift",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TheWizardHub",
        FileName = "TheWizardPF"
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

local Shared = getrenv().shared
local ReplicationInterface = nil
local ReplicationObject = nil

pcall(function()
    ReplicationInterface = Shared.require("ReplicationInterface")
    ReplicationObject = Shared.require("ReplicationObject")
end)

local Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 150,
        Smoothness = 2,
        TargetPart = "Head",
        TeamCheck = true,
        VisibleCheck = true,
        ShowFOV = true,
        AimKey = Enum.UserInputType.MouseButton2
    },
    Triggerbot = {
        Enabled = false,
        Delay = 0.05
    },
    SilentAim = {
        Enabled = false,
        HitChance = 100
    },
    Weapon = {
        NoRecoil = false,
        NoSpread = false,
        NoSway = false,
        InstantAim = false,
        RapidFire = false
    },
    ESP = {
        Players = false,
        Boxes = false,
        Names = false,
        Health = false,
        Distance = false,
        Tracers = false,
        TeamCheck = true,
        TeamColor = Color3.fromRGB(0, 255, 100),
        EnemyColor = Color3.fromRGB(255, 50, 50)
    },
    World = {
        Fullbright = false,
        NoFog = false
    },
    Movement = {
        SpeedEnabled = false,
        Speed = 16,
        SuperJump = false,
        JumpPower = 50
    },
    Player = {
        GodMode = false
    }
}

local Connections = {}
local FOVCircle = nil
local ESPObjects = {}

local function IsPFAlive(player)
    if ReplicationInterface and ReplicationObject then
        local entry = ReplicationInterface.getEntry(player)
        if entry then
            return ReplicationObject.isAlive(entry)
        end
    end
    
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        return humanoid and humanoid.Health > 0
    end
    return false
end

local function GetPFCharacter(player)
    if ReplicationInterface and ReplicationObject then
        local entry = ReplicationInterface.getEntry(player)
        if entry then
            local thirdPerson = ReplicationObject.getThirdPersonObject(entry)
            if thirdPerson then
                return thirdPerson:getCharacterHash()
            end
        end
    end
    return nil
end

local function GetTargetPart(player)
    local pfChar = GetPFCharacter(player)
    if pfChar then
        if Settings.Aimbot.TargetPart == "Head" and pfChar.head then
            return pfChar.head
        elseif pfChar.torso then
            return pfChar.torso
        end
    end
    
    if player.Character then
        local targetPart = player.Character:FindFirstChild(Settings.Aimbot.TargetPart)
        if targetPart then return targetPart end
        return player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function IsTeammate(player)
    if not Settings.Aimbot.TeamCheck then return false end
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function IsVisible(position, ignoreList)
    if not Settings.Aimbot.VisibleCheck then return true end
    
    ignoreList = ignoreList or {}
    table.insert(ignoreList, Camera)
    table.insert(ignoreList, LocalPlayer.Character)
    
    local ignoreFolder = Workspace:FindFirstChild("Ignore")
    if ignoreFolder then
        table.insert(ignoreList, ignoreFolder)
    end
    
    local parts = Camera:GetPartsObscuringTarget({position}, ignoreList)
    return #parts == 0
end

local function GetClosestPlayer()
    local targetPos = nil
    local closestMagnitude = Settings.Aimbot.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IsTeammate(player) and IsPFAlive(player) then
            local targetPart = GetTargetPart(player)
            
            if targetPart then
                local partPosition = targetPart.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(partPosition)
                
                if onScreen then
                    local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local magnitude = (screenPos2D - mousePos).Magnitude
                    
                    local pfChar = GetPFCharacter(player)
                    local ignoreList = {}
                    if pfChar and pfChar.torso and pfChar.torso.Parent then
                        table.insert(ignoreList, pfChar.torso.Parent)
                    elseif player.Character then
                        table.insert(ignoreList, player.Character)
                    end
                    
                    if magnitude < closestMagnitude and IsVisible(partPosition, ignoreList) then
                        closestMagnitude = magnitude
                        targetPos = partPosition
                    end
                end
            end
        end
    end
    
    return targetPos
end

local function CreateFOVCircle()
    if FOVCircle then 
        pcall(function() FOVCircle:Remove() end)
    end
    
    local success, circle = pcall(function()
        local c = Drawing.new("Circle")
        c.Thickness = 1.5
        c.NumSides = 64
        c.Color = Color3.fromRGB(138, 180, 248)
        c.Filled = false
        c.Transparency = 0.8
        c.Visible = Settings.Aimbot.ShowFOV and Settings.Aimbot.Enabled
        c.Radius = Settings.Aimbot.FOV
        return c
    end)
    
    if success then
        FOVCircle = circle
    end
    
    return FOVCircle
end

CreateFOVCircle()

local function AimAt(targetPosition, smoothness)
    local targetScreenPos = Camera:WorldToScreenPoint(targetPosition)
    local mouseScreenPos = Camera:WorldToScreenPoint(Mouse.Hit.Position)
    
    local deltaX = (targetScreenPos.X - mouseScreenPos.X) / smoothness
    local deltaY = (targetScreenPos.Y - mouseScreenPos.Y) / smoothness
    
    mousemoverel(deltaX, deltaY)
end

local function GetGunModule()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return nil end
    
    local gunData = {}
    gunData.Tool = tool
    
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("ModuleScript") then
            local success, module = pcall(function()
                return require(child)
            end)
            if success and type(module) == "table" then
                gunData.Module = module
                break
            end
        end
    end
    
    return gunData
end

local function ApplyWeaponMods()
    local gunData = GetGunModule()
    if not gunData or not gunData.Module then return end
    
    local module = gunData.Module
    
    if Settings.Weapon.NoRecoil then
        local recoilKeys = {
            "camrecovertime", "camrecoilup", "camrecoildown", "camrecoilleft", "camrecoilright",
            "gunrecoilup", "gunrecoildown", "gunrecoilleft", "gunrecoilright",
            "hiprecovertime", "aimrecovertime", "recoil", "visualrecoil"
        }
        for _, key in pairs(recoilKeys) do
            if module[key] ~= nil then
                module[key] = 0
            end
        end
    end
    
    if Settings.Weapon.NoSpread then
        local spreadKeys = {
            "hipfirespread", "hipfirespreadrecoverspeed", "hipfirespreadincrease",
            "hipfirespreadmax", "aimspread", "aimspreadrecoverspeed",
            "aimspreadincrease", "aimspreadmax", "spread"
        }
        for _, key in pairs(spreadKeys) do
            if module[key] ~= nil then
                module[key] = 0
            end
        end
    end
    
    if Settings.Weapon.NoSway then
        local swayKeys = {
            "swayamp", "swayspeed", "aimswayamp", "aimswayspeed", "sway"
        }
        for _, key in pairs(swayKeys) do
            if module[key] ~= nil then
                module[key] = 0
            end
        end
    end
    
    if Settings.Weapon.InstantAim then
        local aimKeys = {
            "aimspeed", "aimwalkspeed", "aimtime"
        }
        for _, key in pairs(aimKeys) do
            if module[key] ~= nil then
                if key == "aimspeed" then
                    module[key] = 100
                else
                    module[key] = 0
                end
            end
        end
    end
    
    if Settings.Weapon.RapidFire then
        local fireKeys = {
            "firerate", "firemodes", "burstcooldown"
        }
        for _, key in pairs(fireKeys) do
            if module[key] ~= nil then
                if key == "firerate" then
                    module[key] = 2000
                elseif key == "burstcooldown" then
                    module[key] = 0
                end
            end
        end
    end
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            pcall(function() obj:Remove() end)
        end
    end
    
    ESPObjects[player] = {}
    
    local isEnemy = not IsTeammate(player)
    local color = isEnemy and Settings.ESP.EnemyColor or Settings.ESP.TeamColor
    
    if Settings.ESP.Players then
        if player.Character then
            local existingHL = player.Character:FindFirstChild("WizardESP")
            if existingHL then existingHL:Destroy() end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "WizardESP"
            highlight.FillColor = color
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = player.Character
        end
    end
    
    if Settings.ESP.Boxes then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Color = color
        box.Filled = false
        box.Transparency = 1
        box.Visible = true
        table.insert(ESPObjects[player], box)
    end
    
    if Settings.ESP.Names then
        local nameText = Drawing.new("Text")
        nameText.Text = player.Name
        nameText.Size = 14
        nameText.Color = color
        nameText.Center = true
        nameText.Outline = true
        nameText.OutlineColor = Color3.new(0, 0, 0)
        nameText.Visible = true
        table.insert(ESPObjects[player], nameText)
    end
    
    if Settings.ESP.Health then
        local healthText = Drawing.new("Text")
        healthText.Size = 12
        healthText.Color = Color3.fromRGB(0, 255, 0)
        healthText.Center = true
        healthText.Outline = true
        healthText.OutlineColor = Color3.new(0, 0, 0)
        healthText.Visible = true
        table.insert(ESPObjects[player], healthText)
    end
    
    if Settings.ESP.Distance then
        local distText = Drawing.new("Text")
        distText.Size = 12
        distText.Color = Color3.fromRGB(200, 200, 200)
        distText.Center = true
        distText.Outline = true
        distText.OutlineColor = Color3.new(0, 0, 0)
        distText.Visible = true
        table.insert(ESPObjects[player], distText)
    end
    
    if Settings.ESP.Tracers then
        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Color = color
        tracer.Transparency = 1
        tracer.Visible = true
        table.insert(ESPObjects[player], tracer)
    end
end

local function UpdateESP()
    for player, objects in pairs(ESPObjects) do
        if not player or not player.Parent then
            for _, obj in pairs(objects) do
                pcall(function() obj:Remove() end)
            end
            ESPObjects[player] = nil
            continue
        end
        
        local targetPart = GetTargetPart(player)
        if not targetPart or not IsPFAlive(player) then
            for _, obj in pairs(objects) do
                pcall(function() obj.Visible = false end)
            end
            continue
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        
        if not onScreen then
            for _, obj in pairs(objects) do
                pcall(function() obj.Visible = false end)
            end
            continue
        end
        
        local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
        local scaleFactor = 1 / (distance * 0.01)
        
        local objIndex = 1
        
        if Settings.ESP.Boxes and objects[objIndex] then
            local box = objects[objIndex]
            local size = Vector2.new(50 * scaleFactor, 80 * scaleFactor)
            box.Size = size
            box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
            box.Visible = true
            objIndex = objIndex + 1
        end
        
        if Settings.ESP.Names and objects[objIndex] then
            local nameText = objects[objIndex]
            nameText.Position = Vector2.new(screenPos.X, screenPos.Y - 50 * scaleFactor)
            nameText.Visible = true
            objIndex = objIndex + 1
        end
        
        if Settings.ESP.Health and objects[objIndex] then
            local healthText = objects[objIndex]
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                healthText.Text = math.floor(humanoid.Health) .. " HP"
            end
            healthText.Position = Vector2.new(screenPos.X, screenPos.Y + 40 * scaleFactor)
            healthText.Visible = true
            objIndex = objIndex + 1
        end
        
        if Settings.ESP.Distance and objects[objIndex] then
            local distText = objects[objIndex]
            distText.Text = math.floor(distance) .. " studs"
            distText.Position = Vector2.new(screenPos.X, screenPos.Y + 55 * scaleFactor)
            distText.Visible = true
            objIndex = objIndex + 1
        end
        
        if Settings.ESP.Tracers and objects[objIndex] then
            local tracer = objects[objIndex]
            local viewportSize = Camera.ViewportSize
            tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
            tracer.To = Vector2.new(screenPos.X, screenPos.Y)
            tracer.Visible = true
            objIndex = objIndex + 1
        end
    end
end

local function ClearAllESP()
    for player, objects in pairs(ESPObjects) do
        for _, obj in pairs(objects) do
            pcall(function() obj:Remove() end)
        end
        
        if player.Character then
            local highlight = player.Character:FindFirstChild("WizardESP")
            if highlight then highlight:Destroy() end
        end
    end
    ESPObjects = {}
end

local function RefreshESP()
    ClearAllESP()
    
    if not Settings.ESP.Players and not Settings.ESP.Boxes and not Settings.ESP.Names 
       and not Settings.ESP.Health and not Settings.ESP.Distance and not Settings.ESP.Tracers then
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not Settings.ESP.TeamCheck or not IsTeammate(player) then
                CreateESP(player)
            end
        end
    end
end

local CombatTab = Window:CreateTab("Combat", "crosshair")
CombatTab:CreateSection("Aim Assist")

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(value)
        Settings.Aimbot.Enabled = value
        if FOVCircle then
            FOVCircle.Visible = value and Settings.Aimbot.ShowFOV
        end
    end
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "AimbotFOV",
    Callback = function(value)
        Settings.Aimbot.FOV = value
        if FOVCircle then
            FOVCircle.Radius = value
        end
    end
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "",
    CurrentValue = 2,
    Flag = "AimbotSmooth",
    Callback = function(value)
        Settings.Aimbot.Smoothness = value
    end
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    MultipleOptions = false,
    Flag = "TargetPart",
    Callback = function(option)
        Settings.Aimbot.TargetPart = option[1]
    end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(value)
        Settings.Aimbot.TeamCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = true,
    Flag = "VisibilityCheck",
    Callback = function(value)
        Settings.Aimbot.VisibleCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = true,
    Flag = "ShowFOV",
    Callback = function(value)
        Settings.Aimbot.ShowFOV = value
        if FOVCircle then
            FOVCircle.Visible = value and Settings.Aimbot.Enabled
        end
    end
})

CombatTab:CreateSection("Triggerbot")

CombatTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "TriggerbotEnabled",
    Callback = function(value)
        Settings.Triggerbot.Enabled = value
    end
})

CombatTab:CreateSlider({
    Name = "Trigger Delay",
    Range = {0, 0.2},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.05,
    Flag = "TriggerDelay",
    Callback = function(value)
        Settings.Triggerbot.Delay = value
    end
})

CombatTab:CreateSection("Silent Aim")

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimEnabled",
    Callback = function(value)
        Settings.SilentAim.Enabled = value
    end
})

CombatTab:CreateSlider({
    Name = "Hit Chance",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "HitChance",
    Callback = function(value)
        Settings.SilentAim.HitChance = value
    end
})

CombatTab:CreateSection("Weapon Mods")

CombatTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(value)
        Settings.Weapon.NoRecoil = value
    end
})

CombatTab:CreateToggle({
    Name = "No Spread",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(value)
        Settings.Weapon.NoSpread = value
    end
})

CombatTab:CreateToggle({
    Name = "No Sway",
    CurrentValue = false,
    Flag = "NoSway",
    Callback = function(value)
        Settings.Weapon.NoSway = value
    end
})

CombatTab:CreateToggle({
    Name = "Instant Aim",
    CurrentValue = false,
    Flag = "InstantAim",
    Callback = function(value)
        Settings.Weapon.InstantAim = value
    end
})

CombatTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = false,
    Flag = "RapidFire",
    Callback = function(value)
        Settings.Weapon.RapidFire = value
    end
})

local VisualsTab = Window:CreateTab("Visuals", "eye")
VisualsTab:CreateSection("Player ESP")

VisualsTab:CreateToggle({
    Name = "Player Highlight",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(value)
        Settings.ESP.Players = value
        RefreshESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(value)
        Settings.ESP.Boxes = value
        RefreshESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Name Tags",
    CurrentValue = false,
    Flag = "NameESP",
    Callback = function(value)
        Settings.ESP.Names = value
        RefreshESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = false,
    Flag = "HealthESP",
    Callback = function(value)
        Settings.ESP.Health = value
        RefreshESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Distance Display",
    CurrentValue = false,
    Flag = "DistanceESP",
    Callback = function(value)
        Settings.ESP.Distance = value
        RefreshESP()
    end
})

VisualsTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "TracerESP",
    Callback = function(value)
        Settings.ESP.Tracers = value
        RefreshESP()
    end
})

VisualsTab:CreateToggle({
    Name = "ESP Team Check",
    CurrentValue = true,
    Flag = "ESPTeamCheck",
    Callback = function(value)
        Settings.ESP.TeamCheck = value
        RefreshESP()
    end
})

VisualsTab:CreateSection("World Visuals")

VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(value)
        Settings.World.Fullbright = value
        
        if value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            
            for _, effect in pairs(Lighting:GetDescendants()) do
                if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = false
                end
            end
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 10000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})

VisualsTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(value)
        Settings.World.NoFog = value
        Lighting.FogEnd = value and 100000 or 10000
        
        if value then
            for _, effect in pairs(Lighting:GetDescendants()) do
                if effect:IsA("Atmosphere") then
                    effect.Density = 0
                end
            end
        end
    end
})

VisualsTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    Suffix = " degrees",
    CurrentValue = 70,
    Flag = "CameraFOV",
    Callback = function(value)
        Camera.FieldOfView = value
    end
})

local MovementTab = Window:CreateTab("Movement", "zap")
MovementTab:CreateSection("Speed Controls")

MovementTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedEnabled",
    Callback = function(value)
        Settings.Movement.SpeedEnabled = value
        
        if value then
            Connections.Speed = RunService.Heartbeat:Connect(function()
                if not Settings.Movement.SpeedEnabled then return end
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = Settings.Movement.Speed
                    end
                end
            end)
        else
            if Connections.Speed then
                Connections.Speed:Disconnect()
                Connections.Speed = nil
            end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        Settings.Movement.Speed = value
    end
})

MovementTab:CreateToggle({
    Name = "Super Jump",
    CurrentValue = false,
    Flag = "SuperJump",
    Callback = function(value)
        Settings.Movement.SuperJump = value
        
        if value then
            Connections.Jump = RunService.Heartbeat:Connect(function()
                if not Settings.Movement.SuperJump then return end
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = Settings.Movement.JumpPower
                    end
                end
            end)
        else
            if Connections.Jump then
                Connections.Jump:Disconnect()
                Connections.Jump = nil
            end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
        end
    end
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 150},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        Settings.Movement.JumpPower = value
    end
})

local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:CreateSection("Survival")

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodModeEnabled",
    Callback = function(value)
        Settings.Player.GodMode = value
        
        if value then
            Connections.GodMode = RunService.Heartbeat:Connect(function()
                if not Settings.Player.GodMode then return end
                
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.MaxHealth = math.huge
                        humanoid.Health = math.huge
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "God Mode",
                Content = "God Mode activated - Note: May not work on all games due to server-side health",
                Duration = 4
            })
        else
            if Connections.GodMode then
                Connections.GodMode:Disconnect()
                Connections.GodMode = nil
            end
            
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end
        end
    end
})

PlayerTab:CreateSection("Quick Actions")

PlayerTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
        Rayfield:Notify({
            Title = "Player",
            Content = "Respawning...",
            Duration = 2
        })
    end
})

local MiscTab = Window:CreateTab("Misc", "settings")
MiscTab:CreateSection("Utilities")

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(value)
        if value then
            local vu = game:GetService("VirtualUser")
            Connections.AntiAFK = LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
            end)
            Rayfield:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK activated",
                Duration = 2.5
            })
        else
            if Connections.AntiAFK then
                Connections.AntiAFK:Disconnect()
                Connections.AntiAFK = nil
            end
        end
    end
})

MiscTab:CreateSection("Configuration")

MiscTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Flag = "UIToggleKey",
    Callback = function(keybind)
    end
})

MiscTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration",
            Content = "Settings saved",
            Duration = 2.5
        })
    end
})

MiscTab:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Configuration",
            Content = "Settings loaded",
            Duration = 2.5
        })
    end
})

MiscTab:CreateSection("Script Info")
MiscTab:CreateLabel("TheWizard Hub v2.0")
MiscTab:CreateLabel("Phantom Forces Edition")

MiscTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for _, conn in pairs(Connections) do
            if conn then
                pcall(function() conn:Disconnect() end)
            end
        end
        
        ClearAllESP()
        
        if FOVCircle then
            pcall(function() FOVCircle:Remove() end)
        end
        
        Rayfield:Destroy()
    end
})

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = mousePos
    end
    
    if Settings.Aimbot.Enabled then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local targetPos = GetClosestPlayer()
            if targetPos then
                AimAt(targetPos, Settings.Aimbot.Smoothness)
            end
        end
    end
    
    if Settings.Triggerbot.Enabled then
        local mouseTarget = Mouse.Target
        if mouseTarget then
            local character = mouseTarget.Parent
            local player = Players:GetPlayerFromCharacter(character)
            
            if not player then
                character = mouseTarget.Parent and mouseTarget.Parent.Parent
                player = Players:GetPlayerFromCharacter(character)
            end
            
            if player and player ~= LocalPlayer and not IsTeammate(player) then
                task.wait(Settings.Triggerbot.Delay)
                mouse1click()
            end
        end
    end
    
    if Settings.Weapon.NoRecoil or Settings.Weapon.NoSpread or Settings.Weapon.NoSway or 
       Settings.Weapon.InstantAim or Settings.Weapon.RapidFire then
        ApplyWeaponMods()
    end
    
    UpdateESP()
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.SilentAim.Enabled and method == "FireServer" then
        if self.Name == "Damage" or self.Name == "Hit" or self.Name == "Shoot" then
            if math.random(1, 100) <= Settings.SilentAim.HitChance then
                local closestTarget = nil
                local closestDist = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not IsTeammate(player) and IsPFAlive(player) then
                        local targetPart = GetTargetPart(player)
                        if targetPart then
                            local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestTarget = targetPart
                            end
                        end
                    end
                end
                
                if closestTarget and args[1] then
                    args[1] = closestTarget.Position
                end
            end
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if Settings.ESP.Players or Settings.ESP.Boxes or Settings.ESP.Names or 
               Settings.ESP.Health or Settings.ESP.Distance or Settings.ESP.Tracers then
                if not Settings.ESP.TeamCheck or not IsTeammate(player) then
                    CreateESP(player)
                end
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            pcall(function() obj:Remove() end)
        end
        ESPObjects[player] = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    RefreshESP()
end)

Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "TheWizard Hub",
    Content = "Phantom Forces Suite loaded - Hold RMB for aimbot",
    Duration = 5
})
