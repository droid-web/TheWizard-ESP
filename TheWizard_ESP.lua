-- ╔══════════════════════════════════════════════════════════════╗
-- ║        TheWizard ESP  —  Compatible JJSploit / Lua 5.1      ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ─── SERVICES ─────────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera           = workspace.CurrentCamera
local LP               = Players.LocalPlayer

-- ─── COMPAT LUA 5.1 ───────────────────────────────────────────
-- task.wait / task.delay non supportés sur JJSploit
local tw = (typeof(task) ~= "nil" and task.wait)  or wait
local td = (typeof(task) ~= "nil" and task.delay) or delay

local function mround(n)
    return math.floor(n + 0.5)
end

-- ═══════════════════════════════════════════════════════════════
--  ESP — CONFIG
-- ═══════════════════════════════════════════════════════════════
local ESP = {
    Enabled     = false,
    Boxes       = false,
    Names       = false,
    Distance    = false,
    HealthBar   = false,
    HealthText  = false,
    Tracers     = false,
    Skeletons   = false,
    Chams       = false,
    HeadCircle  = false,
    OffScreen   = false,
    LookDir     = false,
    ToolName    = false,
    TeamCheck   = false,
    MaxDistance = 500,
    BoxThick    = 1.5,
    TracerThick = 1,
    SkelThick   = 1,
    BoxColor    = Color3.fromRGB(123, 140, 255),
    NameColor   = Color3.fromRGB(255, 255, 255),
    DistColor   = Color3.fromRGB(180, 180, 180),
    TracerColor = Color3.fromRGB(160, 170, 255),
    SkelColor   = Color3.fromRGB(201, 168, 76),
    HeadColor   = Color3.fromRGB(0, 200, 255),
    LookColor   = Color3.fromRGB(94, 255, 160),
    OffColor    = Color3.fromRGB(255, 94, 122),
}

local ESPObjects = {}

-- ═══════════════════════════════════════════════════════════════
--  ESP — UTILITAIRES
-- ═══════════════════════════════════════════════════════════════
local function W2S(pos)
    local s, z, v = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), z, v
end

local function GetDist(char)
    local r  = char:FindFirstChild("HumanoidRootPart")
    local mr = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if r and mr then return (r.Position - mr.Position).Magnitude end
    return 0
end

local function GetHP(char)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then return h.Health, h.MaxHealth end
    return 100, 100
end

local function HPColor(pct)
    if pct > 0.5 then
        return Color3.fromRGB(math.floor(255*(1-pct)*2), 255, 0)
    else
        return Color3.fromRGB(255, math.floor(255*pct*2), 0)
    end
end

local function GetBBox(char)
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local vis = false
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            local corners = {
                p.CFrame * CFrame.new( p.Size.X/2,  p.Size.Y/2,  p.Size.Z/2),
                p.CFrame * CFrame.new(-p.Size.X/2,  p.Size.Y/2,  p.Size.Z/2),
                p.CFrame * CFrame.new( p.Size.X/2, -p.Size.Y/2,  p.Size.Z/2),
                p.CFrame * CFrame.new(-p.Size.X/2, -p.Size.Y/2,  p.Size.Z/2),
                p.CFrame * CFrame.new( p.Size.X/2,  p.Size.Y/2, -p.Size.Z/2),
                p.CFrame * CFrame.new(-p.Size.X/2,  p.Size.Y/2, -p.Size.Z/2),
                p.CFrame * CFrame.new( p.Size.X/2, -p.Size.Y/2, -p.Size.Z/2),
                p.CFrame * CFrame.new(-p.Size.X/2, -p.Size.Y/2, -p.Size.Z/2),
            }
            for _, c in pairs(corners) do
                local s, d, v = W2S(c.Position)
                if v and d > 0 then
                    vis = true
                    if s.X < minX then minX = s.X end
                    if s.Y < minY then minY = s.Y end
                    if s.X > maxX then maxX = s.X end
                    if s.Y > maxY then maxY = s.Y end
                end
            end
        end
    end
    return minX, minY, maxX, maxY, vis
end

local function GetTool(char)
    for _, i in pairs(char:GetChildren()) do
        if i:IsA("Tool") then return i.Name end
    end
    return nil
end

local JOINTS_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},{"RightUpperLeg","RightLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"},
    {"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},{"RightUpperArm","RightLowerArm"},
    {"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},
}
local JOINTS_R6 = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}
local function GetJoints(char)
    if char:FindFirstChild("UpperTorso") then return JOINTS_R15 end
    return JOINTS_R6
end

-- ═══════════════════════════════════════════════════════════════
--  ESP — DRAWINGS
-- ═══════════════════════════════════════════════════════════════
local function NLine(p)
    local d = Drawing.new("Line")
    d.Visible = false; d.ZIndex = 2
    for k,v in pairs(p or {}) do d[k] = v end
    return d
end
local function NText(p)
    local d = Drawing.new("Text")
    d.Visible = false; d.ZIndex = 3
    d.Outline = true; d.Center = true; d.Size = 13
    for k,v in pairs(p or {}) do d[k] = v end
    return d
end
local function NCirc(p)
    local d = Drawing.new("Circle")
    d.Visible = false; d.ZIndex = 3
    d.Filled = false; d.NumSides = 32
    for k,v in pairs(p or {}) do d[k] = v end
    return d
end
local function NTri(p)
    local d = Drawing.new("Triangle")
    d.Visible = false; d.ZIndex = 4; d.Filled = true
    for k,v in pairs(p or {}) do d[k] = v end
    return d
end

