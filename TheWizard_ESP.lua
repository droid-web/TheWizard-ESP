-- Rayfield UI Interface Example pour Roblox
-- Chargement de la bibliothèque Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Création de la fenêtre principale
local Window = Rayfield:CreateWindow({
    Name = "🎮 Mon Hub Roblox",
    LoadingTitle = "Chargement de l'interface",
    LoadingSubtitle = "par Votre Nom",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Dossier personnalisé pour votre hub
        FileName = "MonHubConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink", -- Code d'invitation Discord (sans discord.gg/)
        RememberJoins = true -- false pour forcer à rejoindre à chaque fois
    },
    KeySystem = false, -- Activer le système de clés
    KeySettings = {
        Title = "Système de Clés",
        Subtitle = "Entrez votre clé",
        Note = "Rejoignez le Discord pour obtenir une clé",
        FileName = "MaCle",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"MaCleSecrete123"} -- Votre clé
    }
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 1: PRINCIPAL
-- ═══════════════════════════════════════════════════════════════
local MainTab = Window:CreateTab("🏠 Principal", 4483362458)

local MainSection = MainTab:CreateSection("Bienvenue")

Rayfield:Notify({
    Title = "Interface Chargée",
    Content = "Bienvenue dans votre hub Roblox!",
    Duration = 6.5,
    Image = 4483362458,
})

MainTab:CreateLabel("Voici votre interface de contrôle principale")

local Button = MainTab:CreateButton({
    Name = "🚀 Cliquez-moi!",
    Callback = function()
        Rayfield:Notify({
            Title = "Bouton Cliqué",
            Content = "Vous avez cliqué sur le bouton!",
            Duration = 3,
        })
    end,
})

local Toggle = MainTab:CreateToggle({
    Name = "🔄 Mode Automatique",
    CurrentValue = false,
    Flag = "AutoMode",
    Callback = function(Value)
        print("Mode Automatique:", Value)
        if Value then
            Rayfield:Notify({
                Title = "Mode Auto Activé",
                Content = "Le mode automatique est maintenant actif",
                Duration = 3,
            })
        end
    end,
})

