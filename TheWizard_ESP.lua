local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "TheWizard Hub",
    LoadingTitle = "TheWizard Hub",
    LoadingSubtitle = "by TheWizard",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "TheWizardHub"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = true,
    KeySettings = {
        Title = "TheWizard Hub",
        Subtitle = "Key System",
        Note = "Key required to access",
        FileName = "TheWizardKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"WIZARD2025"}
    }
})

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local aimEnabled = false
local aimbotFOV = 100
local aimbotSmoothness = 0.5
local espEnabled = false
local wallhackEnabled = false
local recoilEnabled = false
local triggerEnabled = false
local radarEnabled = false

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = aimbotFOV
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local screenPoint, onScreen = camera:WorldToScreenPoint(head.Position)
            
            if onScreen then
                local mousePos = userInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = v
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateSection("Aim Assist")

local AimbotToggle = CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimEnabled = Value
    end,
})

local FOVSlider = CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 100,
    Flag = "AimbotFOV",
    Callback = function(Value)
        aimbotFOV = Value
    end,
})

local SmoothnessSlider = CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "AimbotSmooth",
    Callback = function(Value)
        aimbotSmoothness = Value
    end,
})

local TriggerBot = CombatTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "Triggerbot",
    Callback = function(Value)
        triggerEnabled = Value
    end,
})

CombatTab:CreateSection("Weapon Mods")

local NoRecoil = CombatTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        recoilEnabled = Value
    end,
})

local InfiniteAmmo = CombatTab:CreateToggle({
    Name = "Infinite Ammo",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(Value)
        if Value then
            _G.InfiniteAmmoLoop = runService.Heartbeat:Connect(function()
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo:IsA("IntValue") then
                        ammo.Value = 999
                    end
                end
            end)
        else
            if _G.InfiniteAmmoLoop then
                _G.InfiniteAmmoLoop:Disconnect()
            end
        end
    end,
})

local RapidFire = CombatTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = false,
    Flag = "RapidFire",
    Callback = function(Value)
        if Value then
            _G.RapidFireLoop = runService.Heartbeat:Connect(function()
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local fireRate = tool:FindFirstChild("FireRate")
                    if fireRate and fireRate:IsA("NumberValue") then
                        fireRate.Value = 0.01
                    end
                end
            end)
        else
            if _G.RapidFireLoop then
                _G.RapidFireLoop:Disconnect()
            end
        end
    end,
})

local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateSection("ESP")

local PlayerESP = VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        espEnabled = Value
        if Value then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = v.Character
                end
            end
        else
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("ESP") then
                    v.Character.ESP:Destroy()
                end
            end
        end
    end,
})

local BoxESP = VisualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(Value)
        print("Box ESP:", Value)
    end,
})

local HealthESP = VisualTab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = false,
    Flag = "HealthESP",
    Callback = function(Value)
        print("Health ESP:", Value)
    end,
})

local DistanceESP = VisualTab:CreateToggle({
    Name = "Distance",
    CurrentValue = false,
    Flag = "DistanceESP",
    Callback = function(Value)
        print("Distance ESP:", Value)
    end,
})

VisualTab:CreateSection("World")

local Wallhack = VisualTab:CreateToggle({
    Name = "Wallhack",
    CurrentValue = false,
    Flag = "Wallhack",
    Callback = function(Value)
        wallhackEnabled = Value
        if Value then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "Wall" or v.Name == "Part" then
                    v.Transparency = 0.8
                end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0
                end
            end
        end
    end,
})

local Fullbright = VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = 12
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = true
        end
    end,
})

local FOVChanger = VisualTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        camera.FieldOfView = Value
    end,
})

local Radar = VisualTab:CreateToggle({
    Name = "Radar",
    CurrentValue = false,
    Flag = "Radar",
    Callback = function(Value)
        radarEnabled = Value
    end,
})

local MovementTab = Window:CreateTab("Movement", 4483362458)

MovementTab:CreateSection("Speed")

