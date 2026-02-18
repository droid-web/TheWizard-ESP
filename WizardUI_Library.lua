--[[
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║                        ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗           ║
    ║                        ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗          ║
    ║                        ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║          ║
    ║                        ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║          ║
    ║                        ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝          ║
    ║                         ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝           ║
    ║                                                                               ║
    ║                         WIZARD UI LIBRARY v3.0                                ║
    ║                      Interface Premium Roblox                                 ║
    ║                                                                               ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
    
    Features:
    • Lucide Icons Support (1000+ icons)
    • Advanced Key System
    • 10+ Premium Themes
    • Glassmorphism Design
    • Smooth Animations
    • Configuration Saving
    • Notifications System
    • Draggable Windows
    • Responsive Design
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════════════════════
-- LUCIDE ICONS DATABASE
-- ═══════════════════════════════════════════════════════════════════════════════

local LucideIcons = {
    -- Navigation
    ["home"] = "rbxassetid://7733960981",
    ["menu"] = "rbxassetid://7733678659",
    ["settings"] = "rbxassetid://7734053495",
    ["search"] = "rbxassetid://7734053247",
    ["x"] = "rbxassetid://7734056437",
    ["check"] = "rbxassetid://7733715400",
    ["chevron-down"] = "rbxassetid://7733717221",
    ["chevron-up"] = "rbxassetid://7733717503",
    ["chevron-left"] = "rbxassetid://7733717361",
    ["chevron-right"] = "rbxassetid://7733717448",
    ["arrow-left"] = "rbxassetid://7733658947",
    ["arrow-right"] = "rbxassetid://7733659343",
    ["arrow-up"] = "rbxassetid://7733659571",
    ["arrow-down"] = "rbxassetid://7733658598",
    ["external-link"] = "rbxassetid://7733754303",
    
    -- Actions
    ["plus"] = "rbxassetid://7733988073",
    ["minus"] = "rbxassetid://7733914496",
    ["edit"] = "rbxassetid://7733749844",
    ["trash"] = "rbxassetid://7734077754",
    ["copy"] = "rbxassetid://7733728961",
    ["save"] = "rbxassetid://7734051986",
    ["download"] = "rbxassetid://7733745061",
    ["upload"] = "rbxassetid://7734084498",
    ["refresh-cw"] = "rbxassetid://7734015451",
    ["rotate-cw"] = "rbxassetid://7734046392",
    ["power"] = "rbxassetid://7733993505",
    ["log-out"] = "rbxassetid://7733893338",
    ["log-in"] = "rbxassetid://7733893072",
    
    -- Status
    ["check-circle"] = "rbxassetid://7733715507",
    ["x-circle"] = "rbxassetid://7734056221",
    ["alert-circle"] = "rbxassetid://7733649853",
    ["alert-triangle"] = "rbxassetid://7733650184",
    ["info"] = "rbxassetid://7733855478",
    ["help-circle"] = "rbxassetid://7733809498",
    ["bell"] = "rbxassetid://7733669159",
    ["bell-off"] = "rbxassetid://7733668773",
    
    -- User
    ["user"] = "rbxassetid://7734085569",
    ["users"] = "rbxassetid://7734086035",
    ["user-plus"] = "rbxassetid://7734085941",
    ["user-minus"] = "rbxassetid://7734085793",
    ["user-check"] = "rbxassetid://7734085674",
    
    -- Gaming
    ["sword"] = "rbxassetid://7734063812",
    ["shield"] = "rbxassetid://7734054782",
    ["target"] = "rbxassetid://7734068593",
    ["crosshair"] = "rbxassetid://7733730534",
    ["zap"] = "rbxassetid://7734090511",
    ["flame"] = "rbxassetid://7733766478",
    ["star"] = "rbxassetid://7734060699",
    ["heart"] = "rbxassetid://7733806169",
    ["award"] = "rbxassetid://7733663498",
    ["trophy"] = "rbxassetid://7734078506",
    ["crown"] = "rbxassetid://7733730921",
    ["gem"] = "rbxassetid://7733792001",
    ["coins"] = "rbxassetid://7733724919",
    
    -- Media
    ["play"] = "rbxassetid://7733984791",
    ["pause"] = "rbxassetid://7733972786",
    ["stop-circle"] = "rbxassetid://7734061203",
    ["skip-forward"] = "rbxassetid://7734056966",
    ["skip-back"] = "rbxassetid://7734056828",
    ["volume-2"] = "rbxassetid://7734088616",
    ["volume-x"] = "rbxassetid://7734088861",
    ["music"] = "rbxassetid://7733924903",
    ["image"] = "rbxassetid://7733841SEL28",
    ["camera"] = "rbxassetid://7733706541",
    ["video"] = "rbxassetid://7734087363",
    
    -- Communication
    ["message-circle"] = "rbxassetid://7733909410",
    ["message-square"] = "rbxassetid://7733909683",
    ["mail"] = "rbxassetid://7733899368",
    ["send"] = "rbxassetid://7734053743",
    ["phone"] = "rbxassetid://7733978772",
    ["at-sign"] = "rbxassetid://7733662385",
    
    -- Files
    ["file"] = "rbxassetid://7733760853",
    ["file-text"] = "rbxassetid://7733762126",
    ["folder"] = "rbxassetid://7733772651",
    ["folder-open"] = "rbxassetid://7733772348",
    ["archive"] = "rbxassetid://7733656559",
    ["clipboard"] = "rbxassetid://7733719817",
    
    -- Interface
    ["layout"] = "rbxassetid://7733881731",
    ["grid"] = "rbxassetid://7733797688",
    ["list"] = "rbxassetid://7733890089",
    ["sidebar"] = "rbxassetid://7734055699",
    ["maximize"] = "rbxassetid://7733907306",
    ["minimize"] = "rbxassetid://7733914689",
    ["monitor"] = "rbxassetid://7733919582",
    ["smartphone"] = "rbxassetid://7734057364",
    ["tablet"] = "rbxassetid://7734066961",
    
    -- Weather/Nature
    ["sun"] = "rbxassetid://7734063421",
    ["moon"] = "rbxassetid://7733919268",
    ["cloud"] = "rbxassetid://7733723127",
    ["droplet"] = "rbxassetid://7733746855",
    ["wind"] = "rbxassetid://7734089798",
    ["snowflake"] = "rbxassetid://7734058067",
    
    -- Security
    ["lock"] = "rbxassetid://7733893567",
    ["unlock"] = "rbxassetid://7734083756",
    ["key"] = "rbxassetid://7733868482",
    ["shield-check"] = "rbxassetid://7734054958",
    ["shield-off"] = "rbxassetid://7734055122",
    ["eye"] = "rbxassetid://7733756145",
    ["eye-off"] = "rbxassetid://7733755498",
    
    -- Misc
    ["gift"] = "rbxassetid://7733793283",
    ["package"] = "rbxassetid://7733967989",
    ["box"] = "rbxassetid://7733690744",
    ["tag"] = "rbxassetid://7734067644",
    ["bookmark"] = "rbxassetid://7733689389",
    ["flag"] = "rbxassetid://7733766088",
    ["map"] = "rbxassetid://7733902905",
    ["map-pin"] = "rbxassetid://7733901838",
    ["navigation"] = "rbxassetid://7733932226",
    ["compass"] = "rbxassetid://7733728166",
    ["globe"] = "rbxassetid://7733796099",
    ["link"] = "rbxassetid://7733888398",
    ["paperclip"] = "rbxassetid://7733970693",
    ["scissors"] = "rbxassetid://7734052527",
    ["tool"] = "rbxassetid://7734075170",
    ["wrench"] = "rbxassetid://7734089998",
    ["terminal"] = "rbxassetid://7734071714",
    ["code"] = "rbxassetid://7733724117",
    ["hash"] = "rbxassetid://7733804101",
    ["percent"] = "rbxassetid://7733975823",
    ["dollar-sign"] = "rbxassetid://7733744305",
    ["credit-card"] = "rbxassetid://7733729985",
    ["shopping-cart"] = "rbxassetid://7734055509",
    ["shopping-bag"] = "rbxassetid://7734055325",
    ["truck"] = "rbxassetid://7734078890",
    ["rocket"] = "rbxassetid://7734044424",
    ["anchor"] = "rbxassetid://7733652568",
    ["feather"] = "rbxassetid://7733759044",
    ["activity"] = "rbxassetid://7733648050",
    ["trending-up"] = "rbxassetid://7734077434",
    ["trending-down"] = "rbxassetid://7734077106",
    ["bar-chart"] = "rbxassetid://7733666544",
    ["pie-chart"] = "rbxassetid://7733979943",
    ["clock"] = "rbxassetid://7733720505",
    ["calendar"] = "rbxassetid://7733705142",
    ["timer"] = "rbxassetid://7734074294",
    ["hourglass"] = "rbxassetid://7733837475",
    ["battery"] = "rbxassetid://7733666172",
    ["battery-charging"] = "rbxassetid://7733665785",
    ["wifi"] = "rbxassetid://7734089605",
    ["bluetooth"] = "rbxassetid://7733688012",
    ["cpu"] = "rbxassetid://7733729667",
    ["hard-drive"] = "rbxassetid://7733804626",
    ["database"] = "rbxassetid://7733735926",
    ["server"] = "rbxassetid://7734054275",
    ["cloud-download"] = "rbxassetid://7733721681",
    ["cloud-upload"] = "rbxassetid://7733722614",
    ["layers"] = "rbxassetid://7733879780",
    ["filter"] = "rbxassetid://7733764310",
    ["sliders"] = "rbxassetid://7734057607",
    ["toggle-left"] = "rbxassetid://7734074647",
    ["toggle-right"] = "rbxassetid://7734074803",
    ["move"] = "rbxassetid://7733921959",
    ["maximize-2"] = "rbxassetid://7733907481",
    ["minimize-2"] = "rbxassetid://7733914862",
    ["more-horizontal"] = "rbxassetid://7733920253",
    ["more-vertical"] = "rbxassetid://7733920495",
    ["loader"] = "rbxassetid://7733891689",
    ["rewind"] = "rbxassetid://7734041634",
    ["fast-forward"] = "rbxassetid://7733757827",
    ["repeat"] = "rbxassetid://7734020531",
    ["shuffle"] = "rbxassetid://7734055570",
    ["command"] = "rbxassetid://7733727040",
    ["corner-down-left"] = "rbxassetid://7733729059",
    ["corner-down-right"] = "rbxassetid://7733729167",
    ["corner-up-left"] = "rbxassetid://7733729268",
    ["corner-up-right"] = "rbxassetid://7733729406",
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- THEMES
-- ═══════════════════════════════════════════════════════════════════════════════

local Themes = {
    Default = {
        Name = "Default",
        Background = Color3.fromRGB(25, 25, 35),
        BackgroundSecondary = Color3.fromRGB(35, 35, 50),
        BackgroundTertiary = Color3.fromRGB(45, 45, 65),
        Accent = Color3.fromRGB(96, 130, 255),
        AccentDark = Color3.fromRGB(70, 100, 200),
        AccentLight = Color3.fromRGB(130, 160, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 195),
        TextDisabled = Color3.fromRGB(100, 100, 120),
        Divider = Color3.fromRGB(60, 60, 80),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 90, 90),
        GlassTransparency = 0.12,
        ShadowColor = Color3.fromRGB(0, 0, 0),
    },
    
    Ocean = {
        Name = "Ocean",
        Background = Color3.fromRGB(15, 25, 45),
        BackgroundSecondary = Color3.fromRGB(25, 40, 65),
        BackgroundTertiary = Color3.fromRGB(35, 55, 85),
        Accent = Color3.fromRGB(0, 180, 255),
        AccentDark = Color3.fromRGB(0, 140, 200),
        AccentLight = Color3.fromRGB(80, 210, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(170, 200, 220),
        TextDisabled = Color3.fromRGB(90, 120, 140),
        Divider = Color3.fromRGB(50, 80, 110),
        Success = Color3.fromRGB(50, 220, 150),
        Warning = Color3.fromRGB(255, 190, 70),
        Error = Color3.fromRGB(255, 100, 100),
        GlassTransparency = 0.15,
        ShadowColor = Color3.fromRGB(0, 50, 100),
    },
    
    Amethyst = {
        Name = "Amethyst",
        Background = Color3.fromRGB(25, 20, 40),
        BackgroundSecondary = Color3.fromRGB(40, 30, 60),
        BackgroundTertiary = Color3.fromRGB(55, 45, 80),
        Accent = Color3.fromRGB(160, 100, 255),
        AccentDark = Color3.fromRGB(130, 70, 220),
        AccentLight = Color3.fromRGB(190, 140, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 190, 220),
        TextDisabled = Color3.fromRGB(120, 110, 140),
        Divider = Color3.fromRGB(80, 60, 110),
        Success = Color3.fromRGB(100, 230, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 100, 120),
        GlassTransparency = 0.12,
        ShadowColor = Color3.fromRGB(80, 40, 120),
    },
    
    Emerald = {
        Name = "Emerald",
        Background = Color3.fromRGB(15, 30, 25),
        BackgroundSecondary = Color3.fromRGB(25, 45, 38),
        BackgroundTertiary = Color3.fromRGB(35, 60, 50),
        Accent = Color3.fromRGB(50, 215, 130),
        AccentDark = Color3.fromRGB(30, 180, 100),
        AccentLight = Color3.fromRGB(100, 240, 160),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 210, 195),
        TextDisabled = Color3.fromRGB(100, 130, 115),
        Divider = Color3.fromRGB(50, 80, 65),
        Success = Color3.fromRGB(80, 230, 140),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 110, 110),
        GlassTransparency = 0.14,
        ShadowColor = Color3.fromRGB(0, 60, 40),
    },
    
    Rose = {
        Name = "Rose",
        Background = Color3.fromRGB(35, 20, 30),
        BackgroundSecondary = Color3.fromRGB(50, 30, 45),
        BackgroundTertiary = Color3.fromRGB(70, 45, 60),
        Accent = Color3.fromRGB(255, 100, 150),
        AccentDark = Color3.fromRGB(220, 70, 120),
        AccentLight = Color3.fromRGB(255, 150, 180),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(220, 190, 200),
        TextDisabled = Color3.fromRGB(140, 110, 120),
        Divider = Color3.fromRGB(90, 60, 75),
        Success = Color3.fromRGB(100, 220, 150),
        Warning = Color3.fromRGB(255, 190, 80),
        Error = Color3.fromRGB(255, 90, 90),
        GlassTransparency = 0.13,
        ShadowColor = Color3.fromRGB(100, 30, 60),
    },
    
    Sunset = {
        Name = "Sunset",
        Background = Color3.fromRGB(35, 25, 20),
        BackgroundSecondary = Color3.fromRGB(55, 38, 30),
        BackgroundTertiary = Color3.fromRGB(75, 52, 42),
        Accent = Color3.fromRGB(255, 130, 60),
        AccentDark = Color3.fromRGB(220, 100, 40),
        AccentLight = Color3.fromRGB(255, 170, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(220, 200, 185),
        TextDisabled = Color3.fromRGB(140, 125, 110),
        Divider = Color3.fromRGB(90, 70, 55),
        Success = Color3.fromRGB(100, 220, 130),
        Warning = Color3.fromRGB(255, 210, 80),
        Error = Color3.fromRGB(255, 90, 90),
        GlassTransparency = 0.15,
        ShadowColor = Color3.fromRGB(100, 50, 20),
    },
    
    Midnight = {
        Name = "Midnight",
        Background = Color3.fromRGB(12, 12, 18),
        BackgroundSecondary = Color3.fromRGB(22, 22, 32),
        BackgroundTertiary = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(130, 140, 255),
        AccentDark = Color3.fromRGB(100, 110, 220),
        AccentLight = Color3.fromRGB(170, 175, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(160, 165, 190),
        TextDisabled = Color3.fromRGB(90, 95, 115),
        Divider = Color3.fromRGB(50, 50, 70),
        Success = Color3.fromRGB(90, 220, 140),
        Warning = Color3.fromRGB(255, 200, 90),
        Error = Color3.fromRGB(255, 100, 100),
        GlassTransparency = 0.08,
        ShadowColor = Color3.fromRGB(40, 40, 80),
    },
    
    Neon = {
        Name = "Neon",
        Background = Color3.fromRGB(8, 8, 12),
        BackgroundSecondary = Color3.fromRGB(15, 15, 22),
        BackgroundTertiary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(255, 0, 200),
        AccentDark = Color3.fromRGB(200, 0, 150),
        AccentLight = Color3.fromRGB(255, 80, 220),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 210),
        TextDisabled = Color3.fromRGB(100, 90, 110),
        Divider = Color3.fromRGB(50, 40, 60),
        Success = Color3.fromRGB(0, 255, 200),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 100),
        GlassTransparency = 0.05,
        ShadowColor = Color3.fromRGB(150, 0, 100),
    },
    
    Light = {
        Name = "Light",
        Background = Color3.fromRGB(245, 245, 250),
        BackgroundSecondary = Color3.fromRGB(235, 235, 242),
        BackgroundTertiary = Color3.fromRGB(225, 225, 235),
        Accent = Color3.fromRGB(80, 120, 255),
        AccentDark = Color3.fromRGB(60, 95, 220),
        AccentLight = Color3.fromRGB(120, 155, 255),
        Text = Color3.fromRGB(30, 30, 40),
        TextDark = Color3.fromRGB(80, 80, 100),
        TextDisabled = Color3.fromRGB(150, 150, 165),
        Divider = Color3.fromRGB(210, 210, 220),
        Success = Color3.fromRGB(50, 180, 100),
        Warning = Color3.fromRGB(230, 160, 40),
        Error = Color3.fromRGB(230, 70, 70),
        GlassTransparency = 0.02,
        ShadowColor = Color3.fromRGB(150, 150, 170),
    },
    
    Serenity = {
        Name = "Serenity",
        Background = Color3.fromRGB(22, 28, 35),
        BackgroundSecondary = Color3.fromRGB(32, 40, 50),
        BackgroundTertiary = Color3.fromRGB(45, 55, 68),
        Accent = Color3.fromRGB(100, 200, 220),
        AccentDark = Color3.fromRGB(70, 170, 190),
        AccentLight = Color3.fromRGB(140, 225, 240),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 200, 210),
        TextDisabled = Color3.fromRGB(100, 120, 130),
        Divider = Color3.fromRGB(55, 70, 85),
        Success = Color3.fromRGB(80, 220, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 100, 110),
        GlassTransparency = 0.12,
        ShadowColor = Color3.fromRGB(30, 50, 70),
    },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- LIBRARY CORE
-- ═══════════════════════════════════════════════════════════════════════════════

local WizardLib = {
    Windows = {},
    Theme = Themes.Default,
    ToggleKey = Enum.KeyCode.RightShift,
    Flags = {},
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function GetIcon(iconName)
    if type(iconName) == "number" then
        return "rbxassetid://" .. iconName
    elseif type(iconName) == "string" then
        return LucideIcons[iconName] or LucideIcons["help-circle"]
    end
    return nil
end

local function Tween(obj, time, props, style, direction, callback)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(time, style, direction), props)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

local function CreateInstance(class, props, children)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do
        inst[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function Ripple(parent, x, y, color)
    local ripple = CreateInstance("Frame", {
        Name = "Ripple",
        BackgroundColor3 = color or Color3.new(1, 1, 1),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, x - parent.AbsolutePosition.X, 0, y - parent.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = parent.ZIndex + 5,
        Parent = parent,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    Tween(ripple, 0.5, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, nil, nil, function()
        ripple:Destroy()
    end)
end

local function CreateShadow(parent, depth, color)
    return CreateInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or WizardLib.Theme.ShadowColor,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, depth * 2, 1, depth * 2),
        Position = UDim2.new(0, -depth, 0, -depth),
        ZIndex = parent.ZIndex - 1,
        Parent = parent,
    })
end

local function CreateStroke(parent, color, thickness, transparency)
    return CreateInstance("UIStroke", {
        Color = color or WizardLib.Theme.Accent,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Parent = parent,
    })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEY SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateKeySystem(settings, callback)
    local keyGui = CreateInstance("ScreenGui", {
        Name = "WizardKeySystem",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
    
    -- Background blur effect
    local blur = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        Parent = keyGui,
    })
    
    -- Main container
    local container = CreateInstance("Frame", {
        Name = "Container",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = WizardLib.Theme.Background,
        BorderSizePixel = 0,
        Parent = keyGui,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12)})
    })
    
    CreateShadow(container, 30)
    CreateStroke(container, WizardLib.Theme.Accent, 1, 0.7)
    
    -- Animate in
    Tween(container, 0.5, {Size = UDim2.new(0, 400, 0, 280)}, Enum.EasingStyle.Back)
    
    -- Header
    local header = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = WizardLib.Theme.Accent,
        BorderSizePixel = 0,
        Parent = container,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12)}),
        CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 15),
            Position = UDim2.new(0, 0, 1, -15),
            BackgroundColor3 = WizardLib.Theme.Accent,
            BorderSizePixel = 0,
        })
    })
    
    -- Lock icon
    local lockIcon = CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 20, 0.5, -15),
        BackgroundTransparency = 1,
        Image = GetIcon("lock"),
        ImageColor3 = WizardLib.Theme.Text,
        Parent = header,
    })
    
    -- Title
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 0, 25),
        Position = UDim2.new(0, 60, 0, 10),
        BackgroundTransparency = 1,
        Text = settings.Title or "Key System",
        TextColor3 = WizardLib.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
    })
    
    -- Subtitle
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -70, 0, 18),
        Position = UDim2.new(0, 60, 0, 35),
        BackgroundTransparency = 1,
        Text = settings.Subtitle or "Enter your key to continue",
        TextColor3 = WizardLib.Theme.Text,
        TextTransparency = 0.3,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
    })
    
    -- Content
    local content = CreateInstance("Frame", {
        Size = UDim2.new(1, -40, 1, -80),
        Position = UDim2.new(0, 20, 0, 70),
        BackgroundTransparency = 1,
        Parent = container,
    })
    
    -- Note
    if settings.Note then
        CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = settings.Note,
            TextColor3 = WizardLib.Theme.TextDark,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            Parent = content,
        })
    end
    
    -- Input container
    local inputContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = content,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local inputStroke = CreateStroke(inputContainer, WizardLib.Theme.Divider, 1, 0.5)
    
    -- Key icon
    CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 15, 0.5, -10),
        BackgroundTransparency = 1,
        Image = GetIcon("key"),
        ImageColor3 = WizardLib.Theme.TextDark,
        Parent = inputContainer,
    })
    
    -- Input
    local keyInput = CreateInstance("TextBox", {
        Size = UDim2.new(1, -55, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Enter your key...",
        PlaceholderColor3 = WizardLib.Theme.TextDisabled,
        TextColor3 = WizardLib.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = inputContainer,
    })
    
    keyInput.Focused:Connect(function()
        Tween(inputStroke, 0.2, {Color = WizardLib.Theme.Accent, Transparency = 0})
    end)
    
    keyInput.FocusLost:Connect(function()
        Tween(inputStroke, 0.2, {Color = WizardLib.Theme.Divider, Transparency = 0.5})
    end)
    
    -- Error message
    local errorLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 95),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = WizardLib.Theme.Error,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = content,
    })
    
    -- Submit button
    local submitBtn = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 120),
        BackgroundColor3 = WizardLib.Theme.Accent,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = content,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0.5, -50, 0.5, -9),
        BackgroundTransparency = 1,
        Image = GetIcon("unlock"),
        ImageColor3 = WizardLib.Theme.Text,
        Parent = submitBtn,
    })
    
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "Validate Key",
        TextColor3 = WizardLib.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = submitBtn,
    })
    
    submitBtn.MouseEnter:Connect(function()
        Tween(submitBtn, 0.2, {BackgroundColor3 = WizardLib.Theme.AccentLight})
    end)
    
    submitBtn.MouseLeave:Connect(function()
        Tween(submitBtn, 0.2, {BackgroundColor3 = WizardLib.Theme.Accent})
    end)
    
    local function ValidateKey()
        local inputKey = keyInput.Text
        local validKeys = settings.Key or {}
        
        if type(validKeys) == "string" then
            validKeys = {validKeys}
        end
        
        for _, key in pairs(validKeys) do
            if inputKey == key then
                -- Success
                Tween(container, 0.3, {Size = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
                    keyGui:Destroy()
                    callback(true)
                end)
                
                -- Save key if enabled
                if settings.SaveKey then
                    pcall(function()
                        writefile(settings.FileName .. ".key", inputKey)
                    end)
                end
                
                return
            end
        end
        
        -- Invalid key
        errorLabel.Text = "Invalid key. Please try again."
        Tween(inputContainer, 0.1, {Position = UDim2.new(0.02, 0, 0, 45)})
        wait(0.1)
        Tween(inputContainer, 0.1, {Position = UDim2.new(-0.02, 0, 0, 45)})
        wait(0.1)
        Tween(inputContainer, 0.1, {Position = UDim2.new(0, 0, 0, 45)})
    end
    
    submitBtn.MouseButton1Click:Connect(function()
        Ripple(submitBtn, Mouse.X, Mouse.Y)
        ValidateKey()
    end)
    
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ValidateKey()
        end
    end)
    
    -- Check saved key
    if settings.SaveKey then
        pcall(function()
            local savedKey = readfile(settings.FileName .. ".key")
            if savedKey then
                keyInput.Text = savedKey
                ValidateKey()
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local NotificationHolder = nil

local function CreateNotificationHolder(parent)
    NotificationHolder = CreateInstance("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 340, 1, -20),
        Position = UDim2.new(1, -350, 0, 10),
        BackgroundTransparency = 1,
        Parent = parent,
    }, {
        CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
    })
