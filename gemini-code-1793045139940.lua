-- =================================================================
-- TOBOX AIM + ВХ [MINECRAFT TOOLBOX STYLE]
-- Authors: Nazik & Jura
-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local PlayerGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("ToboxHub") then PlayerGui.ToboxHub:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("ToboxLoop") end)

local Features = {
    Aimbot = false, InstantLock = true, AimbotFOV = 150, TeamCheck = false, AimTarget = "Head",
    ESP_Box = false, ESP_BoxColor = Color3.fromRGB(118, 185, 0),
    ESP_FOVColor = Color3.fromRGB(118, 185, 0), ESP_Tracers = false, ESP_Names = false,
    SpeedHack = false, SpeedValue = 50, JumpHack = false, JumpValue = 120, Noclip = false, InfJump = false
}

local ColorPalette = {
    Color3.fromRGB(255, 50, 50),   -- Червоний
    Color3.fromRGB(118, 185, 0),  -- Зелений Toolbox
    Color3.fromRGB(0, 150, 255),  -- Синій
    Color3.fromRGB(255, 220, 0),  -- Жовтий
    Color3.fromRGB(255, 130, 0),  -- Оранжевий
    Color3.fromRGB(160, 32, 240), -- Фіолетовий
    Color3.fromRGB(255, 105, 180),-- Рожевий
    Color3.fromRGB(0, 230, 230),  -- Блакитний
    Color3.fromRGB(255, 255, 255),-- Білий
    Color3.fromRGB(20, 20, 20)    -- Чорний
}

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ToboxHub"
ScreenGui.ResetOnSpawn = false

local function ApplySharpStyle(inst, bg, str)
    inst.BackgroundColor3 = bg or Color3.fromRGB(35, 35, 35)
    inst.BorderSizePixel = 0
    local corner = Instance.new("UICorner", inst) corner.CornerRadius = UDim.new(0, 0)
    local stroke = Instance.new("UIStroke", inst)
    stroke.Color = str or Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
end

local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 650, 0, 480), UDim2.new(0.5, -325, 0.5, -240)
Main.Active, Main.Draggable = true, true
ApplySharpStyle(Main, Color3.fromRGB(30, 30, 30), Color3.fromRGB(70, 70, 70))

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
ApplySharpStyle(Header, Color3.fromRGB(20, 20, 20), Color3.fromRGB(50, 50, 50))

