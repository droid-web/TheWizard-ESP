--[[
    TheWizard Hub v2.0
    FPS Suite for Phantom Forces
    Theme: Dark
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "TheWizard Hub",
    Icon = "crosshair",
    LoadingTitle = "TheWizard Hub",
    LoadingSubtitle = "FPS Suite v2.0",
    Theme = "Ocean",
    ToggleUIKeybind = "RightShift",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TheWizardHub",
        FileName = "TheWizardConfig"
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 120,
        Smoothness = 0.3,
        TargetPart = "Head",
        TeamCheck = true,
        VisibilityCheck = true,
        ShowFOV = true
    },
    Triggerbot = {
        Enabled = false,
        Delay = 0.05
    },
    Weapon = {
        NoRecoil = false,
        NoSpread = false,
        InfiniteAmmo = false,
        RapidFire = false,
        InstantReload = false
    },
    ESP = {
        Players = false,
        Boxes = false,
        Names = false,
        Health = false,
        Distance = false,
        Tracers = false,
        TeamCheck = true
    },
    World = {
        Wallhack = false,
        Fullbright = false,
        NoFog = false
    },
    Movement = {
        SpeedEnabled = false,
        Speed = 16,
        JumpPower = 50,
        Fly = false,
        FlySpeed = 50,
        NoClip = false
    },
    Player = {
        GodMode = false,
        Invisible = false
    }
}

local Connections = {}
local FOVCircle = nil

local function IsAlive(player)
    if not player then return false end
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    return humanoid and humanoid.Health > 0 and rootPart
end

local function IsTeammate(player)
    if not Settings.Aimbot.TeamCheck then return false end
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function IsVisible(part)
    if not Settings.Aimbot.VisibilityCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, direction, rayParams)
    if result then
        local hit = result.Instance
        if hit:IsDescendantOf(part.Parent) then
            return true
        end
        return false
    end
    return true
end

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = Settings.Aimbot.FOV
    local mousePosition = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and not IsTeammate(player) then
            local character = player.Character
            local targetPart = character:FindFirstChild(Settings.Aimbot.TargetPart) or character:FindFirstChild("Head")
            
            if targetPart then
                local screenPoint, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePosition).Magnitude
                    
                    if distance < shortestDistance and IsVisible(targetPart) then
                        closest = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closest
end

local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.Color = Color3.fromRGB(138, 180, 248)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.7
    FOVCircle.Visible = Settings.Aimbot.ShowFOV and Settings.Aimbot.Enabled
    FOVCircle.Radius = Settings.Aimbot.FOV
    return FOVCircle
end

CreateFOVCircle()

local function GetPhantomForcesData()
    local data = {}
    local char = LocalPlayer.Character
    if not char then return data end
    
    local gun = char:FindFirstChildOfClass("Tool")
    if gun then
        data.Gun = gun
        data.GunData = gun:FindFirstChild("GunClient") or gun:FindFirstChild("Gun")
        
        if ReplicatedStorage:FindFirstChild("Weapons") then
            local weaponModule = ReplicatedStorage.Weapons:FindFirstChild(gun.Name)
            if weaponModule then
                data.WeaponModule = weaponModule
            end
        end
    end
    
    return data
end

local function ApplyNoRecoil()
    local pfData = GetPhantomForcesData()
    if pfData.Gun then
        local gunScript = pfData.Gun:FindFirstChild("GunClient") or pfData.Gun:FindFirstChild("Gun")
        if gunScript then
            local recoilValues = {
                "CameraRecoilUp", "CameraRecoilDown", "CameraRecoilLeft", "CameraRecoilRight",
                "GunRecoilUp", "GunRecoilDown", "GunRecoilLeft", "GunRecoilRight",
                "Recoil", "RecoilUp", "RecoilSide"
            }
            for _, valueName in pairs(recoilValues) do
                local value = gunScript:FindFirstChild(valueName)
                if value and (value:IsA("NumberValue") or value:IsA("IntValue")) then
                    value.Value = 0
                end
            end
        end
    end
end