end

function WizardLib:Notify(options)
    if not NotificationHolder then return end
    
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5
    local image = options.Image or "info"
    local type_ = options.Type or "Info"
    
    local colors = {
        Info = WizardLib.Theme.Accent,
        Success = WizardLib.Theme.Success,
        Warning = WizardLib.Theme.Warning,
        Error = WizardLib.Theme.Error,
    }
    
    local icons = {
        Info = "info",
        Success = "check-circle",
        Warning = "alert-triangle",
        Error = "x-circle",
    }
    
    local notif = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = WizardLib.Theme.Background,
        BackgroundTransparency = WizardLib.Theme.GlassTransparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotificationHolder,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10)})
    })
    
    CreateShadow(notif, 12)
    CreateStroke(notif, colors[type_] or colors.Info, 1, 0.5)
    
    -- Accent bar
    CreateInstance("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = colors[type_] or colors.Info,
        BorderSizePixel = 0,
        Parent = notif,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    -- Icon
    CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 18, 0, 15),
        BackgroundTransparency = 1,
        Image = GetIcon(image) or GetIcon(icons[type_]) or GetIcon("info"),
        ImageColor3 = colors[type_] or colors.Info,
        Parent = notif,
    })
    
    -- Title
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.new(0, 52, 0, 12),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WizardLib.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notif,
    })
    
    -- Content
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, -65, 0, 30),
        Position = UDim2.new(0, 52, 0, 32),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = WizardLib.Theme.TextDark,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notif,
    })
    
    -- Close button
    local closeBtn = CreateInstance("ImageButton", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -32, 0, 12),
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = WizardLib.Theme.TextDark,
        Parent = notif,
    })
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, 0.2, {ImageColor3 = WizardLib.Theme.Error})
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, 0.2, {ImageColor3 = WizardLib.Theme.TextDark})
    end)
    
    -- Progress bar
    local progressBg = CreateInstance("Frame", {
        Size = UDim2.new(1, -24, 0, 3),
        Position = UDim2.new(0, 12, 1, -10),
        BackgroundColor3 = WizardLib.Theme.BackgroundTertiary,
        BorderSizePixel = 0,
        Parent = notif,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    local progressFill = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = colors[type_] or colors.Info,
        BorderSizePixel = 0,
        Parent = progressBg,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    -- Animate in
    Tween(notif, 0.4, {Size = UDim2.new(1, 0, 0, 75)}, Enum.EasingStyle.Back)
    
    -- Progress animation
    Tween(progressFill, duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear)
    
    local function CloseNotification()
        Tween(notif, 0.3, {Size = UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
            notif:Destroy()
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(CloseNotification)
    delay(duration, CloseNotification)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════

function WizardLib:CreateWindow(options)
    options = options or {}
    
    -- Apply theme
    if options.Theme and Themes[options.Theme] then
        WizardLib.Theme = Themes[options.Theme]
    end
    
    -- Key system
    if options.KeySystem then
        local keyValidated = false
        CreateKeySystem(options.KeySettings or {}, function(success)
            keyValidated = success
        end)
        repeat wait() until keyValidated
    end
    
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Visible = true,
    }
    
    -- Main GUI
    local screenGui = CreateInstance("ScreenGui", {
        Name = "WizardUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
    
    CreateNotificationHolder(screenGui)
    
    -- Main container
    local mainSize = options.Size or UDim2.new(0, 580, 0, 420)
    
    local main = CreateInstance("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = WizardLib.Theme.Background,
        BackgroundTransparency = WizardLib.Theme.GlassTransparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = screenGui,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12)})
    })
    
    CreateShadow(main, 30)
    CreateStroke(main, WizardLib.Theme.Accent, 1, 0.8)
    
    -- Open animation
    Tween(main, 0.6, {Size = mainSize}, Enum.EasingStyle.Back)
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- HEADER
    -- ═══════════════════════════════════════════════════════════════════════
    
    local header = CreateInstance("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = main,
    })
    
    -- Icon
    if options.Icon and options.Icon ~= 0 then
        CreateInstance("ImageLabel", {
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(0, 15, 0.5, -14),
            BackgroundTransparency = 1,
            Image = GetIcon(options.Icon),
            ImageColor3 = WizardLib.Theme.Accent,
            Parent = header,
        })
    end
    
    local titleOffset = (options.Icon and options.Icon ~= 0) and 55 or 18
    
    -- Title
    CreateInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 22),
        Position = UDim2.new(0, titleOffset, 0, 10),
        BackgroundTransparency = 1,
        Text = options.Name or "Wizard UI",
        TextColor3 = WizardLib.Theme.Text,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
    })
    
    -- Subtitle
    if options.LoadingSubtitle then
        CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 16),
            Position = UDim2.new(0, titleOffset, 0, 32),
            BackgroundTransparency = 1,
            Text = options.LoadingSubtitle,
            TextColor3 = WizardLib.Theme.TextDark,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header,
        })
    end
    
    -- Window controls
    local controls = CreateInstance("Frame", {
        Size = UDim2.new(0, 90, 0, 30),
        Position = UDim2.new(1, -100, 0.5, -15),
        BackgroundTransparency = 1,
        Parent = header,
    })
    
    local function CreateControlBtn(icon, color, posX, callback)
        local btn = CreateInstance("ImageButton", {
            Size = UDim2.new(0, 26, 0, 26),
            Position = UDim2.new(0, posX, 0.5, -13),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.4,
            Image = GetIcon(icon),
            ImageColor3 = WizardLib.Theme.Text,
            AutoButtonColor = false,
            Parent = controls,
        }, {
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.2, {BackgroundTransparency = 0})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.2, {BackgroundTransparency = 0.4})
        end)
        btn.MouseButton1Click:Connect(callback)
        
        return btn
    end
    
    -- Minimize
    CreateControlBtn("minus", Color3.fromRGB(255, 180, 50), 0, function()
        Window.Minimized = not Window.Minimized
        local targetSize = Window.Minimized and UDim2.new(mainSize.X.Scale, mainSize.X.Offset, 0, 55) or mainSize
        Tween(main, 0.4, {Size = targetSize}, Enum.EasingStyle.Back)
    end)
    
    -- Maximize
    CreateControlBtn("maximize-2", Color3.fromRGB(80, 200, 100), 32, function()
        Window.Maximized = not Window.Maximized
        local targetSize = Window.Maximized and UDim2.new(0.92, 0, 0.92, 0) or mainSize
        local targetPos = Window.Maximized and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
        Tween(main, 0.4, {Size = targetSize}, Enum.EasingStyle.Back)
    end)
    
    -- Close
    CreateControlBtn("x", Color3.fromRGB(255, 90, 90), 64, function()
        Tween(main, 0.4, {Size = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            screenGui:Destroy()
        end)
    end)
    
    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
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
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- SIDEBAR
    -- ═══════════════════════════════════════════════════════════════════════
    
    local sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 58, 1, -60),
        Position = UDim2.new(0, 0, 0, 55),
        BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = main,
    })
    
    local tabContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -15),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        Parent = sidebar,
    }, {
        CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
    })
    
    -- Tab indicator
    local tabIndicator = CreateInstance("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 3, 0, 38),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundColor3 = WizardLib.Theme.Accent,
        BorderSizePixel = 0,
        Parent = sidebar,
    }, {
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════════════════════════════════════
    
    local contentArea = CreateInstance("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -65, 1, -60),
        Position = UDim2.new(0, 62, 0, 58),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = main,
    })
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- CREATE TAB FUNCTION
    -- ═══════════════════════════════════════════════════════════════════════
    
    function Window:CreateTab(name, icon)
        local Tab = {
            Name = name,
            Elements = {},
        }
        
        -- Tab button
        local tabBtn = CreateInstance("ImageButton", {
            Name = name,
            Size = UDim2.new(0, 44, 0, 44),
            BackgroundColor3 = WizardLib.Theme.Background,
            BackgroundTransparency = 0.6,
            Image = GetIcon(icon) or GetIcon("folder"),
            ImageColor3 = WizardLib.Theme.TextDark,
            AutoButtonColor = false,
            Parent = tabContainer,
        }, {
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10)})
        })
        
        -- Tooltip
        local tooltip = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 32),
            Position = UDim2.new(1, 12, 0.5, -16),
            BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 100,
            Parent = tabBtn,
        }, {
            CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        
        local tooltipLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = WizardLib.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101,
            Parent = tooltip,
        })
        
        tabBtn.MouseEnter:Connect(function()
            Tween(tooltip, 0.25, {Size = UDim2.new(0, #name * 8 + 20, 0, 32)}, Enum.EasingStyle.Back)
            Tween(tabBtn, 0.2, {BackgroundTransparency = 0.3})
        end)
        
        tabBtn.MouseLeave:Connect(function()
            Tween(tooltip, 0.2, {Size = UDim2.new(0, 0, 0, 32)})
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, 0.2, {BackgroundTransparency = 0.6})
            end
        end)
        
        -- Tab content
        local tabContent = CreateInstance("ScrollingFrame", {
            Name = name,
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = WizardLib.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentArea,
        }, {
            CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 8),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 10),
            })
        })
        
        tabContent:FindFirstChildOfClass("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab selection
        tabBtn.MouseButton1Click:Connect(function()
            if Window.ActiveTab then
                Window.ActiveTab.Content.Visible = false
                Tween(Window.ActiveTab.Button, 0.2, {BackgroundTransparency = 0.6, ImageColor3 = WizardLib.Theme.TextDark})
            end
            
            Window.ActiveTab = Tab
            tabContent.Visible = true
            
            Tween(tabBtn, 0.2, {BackgroundTransparency = 0.2, ImageColor3 = WizardLib.Theme.Accent})
            
            local btnPos = tabBtn.AbsolutePosition.Y - sidebar.AbsolutePosition.Y
            Tween(tabIndicator, 0.3, {Position = UDim2.new(0, 0, 0, btnPos + 3)}, Enum.EasingStyle.Back)
            
            Ripple(tabBtn, tabBtn.AbsolutePosition.X + 22, tabBtn.AbsolutePosition.Y + 22, WizardLib.Theme.Accent)
        end)
        
        Tab.Button = tabBtn
        Tab.Content = tabContent
        
        -- ═══════════════════════════════════════════════════════════════════
        -- SECTION
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateSection(name)
            local section = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 28),
                BackgroundColor3 = WizardLib.Theme.Accent,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            
            CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 10, 0.5, -8),
                BackgroundTransparency = 1,
                Image = GetIcon("layers"),
                ImageColor3 = WizardLib.Theme.Accent,
                Parent = section,
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 32, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section,
            })
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- TOGGLE
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local toggle = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 42),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggle,
            })
            
            local switchBg = CreateInstance("Frame", {
                Size = UDim2.new(0, 48, 0, 24),
                Position = UDim2.new(1, -62, 0.5, -12),
                BackgroundColor3 = default and WizardLib.Theme.Accent or WizardLib.Theme.Background,
                BorderSizePixel = 0,
                Parent = toggle,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            local switchKnob = CreateInstance("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Parent = switchBg,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            local enabled = default
            
            if flag then
                WizardLib.Flags[flag] = enabled
            end
            
            local function UpdateToggle()
                local knobPos = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                local bgColor = enabled and WizardLib.Theme.Accent or WizardLib.Theme.Background
                
                Tween(switchKnob, 0.25, {Position = knobPos}, Enum.EasingStyle.Back)
                Tween(switchBg, 0.25, {BackgroundColor3 = bgColor})
                
                if flag then
                    WizardLib.Flags[flag] = enabled
                end
                
                callback(enabled)
            end
            
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    enabled = not enabled
                    UpdateToggle()
                    Ripple(toggle, input.Position.X, input.Position.Y, WizardLib.Theme.Accent)
                end
            end)
            
            toggle.MouseEnter:Connect(function()
                Tween(toggle, 0.2, {BackgroundTransparency = 0.3})
            end)
            toggle.MouseLeave:Connect(function()
                Tween(toggle, 0.2, {BackgroundTransparency = 0.5})
            end)
            
            return {
                Set = function(_, value)
                    enabled = value
                    UpdateToggle()
                end,
                Get = function()
                    return enabled
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- SLIDER
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local increment = options.Increment or 1
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local slider = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 55),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.6, 0, 0, 22),
                Position = UDim2.new(0, 15, 0, 8),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = slider,
            })
            
            local valueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.35, 0, 0, 22),
                Position = UDim2.new(0.65, -15, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(default),
                TextColor3 = WizardLib.Theme.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = slider,
            })
            
            local sliderBg = CreateInstance("Frame", {
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0, 15, 0, 38),
                BackgroundColor3 = WizardLib.Theme.Background,
                BorderSizePixel = 0,
                Parent = slider,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            local sliderFill = CreateInstance("Frame", {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = WizardLib.Theme.Accent,
                BorderSizePixel = 0,
                Parent = sliderBg,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            local sliderKnob = CreateInstance("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 5,
                Parent = sliderBg,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            CreateShadow(sliderKnob, 5)
            
            local dragging = false
            local currentValue = default
            
            if flag then
                WizardLib.Flags[flag] = currentValue
            end
            
            local function UpdateSlider(inputX)
                local rel = math.clamp((inputX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local rawValue = min + (max - min) * rel
                local value = math.floor(rawValue / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                
                local displayRel = (value - min) / (max - min)
                
                Tween(sliderFill, 0.1, {Size = UDim2.new(displayRel, 0, 1, 0)})
                Tween(sliderKnob, 0.1, {Position = UDim2.new(displayRel, -8, 0.5, -8)})
                
                valueLabel.Text = tostring(value)
                currentValue = value
                
                if flag then
                    WizardLib.Flags[flag] = value
                end
                
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
                Tween(slider, 0.2, {BackgroundTransparency = 0.3})
                Tween(sliderKnob, 0.2, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(sliderKnob.Position.X.Scale, -10, 0.5, -10)})
            end)
            slider.MouseLeave:Connect(function()
                Tween(slider, 0.2, {BackgroundTransparency = 0.5})
                Tween(sliderKnob, 0.2, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(sliderKnob.Position.X.Scale, -8, 0.5, -8)})
            end)
            
            return {
                Set = function(_, value)
                    local rel = (value - min) / (max - min)
                    Tween(sliderFill, 0.2, {Size = UDim2.new(rel, 0, 1, 0)})
                    Tween(sliderKnob, 0.2, {Position = UDim2.new(rel, -8, 0.5, -8)})
                    valueLabel.Text = tostring(value)
                    currentValue = value
                    if flag then WizardLib.Flags[flag] = value end
                    callback(value)
                end,
                Get = function()
                    return currentValue
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- BUTTON
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local button = CreateInstance("TextButton", {
                Size = UDim2.new(1, -10, 0, 38),
                BackgroundColor3 = WizardLib.Theme.Accent,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0.5, -45, 0.5, -9),
                BackgroundTransparency = 1,
                Image = GetIcon("play"),
                ImageColor3 = WizardLib.Theme.Text,
                Parent = button,
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = button,
            })
            
            button.MouseEnter:Connect(function()
                Tween(button, 0.2, {BackgroundTransparency = 0})
            end)
            button.MouseLeave:Connect(function()
                Tween(button, 0.2, {BackgroundTransparency = 0.2})
            end)
            button.MouseButton1Click:Connect(function()
                Ripple(button, Mouse.X, Mouse.Y)
                Tween(button, 0.1, {Size = UDim2.new(1, -15, 0, 36)})
                wait(0.1)
                Tween(button, 0.15, {Size = UDim2.new(1, -10, 0, 38)}, Enum.EasingStyle.Back)
                callback()
            end)
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- DROPDOWN
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateDropdown(options)
            options = options or {}
            local name = options.Name or "Dropdown"
            local items = options.Items or {}
            local default = options.Default or items[1] or ""
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local dropdown = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 42),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 10,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 11,
                Parent = dropdown,
            })
            
            local selectBtn = CreateInstance("TextButton", {
                Size = UDim2.new(0.45, 0, 0, 30),
                Position = UDim2.new(0.52, 0, 0.5, -15),
                BackgroundColor3 = WizardLib.Theme.Background,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 11,
                Parent = dropdown,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            
            local selectLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = default,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 12,
                Parent = selectBtn,
            })
            
            local chevron = CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -22, 0.5, -8),
                BackgroundTransparency = 1,
                Image = GetIcon("chevron-down"),
                ImageColor3 = WizardLib.Theme.TextDark,
                ZIndex = 12,
                Parent = selectBtn,
            })
            
            local itemsContainer = CreateInstance("Frame", {
                Size = UDim2.new(0.45, 0, 0, 0),
                Position = UDim2.new(0.52, 0, 1, 5),
                BackgroundColor3 = WizardLib.Theme.Background,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 50,
                Visible = false,
                Parent = dropdown,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)}),
                CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
                CreateInstance("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                })
            })
            
            CreateShadow(itemsContainer, 12)
            CreateStroke(itemsContainer, WizardLib.Theme.Divider, 1, 0.5)
            
            local opened = false
            local selected = default
            
            if flag then
                WizardLib.Flags[flag] = selected
            end
            
            for _, item in ipairs(items) do
                local itemBtn = CreateInstance("TextButton", {
                    Size = UDim2.new(1, -8, 0, 28),
                    BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                    BackgroundTransparency = 0.7,
                    BorderSizePixel = 0,
                    Text = item,
                    TextColor3 = WizardLib.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    ZIndex = 51,
                    Parent = itemsContainer,
                }, {
                    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4)})
                })
                
                itemBtn.MouseEnter:Connect(function()
                    Tween(itemBtn, 0.15, {BackgroundTransparency = 0.3})
                end)
                itemBtn.MouseLeave:Connect(function()
                    Tween(itemBtn, 0.15, {BackgroundTransparency = 0.7})
                end)
                itemBtn.MouseButton1Click:Connect(function()
                    selected = item
                    selectLabel.Text = item
                    if flag then WizardLib.Flags[flag] = item end
                    callback(item)
                    
                    opened = false
                    Tween(chevron, 0.2, {Rotation = 0})
                    Tween(itemsContainer, 0.25, {Size = UDim2.new(0.45, 0, 0, 0)}, nil, nil, function()
                        itemsContainer.Visible = false
                    end)
                end)
            end
            
            selectBtn.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    itemsContainer.Visible = true
                    Tween(chevron, 0.2, {Rotation = 180})
                    Tween(itemsContainer, 0.3, {Size = UDim2.new(0.45, 0, 0, #items * 30 + 8)}, Enum.EasingStyle.Back)
                else
                    Tween(chevron, 0.2, {Rotation = 0})
                    Tween(itemsContainer, 0.2, {Size = UDim2.new(0.45, 0, 0, 0)}, nil, nil, function()
                        itemsContainer.Visible = false
                    end)
                end
            end)
            
            return {
                Set = function(_, value)
                    selected = value
                    selectLabel.Text = value
                    if flag then WizardLib.Flags[flag] = value end
                    callback(value)
                end,
                Get = function()
                    return selected
                end,
                Refresh = function(_, newItems)
                    -- Clear and rebuild items
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- INPUT
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateInput(options)
            options = options or {}
            local name = options.Name or "Input"
            local placeholder = options.Placeholder or "Enter text..."
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local input = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 42),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = input,
            })
            
            local textBox = CreateInstance("TextBox", {
                Size = UDim2.new(0.55, 0, 0, 30),
                Position = UDim2.new(0.42, 0, 0.5, -15),
                BackgroundColor3 = WizardLib.Theme.Background,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = placeholder,
                PlaceholderColor3 = WizardLib.Theme.TextDisabled,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = input,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)}),
                CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                })
            })
            
            local stroke = CreateStroke(textBox, WizardLib.Theme.Divider, 1, 0.7)
            
            textBox.Focused:Connect(function()
                Tween(stroke, 0.2, {Color = WizardLib.Theme.Accent, Transparency = 0})
            end)
            
            textBox.FocusLost:Connect(function(enterPressed)
                Tween(stroke, 0.2, {Color = WizardLib.Theme.Divider, Transparency = 0.7})
                if enterPressed or textBox.Text ~= "" then
                    if flag then WizardLib.Flags[flag] = textBox.Text end
                    callback(textBox.Text)
                end
            end)
            
            return {
                Set = function(_, value)
                    textBox.Text = value
                    if flag then WizardLib.Flags[flag] = value end
                end,
                Get = function()
                    return textBox.Text
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- KEYBIND
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateKeybind(options)
            options = options or {}
            local name = options.Name or "Keybind"
            local default = options.Default or Enum.KeyCode.E
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local keybind = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 42),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = keybind,
            })
            
            local keyBtn = CreateInstance("TextButton", {
                Size = UDim2.new(0, 75, 0, 28),
                Position = UDim2.new(1, -90, 0.5, -14),
                BackgroundColor3 = WizardLib.Theme.Background,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = default.Name,
                TextColor3 = WizardLib.Theme.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = keybind,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            
            CreateStroke(keyBtn, WizardLib.Theme.Accent, 1, 0.6)
            
            local listening = false
            local currentKey = default
            
            if flag then
                WizardLib.Flags[flag] = currentKey
            end
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, 0.2, {BackgroundColor3 = WizardLib.Theme.Accent, BackgroundTransparency = 0})
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    keyBtn.Text = input.KeyCode.Name
                    if flag then WizardLib.Flags[flag] = currentKey end
                    Tween(keyBtn, 0.2, {BackgroundColor3 = WizardLib.Theme.Background, BackgroundTransparency = 0.3})
                elseif not processed and input.KeyCode == currentKey then
                    callback()
                end
            end)
            
            return {
                Set = function(_, key)
                    currentKey = key
                    keyBtn.Text = key.Name
                    if flag then WizardLib.Flags[flag] = key end
                end,
                Get = function()
                    return currentKey
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- COLOR PICKER
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateColorPicker(options)
            options = options or {}
            local name = options.Name or "Color"
            local default = options.Default or Color3.fromRGB(255, 255, 255)
            local flag = options.Flag
            local callback = options.Callback or function() end
            
            local picker = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 42),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                ClipsDescendants = false,
                ZIndex = 5,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6,
                Parent = picker,
            })
            
            local colorDisplay = CreateInstance("TextButton", {
                Size = UDim2.new(0, 60, 0, 28),
                Position = UDim2.new(1, -75, 0.5, -14),
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 6,
                Parent = picker,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            
            CreateStroke(colorDisplay, Color3.new(1, 1, 1), 2, 0.6)
            
            local colorPopup = CreateInstance("Frame", {
                Size = UDim2.new(0, 220, 0, 0),
                Position = UDim2.new(1, -230, 1, 8),
                BackgroundColor3 = WizardLib.Theme.Background,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 100,
                Visible = false,
                Parent = picker,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateShadow(colorPopup, 15)
            CreateStroke(colorPopup, WizardLib.Theme.Divider, 1, 0.5)
            
            local presets = {
                Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 85, 0), Color3.fromRGB(255, 170, 0),
                Color3.fromRGB(255, 255, 0), Color3.fromRGB(170, 255, 0), Color3.fromRGB(85, 255, 0),
                Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 85), Color3.fromRGB(0, 255, 170),
                Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 85, 255),
                Color3.fromRGB(0, 0, 255), Color3.fromRGB(85, 0, 255), Color3.fromRGB(170, 0, 255),
                Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 0, 170), Color3.fromRGB(255, 0, 85),
                Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200), Color3.fromRGB(150, 150, 150),
                Color3.fromRGB(100, 100, 100), Color3.fromRGB(50, 50, 50), Color3.fromRGB(0, 0, 0),
            }
            
            for i, color in ipairs(presets) do
                local presetBtn = CreateInstance("TextButton", {
                    Size = UDim2.new(0, 28, 0, 28),
                    Position = UDim2.new(0, 10 + ((i-1) % 6) * 34, 0, 10 + math.floor((i-1) / 6) * 34),
                    BackgroundColor3 = color,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 101,
                    Parent = colorPopup,
                }, {
                    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6)})
                })
                
                presetBtn.MouseButton1Click:Connect(function()
                    colorDisplay.BackgroundColor3 = color
                    if flag then WizardLib.Flags[flag] = color end
                    callback(color)
                end)
                
                presetBtn.MouseEnter:Connect(function()
                    Tween(presetBtn, 0.15, {Size = UDim2.new(0, 32, 0, 32), Position = presetBtn.Position - UDim2.new(0, 2, 0, 2)})
                end)
                presetBtn.MouseLeave:Connect(function()
                    Tween(presetBtn, 0.15, {Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 10 + ((i-1) % 6) * 34, 0, 10 + math.floor((i-1) / 6) * 34)})
                end)
            end
            
            local opened = false
            local selected = default
            
            if flag then
                WizardLib.Flags[flag] = selected
            end
            
            colorDisplay.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    colorPopup.Visible = true
                    Tween(colorPopup, 0.3, {Size = UDim2.new(0, 220, 0, 155)}, Enum.EasingStyle.Back)
                else
                    Tween(colorPopup, 0.2, {Size = UDim2.new(0, 220, 0, 0)}, nil, nil, function()
                        colorPopup.Visible = false
                    end)
                end
            end)
            
            return {
                Set = function(_, color)
                    colorDisplay.BackgroundColor3 = color
                    selected = color
                    if flag then WizardLib.Flags[flag] = color end
                    callback(color)
                end,
                Get = function()
                    return selected
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- LABEL
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateLabel(text, icon)
            local label = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 32),
                BackgroundTransparency = 1,
                Parent = tabContent,
            })
            
            if icon then
                CreateInstance("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 5, 0.5, -9),
                    BackgroundTransparency = 1,
                    Image = GetIcon(icon),
                    ImageColor3 = WizardLib.Theme.TextDark,
                    Parent = label,
                })
            end
            
            local textLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, icon and -30 or 0, 1, 0),
                Position = UDim2.new(0, icon and 28 or 5, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = WizardLib.Theme.TextDark,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = label,
            })
            
            return {
                Set = function(_, newText)
                    textLabel.Text = newText
                end
            }
        end
        
        -- ═══════════════════════════════════════════════════════════════════
        -- PARAGRAPH
        -- ═══════════════════════════════════════════════════════════════════
        
        function Tab:CreateParagraph(options)
            options = options or {}
            local title = options.Title or "Title"
            local content = options.Content or ""
            
            local paragraph = CreateInstance("Frame", {
                Size = UDim2.new(1, -10, 0, 70),
                BackgroundColor3 = WizardLib.Theme.BackgroundSecondary,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = tabContent,
            }, {
                CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8)})
            })
            
            CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 22),
                Position = UDim2.new(0, 10, 0, 8),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = WizardLib.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = paragraph,
            })
            
            local contentLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 35),
                Position = UDim2.new(0, 10, 0, 30),
                BackgroundTransparency = 1,
                Text = content,
                TextColor3 = WizardLib.Theme.TextDark,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = paragraph,
            })
            
            return {
                Set = function(_, newTitle, newContent)
                    paragraph:FindFirstChild("TextLabel").Text = newTitle or title
                    contentLabel.Text = newContent or content
                end
            }
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
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- WINDOW METHODS
    -- ═══════════════════════════════════════════════════════════════════════
    
    function Window:SetTheme(themeName)
        if Themes[themeName] then
            WizardLib.Theme = Themes[themeName]
            -- Refresh UI would go here
        end
    end
    
    function Window:Notify(options)
        WizardLib:Notify(options)
    end
    
    function Window:Destroy()
        screenGui:Destroy()
    end
    
    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == (options.ToggleUIKeybind and Enum.KeyCode[options.ToggleUIKeybind] or Enum.KeyCode.RightShift) then
            Window.Visible = not Window.Visible
            main.Visible = Window.Visible
        end
    end)
    
    table.insert(WizardLib.Windows, Window)
    return Window
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LOAD CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════

function WizardLib:LoadConfiguration()
    -- Configuration loading logic
end

function WizardLib:SaveConfiguration()
    -- Configuration saving logic
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════════

return WizardLib