local Title = Instance.new("TextLabel", Header)
Title.Size, Title.Position, Title.BackgroundTransparency = UDim2.new(1, -50, 1, 0), UDim2.new(0, 15, 0, 0), 1
Title.Text, Title.TextColor3, Title.TextSize, Title.Font = "Tobox aim + вх", Color3.fromRGB(118, 185, 0), 18, Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 40, 0, 40), UDim2.new(1, -40, 0, 0)
CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize = "✕", Color3.fromRGB(200, 200, 200), 18
ApplySharpStyle(CloseBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local OpenToggle = Instance.new("TextButton", ScreenGui)
OpenToggle.Size, OpenToggle.Position = UDim2.new(0, 90, 0, 35), UDim2.new(0, 10, 0.4, 0)
OpenToggle.Text, OpenToggle.TextColor3, OpenToggle.TextSize = "Tobox UI", Color3.fromRGB(255, 255, 255), 14
OpenToggle.Active, OpenToggle.Draggable = true, true
ApplySharpStyle(OpenToggle, Color3.fromRGB(118, 185, 0), Color3.fromRGB(140, 210, 0))
OpenToggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size, Sidebar.Position = UDim2.new(0, 140, 1, -40), UDim2.new(0, 0, 0, 40)
ApplySharpStyle(Sidebar, Color3.fromRGB(25, 25, 25), Color3.fromRGB(45, 45, 45))

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.SortOrder = Enum.SortOrder.LayoutOrder

local ContentHolder = Instance.new("Frame", Main)
ContentHolder.Size, ContentHolder.Position = UDim2.new(1, -140, 1, -40), UDim2.new(0, 140, 0, 40)
ContentHolder.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name, iconText)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Text = "  " .. iconText .. " " .. name
    btn.TextColor3, btn.TextSize, btn.Font = Color3.fromRGB(180, 180, 180), 15, Enum.Font.SourceSansBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    ApplySharpStyle(btn, Color3.fromRGB(25, 25, 25), Color3.fromRGB(35, 35, 35))

    local page = Instance.new("ScrollingFrame", ContentHolder)
    page.Size, page.Position, page.Visible = UDim2.new(1, -20, 1, -20), UDim2.new(0, 10, 0, 10), false
    page.BackgroundTransparency, page.ScrollBarThickness = 1, 4
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIGridLayout", page)
    layout.CellSize = UDim2.new(0, 230, 0, 50)
    layout.CellPadding = UDim2.new(0, 10, 0, 10)

    Tabs[name] = {Btn = btn, Page = page}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(118, 185, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return page
end

local AimPage = CreateTab("Аімбот", "🎯")
local EspPage = CreateTab("ВХ / ESP", "👁️")
local CharPage = CreateTab("Персонаж", "🏃")
local SettPage = CreateTab("Налаштування", "⚙️")

Tabs["Аімбот"].Page.Visible = true
Tabs["Аімбот"].Btn.BackgroundColor3 = Color3.fromRGB(118, 185, 0)
Tabs["Аімбот"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

local function AddToggle(page, name, key)
    local card = Instance.new("TextButton", page)
    card.Text = name
    card.TextColor3, card.Font, card.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
    
    local function update()
        if Features[key] then
            ApplySharpStyle(card, Color3.fromRGB(118, 185, 0), Color3.fromRGB(150, 220, 0))
        else
            ApplySharpStyle(card, Color3.fromRGB(45, 45, 45), Color3.fromRGB(60, 60, 60))
        end
    end
    card.MouseButton1Click:Connect(function() Features[key] = not Features[key] update() end)
    update()
end

local function AddColorPicker(page, name, key)
    local card = Instance.new("Frame", page)
    ApplySharpStyle(card, Color3.fromRGB(45, 45, 45), Color3.fromRGB(60, 60, 60))

    local lbl = Instance.new("TextLabel", card)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 5, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = name, Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local colorPreview = Instance.new("TextButton", card)
    colorPreview.Size, colorPreview.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 10)
    colorPreview.Text = ""
    ApplySharpStyle(colorPreview, Features[key], Color3.fromRGB(255, 255, 255))

    local pickerFrame = Instance.new("Frame", ScreenGui)
    pickerFrame.Size, pickerFrame.Position, pickerFrame.Visible = UDim2.new(0, 170, 0, 75), UDim2.new(0.5, -85, 0.5, -37), false
    ApplySharpStyle(pickerFrame, Color3.fromRGB(20, 20, 20), Color3.fromRGB(118, 185, 0))
    pickerFrame.ZIndex = 10

    local grid = Instance.new("UIGridLayout", pickerFrame)
    grid.CellSize, grid.CellPadding = UDim2.new(0, 28, 0, 28), UDim2.new(0, 4, 0, 4)

    for _, color in ipairs(ColorPalette) do
        local sq = Instance.new("TextButton", pickerFrame)
        sq.Text, sq.ZIndex = "", 11
        ApplySharpStyle(sq, color, Color3.fromRGB(0, 0, 0))
        sq.MouseButton1Click:Connect(function()
            Features[key] = color
            colorPreview.BackgroundColor3 = color
            pickerFrame.Visible = false
        end)
    end

    colorPreview.MouseButton1Click:Connect(function()
        pickerFrame.Visible = not pickerFrame.Visible
    end)
end

AddToggle(AimPage, "Аімбот (Затиснути ПКМ)", "Aimbot")
AddToggle(AimPage, "Instant Lock", "InstantLock")
AddToggle(AimPage, "Team Check", "TeamCheck")

AddToggle(EspPage, "ВХ Бокси (Box)", "ESP_Box")
AddToggle(EspPage, "Лінії (Tracers)", "ESP_Tracers")
AddToggle(EspPage, "Нікнейми (Names)", "ESP_Names")
AddColorPicker(EspPage, "Колір Боксу", "ESP_BoxColor")
AddColorPicker(EspPage, "Колір FOV", "ESP_FOVColor")

AddToggle(CharPage, "SpeedHack", "SpeedHack")
AddToggle(CharPage, "Super Jump", "JumpHack")
AddToggle(CharPage, "Noclip", "Noclip")
AddToggle(CharPage, "Inf Jump", "InfJump")

local KillBtn = Instance.new("TextButton", SettPage)
KillBtn.Text = "🛑 ВИМКНУТИ СКРИПТ"
KillBtn.TextColor3, KillBtn.Font, KillBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
ApplySharpStyle(KillBtn, Color3.fromRGB(180, 40, 40), Color3.fromRGB(220, 50, 50))
KillBtn.MouseButton1Click:Connect(function()
    pcall(function() RunService:UnbindFromRenderStep("ToboxLoop") end)
    ScreenGui:Destroy()
end)

local AuthorLabel = Instance.new("TextLabel", Main)
AuthorLabel.Size, AuthorLabel.Position = UDim2.new(1, -150, 0, 25), UDim2.new(0, 145, 1, -25)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Text = "Autor by nazik and jura"
AuthorLabel.Font, AuthorLabel.TextSize = Enum.Font.SourceSansBold, 16
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 0.01) % 1
        AuthorLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Filled, FOVCircle.Visible = 1.5, false, false

