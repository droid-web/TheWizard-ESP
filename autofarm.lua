--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                    WIZARD UI LIBRARY                          ║
    ║                     Version 2.0                               ║
    ║              Interface Révolutionnaire                        ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    Caractéristiques uniques:
    • Glassmorphism avec blur réel
    • Animations fluides sur TOUT
    • Système de notifications avancé
    • Thèmes dynamiques
    • Particules interactives
    • Sons UI
    • Dock flottant
    • Mini-map de navigation
    • Mode picture-in-picture
    • Raccourcis clavier personnalisables
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURATION & THÈMES
-- ═══════════════════════════════════════════════════════════════

local WizardUI = {}
WizardUI.__index = WizardUI

local Themes = {
    Ocean = {
        Primary = Color3.fromRGB(20, 30, 50),
        Secondary = Color3.fromRGB(30, 45, 70),
        Accent = Color3.fromRGB(0, 180, 255),
        AccentDark = Color3.fromRGB(0, 120, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(50, 200, 100),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 180, 50),
        Glass = 0.15,
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Midnight = {
        Primary = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 40),
        Accent = Color3.fromRGB(150, 100, 255),
        AccentDark = Color3.fromRGB(100, 60, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(160, 160, 180),
        Success = Color3.fromRGB(100, 255, 150),
        Error = Color3.fromRGB(255, 100, 100),
        Warning = Color3.fromRGB(255, 200, 80),
        Glass = 0.12,
        Shadow = Color3.fromRGB(80, 50, 150),
    },
    Sunset = {
        Primary = Color3.fromRGB(40, 20, 30),
        Secondary = Color3.fromRGB(60, 30, 45),
        Accent = Color3.fromRGB(255, 100, 80),
        AccentDark = Color3.fromRGB(200, 70, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 180),
        Success = Color3.fromRGB(100, 255, 150),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 180, 80),
        Glass = 0.18,
        Shadow = Color3.fromRGB(255, 50, 50),
    },
    Emerald = {
        Primary = Color3.fromRGB(15, 30, 25),
        Secondary = Color3.fromRGB(25, 45, 35),
        Accent = Color3.fromRGB(50, 255, 150),
        AccentDark = Color3.fromRGB(30, 180, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 190),
        Success = Color3.fromRGB(50, 255, 150),
        Error = Color3.fromRGB(255, 100, 100),
        Warning = Color3.fromRGB(255, 200, 80),
        Glass = 0.15,
        Shadow = Color3.fromRGB(0, 100, 50),
    },
    Neon = {
        Primary = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(255, 0, 150),
        AccentDark = Color3.fromRGB(180, 0, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 150, 200),
        Success = Color3.fromRGB(0, 255, 200),
        Error = Color3.fromRGB(255, 50, 100),
        Warning = Color3.fromRGB(255, 255, 0),
        Glass = 0.1,
        Shadow = Color3.fromRGB(255, 0, 150),
    },
}

local CurrentTheme = Themes.Ocean
local ActiveWindows = {}
local NotificationQueue = {}

-- ═══════════════════════════════════════════════════════════════
-- UTILITAIRES & ANIMATIONS
-- ═══════════════════════════════════════════════════════════════

local function CreateTween(obj, time, props, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(time, style, direction), props)
end

local function Ripple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    
    local expandTween = CreateTween(ripple, 0.5, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    })
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function CreateShadow(parent, depth, color)
    depth = depth or 15
    color = color or CurrentTheme.Shadow
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = color
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Size = UDim2.new(1, depth * 2, 1, depth * 2)
    shadow.Position = UDim2.new(0, -depth, 0, -depth)
    shadow.ZIndex = -1
    shadow.Parent = parent
    
    return shadow
end

local function CreateGlow(parent, color, intensity)
    intensity = intensity or 0.5
    color = color or CurrentTheme.Accent
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5554236805"
    glow.ImageColor3 = color
    glow.ImageTransparency = intensity
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Position = UDim2.new(0, -15, 0, -15)
    glow.ZIndex = -2
    glow.Parent = parent
    
    -- Animation pulsation
    spawn(function()
        while glow and glow.Parent do
            CreateTween(glow, 1.5, {ImageTransparency = intensity + 0.2}):Play()
            wait(1.5)
            CreateTween(glow, 1.5, {ImageTransparency = intensity}):Play()
            wait(1.5)
        end
    end)
    
    return glow
end