local function CreateESP(player)
    if player == LP then return end
    local o = {}
    o.BoxLines    = {}; for i=1,4  do o.BoxLines[i]    = NLine() end
    o.CornerLines = {}; for i=1,8  do o.CornerLines[i] = NLine({Thickness=2,ZIndex=3}) end
    o.SkelLines   = {}; for i=1,14 do o.SkelLines[i]   = NLine({ZIndex=1}) end
    o.LookLines   = {}; for i=1,3  do o.LookLines[i]   = NLine({Thickness=2,ZIndex=4}) end
    o.NameLabel  = NText({Size=14})
    o.DistLabel  = NText({Size=12})
    o.ToolLabel  = NText({Size=12, Color=Color3.fromRGB(180,255,180)})
    o.HealthBg   = NLine({Thickness=4, Color=Color3.fromRGB(0,0,0), ZIndex=2})
    o.HealthFill = NLine({Thickness=3, ZIndex=3})
    o.HealthText = NText({Size=11})
    o.Tracer     = NLine({ZIndex=1})
    o.HeadCircle = NCirc({Thickness=1.5})
    o.OffArrow   = NTri({Color=ESP.OffColor})
    local hl = Instance.new("SelectionBox")
    hl.LineThickness = 0.04
    hl.SurfaceTransparency = 0.55
    hl.Parent = workspace
    o.Highlight = hl
    ESPObjects[player] = o
end

local function RemoveESP(player)
    local o = ESPObjects[player]
    if not o then return end
    for _,l in pairs(o.BoxLines)    do l:Remove() end
    for _,l in pairs(o.CornerLines) do l:Remove() end
    for _,l in pairs(o.SkelLines)   do l:Remove() end
    for _,l in pairs(o.LookLines)   do l:Remove() end
    o.NameLabel:Remove(); o.DistLabel:Remove(); o.ToolLabel:Remove()
    o.HealthBg:Remove();  o.HealthFill:Remove(); o.HealthText:Remove()
    o.Tracer:Remove();    o.HeadCircle:Remove();  o.OffArrow:Remove()
    o.Highlight:Destroy()
    ESPObjects[player] = nil
end

local function HideAll(o)
    for _,l in pairs(o.BoxLines)    do l.Visible = false end
    for _,l in pairs(o.CornerLines) do l.Visible = false end
    for _,l in pairs(o.SkelLines)   do l.Visible = false end
    for _,l in pairs(o.LookLines)   do l.Visible = false end
    o.NameLabel.Visible  = false; o.DistLabel.Visible   = false
    o.ToolLabel.Visible  = false; o.HealthBg.Visible    = false
    o.HealthFill.Visible = false; o.HealthText.Visible  = false
    o.Tracer.Visible     = false; o.HeadCircle.Visible  = false
    o.OffArrow.Visible   = false; o.Highlight.Adornee   = nil
end