local Slider = MainTab:CreateSlider({
    Name = "⚡ Vitesse de Marche",
    Range = {16, 100},
    Increment = 1,
    Suffix = " vitesse",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

local Input = MainTab:CreateInput({
    Name = "📝 Entrez votre nom",
    PlaceholderText = "Votre nom ici...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        print("Nom entré:", Text)
        Rayfield:Notify({
            Title = "Nom Enregistré",
            Content = "Bonjour " .. Text .. "!",
            Duration = 3,
        })
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 2: JOUEUR
-- ═══════════════════════════════════════════════════════════════
local PlayerTab = Window:CreateTab("👤 Joueur", 4483362458)

local PlayerSection = PlayerTab:CreateSection("Modifications du Joueur")

local WalkSpeedToggle = PlayerTab:CreateToggle({
    Name = "🏃 Vitesse Rapide",
    CurrentValue = false,
    Flag = "FastSpeed",
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end,
})

local JumpPowerToggle = PlayerTab:CreateToggle({
    Name = "🦘 Super Saut",
    CurrentValue = false,
    Flag = "SuperJump",
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
        else
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end,
})

local NoClipToggle = PlayerTab:CreateToggle({
    Name = "👻 NoClip (Traverser les murs)",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if Value then
            _G.NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
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

local FlyToggle = PlayerTab:CreateToggle({
    Name = "✈️ Vol",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        if Value then
            local BV = Instance.new("BodyVelocity")
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.Parent = rootPart
            _G.FlyBodyVelocity = BV
            
            local BG = Instance.new("BodyGyro")
            BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BG.P = 10000
            BG.Parent = rootPart
            _G.FlyBodyGyro = BG
            
            _G.FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local camera = workspace.CurrentCamera
                local moveDirection = Vector3.new()
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                
                BV.Velocity = moveDirection * 50
                BG.CFrame = camera.CFrame
            end)
        else
            if _G.FlyConnection then
                _G.FlyConnection:Disconnect()
            end
            if _G.FlyBodyVelocity then
                _G.FlyBodyVelocity:Destroy()
            end
            if _G.FlyBodyGyro then
                _G.FlyBodyGyro:Destroy()
            end
        end
    end,
})

local GodModeToggle = PlayerTab:CreateToggle({
    Name = "🛡️ Mode Dieu",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
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

-- ═══════════════════════════════════════════════════════════════
-- TAB 3: TÉLÉPORTATION
-- ═══════════════════════════════════════════════════════════════
local TeleportTab = Window:CreateTab("🌍 Téléportation", 4483362458)

local TeleportSection = TeleportTab:CreateSection("Positions Rapides")

local function teleportToPosition(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    rootPart.CFrame = CFrame.new(position)
end

TeleportTab:CreateButton({
    Name = "📍 Téléporter au Spawn",
    Callback = function()
        local spawnLocation = game:GetService("Workspace"):FindFirstChild("SpawnLocation")
        if spawnLocation then
            teleportToPosition(spawnLocation.Position + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Téléportation",
                Content = "Téléporté au spawn!",
                Duration = 2,
            })
        end
    end,
})

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "🎯 Téléporter vers un joueur",
    Options = {},
    CurrentOption = {"Sélectionnez un joueur"},
    MultipleOptions = false,
    Flag = "PlayerTeleport",
    Callback = function(Option)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name == Option[1] and player.Character then
                local targetPos = player.Character.HumanoidRootPart.Position
                teleportToPosition(targetPos + Vector3.new(0, 3, 0))
                Rayfield:Notify({
                    Title = "Téléportation",
                    Content = "Téléporté vers " .. player.Name,
                    Duration = 2,
                })
            end
        end
    end,
})

-- Mise à jour de la liste des joueurs
task.spawn(function()
    while true do
        local playerNames = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        PlayerDropdown:Refresh(playerNames)
        task.wait(5)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB 4: VISUEL
-- ═══════════════════════════════════════════════════════════════
local VisualTab = Window:CreateTab("👁️ Visuel", 4483362458)

local VisualSection = VisualTab:CreateSection("Options Visuelles")

local FullbrightToggle = VisualTab:CreateToggle({
    Name = "💡 Fullbright (Luminosité Max)",
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

local ESPToggle = VisualTab:CreateToggle({
    Name = "👤 ESP Joueurs",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        if Value then
            _G.ESPEnabled = true
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP"
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                end
            end
        else
            _G.ESPEnabled = false
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("ESP") then
                    player.Character.ESP:Destroy()
                end
            end
        end
    end,
})

local FOVSlider = VisualTab:CreateSlider({
    Name = "🔭 Champ de Vision (FOV)",
    Range = {70, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        game.Workspace.CurrentCamera.FieldOfView = Value
    end,
})

local ColorPicker = VisualTab:CreateColorPicker({
    Name = "🎨 Couleur de l'Interface",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker",
    Callback = function(Value)
        print("Couleur choisie:", Value)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- TAB 5: PARAMÈTRES
-- ═══════════════════════════════════════════════════════════════
local SettingsTab = Window:CreateTab("⚙️ Paramètres", 4483362458)

local SettingsSection = SettingsTab:CreateSection("Configuration")

local Keybind = SettingsTab:CreateKeybind({
    Name = "🔑 Touche pour Ouvrir/Fermer l'UI",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "UIToggleKeybind",
    Callback = function(Keybind)
        print("Keybind changé à:", Keybind)
    end,
})

SettingsTab:CreateButton({
    Name = "💾 Sauvegarder la Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Configuration",
            Content = "Configuration sauvegardée avec succès!",
            Duration = 3,
        })
    end,
})

SettingsTab:CreateButton({
    Name = "🔄 Réinitialiser l'Interface",
    Callback = function()
        Rayfield:Notify({
            Title = "Réinitialisation",
            Content = "Interface réinitialisée!",
            Duration = 3,
        })
        -- Recharger l'interface
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateButton({
    Name = "❌ Fermer l'Interface",
    Callback = function()
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateLabel("Version 1.0.0 - Créé avec Rayfield")

-- ═══════════════════════════════════════════════════════════════
-- TAB 6: CRÉDITS
-- ═══════════════════════════════════════════════════════════════
local CreditsTab = Window:CreateTab("ℹ️ Crédits", 4483362458)

CreditsTab:CreateSection("À Propos")

CreditsTab:CreateLabel("Hub créé avec Rayfield UI Library")
CreditsTab:CreateLabel("Développé par: Votre Nom")
CreditsTab:CreateLabel("Version: 1.0.0")
CreditsTab:CreateLabel("Date: 2025")

CreditsTab:CreateButton({
    Name = "📋 Copier le lien Discord",
    Callback = function()
        setclipboard("discord.gg/votre-serveur")
        Rayfield:Notify({
            Title = "Lien Copié",
            Content = "Le lien Discord a été copié dans le presse-papier",
            Duration = 3,
        })
    end,
})

-- ═══════════════════════════════════════════════════════════════
-- INITIALISATION FINALE
-- ═══════════════════════════════════════════════════════════════

-- Message de bienvenue final
Rayfield:Notify({
    Title = "🎉 Prêt!",
    Content = "Toutes les fonctionnalités sont maintenant disponibles!",
    Duration = 5,
})

-- Charger la configuration sauvegardée
Rayfield:LoadConfiguration()

print("Interface Rayfield chargée avec succès!")