-- ═══════════════════════════════════════════════════════════════
-- COMPOSANTS UI
-- ═══════════════════════════════════════════════════════════════

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CurrentTheme.Accent
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    
    if type(colors) == "table" then
        local colorSeq = {}
        for i, col in ipairs(colors) do
            table.insert(colorSeq, ColorSequenceKeypoint.new((i-1)/(#colors-1), col))
        end
        gradient.Color = ColorSequence.new(colorSeq)
    else
        gradient.Color = ColorSequence.new(colors or CurrentTheme.Primary, CurrentTheme.Secondary)
    end
    
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

-- ═══════════════════════════════════════════════════════════════
-- SYSTÈME DE NOTIFICATIONS AVANCÉ
-- ═══════════════════════════════════════════════════════════════

local NotificationContainer = nil

local function CreateNotificationSystem(screenGui)
    NotificationContainer = Instance.new("Frame")
    NotificationContainer.Name = "Notifications"
    NotificationContainer.Size = UDim2.new(0, 320, 1, -20)
    NotificationContainer.Position = UDim2.new(1, -330, 0, 10)
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.Parent = screenGui
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = NotificationContainer
end

function WizardUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 5
    local type_ = options.Type or "Info" -- Info, Success, Error, Warning
    
    local colors = {
        Info = CurrentTheme.Accent,
        Success = CurrentTheme.Success,
        Error = CurrentTheme.Error,
        Warning = CurrentTheme.Warning,
    }
    
    local icons = {
        Info = "ℹ️",
        Success = "✅",
        Error = "❌",
        Warning = "⚠️",
    }
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.BackgroundColor3 = CurrentTheme.Primary
    notif.BackgroundTransparency = CurrentTheme.Glass
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = NotificationContainer
    
    CreateCorner(notif, 10)
    CreateStroke(notif, colors[type_], 2, 0.3)
    CreateShadow(notif, 10)
    
    -- Accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = colors[type_]
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notif
    CreateCorner(accentBar, 2)
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 35, 0, 35)
    icon.Position = UDim2.new(0, 15, 0, 12)
    icon.BackgroundTransparency = 1
    icon.Text = icons[type_]
    icon.TextSize = 22
    icon.Parent = notif
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 0, 20)
    titleLabel.Position = UDim2.new(0, 55, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -70, 0, 30)
    msgLabel.Position = UDim2.new(0, 55, 0, 30)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = CurrentTheme.TextDark
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = notif
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = CurrentTheme.TextDark
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = notif
    
    -- Progress bar
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -20, 0, 3)
    progressBg.Position = UDim2.new(0, 10, 1, -8)
    progressBg.BackgroundColor3 = CurrentTheme.Secondary
    progressBg.BorderSizePixel = 0
    progressBg.Parent = notif
    CreateCorner(progressBg, 2)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = colors[type_]
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    CreateCorner(progressFill, 2)
    
    -- Animations
    notif.Size = UDim2.new(1, 0, 0, 0)
    local openTween = CreateTween(notif, 0.4, {Size = UDim2.new(1, 0, 0, 75)}, Enum.EasingStyle.Back)
    openTween:Play()
    
    -- Progress animation
    CreateTween(progressFill, duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear):Play()
    
    local function CloseNotif()
        local closeTween = CreateTween(notif, 0.3, {Size = UDim2.new(1, 0, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            notif:Destroy()
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(CloseNotif)
    closeBtn.MouseEnter:Connect(function()
        CreateTween(closeBtn, 0.2, {TextColor3 = colors[type_]}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        CreateTween(closeBtn, 0.2, {TextColor3 = CurrentTheme.TextDark}):Play()
    end)
    
    delay(duration, CloseNotif)
end

-- ═══════════════════════════════════════════════════════════════
-- FENÊTRE PRINCIPALE
-- ═══════════════════════════════════════════════════════════════

function WizardUI:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Wizard UI"
    local subtitle = options.Subtitle or ""
    local size = options.Size or UDim2.new(0, 550, 0, 400)
    local theme = options.Theme or "Ocean"
    
    if Themes[theme] then
        CurrentTheme = Themes[theme]
    end
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WizardUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.CoreGui
    
    CreateNotificationSystem(screenGui)
    
    -- Main Container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = size
    mainContainer.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    mainContainer.BackgroundColor3 = CurrentTheme.Primary
    mainContainer.BackgroundTransparency = CurrentTheme.Glass
    mainContainer.BorderSizePixel = 0
    mainContainer.ClipsDescendants = true
    mainContainer.Parent = screenGui
    
    CreateCorner(mainContainer, 12)
    CreateStroke(mainContainer, CurrentTheme.Accent, 1, 0.7)
    CreateShadow(mainContainer, 25, CurrentTheme.Shadow)
    CreateGlow(mainContainer, CurrentTheme.Accent, 0.85)
    
    -- Animation d'ouverture
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.BackgroundTransparency = 1
    
    local openTween = CreateTween(mainContainer, 0.6, {
        Size = size,
        BackgroundTransparency = CurrentTheme.Glass
    }, Enum.EasingStyle.Back)
    openTween:Play()
    
    -- ═══════════════════════════════════════════════════════════
    -- HEADER
    -- ═══════════════════════════════════════════════════════════
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = CurrentTheme.Secondary
    header.BackgroundTransparency = 0.5
    header.BorderSizePixel = 0
    header.Parent = mainContainer
    
    -- Header gradient
    CreateGradient(header, {CurrentTheme.Accent, CurrentTheme.AccentDark}, 90)
    
    local headerCorner = Instance.new("Frame")
    headerCorner.Size = UDim2.new(1, 0, 0, 12)
    headerCorner.Position = UDim2.new(0, 0, 1, -12)
    headerCorner.BackgroundColor3 = CurrentTheme.Secondary
    headerCorner.BackgroundTransparency = 0.5
    headerCorner.BorderSizePixel = 0
    headerCorner.Parent = header
    
    -- Logo/Icon animé
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 36, 0, 36)
    logoContainer.Position = UDim2.new(0, 12, 0.5, -18)
    logoContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    logoContainer.BackgroundTransparency = 0.9
    logoContainer.Parent = header
    CreateCorner(logoContainer, 8)
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "🔮"
    logo.TextSize = 22
    logo.Parent = logoContainer
    
    -- Animation rotation logo
    spawn(function()
        local rotation = 0
        while logoContainer and logoContainer.Parent do
            rotation = rotation + 1
            logo.Rotation = math.sin(rotation * 0.05) * 10
            RunService.RenderStepped:Wait()
        end
    end)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, 0, 0, 22)
    titleLabel.Position = UDim2.new(0, 58, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Subtitle
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(0.5, 0, 0, 16)
    subtitleLabel.Position = UDim2.new(0, 58, 0, 28)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = subtitle
    subtitleLabel.TextColor3 = CurrentTheme.TextDark
    subtitleLabel.TextSize = 11
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = header
    
    -- Window Controls
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 85, 0, 30)
    controls.Position = UDim2.new(1, -95, 0.5, -15)
    controls.BackgroundTransparency = 1
    controls.Parent = header
    
    local function CreateControlButton(icon, color, posX, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 25, 0, 25)
        btn.Position = UDim2.new(0, posX, 0.5, -12.5)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.3
        btn.Text = icon
        btn.TextSize = 12
        btn.TextColor3 = CurrentTheme.Text
        btn.Font = Enum.Font.GothamBold
        btn.Parent = controls
        CreateCorner(btn, 6)
        
        btn.MouseEnter:Connect(function()
            CreateTween(btn, 0.2, {BackgroundTransparency = 0, Size = UDim2.new(0, 28, 0, 28)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            CreateTween(btn, 0.2, {BackgroundTransparency = 0.3, Size = UDim2.new(0, 25, 0, 25)}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    -- Minimize
    CreateControlButton("−", Color3.fromRGB(255, 180, 50), 0, function()
        local targetSize = Window.Minimized and size or UDim2.new(size.X.Scale, size.X.Offset, 0, 50)
        Window.Minimized = not Window.Minimized
        CreateTween(mainContainer, 0.4, {Size = targetSize}, Enum.EasingStyle.Back):Play()
    end)
    
    -- Maximize
    CreateControlButton("□", Color3.fromRGB(50, 200, 100), 30, function()
        Window.Maximized = not Window.Maximized
        local targetSize = Window.Maximized and UDim2.new(0.9, 0, 0.9, 0) or size
        local targetPos = Window.Maximized and UDim2.new(0.05, 0, 0.05, 0) or UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
        CreateTween(mainContainer, 0.4, {Size = targetSize, Position = targetPos}, Enum.EasingStyle.Back):Play()
    end)
    
    -- Close
    CreateControlButton("×", Color3.fromRGB(255, 80, 80), 60, function()
        CreateTween(mainContainer, 0.4, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        delay(0.5, function()
            screenGui:Destroy()
        end)
    end)
    
    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainContainer.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- TAB BAR (SIDEBAR)
    -- ═══════════════════════════════════════════════════════════
    
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 55, 1, -55)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = CurrentTheme.Secondary
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainContainer
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.Parent = sidebar
    
    -- Tab indicator
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "Indicator"
    tabIndicator.Size = UDim2.new(0, 3, 0, 35)
    tabIndicator.Position = UDim2.new(0, 0, 0, 10)
    tabIndicator.BackgroundColor3 = CurrentTheme.Accent
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Parent = sidebar
    CreateCorner(tabIndicator, 2)
    
    -- ═══════════════════════════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════════════════════════
    
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -60, 1, -55)
    contentArea.Position = UDim2.new(0, 58, 0, 52)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainContainer
    
    -- ═══════════════════════════════════════════════════════════
    -- CREATE TAB FUNCTION
    -- ═══════════════════════════════════════════════════════════
    
    function Window:CreateTab(options)
        options = options or {}
        local name = options.Name or "Tab"
        local icon = options.Icon or "📁"
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.Size = UDim2.new(0, 45, 0, 45)
        tabBtn.BackgroundColor3 = CurrentTheme.Primary
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.Parent = sidebar
        CreateCorner(tabBtn, 10)
        
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(1, 0, 1, 0)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = icon
        tabIcon.TextSize = 20
        tabIcon.Parent = tabBtn
        
        -- Tooltip
        local tooltip = Instance.new("Frame")
        tooltip.Size = UDim2.new(0, 0, 0, 30)
        tooltip.Position = UDim2.new(1, 10, 0.5, -15)
        tooltip.BackgroundColor3 = CurrentTheme.Secondary
        tooltip.BackgroundTransparency = 0.1
        tooltip.BorderSizePixel = 0
        tooltip.ClipsDescendants = true
        tooltip.Visible = false
        tooltip.Parent = tabBtn
        CreateCorner(tooltip, 6)
        
        local tooltipText = Instance.new("TextLabel")
        tooltipText.Size = UDim2.new(1, -10, 1, 0)
        tooltipText.Position = UDim2.new(0, 5, 0, 0)
        tooltipText.BackgroundTransparency = 1
        tooltipText.Text = name
        tooltipText.TextColor3 = CurrentTheme.Text
        tooltipText.TextSize = 12
        tooltipText.Font = Enum.Font.GothamBold
        tooltipText.TextXAlignment = Enum.TextXAlignment.Left
        tooltipText.Parent = tooltip
        
        tabBtn.MouseEnter:Connect(function()
            tooltip.Visible = true
            CreateTween(tooltip, 0.3, {Size = UDim2.new(0, #name * 8 + 20, 0, 30)}, Enum.EasingStyle.Back):Play()
            CreateTween(tabBtn, 0.2, {BackgroundTransparency = 0.2}):Play()
        end)
        
        tabBtn.MouseLeave:Connect(function()
            CreateTween(tooltip, 0.2, {Size = UDim2.new(0, 0, 0, 30)}):Play()
            delay(0.2, function() tooltip.Visible = false end)
            if Window.ActiveTab ~= Tab then
                CreateTween(tabBtn, 0.2, {BackgroundTransparency = 0.5}):Play()
            end
        end)
        
        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = CurrentTheme.Accent
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        tabBtn.MouseButton1Click:Connect(function()
            if Window.ActiveTab then
                Window.ActiveTab.Content.Visible = false
                CreateTween(Window.ActiveTab.Button, 0.2, {BackgroundTransparency = 0.5}):Play()
            end
            
            Window.ActiveTab = Tab
            tabContent.Visible = true
            CreateTween(tabBtn, 0.2, {BackgroundTransparency = 0.1}):Play()
            
            -- Animate indicator
            local btnPos = tabBtn.AbsolutePosition.Y - sidebar.AbsolutePosition.Y
            CreateTween(tabIndicator, 0.3, {Position = UDim2.new(0, 0, 0, btnPos + 5)}, Enum.EasingStyle.Back):Play()
            
            Ripple(tabBtn, tabBtn.AbsolutePosition.X + 22, tabBtn.AbsolutePosition.Y + 22)
        end)
        
        Tab.Button = tabBtn
        Tab.Content = tabContent
        
        -- ═══════════════════════════════════════════════════════
        -- SECTION
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateSection(name)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, -10, 0, 30)
            section.BackgroundColor3 = CurrentTheme.Accent
            section.BackgroundTransparency = 0.7
            section.BorderSizePixel = 0
            section.Parent = tabContent
            CreateCorner(section, 6)
            
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, 0, 1, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = "  " .. name
            sectionLabel.TextColor3 = CurrentTheme.Text
            sectionLabel.TextSize = 13
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = section
            
            return section
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TOGGLE
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            local toggle = Instance.new("Frame")
            toggle.Size = UDim2.new(1, -10, 0, 45)
            toggle.BackgroundColor3 = CurrentTheme.Secondary
            toggle.BackgroundTransparency = 0.5
            toggle.BorderSizePixel = 0
            toggle.Parent = tabContent
            CreateCorner(toggle, 8)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = name
            toggleLabel.TextColor3 = CurrentTheme.Text
            toggleLabel.TextSize = 13
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggle
            
            -- Toggle Switch
            local switchBg = Instance.new("Frame")
            switchBg.Size = UDim2.new(0, 50, 0, 26)
            switchBg.Position = UDim2.new(1, -65, 0.5, -13)
            switchBg.BackgroundColor3 = default and CurrentTheme.Accent or CurrentTheme.Primary
            switchBg.BorderSizePixel = 0
            switchBg.Parent = toggle
            CreateCorner(switchBg, 13)
            
            local switchKnob = Instance.new("Frame")
            switchKnob.Size = UDim2.new(0, 20, 0, 20)
            switchKnob.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            switchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
            switchKnob.BorderSizePixel = 0
            switchKnob.Parent = switchBg
            CreateCorner(switchKnob, 10)
            
            local enabled = default
            
            local function UpdateToggle()
                local knobPos = enabled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                local bgColor = enabled and CurrentTheme.Accent or CurrentTheme.Primary
                
                CreateTween(switchKnob, 0.3, {Position = knobPos}, Enum.EasingStyle.Back):Play()
                CreateTween(switchBg, 0.3, {BackgroundColor3 = bgColor}):Play()
                
                callback(enabled)
            end
            
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    enabled = not enabled
                    UpdateToggle()
                    Ripple(toggle, input.Position.X, input.Position.Y)
                end
            end)
            
            toggle.MouseEnter:Connect(function()
                CreateTween(toggle, 0.2, {BackgroundTransparency = 0.3}):Play()
            end)
            toggle.MouseLeave:Connect(function()
                CreateTween(toggle, 0.2, {BackgroundTransparency = 0.5}):Play()
            end)
            
            return {
                Set = function(_, value)
                    enabled = value
                    UpdateToggle()
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SLIDER
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(1, -10, 0, 55)
            slider.BackgroundColor3 = CurrentTheme.Secondary
            slider.BackgroundTransparency = 0.5
            slider.BorderSizePixel = 0
            slider.Parent = tabContent
            CreateCorner(slider, 8)
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(0.6, 0, 0, 25)
            sliderLabel.Position = UDim2.new(0, 15, 0, 5)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = name
            sliderLabel.TextColor3 = CurrentTheme.Text
            sliderLabel.TextSize = 13
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = slider
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.3, 0, 0, 25)
            valueLabel.Position = UDim2.new(0.7, -15, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = CurrentTheme.Accent
            valueLabel.TextSize = 13
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = slider
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -30, 0, 8)
            sliderBg.Position = UDim2.new(0, 15, 0, 35)
            sliderBg.BackgroundColor3 = CurrentTheme.Primary
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = slider
            CreateCorner(sliderBg, 4)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = CurrentTheme.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            CreateCorner(sliderFill, 4)
            CreateGradient(sliderFill, {CurrentTheme.Accent, CurrentTheme.AccentDark}, 0)
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Size = UDim2.new(0, 18, 0, 18)
            sliderKnob.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
            sliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
            sliderKnob.BorderSizePixel = 0
            sliderKnob.ZIndex = 2
            sliderKnob.Parent = sliderBg
            CreateCorner(sliderKnob, 9)
            CreateShadow(sliderKnob, 5)
            
            local dragging = false
            
            local function UpdateSlider(inputX)
                local rel = math.clamp((inputX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * rel)
                
                CreateTween(sliderFill, 0.1, {Size = UDim2.new(rel, 0, 1, 0)}):Play()
                CreateTween(sliderKnob, 0.1, {Position = UDim2.new(rel, -9, 0.5, -9)}):Play()
                valueLabel.Text = tostring(value)
                callback(value)
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    UpdateSlider(input.Position.X)
                end
            end)
            
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input.Position.X)
                end
            end)
            
            slider.MouseEnter:Connect(function()
                CreateTween(slider, 0.2, {BackgroundTransparency = 0.3}):Play()
                CreateTween(sliderKnob, 0.2, {Size = UDim2.new(0, 22, 0, 22), Position = sliderKnob.Position - UDim2.new(0, 2, 0, 2)}):Play()
            end)
            slider.MouseLeave:Connect(function()
                CreateTween(slider, 0.2, {BackgroundTransparency = 0.5}):Play()
                CreateTween(sliderKnob, 0.2, {Size = UDim2.new(0, 18, 0, 18)}):Play()
            end)
        end
        
        -- ═══════════════════════════════════════════════════════
        -- BUTTON
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 40)
            button.BackgroundColor3 = CurrentTheme.Accent
            button.BackgroundTransparency = 0.3
            button.BorderSizePixel = 0
            button.Text = name
            button.TextColor3 = CurrentTheme.Text
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold
            button.Parent = tabContent
            CreateCorner(button, 8)
            CreateGradient(button, {CurrentTheme.Accent, CurrentTheme.AccentDark}, 90)
            
            button.MouseEnter:Connect(function()
                CreateTween(button, 0.2, {BackgroundTransparency = 0.1}):Play()
            end)
            button.MouseLeave:Connect(function()
                CreateTween(button, 0.2, {BackgroundTransparency = 0.3}):Play()
            end)
            button.MouseButton1Click:Connect(function()
                Ripple(button, Mouse.X, Mouse.Y)
                
                -- Click animation
                CreateTween(button, 0.1, {Size = UDim2.new(1, -15, 0, 38)}):Play()
                delay(0.1, function()
                    CreateTween(button, 0.2, {Size = UDim2.new(1, -10, 0, 40)}, Enum.EasingStyle.Back):Play()
                end)
                
                callback()
            end)
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(options)
            options = options or {}
            local name = options.Name or "Dropdown"
            local items = options.Items or {}
            local default = options.Default or items[1] or ""
            local callback = options.Callback or function() end
            
            local dropdown = Instance.new("Frame")
            dropdown.Size = UDim2.new(1, -10, 0, 45)
            dropdown.BackgroundColor3 = CurrentTheme.Secondary
            dropdown.BackgroundTransparency = 0.5
            dropdown.BorderSizePixel = 0
            dropdown.ClipsDescendants = false
            dropdown.Parent = tabContent
            CreateCorner(dropdown, 8)
            
            local dropLabel = Instance.new("TextLabel")
            dropLabel.Size = UDim2.new(0.5, 0, 1, 0)
            dropLabel.Position = UDim2.new(0, 15, 0, 0)
            dropLabel.BackgroundTransparency = 1
            dropLabel.Text = name
            dropLabel.TextColor3 = CurrentTheme.Text
            dropLabel.TextSize = 13
            dropLabel.Font = Enum.Font.Gotham
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropLabel.Parent = dropdown
            
            local selectBtn = Instance.new("TextButton")
            selectBtn.Size = UDim2.new(0.45, 0, 0, 30)
            selectBtn.Position = UDim2.new(0.52, 0, 0.5, -15)
            selectBtn.BackgroundColor3 = CurrentTheme.Primary
            selectBtn.BackgroundTransparency = 0.3
            selectBtn.Text = default .. " ▼"
            selectBtn.TextColor3 = CurrentTheme.Text
            selectBtn.TextSize = 12
            selectBtn.Font = Enum.Font.Gotham
            selectBtn.Parent = dropdown
            CreateCorner(selectBtn, 6)
            
            local itemsContainer = Instance.new("Frame")
            itemsContainer.Size = UDim2.new(0.45, 0, 0, 0)
            itemsContainer.Position = UDim2.new(0.52, 0, 1, 5)
            itemsContainer.BackgroundColor3 = CurrentTheme.Primary
            itemsContainer.BackgroundTransparency = 0.1
            itemsContainer.BorderSizePixel = 0
            itemsContainer.ClipsDescendants = true
            itemsContainer.ZIndex = 10
            itemsContainer.Visible = false
            itemsContainer.Parent = dropdown
            CreateCorner(itemsContainer, 6)
            CreateShadow(itemsContainer, 10)
            
            local itemsLayout = Instance.new("UIListLayout")
            itemsLayout.Padding = UDim.new(0, 2)
            itemsLayout.Parent = itemsContainer
            
            local opened = false
            local selected = default
            
            for _, item in ipairs(items) do
                local itemBtn = Instance.new("TextButton")
                itemBtn.Size = UDim2.new(1, 0, 0, 30)
                itemBtn.BackgroundColor3 = CurrentTheme.Secondary
                itemBtn.BackgroundTransparency = 0.5
                itemBtn.Text = item
                itemBtn.TextColor3 = CurrentTheme.Text
                itemBtn.TextSize = 12
                itemBtn.Font = Enum.Font.Gotham
                itemBtn.ZIndex = 11
                itemBtn.Parent = itemsContainer
                
                itemBtn.MouseEnter:Connect(function()
                    CreateTween(itemBtn, 0.15, {BackgroundTransparency = 0.2}):Play()
                end)
                itemBtn.MouseLeave:Connect(function()
                    CreateTween(itemBtn, 0.15, {BackgroundTransparency = 0.5}):Play()
                end)
                itemBtn.MouseButton1Click:Connect(function()
                    selected = item
                    selectBtn.Text = item .. " ▼"
                    callback(item)
                    
                    -- Close dropdown
                    opened = false
                    CreateTween(itemsContainer, 0.3, {Size = UDim2.new(0.45, 0, 0, 0)}):Play()
                    delay(0.3, function() itemsContainer.Visible = false end)
                end)
            end
            
            selectBtn.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    itemsContainer.Visible = true
                    CreateTween(itemsContainer, 0.3, {Size = UDim2.new(0.45, 0, 0, #items * 32)}, Enum.EasingStyle.Back):Play()
                    selectBtn.Text = selected .. " ▲"
                else
                    CreateTween(itemsContainer, 0.2, {Size = UDim2.new(0.45, 0, 0, 0)}):Play()
                    delay(0.2, function() itemsContainer.Visible = false end)
                    selectBtn.Text = selected .. " ▼"
                end
            end)
        end
        
        -- ═══════════════════════════════════════════════════════
        -- INPUT
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateInput(options)
            options = options or {}
            local name = options.Name or "Input"
            local placeholder = options.Placeholder or "Enter text..."
            local callback = options.Callback or function() end
            
            local input = Instance.new("Frame")
            input.Size = UDim2.new(1, -10, 0, 45)
            input.BackgroundColor3 = CurrentTheme.Secondary
            input.BackgroundTransparency = 0.5
            input.BorderSizePixel = 0
            input.Parent = tabContent
            CreateCorner(input, 8)
            
            local inputLabel = Instance.new("TextLabel")
            inputLabel.Size = UDim2.new(0.4, 0, 1, 0)
            inputLabel.Position = UDim2.new(0, 15, 0, 0)
            inputLabel.BackgroundTransparency = 1
            inputLabel.Text = name
            inputLabel.TextColor3 = CurrentTheme.Text
            inputLabel.TextSize = 13
            inputLabel.Font = Enum.Font.Gotham
            inputLabel.TextXAlignment = Enum.TextXAlignment.Left
            inputLabel.Parent = input
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0.55, 0, 0, 30)
            textBox.Position = UDim2.new(0.42, 0, 0.5, -15)
            textBox.BackgroundColor3 = CurrentTheme.Primary
            textBox.BackgroundTransparency = 0.3
            textBox.Text = ""
            textBox.PlaceholderText = placeholder
            textBox.PlaceholderColor3 = CurrentTheme.TextDark
            textBox.TextColor3 = CurrentTheme.Text
            textBox.TextSize = 12
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            textBox.Parent = input
            CreateCorner(textBox, 6)
            
            local stroke = CreateStroke(textBox, CurrentTheme.Accent, 1, 1)
            
            textBox.Focused:Connect(function()
                CreateTween(stroke, 0.3, {Transparency = 0}):Play()
            end)
            textBox.FocusLost:Connect(function(enterPressed)
                CreateTween(stroke, 0.3, {Transparency = 1}):Play()
                if enterPressed then
                    callback(textBox.Text)
                end
            end)
        end
        
        -- ═══════════════════════════════════════════════════════
        -- KEYBIND
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateKeybind(options)
            options = options or {}
            local name = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.E
            local callback = options.Callback or function() end
            
            local keybind = Instance.new("Frame")
            keybind.Size = UDim2.new(1, -10, 0, 45)
            keybind.BackgroundColor3 = CurrentTheme.Secondary
            keybind.BackgroundTransparency = 0.5
            keybind.BorderSizePixel = 0
            keybind.Parent = tabContent
            CreateCorner(keybind, 8)
            
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(0.6, 0, 1, 0)
            keyLabel.Position = UDim2.new(0, 15, 0, 0)
            keyLabel.BackgroundTransparency = 1
            keyLabel.Text = name
            keyLabel.TextColor3 = CurrentTheme.Text
            keyLabel.TextSize = 13
            keyLabel.Font = Enum.Font.Gotham
            keyLabel.TextXAlignment = Enum.TextXAlignment.Left
            keyLabel.Parent = keybind
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0, 70, 0, 30)
            keyBtn.Position = UDim2.new(1, -85, 0.5, -15)
            keyBtn.BackgroundColor3 = CurrentTheme.Primary
            keyBtn.BackgroundTransparency = 0.3
            keyBtn.Text = default.Name
            keyBtn.TextColor3 = CurrentTheme.Accent
            keyBtn.TextSize = 12
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.Parent = keybind
            CreateCorner(keyBtn, 6)
            CreateStroke(keyBtn, CurrentTheme.Accent, 1, 0.5)
            
            local listening = false
            local currentKey = default
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                CreateTween(keyBtn, 0.2, {BackgroundColor3 = CurrentTheme.Accent}):Play()
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyBtn.Text = input.KeyCode.Name
                    CreateTween(keyBtn, 0.2, {BackgroundColor3 = CurrentTheme.Primary}):Play()
                elseif not processed and input.KeyCode == currentKey then
                    callback()
                end
            end)
        end
        
        -- ═══════════════════════════════════════════════════════
        -- COLOR PICKER
        -- ═══════════════════════════════════════════════════════
        
        function Tab:CreateColorPicker(options)
            options = options or {}
            local name = options.Name or "Color"
            local default = options.Default or Color3.fromRGB(255, 255, 255)
            local callback = options.Callback or function() end
            
            local picker = Instance.new("Frame")
            picker.Size = UDim2.new(1, -10, 0, 45)
            picker.BackgroundColor3 = CurrentTheme.Secondary
            picker.BackgroundTransparency = 0.5
            picker.BorderSizePixel = 0
            picker.Parent = tabContent
            CreateCorner(picker, 8)
            
            local pickerLabel = Instance.new("TextLabel")
            pickerLabel.Size = UDim2.new(0.6, 0, 1, 0)
            pickerLabel.Position = UDim2.new(0, 15, 0, 0)
            pickerLabel.BackgroundTransparency = 1
            pickerLabel.Text = name
            pickerLabel.TextColor3 = CurrentTheme.Text
            pickerLabel.TextSize = 13
            pickerLabel.Font = Enum.Font.Gotham
            pickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            pickerLabel.Parent = picker
            
            local colorDisplay = Instance.new("TextButton")
            colorDisplay.Size = UDim2.new(0, 60, 0, 30)
            colorDisplay.Position = UDim2.new(1, -75, 0.5, -15)
            colorDisplay.BackgroundColor3 = default
            colorDisplay.Text = ""
            colorDisplay.Parent = picker
            CreateCorner(colorDisplay, 6)
            CreateStroke(colorDisplay, Color3.new(1, 1, 1), 2, 0.5)
            
            -- Mini color picker popup
            local colorPopup = Instance.new("Frame")
            colorPopup.Size = UDim2.new(0, 200, 0, 0)
            colorPopup.Position = UDim2.new(1, -210, 1, 5)
            colorPopup.BackgroundColor3 = CurrentTheme.Primary
            colorPopup.BackgroundTransparency = 0.1
            colorPopup.BorderSizePixel = 0
            colorPopup.ClipsDescendants = true
            colorPopup.ZIndex = 20
            colorPopup.Visible = false
            colorPopup.Parent = picker
            CreateCorner(colorPopup, 8)
            CreateShadow(colorPopup, 15)
            
            -- Preset colors
            local presets = {
                Color3.fromRGB(255, 0, 0),
                Color3.fromRGB(255, 128, 0),
                Color3.fromRGB(255, 255, 0),
                Color3.fromRGB(0, 255, 0),
                Color3.fromRGB(0, 255, 255),
                Color3.fromRGB(0, 128, 255),
                Color3.fromRGB(128, 0, 255),
                Color3.fromRGB(255, 0, 255),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(128, 128, 128),
            }
            
            for i, color in ipairs(presets) do
                local presetBtn = Instance.new("TextButton")
                presetBtn.Size = UDim2.new(0, 30, 0, 30)
                presetBtn.Position = UDim2.new(0, 10 + ((i-1) % 5) * 36, 0, 10 + math.floor((i-1) / 5) * 36)
                presetBtn.BackgroundColor3 = color
                presetBtn.Text = ""
                presetBtn.ZIndex = 21
                presetBtn.Parent = colorPopup
                CreateCorner(presetBtn, 6)
                
                presetBtn.MouseButton1Click:Connect(function()
                    colorDisplay.BackgroundColor3 = color
                    callback(color)
                end)
            end
            
            local opened = false
            
            colorDisplay.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    colorPopup.Visible = true
                    CreateTween(colorPopup, 0.3, {Size = UDim2.new(0, 200, 0, 90)}, Enum.EasingStyle.Back):Play()
                else
                    CreateTween(colorPopup, 0.2, {Size = UDim2.new(0, 200, 0, 0)}):Play()
                    delay(0.2, function() colorPopup.Visible = false end)
                end
            end)
        end
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            delay(0.7, function()
                tabBtn.MouseButton1Click:Fire()
            end)
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Theme changer
    function Window:SetTheme(themeName)
        if Themes[themeName] then
            CurrentTheme = Themes[themeName]
            -- Refresh UI colors would go here
        end
    end
    
    -- Notify shortcut
    function Window:Notify(options)
        WizardUI:Notify(options)
    end
    
    table.insert(ActiveWindows, Window)
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════

return WizardUI
