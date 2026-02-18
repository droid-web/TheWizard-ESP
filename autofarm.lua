--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║              WIZARD UI - EXEMPLE D'UTILISATION                ║
    ║                    Démonstration Complète                     ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

-- Charger la librairie (en local pour test)
local WizardUI = loadstring(game:HttpGet("VOTRE_LIEN_RAW_ICI"))() 
-- OU copiez le contenu de WizardUI_Library.lua ici

-- ═══════════════════════════════════════════════════════════════
-- CRÉER LA FENÊTRE
-- ═══════════════════════════════════════════════════════════════

local Window = WizardUI:CreateWindow({
    Title = "Wizard UI",
    Subtitle = "Interface Révolutionnaire v2.0",
    Size = UDim2.new(0, 580, 0, 420),
    Theme = "Ocean" -- Ocean, Midnight, Sunset, Emerald, Neon
})

-- ═══════════════════════════════════════════════════════════════
-- ONGLET PRINCIPAL
-- ═══════════════════════════════════════════════════════════════

local MainTab = Window:CreateTab({
    Name = "Principal",
    Icon = "🏠"
})

MainTab:CreateSection("⚡ Fonctions Rapides")

MainTab:CreateToggle({
    Name = "Fonction Principale",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

MainTab:CreateToggle({
    Name = "Mode Avancé",
    Default = false,
    Callback = function(value)
        print("Mode Avancé:", value)
    end
})

MainTab:CreateButton({
    Name = "Exécuter Action",
    Callback = function()
        Window:Notify({
            Title = "Action",
            Message = "L'action a été exécutée avec succès!",
            Type = "Success",
            Duration = 3
        })
    end
})

MainTab:CreateSection("🎚️ Paramètres")

MainTab:CreateSlider({
    Name = "Vitesse",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Vitesse:", value)
    end
})

MainTab:CreateSlider({
    Name = "Puissance",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        print("Puissance:", value)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- ONGLET COMBAT
-- ═══════════════════════════════════════════════════════════════

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "⚔️"
})

CombatTab:CreateSection("🎯 Aimbot")

CombatTab:CreateToggle({
    Name = "Activer Aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value)
    end
})

CombatTab:CreateDropdown({
    Name = "Partie visée",
    Items = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(item)
        print("Partie:", item)
    end
})

CombatTab:CreateSlider({
    Name = "FOV",
    Min = 50,
    Max = 500,
    Default = 150,
    Callback = function(value)
        print("FOV:", value)
    end
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 20,
    Default = 8,
    Callback = function(value)
        print("Smooth:", value)
    end
})

CombatTab:CreateSection("👁️ ESP")

CombatTab:CreateToggle({
    Name = "Activer ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

CombatTab:CreateColorPicker({
    Name = "Couleur ESP",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Couleur:", color)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- ONGLET PERSONNAGE
-- ═══════════════════════════════════════════════════════════════

local PlayerTab = Window:CreateTab({
    Name = "Personnage",
    Icon = "🧑"
})

PlayerTab:CreateSection("🏃 Mouvement")

PlayerTab:CreateToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(value)
        print("Speed:", value)
    end
})

PlayerTab:CreateToggle({
    Name = "Fly",
    Default = false,
    Callback = function(value)
        print("Fly:", value)
    end
})

PlayerTab:CreateToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(value)
        print("NoClip:", value)
    end
})

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(value)
        print("WalkSpeed:", value)
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        print("JumpPower:", value)
    end
})

PlayerTab:CreateSection("🛡️ Protection")

PlayerTab:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value)
        print("God:", value)
    end
})

-- ═══════════════════════════════════════════════════════════════
-- ONGLET TÉLÉPORTATION
-- ═══════════════════════════════════════════════════════════════

local TeleportTab = Window:CreateTab({
    Name = "Téléportation",
    Icon = "🌍"
})

TeleportTab:CreateSection("📍 Lieux")

TeleportTab:CreateDropdown({
    Name = "Destination",
    Items = {"Spawn", "Shop", "Boss", "Secret Area", "Event"},
    Default = "Spawn",
    Callback = function(item)
        print("Destination:", item)
    end
})

TeleportTab:CreateButton({
    Name = "Téléporter",
    Callback = function()
        Window:Notify({
            Title = "Téléportation",
            Message = "Téléportation en cours...",
            Type = "Info",
            Duration = 2
        })
    end
})

TeleportTab:CreateSection("📐 Coordonnées")

TeleportTab:CreateInput({
    Name = "Position X",
    Placeholder = "0",
    Callback = function(text)
        print("X:", text)
    end
})

TeleportTab:CreateInput({
    Name = "Position Y",
    Placeholder = "0",
    Callback = function(text)
        print("Y:", text)
    end
})

TeleportTab:CreateInput({
    Name = "Position Z",
    Placeholder = "0",
    Callback = function(text)
        print("Z:", text)
    end
})

TeleportTab:CreateButton({
    Name = "Téléporter aux Coords",
    Callback = function()
        print("TP Coords")
    end
})

-- ═══════════════════════════════════════════════════════════════
-- ONGLET PARAMÈTRES
-- ═══════════════════════════════════════════════════════════════

local SettingsTab = Window:CreateTab({
    Name = "Paramètres",
    Icon = "⚙️"
})

SettingsTab:CreateSection("🎨 Apparence")

SettingsTab:CreateDropdown({
    Name = "Thème",
    Items = {"Ocean", "Midnight", "Sunset", "Emerald", "Neon"},
    Default = "Ocean",
    Callback = function(theme)
        Window:SetTheme(theme)
        Window:Notify({
            Title = "Thème",
            Message = "Thème changé: " .. theme,
            Type = "Success",
            Duration = 2
        })
    end
})

SettingsTab:CreateSection("⌨️ Raccourcis")

SettingsTab:CreateKeybind({
    Name = "Toggle Menu",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        print("Menu toggled")
    end
})

SettingsTab:CreateKeybind({
    Name = "Panic Key",
    Default = Enum.KeyCode.P,
    Callback = function()
        print("Panic!")
    end
})

SettingsTab:CreateSection("ℹ️ Informations")

SettingsTab:CreateButton({
    Name = "Rejoindre Discord",
    Callback = function()
        -- setclipboard("discord.gg/xxx")
        Window:Notify({
            Title = "Discord",
            Message = "Lien copié dans le presse-papier!",
            Type = "Info",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "Vérifier Mise à Jour",
    Callback = function()
        Window:Notify({
            Title = "Mise à jour",
            Message = "Vous avez la dernière version!",
            Type = "Success",
            Duration = 3
        })
    end
})

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION DE BIENVENUE
-- ═══════════════════════════════════════════════════════════════

wait(1)
Window:Notify({
    Title = "Bienvenue!",
    Message = "Wizard UI chargé avec succès. Profitez de l'interface!",
    Type = "Success",
    Duration = 5
})