-- ═══════════════════════════════════════════════════════════════
--  ESP — BOUCLE (pas de continue, pas de +=)
-- ═══════════════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    for player, o in pairs(ESPObjects) do
        local char = player.Character
        local skip = (
            not ESP.Enabled or not char
            or not char:FindFirstChild("HumanoidRootPart")
            or not char:FindFirstChild("Head")
            or (ESP.TeamCheck and player.Team == LP.Team)
            or GetDist(char) > ESP.MaxDistance
        )

        if skip then
            HideAll(o)
        else
            local rootS, _, onScreen = W2S(char.HumanoidRootPart.Position)
            local headS, _, headVis  = W2S(char.Head.Position)
            local col = ESP.BoxColor

            if not onScreen then
                HideAll(o)
                if ESP.OffScreen then
                    local vp  = Camera.ViewportSize
                    local ctr = vp / 2
                    local dir = Vector2.new(rootS.X - ctr.X, rootS.Y - ctr.Y)
                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                        local r   = math.min(vp.X, vp.Y) * 0.42
                        local e   = ctr + dir * r
                        local ang = math.atan2(dir.Y, dir.X)
                        local sz  = 10
                        o.OffArrow.PointA = e + dir * sz
                        o.OffArrow.PointB = e + Vector2.new(math.cos(ang+math.rad(150))*sz, math.sin(ang+math.rad(150))*sz)
                        o.OffArrow.PointC = e + Vector2.new(math.cos(ang-math.rad(150))*sz, math.sin(ang-math.rad(150))*sz)
                        o.OffArrow.Color   = ESP.OffColor
                        o.OffArrow.Visible = true
                    end
                end
            else
                o.OffArrow.Visible = false
                local x1, y1, x2, y2, boxV = GetBBox(char)
                local hp, maxhp = GetHP(char)
                local hpPct = hp / maxhp

                -- BOITE
                if ESP.Boxes and boxV then
                    local bl = o.BoxLines
                    bl[1].From=Vector2.new(x1,y1); bl[1].To=Vector2.new(x2,y1)
                    bl[2].From=Vector2.new(x2,y1); bl[2].To=Vector2.new(x2,y2)
                    bl[3].From=Vector2.new(x2,y2); bl[3].To=Vector2.new(x1,y2)
                    bl[4].From=Vector2.new(x1,y2); bl[4].To=Vector2.new(x1,y1)
                    for _,l in pairs(bl) do l.Color=col; l.Thickness=ESP.BoxThick; l.Visible=true end
                    local w,h   = x2-x1, y2-y1
                    local cw,ch = w*0.22, h*0.22
                    local cl    = o.CornerLines
                    cl[1].From=Vector2.new(x1,y1);    cl[1].To=Vector2.new(x1+cw,y1)
                    cl[2].From=Vector2.new(x1,y1);    cl[2].To=Vector2.new(x1,y1+ch)
                    cl[3].From=Vector2.new(x2,y1);    cl[3].To=Vector2.new(x2-cw,y1)
                    cl[4].From=Vector2.new(x2,y1);    cl[4].To=Vector2.new(x2,y1+ch)
                    cl[5].From=Vector2.new(x1,y2);    cl[5].To=Vector2.new(x1+cw,y2)
                    cl[6].From=Vector2.new(x1,y2);    cl[6].To=Vector2.new(x1,y2-ch)
                    cl[7].From=Vector2.new(x2,y2);    cl[7].To=Vector2.new(x2-cw,y2)
                    cl[8].From=Vector2.new(x2,y2);    cl[8].To=Vector2.new(x2,y2-ch)
                    for _,l in pairs(cl) do l.Color=col; l.Visible=true end
                else
                    for _,l in pairs(o.BoxLines)    do l.Visible=false end
                    for _,l in pairs(o.CornerLines) do l.Visible=false end
                end

                -- NOM
                if ESP.Names then
                    o.NameLabel.Text=player.Name; o.NameLabel.Color=ESP.NameColor
                    o.NameLabel.Position=Vector2.new(rootS.X,y1-17); o.NameLabel.Visible=true
                else o.NameLabel.Visible=false end

                -- DISTANCE
                if ESP.Distance then
                    o.DistLabel.Text=string.format("%.0f m",GetDist(char))
                    o.DistLabel.Color=ESP.DistColor
                    o.DistLabel.Position=Vector2.new(rootS.X,y2+4); o.DistLabel.Visible=true
                else o.DistLabel.Visible=false end

                -- OUTIL
                if ESP.ToolName then
                    local t = GetTool(char)
                    if t then
                        o.ToolLabel.Text="["..t.."]"
                        o.ToolLabel.Position=Vector2.new(rootS.X,y2+17); o.ToolLabel.Visible=true
                    else o.ToolLabel.Visible=false end
                else o.ToolLabel.Visible=false end

                -- BARRE SANTE
                if ESP.HealthBar and boxV then
                    local bx=x1-7; local fillY=y2-(y2-y1)*hpPct
                    o.HealthBg.From=Vector2.new(bx,y1); o.HealthBg.To=Vector2.new(bx,y2); o.HealthBg.Visible=true
                    o.HealthFill.From=Vector2.new(bx,fillY); o.HealthFill.To=Vector2.new(bx,y2)
                    o.HealthFill.Color=HPColor(hpPct); o.HealthFill.Visible=true
                else o.HealthBg.Visible=false; o.HealthFill.Visible=false end

                -- TEXTE SANTE
                if ESP.HealthText then
                    o.HealthText.Text=string.format("%.0f/%.0f",hp,maxhp)
                    o.HealthText.Color=HPColor(hpPct)
                    o.HealthText.Position=Vector2.new(x1-24,(y1+y2)/2-6); o.HealthText.Visible=true
                else o.HealthText.Visible=false end

                -- TRACER
                if ESP.Tracers then
                    local vp=Camera.ViewportSize
                    o.Tracer.From=Vector2.new(vp.X/2,vp.Y); o.Tracer.To=rootS
                    o.Tracer.Color=ESP.TracerColor; o.Tracer.Thickness=ESP.TracerThick; o.Tracer.Visible=true
                else o.Tracer.Visible=false end

                -- SQUELETTE
                if ESP.Skeletons then
                    local joints = GetJoints(char)
                    for i, j in pairs(joints) do
                        local p1=char:FindFirstChild(j[1]); local p2=char:FindFirstChild(j[2])
                        local ln=o.SkelLines[i]
                        if p1 and p2 then
                            local s1,_,v1=W2S(p1.Position); local s2,_,v2=W2S(p2.Position)
                            if v1 and v2 then
                                ln.From=s1; ln.To=s2; ln.Color=ESP.SkelColor; ln.Thickness=ESP.SkelThick; ln.Visible=true
                            else ln.Visible=false end
                        else ln.Visible=false end
                    end
                    local jcount = #GetJoints(char)
                    for i=jcount+1,14 do o.SkelLines[i].Visible=false end
                else for _,l in pairs(o.SkelLines) do l.Visible=false end end

                -- CERCLE TETE
                if ESP.HeadCircle and headVis then
                    local ep=char.Head.Position+Camera.CFrame.RightVector*(char.Head.Size.X/2)
                    local es,_,_=W2S(ep)
                    o.HeadCircle.Position=headS; o.HeadCircle.Radius=math.max(4,(es-headS).Magnitude)
                    o.HeadCircle.Color=ESP.HeadColor; o.HeadCircle.Visible=true
                else o.HeadCircle.Visible=false end

                -- REGARD
                if ESP.LookDir and headVis then
                    local head=char:FindFirstChild("Head")
                    if head then
                        local lt=head.CFrame.LookVector*3+head.Position
                        local s1,_,_=W2S(head.Position); local s2,_,_=W2S(lt)
                        local dir=s2-s1
                        if dir.Magnitude>0.01 then
                            dir=dir.Unit*20
                            local tip=s1+dir; local perp=Vector2.new(-dir.Y,dir.X).Unit*5
                            o.LookLines[1].From=s1;  o.LookLines[1].To=tip
                            o.LookLines[2].From=tip; o.LookLines[2].To=tip-dir.Unit*6+perp
                            o.LookLines[3].From=tip; o.LookLines[3].To=tip-dir.Unit*6-perp
                            for _,l in pairs(o.LookLines) do l.Color=ESP.LookColor; l.Visible=true end
                        else for _,l in pairs(o.LookLines) do l.Visible=false end end
                    end
                else for _,l in pairs(o.LookLines) do l.Visible=false end end

                -- CHAMS
                if ESP.Chams then
                    o.Highlight.Adornee=char; o.Highlight.Color3=col
                    o.Highlight.SurfaceColor3=col; o.Highlight.SurfaceTransparency=0.5
                else o.Highlight.Adornee=nil end
            end
        end
    end