local SpeedHack = MovementTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        if Value then
            player.Character.Humanoid.WalkSpeed = 50
        else
            player.Character.Humanoid.WalkSpeed = 16
        end
    end,
})

local SpeedSlider = MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        player.Character.Humanoid.WalkSpeed = Value
    end,
})

local JumpPower = MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        player.Character.Humanoid.JumpPower = Value
    end,
})

MovementTab:CreateSection("Physics")

local Fly = MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        if Value then
            local BV = Instance.new("BodyVelocity")
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.Parent = rootPart
            _G.FlyBV = BV
            
            local BG = Instance.new("BodyGyro")
            BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BG.P = 10000
            BG.Parent = rootPart
            _G.FlyBG = BG
            
            _G.FlyConnection = runService.Heartbeat:Connect(function()
                local moveDirection = Vector3.new()
                
                if userInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if userInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if userInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if userInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                
                BV.Velocity = moveDirection * 50
                BG.CFrame = camera.CFrame
            end)
        else
            if _G.FlyConnection then _G.FlyConnection:Disconnect() end
            if _G.FlyBV then _G.FlyBV:Destroy() end
            if _G.FlyBG then _G.FlyBG:Destroy() end
        end
    end,
})

local NoClip = MovementTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        local character = player.Character or player.CharacterAdded:Wait()
        
        if Value then
            _G.NoClipConnection = runService.Stepped:Connect(function()
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if _G.NoClipConnection then
                _G.NoClipConnection:Disconnect()
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("Quick Teleports")

local function teleportTo(position)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    rootPart.CFrame = CFrame.new(position)
end

TeleportTab:CreateButton({
    Name = "Spawn Point",
    Callback = function()
        local spawn = workspace:FindFirstChild("SpawnLocation")
        if spawn then
            teleportTo(spawn.Position + Vector3.new(0, 5, 0))
        end
    end,
})

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = {"Select Player"},
    MultipleOptions = false,
    Flag = "TeleportPlayer",
    Callback = function(Option)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Name == Option[1] and p.Character then
                teleportTo(p.Character.HumanoidRootPart.Position)
            end
        end
    end,
})

task.spawn(function()
    while true do
        local names = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                table.insert(names, p.Name)
            end
        end
        PlayerDropdown:Refresh(names)
        task.wait(3)
    end
end)

local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Game")

local GodMode = MiscTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        if Value then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end,
})

local AutoRespawn = MiscTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(Value)
        if Value then
            _G.AutoRespawn = player.CharacterAdded:Connect(function()
                wait(1)
                player:LoadCharacter()
            end)
        else
            if _G.AutoRespawn then
                _G.AutoRespawn:Disconnect()
            end
        end
    end,
})

MiscTab:CreateButton({
    Name = "Remove Kill Barriers",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "KillBrick" or v.Name == "DeathBrick" then
                v:Destroy()
            end
        end
        Rayfield:Notify({
            Title = "Kill Barriers",
            Content = "All kill barriers removed",
            Duration = 2,
        })
    end,
})

local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Configuration")

local UIKeybind = SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    HoldToInteract = false,
    Flag = "UIKeybind",
    Callback = function(Keybind)
    end,
})

SettingsTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration",
            Content = "Settings saved successfully",
            Duration = 2,
        })
    end,
})

SettingsTab:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        Rayfield:LoadConfiguration()
    end,
})

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateSection("Info")
SettingsTab:CreateLabel("TheWizard Hub v1.0")
SettingsTab:CreateLabel("FPS Game Suite")

runService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            local camCFrame = camera.CFrame
            local targetCFrame = CFrame.new(camCFrame.Position, targetPos)
            camera.CFrame = camCFrame:Lerp(targetCFrame, aimbotSmoothness)
        end
    end
end)

game.Players.PlayerAdded:Connect(function(newPlayer)
    if espEnabled and newPlayer ~= player then
        newPlayer.CharacterAdded:Connect(function(character)
            wait(0.5)
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end)
    end
end)

Rayfield:LoadConfiguration()
