
--[[
    APEX V91 MOTION | VNX
    Smooth Neon + Liquid Glass + Cyberpunk
]]

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local UIModule = {}
UIModule.__index = UIModule

local GUI_NAME = "APEX_V91_MOTION"

local COLORS = {
    Background = Color3.fromRGB(12, 14, 22),
    Surface = Color3.fromRGB(25, 29, 42),
    Surface2 = Color3.fromRGB(35, 40, 55),
    Accent = Color3.fromRGB(0, 255, 170),
    Blue = Color3.fromRGB(0, 180, 255),
    White = Color3.fromRGB(245, 250, 255),
    Muted = Color3.fromRGB(145, 155, 175)
}

local function Tween(obj, properties, duration)
    local info = TweenInfo.new(
        duration or 0.25,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    local tw = TweenService:Create(obj, info, properties)
    tw:Play()
    return tw
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.Accent
    s.Thickness = thickness or 1
    s.Transparency = 0.2
    s.Parent = parent
    return s
end

local function New(class, properties, parent)
    local obj = Instance.new(class)

    for k, v in pairs(properties or {}) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

function UIModule.CreateWindow(titleText, footerText)
    local self = setmetatable({}, UIModule)

    local player = Players.LocalPlayer
    local parent = game:GetService("CoreGui")

    if not pcall(function()
        parent = player:WaitForChild("PlayerGui")
    end) then
        parent = game:GetService("CoreGui")
    end

    local old = parent:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end

    local gui = New("ScreenGui", {
        Name = GUI_NAME,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, parent)

    self.Gui = gui

    local main = New("Frame", {
        Size = UDim2.fromOffset(280, 100),
        Position = UDim2.new(0.5, -140, 0.5, -50),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0
    }, gui)

    Corner(main, 15)

    local outline = Stroke(main, COLORS.Accent, 2)
    self.Outline = outline

    local gradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.Background),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 35, 48))
        }),
        Rotation = 45
    }, main)

    local scale = New("UIScale", {
        Scale = 0.8
    }, main)

    self.Main = main
    self.Scale = scale
    self.Minimized = false

    Tween(scale, {Scale = 1}, 0.35)

    local title = New("TextLabel", {
        Size = UDim2.new(1, -60, 0, 48),
        Position = UDim2.fromOffset(14, 0),
        BackgroundTransparency = 1,
        Text = titleText or "APEX V91",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    }, main)

    self.TitleLabel = title

    local titleLine = New("Frame", {
        Size = UDim2.new(1, -28, 0, 2),
        Position = UDim2.fromOffset(14, 47),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0
    }, main)

    local minBtn = New("TextButton", {
        Size = UDim2.fromOffset(30, 28),
        Position = UDim2.new(1, -42, 0, 9),
        BackgroundColor3 = COLORS.Surface2,
        Text = "−",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        AutoButtonColor = false
    }, main)

    Corner(minBtn, 7)

    local content = New("ScrollingFrame", {
        Size = UDim2.new(1, -24, 1, -105),
        Position = UDim2.fromOffset(12, 58),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.Accent,
        CanvasSize = UDim2.new()
    }, main)

    local layout = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, content)

    self.Content = content

    local footer = New("TextLabel", {
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.new(0, 12, 1, -25),
        BackgroundTransparency = 1,
        Text = footerText or "POWERED BY VNX",
        TextColor3 = COLORS.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 10
    }, main)

    local function updateSize()
        local height = math.clamp(layout.AbsoluteContentSize.Y, 0, 350)
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        content.Size = UDim2.new(1, -24, 1, -105)
        if not self.Minimized then
            main.Size = UDim2.fromOffset(280, math.clamp(height + 105, 150, 455))
        end
    end

    self.UpdateSize = updateSize
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

    minBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized

        if self.Minimized then
            Tween(main, {Size = UDim2.fromOffset(280, 52)}, 0.25)
            Tween(content, {BackgroundTransparency = 1}, 0.2)
            content.Visible = false
            footer.Visible = false
            minBtn.Text = "+"
        else
            content.Visible = true
            footer.Visible = true
            minBtn.Text = "−"
            updateSize()
        end
    end)

    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundColor3 = COLORS.Accent}, 0.15)
    end)

    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundColor3 = COLORS.Surface2}, 0.15)
    end)

    -- Smooth drag
    local dragging = false
    local dragStart, startPos

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            Tween(main, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.08)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Neon pulse
    task.spawn(function()
        while gui.Parent do
            Tween(outline, {Transparency = 0.65}, 1)
            task.wait(1)
            if not gui.Parent then break end
            Tween(outline, {Transparency = 0.1}, 1)
            task.wait(1)
        end
    end)

    return self
end

function UIModule:SetTitle(text)
    self.TitleLabel.Text = tostring(text)
end

function UIModule:CreateButton(txt, cb)
    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.Surface,
        Text = tostring(txt),
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        AutoButtonColor = false
    }, self.Content)

    Corner(btn, 9)
    local stroke = Stroke(btn, COLORS.Surface2, 1)

    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = COLORS.Surface2}, 0.15)
        Tween(stroke, {Color = COLORS.Accent}, 0.15)
    end)

    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = COLORS.Surface}, 0.15)
        Tween(stroke, {Color = COLORS.Surface2}, 0.15)
    end)

    btn.MouseButton1Down:Connect(function()
        Tween(btn, {BackgroundColor3 = COLORS.Accent}, 0.08)
    end)

    btn.MouseButton1Click:Connect(function()
        Tween(btn, {BackgroundColor3 = COLORS.Surface2}, 0.15)
        if cb then cb(btn) end
    end)

    self.UpdateSize()
    return btn