local ESP_Store = {}
RunService:BindToRenderStep("ToboxLoop", Enum.RenderPriority.Camera.Value + 1, function()
    local mPos = UserInputService:GetMouseLocation()
    FOVCircle.Position, FOVCircle.Radius, FOVCircle.Color, FOVCircle.Visible = mPos, Features.AimbotFOV, Features.ESP_FOVColor, Features.Aimbot

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if not ESP_Store[p] then
                ESP_Store[p] = {Box = Drawing.new("Square"), Tracer = Drawing.new("Line"), Name = Drawing.new("Text")}
                ESP_Store[p].Box.Thickness, ESP_Store[p].Name.Size, ESP_Store[p].Name.Center = 1.5, 14, true
            end
            local e, ch = ESP_Store[p], p.Character
            local hum, root, head = ch and ch:FindFirstChildOfClass("Humanoid"), ch and ch:FindFirstChild("HumanoidRootPart"), ch and ch:FindFirstChild("Head")
            local valid = ch and root and head and hum and hum.Health > 0 and not (Features.TeamCheck and p.Team == LocalPlayer.Team)

            if valid then
                local v, onS = Camera:WorldToViewportPoint(root.Position)
                local hV, lV = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)), Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                if onS then
                    local h = math.abs(hV.Y - lV.Y) local w = h / 1.8
                    e.Box.Visible, e.Box.Size, e.Box.Position, e.Box.Color = Features.ESP_Box, Vector2.new(w, h), Vector2.new(v.X - w/2, hV.Y), Features.ESP_BoxColor
                    e.Tracer.Visible, e.Tracer.From, e.Tracer.To, e.Tracer.Color = Features.ESP_Tracers, Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y), Vector2.new(v.X, lV.Y), Features.ESP_BoxColor
                    e.Name.Visible, e.Name.Text, e.Name.Position = Features.ESP_Names, p.Name, Vector2.new(v.X, hV.Y - 16)
                else e.Box.Visible, e.Tracer.Visible, e.Name.Visible = false, false, false end
            else if e.Box then e.Box.Visible, e.Tracer.Visible, e.Name.Visible = false, false, false end end
        end
    end

    if Features.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target, minD = nil, Features.AimbotFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not (Features.TeamCheck and p.Team == LocalPlayer.Team) then
                    local pos, onS = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onS then
                        local d = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                        if d < minD then minD = d target = p.Character.Head end
                    end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if Features.SpeedHack then hum.WalkSpeed = Features.SpeedValue end
        if Features.JumpHack then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
    end
end)