end)

for _,p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ═══════════════════════════════════════════════════════════════
--  GUI — PALETTE
-- ═══════════════════════════════════════════════════════════════
local C = {
    BgVoid    = Color3.fromRGB(7,8,15),
    BgDeep    = Color3.fromRGB(13,15,28),
    BgPanel   = Color3.fromRGB(17,20,34),
    BgCard    = Color3.fromRGB(22,25,40),
    BgHover   = Color3.fromRGB(28,32,53),
    Accent    = Color3.fromRGB(123,140,255),
    AccentBrt = Color3.fromRGB(160,170,255),
    Gold      = Color3.fromRGB(201,168,76),
    TextMain  = Color3.fromRGB(216,221,245),
    TextSub   = Color3.fromRGB(110,117,148),
    TextDim   = Color3.fromRGB(61,66,96),
    Border    = Color3.fromRGB(120,140,255),
    Success   = Color3.fromRGB(94,255,160),
    Danger    = Color3.fromRGB(255,94,122),
    White     = Color3.fromRGB(255,255,255),
    Black     = Color3.fromRGB(0,0,0),
}

local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k]=v end
    if parent then obj.Parent=parent end
    return obj
end

-- ═══════════════════════════════════════════════════════════════
--  SCREEN GUI
-- ═══════════════════════════════════════════════════════════════
local screenGui = New("ScreenGui",{
    Name="TheWizard_ESP",
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true,
})
local ok = pcall(function() screenGui.Parent=game:GetService("CoreGui") end)
if not ok or not screenGui.Parent then
    screenGui.Parent = LP:WaitForChild("PlayerGui")
end

-- ─── LOADING ──────────────────────────────────────────────────
local loadFrame = New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.BgVoid,ZIndex=100},screenGui)
New("TextLabel",{
    Text="TheWizard ESP",
    Size=UDim2.new(0,400,0,30),Position=UDim2.new(0.5,-200,0.5,-40),
    BackgroundTransparency=1,TextColor3=C.AccentBrt,TextSize=20,Font=Enum.Font.GothamBold,ZIndex=101,
},loadFrame)
New("TextLabel",{
    Text="Chargement du Grimoire...",
    Size=UDim2.new(0,400,0,20),Position=UDim2.new(0.5,-200,0.5,-8),
    BackgroundTransparency=1,TextColor3=C.TextSub,TextSize=13,Font=Enum.Font.Gotham,ZIndex=101,
},loadFrame)
local loadTrack=New("Frame",{Size=UDim2.new(0,300,0,3),Position=UDim2.new(0.5,-150,0.5,18),BackgroundColor3=C.BgCard,BorderSizePixel=0,ZIndex=100},loadFrame)
New("UICorner",{CornerRadius=UDim.new(0,2)},loadTrack)
local loadBar=New("Frame",{Size=UDim2.new(0,0,0,3),BackgroundColor3=C.Accent,BorderSizePixel=0,ZIndex=101},loadTrack)
New("UICorner",{CornerRadius=UDim.new(0,2)},loadBar)
Tween(loadBar,{Size=UDim2.new(1,0,1,0)},1.2,Enum.EasingStyle.Quart)
tw(1.4)
Tween(loadFrame,{BackgroundTransparency=1},0.4)
tw(0.45)
loadFrame:Destroy()

-- ═══════════════════════════════════════════════════════════════
--  FENÊTRE
-- ═══════════════════════════════════════════════════════════════
local mainFrame=New("Frame",{
    Size=UDim2.new(0,700,0,480),
    Position=UDim2.new(0.5,-350,0.5,-240),
    BackgroundColor3=C.BgDeep,
    BorderSizePixel=0,
    ClipsDescendants=true,
},screenGui)
New("UICorner",{CornerRadius=UDim.new(0,12)},mainFrame)
New("UIStroke",{Color=C.Border,Transparency=0.65,Thickness=1},mainFrame)

mainFrame.Size=UDim2.new(0,0,0,0)
mainFrame.Position=UDim2.new(0.5,0,0.5,0)
Tween(mainFrame,{Size=UDim2.new(0,700,0,480),Position=UDim2.new(0.5,-350,0.5,-240)},0.5,Enum.EasingStyle.Back)

-- TOPBAR
local topBar=New("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=C.BgPanel,BorderSizePixel=0},mainFrame)
New("UIStroke",{Color=C.Border,Transparency=0.82,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},topBar)

local logoF=New("Frame",{Size=UDim2.new(0,30,0,30),Position=UDim2.new(0,10,0.5,-15),BackgroundColor3=C.BgCard,BorderSizePixel=0},topBar)
New("UICorner",{CornerRadius=UDim.new(0,7)},logoF)
New("UIStroke",{Color=C.Border,Transparency=0.6,Thickness=1},logoF)
New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=C.AccentBrt,TextSize=16,Font=Enum.Font.GothamBold,Text="*"},logoF)