end

function UIModule:CreateToggle(txt, default, cb)
    local state = default == true

    local btn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = COLORS.Surface,
        Text = "  " .. txt,
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, self.Content)

    Corner(btn, 9)

    local switch = New("Frame", {
        Size = UDim2.fromOffset(38, 20),
        Position = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = COLORS.Surface2
    }, btn)

    Corner(switch, 20)

    local dot = New("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = COLORS.White
    }, switch)

    Corner(dot, 20)

    local function update()
        Tween(switch, {
            BackgroundColor3 = state and COLORS.Accent or COLORS.Surface2
        }, 0.2)

        Tween(dot, {
            Position = state and UDim2.new(1, -17, 0, 3)
                or UDim2.fromOffset(3, 3)
        }, 0.2)
    end

    update()

    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
        if cb then cb(state) end
    end)

    self.UpdateSize()
    return btn
end

function UIModule:CreateSlider(txt, min, max, default, cb)
    min = min or 0
    max = max or 100

    assert(max > min, "Slider max must be greater than min")

    local value = math.clamp(default or min, min, max)

    local frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = COLORS.Surface
    }, self.Content)

    Corner(frame, 9)

    local label = New("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.fromOffset(10, 3),
        BackgroundTransparency = 1,
        Text = txt .. ": " .. value,
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local track = New("TextButton", {
        Size = UDim2.new(1, -20, 0, 8),
        Position = UDim2.fromOffset(10, 37),
        BackgroundColor3 = COLORS.Surface2,
        Text = "",
        AutoButtonColor = false
    }, frame)

    Corner(track, 10)

    local fill = New("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = COLORS.Accent
    }, track)

    Corner(fill, 10)

    local dragging = false

    local function update(input)
        local pos = math.clamp(
            (input.Position.X - track.AbsolutePosition.X)
            / track.AbsoluteSize.X, 0, 1
        )

        value = math.floor(min + (max - min) * pos)
        Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.08)
        label.Text = txt .. ": " .. value

        if cb then cb(value) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            update(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    self.UpdateSize()
    return frame
end

function UIModule:CreateDropdown(txt, options, default, cb)
    options = options or {}

    local selected = default or options[1] or "None"
    local opened = false

    local frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.Surface,
        ClipsDescendants = true
    }, self.Content)

    Corner(frame, 9)

    local mainBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        Text = "  " .. txt .. ": " .. selected .. "     ▼",
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, frame)

    local container = New("Frame", {
        Size = UDim2.new(1, -12, 0, 0),
        Position = UDim2.fromOffset(6, 44),
        BackgroundTransparency = 1
    }, frame)

    local layout = New("UIListLayout", {
        Padding = UDim.new(0, 4)
    }, container)

    local function toggle()
        opened = not opened

        local height = opened
            and (46 + #options * 32)
            or 42

        Tween(frame, {
            Size = UDim2.new(1, 0, 0, height)
        }, 0.25)

        Tween(container, {
            Size = UDim2.new(1, -12, 0, opened and #options * 32 or 0)
        }, 0.25)

        mainBtn.Text = "  " .. txt .. ": " .. selected
            .. (opened and "     ▲" or "     ▼")

        self.UpdateSize()
    end

    mainBtn.MouseButton1Click:Connect(toggle)

    for _, option in ipairs(options) do
        local opt = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = COLORS.Surface2,
            Text = tostring(option),
            TextColor3 = COLORS.White,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            AutoButtonColor = false
        }, container)

        Corner(opt, 6)

        opt.MouseButton1Click:Connect(function()
            selected = tostring(option)
            mainBtn.Text = "  " .. txt .. ": " .. selected .. "     ▼"

            if opened then toggle() end
            if cb then cb(selected) end
        end)
    end

    self.UpdateSize()
    return frame
end

function UIModule:CreateInput(txt, placeholder, cb)
    local frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = COLORS.Surface
    }, self.Content)

    Corner(frame, 9)

    local label = New("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = COLORS.White,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local box = New("TextBox", {
        Size = UDim2.new(0.55, -8, 0, 29),
        Position = UDim2.new(0.43, 0, 0.5, -14),
        BackgroundColor3 = COLORS.Surface2,
        Text = "",
        PlaceholderText = placeholder or "Enter text...",
        PlaceholderColor3 = COLORS.Muted,
        TextColor3 = COLORS.Accent,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        ClearTextOnFocus = false
    }, frame)

    Corner(box, 7)

    local stroke = Stroke(box, COLORS.Surface2, 1)

    box.Focused:Connect(function()
        Tween(stroke, {Color = COLORS.Accent}, 0.2)
    end)

    box.FocusLost:Connect(function(enter)
        Tween(stroke, {Color = COLORS.Surface2}, 0.2)
        if cb then cb(box.Text, enter) end
    end)

    self.UpdateSize()
    return frame
end

function UIModule:Clear()
    for _, child in ipairs(self.Content:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    self.UpdateSize()
end

function UIModule:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

return UIModule