local function ApplyNoSpread()
    local pfData = GetPhantomForcesData()
    if pfData.Gun then
        local gunScript = pfData.Gun:FindFirstChild("GunClient") or pfData.Gun:FindFirstChild("Gun")
        if gunScript then
            local spreadValues = {
                "Spread", "SpreadHip", "SpreadAim", "SpreadMove", "SpreadJump",
                "HipSpread", "AimSpread", "MoveSpread"
            }
            for _, valueName in pairs(spreadValues) do
                local value = gunScript:FindFirstChild(valueName)
                if value and (value:IsA("NumberValue") or value:IsA("IntValue")) then
                    value.Value = 0
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
    CurrentValue = 120,
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
    Range = {0.1, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.3,
    Flag = "AimbotSmooth",
    Callback = function(value)
        Settings.Aimbot.Smoothness = value
    end
})

CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
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
        Settings.Aimbot.VisibilityCheck = value
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

CombatTab:CreateSection("Weapon Modifications")

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
    Name = "Infinite Ammo",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(value)
        Settings.Weapon.InfiniteAmmo = value
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

CombatTab:CreateToggle({
    Name = "Instant Reload",
    CurrentValue = false,
    Flag = "InstantReload",
    Callback = function(value)
        Settings.Weapon.InstantReload = value
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
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local existingHL = player.Character:FindFirstChild("WizardESP")
                if existingHL then existingHL:Destroy() end
                
                if value and (not Settings.ESP.TeamCheck or not IsTeammate(player)) then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "WizardESP"
                    highlight.FillColor = IsTeammate(player) and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 50, 50)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.6
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                end
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(value)
        Settings.ESP.Boxes = value
    end
})

VisualsTab:CreateToggle({
    Name = "Name Tags",
    CurrentValue = false,
    Flag = "NameESP",
    Callback = function(value)
        Settings.ESP.Names = value
    end
})

VisualsTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = false,
    Flag = "HealthESP",
    Callback = function(value)
        Settings.ESP.Health = value
    end
})

VisualsTab:CreateToggle({
    Name = "Distance Display",
    CurrentValue = false,
    Flag = "DistanceESP",
    Callback = function(value)
        Settings.ESP.Distance = value
    end
})

VisualsTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Flag = "TracerESP",
    Callback = function(value)
        Settings.ESP.Tracers = value
    end
})

VisualsTab:CreateToggle({
    Name = "ESP Team Check",
    CurrentValue = true,
    Flag = "ESPTeamCheck",
    Callback = function(value)
        Settings.ESP.TeamCheck = value
    end
})

VisualsTab:CreateSection("World Visuals")

VisualsTab:CreateToggle({
    Name = "Wallhack",
    CurrentValue = false,
    Flag = "Wallhack",
    Callback = function(value)
        Settings.World.Wallhack = value
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character or {}) then
                local objName = obj.Name:lower()
                if objName:find("wall") or objName:find("door") or objName:find("window") then
                    obj.Transparency = value and 0.7 or 0
                end
            end
        end
    end
})

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
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value and Settings.Movement.Speed or 16
        end
    end
})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 150},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        Settings.Movement.Speed = value
        if Settings.Movement.SpeedEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 150},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        Settings.Movement.JumpPower = value
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

MovementTab:CreateSection("Flight Controls")

MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyEnabled",
    Callback = function(value)
        Settings.Movement.Fly = value
        
        local character = LocalPlayer.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        if value then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "WizardFlyBV"
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = rootPart
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.Name = "WizardFlyBG"
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 10000
            bodyGyro.Parent = rootPart
            
            Connections.Fly = RunService.Heartbeat:Connect(function()
                if not Settings.Movement.Fly then return end
                
                local moveDir = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveDir * Settings.Movement.FlySpeed
                bodyGyro.CFrame = Camera.CFrame
            end)
        else
            if Connections.Fly then
                Connections.Fly:Disconnect()
                Connections.Fly = nil
            end
            
            local bv = rootPart:FindFirstChild("WizardFlyBV")
            local bg = rootPart:FindFirstChild("WizardFlyBG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(value)
        Settings.Movement.FlySpeed = value
    end
})

MovementTab:CreateSection("Physics")

MovementTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipEnabled",
    Callback = function(value)
        Settings.Movement.NoClip = value
        
        if value then
            Connections.NoClip = RunService.Stepped:Connect(function()
                if not Settings.Movement.NoClip then return end
                
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if Connections.NoClip then
                Connections.NoClip:Disconnect()
                Connections.NoClip = nil
            end
            
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
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
                    
                    local forceField = character:FindFirstChildOfClass("ForceField")
                    if not forceField then
                        local ff = Instance.new("ForceField")
                        ff.Name = "WizardGodMode"
                        ff.Visible = false
                        ff.Parent = character
                    end
                end
            end)
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
                
                local ff = character:FindFirstChild("WizardGodMode")
                if ff then ff:Destroy() end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Invisible",
    CurrentValue = false,
    Flag = "InvisibleEnabled",
    Callback = function(value)
        Settings.Player.Invisible = value
        
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = value and 1 or 0
                elseif part:IsA("Decal") then
                    part.Transparency = value and 1 or 0
                end
            end
        end
    end
})