New("TextLabel",{Size=UDim2.new(0,220,0,22),Position=UDim2.new(0,48,0,6),BackgroundTransparency=1,TextColor3=C.AccentBrt,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Text="TheWizard ESP"},topBar)
New("TextLabel",{Size=UDim2.new(0,280,0,14),Position=UDim2.new(0,48,0,26),BackgroundTransparency=1,TextColor3=C.TextDim,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Text="by TheWizard  |  Insert pour masquer"},topBar)

local function makeTopBtn(icon,xOff,hoverCol,action)
    local btn=New("TextButton",{Text=icon,Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,xOff,0.5,-13),BackgroundColor3=C.BgCard,TextColor3=C.TextSub,TextSize=13,Font=Enum.Font.GothamBold,BorderSizePixel=0,AutoButtonColor=false},topBar)
    New("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    New("UIStroke",{Color=C.Border,Transparency=0.8,Thickness=1},btn)
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=hoverCol,TextColor3=C.White},0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=C.BgCard,TextColor3=C.TextSub},0.15) end)
    btn.MouseButton1Click:Connect(action)
    return btn
end
makeTopBtn("X",-10,C.Danger,function()
    for _,o in pairs(ESPObjects) do HideAll(o) end
    Tween(mainFrame,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)},0.3)
    tw(0.35); screenGui:Destroy()
end)
makeTopBtn("-",-42,C.Accent,function() mainFrame.Visible=false end)

-- DRAG
local dragging,dragStart,startPos=false,nil,nil
topBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=i.Position; startPos=mainFrame.Position
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-dragStart
        mainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.Insert then mainFrame.Visible=not mainFrame.Visible end
end)

-- SIDEBAR
local sideBar=New("Frame",{Size=UDim2.new(0,175,1,-44),Position=UDim2.new(0,0,0,44),BackgroundColor3=C.BgPanel,BorderSizePixel=0},mainFrame)
New("UIStroke",{Color=C.Border,Transparency=0.82,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},sideBar)

local tabContainer=New("ScrollingFrame",{
    Size=UDim2.new(1,0,1,-28),BackgroundTransparency=1,BorderSizePixel=0,
    ScrollBarThickness=3,ScrollBarImageColor3=C.Border,
    CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
},sideBar)
New("UIPadding",{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)},tabContainer)
New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3)},tabContainer)
New("TextLabel",{Text="by TheWizard",Size=UDim2.new(1,0,0,26),Position=UDim2.new(0,0,1,-26),BackgroundTransparency=1,TextColor3=C.TextDim,TextSize=11,Font=Enum.Font.Gotham},sideBar)

local contentArea=New("Frame",{Size=UDim2.new(1,-175,1,-44),Position=UDim2.new(0,175,0,44),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true},mainFrame)

-- ═══════════════════════════════════════════════════════════════
--  ONGLETS
-- ═══════════════════════════════════════════════════════════════
local allTabs  = {}
local activeTab = nil
local tabOrderN = 0
local elemOrderN = 0

local function nextEO()
    elemOrderN = elemOrderN + 1
    return elemOrderN
end

local function switchTab(name)
    for n,t in pairs(allTabs) do
        local isA=(n==name)
        t.page.Visible=isA; t.acc.Visible=isA
        Tween(t.btn,{BackgroundColor3=isA and C.BgCard or C.BgPanel},0.15)
        Tween(t.lbl,{TextColor3=isA and C.AccentBrt or C.TextSub},0.15)
        Tween(t.ico,{TextColor3=isA and C.Accent or C.TextSub},0.15)
    end
    activeTab=name
end

local function CreateTab(name,icon)
    tabOrderN = tabOrderN + 1
    local tabBtn=New("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.BgPanel,BorderSizePixel=0,Text="",AutoButtonColor=false,LayoutOrder=tabOrderN},tabContainer)
    New("UICorner",{CornerRadius=UDim.new(0,8)},tabBtn)
    local acc=New("Frame",{Size=UDim2.new(0,3,0.6,0),Position=UDim2.new(0,0,0.2,0),BackgroundColor3=C.Accent,BorderSizePixel=0,Visible=false},tabBtn)
    New("UICorner",{CornerRadius=UDim.new(0,2)},acc)
    local icoL=New("TextLabel",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,12,0.5,-8),BackgroundTransparency=1,TextColor3=C.TextSub,TextSize=14,Font=Enum.Font.GothamBold,Text=icon or "o"},tabBtn)
    local lblL=New("TextLabel",{Size=UDim2.new(1,-36,1,0),Position=UDim2.new(0,32,0,0),BackgroundTransparency=1,TextColor3=C.TextSub,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Text=name},tabBtn)

    local page=New("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=C.Border,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},contentArea)
    New("UIPadding",{PaddingTop=UDim.new(0,10),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,14),PaddingBottom=UDim.new(0,10)},page)
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8)},page)

    allTabs[name]={btn=tabBtn,lbl=lblL,ico=icoL,acc=acc,page=page}
    tabBtn.MouseEnter:Connect(function() if activeTab~=name then Tween(tabBtn,{BackgroundColor3=C.BgHover},0.15) end end)
    tabBtn.MouseLeave:Connect(function() if activeTab~=name then Tween(tabBtn,{BackgroundColor3=C.BgPanel},0.15) end end)
    tabBtn.MouseButton1Click:Connect(function() switchTab(name) end)
    if tabOrderN==1 then switchTab(name) end
    return page
end

-- ─── HELPERS ÉLÉMENTS ─────────────────────────────────────────
local function MakeSection(parent, title)
    local sec=New("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=C.BgCard,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=nextEO()},parent)
    New("UICorner",{CornerRadius=UDim.new(0,10)},sec)
    New("UIStroke",{Color=C.Border,Transparency=0.82,Thickness=1},sec)
    local hdr=New("TextLabel",{Text=string.upper(title),Size=UDim2.new(1,0,0,32),BackgroundColor3=C.BgPanel,BorderSizePixel=0,TextColor3=C.TextSub,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},sec)
    New("UICorner",{CornerRadius=UDim.new(0,10)},hdr)
    New("UIPadding",{PaddingLeft=UDim.new(0,12)},hdr)
    local body=New("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,32),BackgroundTransparency=1,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.Y},sec)
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1)},body)
    New("UIPadding",{PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingBottom=UDim.new(0,4)},body)
    return body
end

local function MakeElem(parent)
    local e=New("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=C.BgCard,BorderSizePixel=0,LayoutOrder=nextEO()},parent)
    New("UICorner",{CornerRadius=UDim.new(0,7)},e)
    e.MouseEnter:Connect(function() Tween(e,{BackgroundColor3=C.BgHover},0.15) end)
    e.MouseLeave:Connect(function() Tween(e,{BackgroundColor3=C.BgCard},0.15) end)
    local iF=New("Frame",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(0,9,0.5,-14),BackgroundColor3=C.Accent,BackgroundTransparency=0.85,BorderSizePixel=0},e)
    New("UICorner",{CornerRadius=UDim.new(0,7)},iF)
    New("UIStroke",{Color=C.Accent,Transparency=0.75,Thickness=1},iF)
    local iL=New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=C.AccentBrt,TextSize=13,Font=Enum.Font.GothamBold,Text="o"},iF)
    local nL=New("TextLabel",{Size=UDim2.new(0.55,0,0,18),Position=UDim2.new(0,46,0.5,-17),BackgroundTransparency=1,TextColor3=C.TextMain,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true},e)
    local dL=New("TextLabel",{Size=UDim2.new(0.55,0,0,14),Position=UDim2.new(0,46,0.5,-1),BackgroundTransparency=1,TextColor3=C.TextSub,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true},e)
    return e,iL,nL,dL
end

local function MakeToggle(parent,label,desc,espKey,init)
    local e,iL,nL,dL=MakeElem(parent)
    nL.Text=label; dL.Text=desc; iL.Text="O"
    local track=New("Frame",{Size=UDim2.new(0,38,0,21),Position=UDim2.new(1,-48,0.5,-10.5),BackgroundColor3=C.BgVoid,BorderSizePixel=0},e)
    New("UICorner",{CornerRadius=UDim.new(1,0)},track)
    New("UIStroke",{Color=C.Border,Transparency=0.75,Thickness=1},track)
    local thumb=New("Frame",{Size=UDim2.new(0,15,0,15),Position=UDim2.new(0,3,0.5,-7.5),BackgroundColor3=C.TextDim,BorderSizePixel=0},track)
    New("UICorner",{CornerRadius=UDim.new(1,0)},thumb)
    local state=init or false
    local function apply()
        if espKey then ESP[espKey]=state end
        if state then
            Tween(track,{BackgroundColor3=C.Accent},0.2)
            Tween(thumb,{Position=UDim2.new(0,20,0.5,-7.5),BackgroundColor3=C.White},0.2,Enum.EasingStyle.Back)
        else
            Tween(track,{BackgroundColor3=C.BgVoid},0.2)
            Tween(thumb,{Position=UDim2.new(0,3,0.5,-7.5),BackgroundColor3=C.TextDim},0.2)
        end
    end
    apply()
    local cb=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5},e)
    cb.MouseButton1Click:Connect(function() state=not state; apply() end)
end

local function MakeSlider(parent,label,desc,min,max,default,suffix,onChange)
    local e,iL,nL,dL=MakeElem(parent)
    nL.Text=label; dL.Text=desc; iL.Text="-"
    local valLbl=New("TextLabel",{Size=UDim2.new(0,50,0,14),Position=UDim2.new(1,-80,0,8),BackgroundTransparency=1,TextColor3=C.AccentBrt,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(default)..(suffix or "")},e)
    local track=New("Frame",{Size=UDim2.new(0,200,0,4),Position=UDim2.new(0,46,1,-12),BackgroundColor3=C.BgVoid,BorderSizePixel=0},e)
    New("UICorner",{CornerRadius=UDim.new(0,2)},track)
    local pct0=(default-min)/(max-min)
    local fill=New("Frame",{Size=UDim2.new(pct0,0,1,0),BackgroundColor3=C.Accent,BorderSizePixel=0},track)
    New("UICorner",{CornerRadius=UDim.new(0,2)},fill)
    local knob=New("Frame",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(pct0,0,0.5,-6),BackgroundColor3=C.White,BorderSizePixel=0,ZIndex=2},track)
    New("UICorner",{CornerRadius=UDim.new(1,0)},knob)
    local sliding=false
    local function setVal(mx)
        local abs=track.AbsolutePosition.X; local width=track.AbsoluteSize.X
        local p=math.clamp((mx-abs)/width,0,1)
        local v=math.floor(min+(max-min)*p)
        fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,0,0.5,-6)
        valLbl.Text=tostring(v)..(suffix or "")
        if onChange then onChange(v) end
    end
    local ca=New("TextButton",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,-5),BackgroundTransparency=1,Text="",ZIndex=3},track)
    ca.MouseButton1Down:Connect(function() sliding=true end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then setVal(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
    end)
end

local function MakeColorBtn(parent,label,box,tracer,skel,allBtns)
    local btn=New("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=C.BgCard,Text="",BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=nextEO()},parent)
    New("UICorner",{CornerRadius=UDim.new(0,7)},btn)
    New("UIStroke",{Color=C.Border,Transparency=0.82,Thickness=1},btn)
    local sw=New("Frame",{Size=UDim2.new(0,18,0,18),Position=UDim2.new(0,10,0.5,-9),BackgroundColor3=box,BorderSizePixel=0},btn)
    New("UICorner",{CornerRadius=UDim.new(0,4)},sw)
    New("TextLabel",{Size=UDim2.new(1,-55,1,0),Position=UDim2.new(0,36,0,0),BackgroundTransparency=1,Text=label,TextColor3=C.TextMain,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left},btn)
    local check=New("TextLabel",{Size=UDim2.new(0,30,1,0),Position=UDim2.new(1,-34,0,0),BackgroundTransparency=1,Text="",TextColor3=C.Success,Font=Enum.Font.GothamBold,TextSize=14},btn)
    btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=C.BgHover},0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=C.BgCard},0.15) end)
    btn.MouseButton1Click:Connect(function()
        ESP.BoxColor=box; ESP.TracerColor=tracer; ESP.SkelColor=skel
        ESP.HeadColor=box; ESP.LookColor=tracer; ESP.OffColor=box
        for _,o in pairs(ESPObjects) do
            for _,l in pairs(o.BoxLines) do l.Color=box end
            for _,l in pairs(o.CornerLines) do l.Color=box end
            o.Tracer.Color=tracer
            for _,l in pairs(o.SkelLines) do l.Color=skel end
            o.HeadCircle.Color=box
            o.Highlight.Color3=box; o.Highlight.SurfaceColor3=box
        end
        for _,b in pairs(allBtns) do
            for _,ch in pairs(b:GetDescendants()) do
                if ch:IsA("TextLabel") and ch.Text=="OK" then ch.Text="" end
            end
        end
        check.Text="OK"
    end)
    return btn