PlayerTab:CreateSection("Quick Actions")

PlayerTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        LocalPlayer:LoadCharacter()
        Rayfield:Notify({
            Title = "Player",
            Content = "Respawned successfully",
            Duration = 2.5
        })
    end
})

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
})

local TeleportTab = Window:CreateTab("Teleport", "map-pin")
TeleportTab:CreateSection("Player Teleport")

local playerNames = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.Name)
    end
end

local PlayerTeleportDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = playerNames,
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "TeleportTarget",
    Callback = function(option)
        local targetName = option[1]
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name == targetName and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Teleported to " .. targetName,
                        Duration = 2.5
                    })
                end
            end
        end
    end
})

task.spawn(function()
    while task.wait(3) do
        local names = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(names, player.Name)
            end
        end
        PlayerTeleportDropdown:Refresh(names)
    end
end)

TeleportTab:CreateSection("Map Teleports")

TeleportTab:CreateButton({
    Name = "Spawn Point",
    Callback = function()
        local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildOfClass("SpawnLocation")
        if spawn then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported to spawn",
                    Duration = 2.5
                })
            end
        end
    end
})

local MiscTab = Window:CreateTab("Misc", "settings")
MiscTab:CreateSection("Game Utilities")

MiscTab:CreateButton({
    Name = "Remove Kill Barriers",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("kill") or name:find("death") or name:find("barrier") then
                if obj:IsA("BasePart") then
                    obj:Destroy()
                    count = count + 1
                end
            end
        end
        Rayfield:Notify({
            Title = "Utilities",
            Content = "Removed " .. count .. " barriers",
            Duration = 2.5
        })
    end
})

MiscTab:CreateButton({
    Name = "Remove Invisibles",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency == 1 then
                obj:Destroy()
                count = count + 1
            end
        end
        Rayfield:Notify({
            Title = "Utilities",
            Content = "Removed " .. count .. " invisible parts",
            Duration = 2.5
        })
    end
})

MiscTab:CreateSection("Anti-AFK")

local AntiAFKEnabled = false
MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(value)
        AntiAFKEnabled = value
        
        if value then
            local vu = game:GetService("VirtualUser")
            Connections.AntiAFK = Players.LocalPlayer.Idled:Connect(function()
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
MiscTab:CreateLabel("FPS Suite for Phantom Forces")

MiscTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        for _, conn in pairs(Connections) do
            if conn then
                conn:Disconnect()
            end
        end
        
        if FOVCircle then
            FOVCircle:Remove()
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
        local target = GetClosestPlayer()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(Settings.Aimbot.TargetPart) or target.Character:FindFirstChild("Head")
            
            if targetPart and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local targetPos = targetPart.Position
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
            end
        end
    end
    
    if Settings.Triggerbot.Enabled then
        local mouseTarget = Mouse.Target
        if mouseTarget then
            local targetPlayer = Players:GetPlayerFromCharacter(mouseTarget.Parent)
            if targetPlayer and targetPlayer ~= LocalPlayer and not IsTeammate(targetPlayer) then
                task.wait(Settings.Triggerbot.Delay)
                mouse1click()
            end
        end
    end
    
    if Settings.Weapon.NoRecoil then
        ApplyNoRecoil()
    end
    
    if Settings.Weapon.NoSpread then
        ApplyNoSpread()
    end
end)

Players.PlayerAdded:Connect(function(player)
    if Settings.ESP.Players and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            if Settings.ESP.Players and (not Settings.ESP.TeamCheck or not IsTeammate(player)) then
                local highlight = Instance.new("Highlight")
                highlight.Name = "WizardESP"
                highlight.FillColor = IsTeammate(player) and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 50, 50)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.6
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = character
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    
    if Settings.Movement.SpeedEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Settings.Movement.Speed
        end
    end
    
    if Settings.Movement.JumpPower ~= 50 then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Settings.Movement.JumpPower
        end
    end
end)

Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "TheWizard Hub",
    Content = "Loaded successfully - FPS Suite v2.0",
    Duration = 4
})