end

-- ═══════════════════════════════════════════════════════════════
--  CONSTRUCTION DES ONGLETS
-- ═══════════════════════════════════════════════════════════════

-- ONGLET ESP
local P1=CreateTab("ESP","o")
local S1=MakeSection(P1,"Principal")
MakeToggle(S1,"ESP Global",    "Activer tout l'ESP",            "Enabled")
local S2=MakeSection(P1,"Boites")
MakeToggle(S2,"Boites",        "Boite autour des joueurs",      "Boxes")
MakeToggle(S2,"Barre de Sante","Affiche les PV",                "HealthBar")
MakeToggle(S2,"Texte PV",      "Valeur PV en chiffres",         "HealthText")
local S3=MakeSection(P1,"Textes")
MakeToggle(S3,"Noms",          "Affiche le pseudo",             "Names")
MakeToggle(S3,"Distance",      "Distance en metres",            "Distance")
MakeToggle(S3,"Outil Tenu",    "Nom de l'outil equipe",         "ToolName")
local S4=MakeSection(P1,"Avance")
MakeToggle(S4,"Tracer",        "Ligne vers les joueurs",        "Tracers")
MakeToggle(S4,"Squelette",     "Squelette des persos",          "Skeletons")
MakeToggle(S4,"Cercle Tete",   "Cercle autour de la tete",      "HeadCircle")
MakeToggle(S4,"Direction",     "Fleche du regard",              "LookDir")
MakeToggle(S4,"Chams 3D",      "Surbrillance 3D",               "Chams")
MakeToggle(S4,"Hors-Ecran",    "Fleche si hors champ",          "OffScreen")
local S5=MakeSection(P1,"Filtres")
MakeToggle(S5,"Ignorer Allies","Pas d'ESP sur allies",          "TeamCheck")

-- ONGLET VISUELS
local P2=CreateTab("Visuels","*")
local S6=MakeSection(P2,"Couleurs Predefinies")
local colorBtns={}
local presets={
    {"Arcane Violet",Color3.fromRGB(123,140,255),Color3.fromRGB(160,170,255),Color3.fromRGB(201,168,76)},
    {"Rouge Vif",    Color3.fromRGB(255,60,60),  Color3.fromRGB(255,230,0),  Color3.fromRGB(255,140,0)},
    {"Cyan Electro", Color3.fromRGB(0,200,255),  Color3.fromRGB(0,255,200),  Color3.fromRGB(0,150,255)},
    {"Vert Neon",    Color3.fromRGB(0,255,100),  Color3.fromRGB(100,255,0),  Color3.fromRGB(0,200,80)},
    {"Or Arcane",    Color3.fromRGB(201,168,76), Color3.fromRGB(255,220,80), Color3.fromRGB(180,130,40)},
    {"Rose Vif",     Color3.fromRGB(255,100,180),Color3.fromRGB(255,150,220),Color3.fromRGB(220,80,160)},
    {"Blanc Pur",    Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Color3.fromRGB(180,180,180)},
    {"Orange Feu",   Color3.fromRGB(255,150,0),  Color3.fromRGB(255,220,0),  Color3.fromRGB(220,100,0)},
}
for _,p in ipairs(presets) do
    local b=MakeColorBtn(S6,p[1],p[2],p[3],p[4],colorBtns)
    table.insert(colorBtns,b)
end

-- ONGLET PARAMETRES
local P3=CreateTab("Params","s")
local S7=MakeSection(P3,"Distances et Epaisseurs")
MakeSlider(S7,"Distance Max",    "Portee de l'ESP",        50,  2000, 500, " m",  function(v) ESP.MaxDistance=v end)
MakeSlider(S7,"Epaisseur Boites","Epaisseur des boites",   1,   5,    2,   " px", function(v) ESP.BoxThick=v end)
MakeSlider(S7,"Epaisseur Tracer","Epaisseur des tracers",  1,   5,    1,   " px", function(v) ESP.TracerThick=v end)
MakeSlider(S7,"Epaisseur Squel.","Epaisseur squelette",    1,   5,    1,   " px", function(v) ESP.SkelThick=v end)

-- ONGLET JOUEUR
local P4=CreateTab("Joueur","!")
local S8=MakeSection(P4,"Mouvements")
MakeSlider(S8,"Vitesse","Vitesse de marche",16,300,16," WS",function(v)
    local c=LP.Character
    if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=v end end
end)
MakeSlider(S8,"Saut","Hauteur de saut",50,400,50," JP",function(v)
    local c=LP.Character
    if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower=v end end
end)

local S9=MakeSection(P4,"Capacites")

-- NoClip
local noclipOn=false
do
    local e,iL,nL,dL=MakeElem(S9)
    nL.Text="NoClip"; dL.Text="Traverser les murs"; iL.Text="O"
    local track=New("Frame",{Size=UDim2.new(0,38,0,21),Position=UDim2.new(1,-48,0.5,-10.5),BackgroundColor3=C.BgVoid,BorderSizePixel=0},e)
    New("UICorner",{CornerRadius=UDim.new(1,0)},track)
    New("UIStroke",{Color=C.Border,Transparency=0.75,Thickness=1},track)
    local thumb=New("Frame",{Size=UDim2.new(0,15,0,15),Position=UDim2.new(0,3,0.5,-7.5),BackgroundColor3=C.TextDim,BorderSizePixel=0},track)
    New("UICorner",{CornerRadius=UDim.new(1,0)},thumb)
    local function applyNC()
        if noclipOn then Tween(track,{BackgroundColor3=C.Accent},0.2); Tween(thumb,{Position=UDim2.new(0,20,0.5,-7.5),BackgroundColor3=C.White},0.2,Enum.EasingStyle.Back)
        else Tween(track,{BackgroundColor3=C.BgVoid},0.2); Tween(thumb,{Position=UDim2.new(0,3,0.5,-7.5),BackgroundColor3=C.TextDim},0.2) end
    end
    local cb=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5},e)
    cb.MouseButton1Click:Connect(function() noclipOn=not noclipOn; applyNC() end)
end

RunService.Stepped:Connect(function()
    if noclipOn then
        local c=LP.Character
        if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    end
end)

-- Spawn
do
    local e,iL,nL,dL=MakeElem(S9)
    nL.Text="Teleporter Spawn"; dL.Text="Retour a (0,5,0)"; iL.Text=">"
    local btn=New("TextButton",{Text="Go",Size=UDim2.new(0,50,0,24),Position=UDim2.new(1,-60,0.5,-12),BackgroundColor3=C.Accent,BackgroundTransparency=0.82,TextColor3=C.AccentBrt,TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0},e)
    New("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    New("UIStroke",{Color=C.Accent,Transparency=0.65,Thickness=1},btn)
    btn.MouseButton1Click:Connect(function()
        local c=LP.Character
        if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame=CFrame.new(0,5,0) end
    end)
end

-- Stats
do
    local sf=New("Frame",{Size=UDim2.new(1,0,0,80),BackgroundColor3=C.BgCard,BorderSizePixel=0,LayoutOrder=nextEO()},P4)
    New("UICorner",{CornerRadius=UDim.new(0,8)},sf)
    New("UIStroke",{Color=C.Border,Transparency=0.82,Thickness=1},sf)
    New("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingTop=UDim.new(0,8)},sf)
    local sl=New("TextLabel",{Size=UDim2.new(1,-20,1,0),BackgroundTransparency=1,TextColor3=C.TextMain,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Text="Chargement...",TextWrapped=true},sf)
    local fps=0
    RunService.Heartbeat:Connect(function(dt) fps=math.floor(1/dt) end)
    RunService.Heartbeat:Connect(function()
        local count=#Players:GetPlayers()-1
        local myC=LP.Character; local hp,mhp=100,100
        if myC then hp,mhp=GetHP(myC) end
        sl.Text=string.format("Joueurs : %d\nVos PV : %.0f / %.0f\nFPS : %d",count,hp,mhp,fps)
    end)
end

-- ═══════════════════════════════════════════════════════════════
--  NOTIFICATION
-- ═══════════════════════════════════════════════════════════════
local function Notify(title,content,dur)
    local nf=New("Frame",{Size=UDim2.new(0,260,0,64),Position=UDim2.new(1,20,1,-80),BackgroundColor3=C.BgPanel,BorderSizePixel=0},screenGui)
    New("UICorner",{CornerRadius=UDim.new(0,10)},nf)
    New("UIStroke",{Color=C.Border,Transparency=0.6,Thickness=1},nf)
    New("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=C.Accent,BorderSizePixel=0},nf)
    New("TextLabel",{Size=UDim2.new(1,-20,0,20),Position=UDim2.new(0,14,0,8),BackgroundTransparency=1,Text=title,TextColor3=C.AccentBrt,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},nf)
    New("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.new(0,14,0,30),BackgroundTransparency=1,Text=content,TextColor3=C.TextSub,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},nf)
    Tween(nf,{Position=UDim2.new(1,-276,1,-80)},0.4,Enum.EasingStyle.Back)
    td(dur or 3.5, function()
        Tween(nf,{Position=UDim2.new(1,20,1,-80)},0.3)
        tw(0.35); nf:Destroy()
    end)
end

Notify("TheWizard ESP","Grimoire active ! Insert = masquer",4)