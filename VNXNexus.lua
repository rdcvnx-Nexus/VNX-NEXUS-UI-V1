
-- VNX NEXUS UI v1.0
-- Single Script Library
-- Roblox Studio / LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local VNX = {}
VNX.__index = VNX

local Theme = {
    Background = Color3.fromRGB(10, 13, 20),
    Surface = Color3.fromRGB(20, 25, 36),
    Hover = Color3.fromRGB(31, 40, 56),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(245, 248, 255),
    Muted = Color3.fromRGB(145, 160, 180),
    Green = Color3.fromRGB(0, 220, 130)
}

local function New(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function Round(obj, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function Outline(obj, color)
    New("UIStroke", {
        Color = color or Theme.Accent,
        Thickness = 1,
        Transparency = 0.35
    }, obj)
end

local function Animate(obj, props)
    TweenService:Create(
        obj,
        TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function SafeCall(callback, ...)
    if callback then
        local ok, err = pcall(callback, ...)
        if not ok then
            warn("[VNX Nexus] " .. tostring(err))
        end
    end
end

function VNX.new(config)
    config = config or {}

    local self = setmetatable({}, VNX)
    self.Tabs = {}

    local old = PlayerGui:FindFirstChild("VNX_Nexus")
    if old then old:Destroy() end

    self.Gui = New("ScreenGui", {
        Name = "VNX_Nexus",
        ResetOnSpawn = false,
        DisplayOrder = 100
    }, PlayerGui)

    local main = New("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(320, 280),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, self.Gui)

    Round(main, 12)
    Outline(main)
    self.Main = main

    local header = New("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0
    }, main)

    local title = New("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -90, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "VNX NEXUS",
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, header)

    self.TitleLabel = title

    local minimize = New("TextButton", {
        Position = UDim2.new(1, -39, 0, 9),
        Size = UDim2.fromOffset(28, 28),
        Text = "−",
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        BackgroundColor3 = Theme.Background
    }, header)
    Round(minimize, 6)

    local tabBar = New("ScrollingFrame", {
        Position = UDim2.fromOffset(10, 55),
        Size = UDim2.new(1, -20, 0, 34),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.X
    }, main)

    local tabLayout = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6)
    }, tabBar)

    self.TabBar = tabBar

    local contentArea = New("Frame", {
        Position = UDim2.fromOffset(10, 98),
        Size = UDim2.new(1, -20, 1, -108),
        BackgroundTransparency = 1
    }, main)

    self.ContentArea = contentArea

    local minimized = false
    minimize.Activated:Connect(function()
        minimized = not minimized
        contentArea.Visible = not minimized
        tabBar.Visible = not minimized

        Animate(main, {
            Size = minimized
                and UDim2.fromOffset(320, 48)
                or UDim2.fromOffset(320, 280)
        })

        minimize.Text = minimized and "+" or "−"
    end)

    -- Drag window
    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(input)
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
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    function self:Notify(message, duration)
        local note = New("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 320, 0, 12),
            Size = UDim2.fromOffset(260, 48),
            BackgroundColor3 = Theme.Surface,
            Text = tostring(message),
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            TextWrapped = true
        }, self.Gui)

        Round(note, 8)
        Outline(note)
        Animate(note, {Position = UDim2.new(1, -12, 0, 12)})

        task.delay(duration or 3, function()
            if note.Parent then
                Animate(note, {Position = UDim2.new(1, 300, 0, 12)})
                task.wait(0.25)
                note:Destroy()
            end
        end)
    end

    function self:CreateTab(name)
        local page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Visible = false
        }, contentArea)

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 7),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }, page)

        local padding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 8)
        }, page)

        local tabButton = New("TextButton", {
            Size = UDim2.fromOffset(85, 30),
            BackgroundColor3 = Theme.Surface,
            Text = tostring(name),
            TextColor3 = Theme.Muted,
            TextSize = 11,
            Font = Enum.Font.GothamSemibold
        }, tabBar)
        Round(tabButton, 6)

        local tab = setmetatable({}, VNX)
        tab.Gui = self.Gui
        tab.Content = page
        tab.Window = self

        local function selectTab()
            for _, item in ipairs(self.Tabs) do
                item.Page.Visible = false
                item.Button.BackgroundColor3 = Theme.Surface
                item.Button.TextColor3 = Theme.Muted
            end

            page.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
            tabButton.TextColor3 = Theme.Text
        end

        tabButton.Activated:Connect(selectTab)

        table.insert(self.Tabs, {
            Page = page,
            Button = tabButton
        })

        if #self.Tabs == 1 then
            selectTab()
        end

        return tab
    end

    function self:CreateButton(text, callback)
        local button = New("TextButton", {
            Size = UDim2.new(0.96, 0, 0, 38),
            BackgroundColor3 = Theme.Surface,
            Text = tostring(text),
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            AutoButtonColor = false
        }, self.Content)

        Round(button, 7)
        Outline(button)

        button.Activated:Connect(function()
            Animate(button, {BackgroundColor3 = Theme.Accent})
            task.delay(0.15, function()
                if button.Parent then
                    Animate(button, {BackgroundColor3 = Theme.Surface})
                end
            end)
            SafeCall(callback, button)
        end)

        return button
    end

    function self:CreateToggle(text, default, callback)
        local state = default == true

        local button = New("TextButton", {
            Size = UDim2.new(0.96, 0, 0, 38),
            BackgroundColor3 = Theme.Surface,
            Text = "",
            AutoButtonColor = false
        }, self.Content)

        Round(button, 7)
        Outline(button)

        New("TextLabel", {
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(1, -55, 1, 0),
            BackgroundTransparency = 1,
            Text = tostring(text),
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left
        }, button)

        local indicator = New("Frame", {
            Position = UDim2.new(1, -38, 0.5, -8),
            Size = UDim2.fromOffset(26, 16),
            BackgroundColor3 = state and Theme.Green or Theme.Muted
        }, button)
        Round(indicator, 8)

        button.Activated:Connect(function()
            state = not state
            Animate(indicator, {
                BackgroundColor3 = state and Theme.Green or Theme.Muted
            })
            SafeCall(callback, state)
        end)

        return button
    end

    function self:CreateSlider(text, min, max, default, callback)
        min = min or 0
        max = max or 100
        if max <= min then max = min + 1 end

        local value = math.clamp(default or min, min, max)

        local frame = New("Frame", {
            Size = UDim2.new(0.96, 0, 0, 52),
            BackgroundColor3 = Theme.Surface
        }, self.Content)
        Round(frame, 7)
        Outline(frame)

        local label = New("TextLabel", {
            Position = UDim2.fromOffset(9, 2),
            Size = UDim2.new(1, -18, 0, 20),
            BackgroundTransparency = 1,
            Text = text .. ": " .. tostring(value),
            TextColor3 = Theme.Text,
            TextSize = 11,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left
        }, frame)

        local track = New("TextButton", {
            Position = UDim2.fromOffset(9, 32),
            Size = UDim2.new(1, -18, 0, 7),
            BackgroundColor3 = Theme.Background,
            Text = ""
        }, frame)
        Round(track, 5)

        local fill = New("Frame", {
            Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.Accent
        }, track)
        Round(fill, 5)

        local dragging = false

        local function update(input)
            local width = track.AbsoluteSize.X
            if width <= 0 then return end

            local pct = math.clamp(
                (input.Position.X - track.AbsolutePosition.X) / width,
                0, 1
            )

            value = math.floor(min + (max - min) * pct)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            label.Text = text .. ": " .. tostring(value)
            SafeCall(callback, value)
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

        return frame
    end

    function self:CreateDropdown(text, options, default, callback)
        options = options or {}
        local selected = default or options[1] or "None"
        local opened = false

        local frame = New("Frame", {
            Size = UDim2.new(0.96, 0, 0, 36),
            BackgroundColor3 = Theme.Surface,
            ClipsDescendants = true
        }, self.Content)
        Round(frame, 7)
        Outline(frame)

        local mainButton = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Text = text .. ": " .. tostring(selected),
            TextColor3 = Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamSemibold
        }, frame)

        local list = New("Frame", {
            Position = UDim2.fromOffset(5, 38),
            Size = UDim2.new(1, -10, 0, #options * 29),
            BackgroundTransparency = 1
        }, frame)

        New("UIListLayout", {
            Padding = UDim.new(0, 3)
        }, list)

        local function toggle()
            opened = not opened
            Animate(frame, {
                Size = UDim2.new(
                    0.96, 0, 0,
                    opened and (38 + #options * 29) or 36
                )
            })
        end

        mainButton.Activated:Connect(toggle)

        for _, option in ipairs(options) do
            local opt = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = Theme.Hover,
                Text = tostring(option),
                TextColor3 = Theme.Text,
                TextSize = 11,
                Font = Enum.Font.Gotham
            }, list)
            Round(opt, 5)

            opt.Activated:Connect(function()
                selected = option
                mainButton.Text = text .. ": " .. tostring(selected)
                toggle()
                SafeCall(callback, selected)
            end)
        end

        return frame
    end

    function self:CreateInput(text, placeholder, callback)
        local frame = New("Frame", {
            Size = UDim2.new(0.96, 0, 0, 40),
            BackgroundColor3 = Theme.Surface
        }, self.Content)
        Round(frame, 7)
        Outline(frame)

        New("TextLabel", {
            Position = UDim2.fromOffset(9, 0),
            Size = UDim2.new(0.4, -5, 1, 0),
            BackgroundTransparency = 1,
            Text = tostring(text),
            TextColor3 = Theme.Text,
            TextSize = 11,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left
        }, frame)

        local box = New("TextBox", {
            Position = UDim2.new(0.42, 0, 0.5, -13),
            Size = UDim2.new(0.55, -5, 0, 26),
            BackgroundColor3 = Theme.Background,
            Text = "",
            PlaceholderText = placeholder or "Type here...",
            TextColor3 = Theme.Text,
            PlaceholderColor3 = Theme.Muted,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false
        }, frame)
        Round(box, 5)

        box.FocusLost:Connect(function(enterPressed)
            SafeCall(callback, box.Text, enterPressed)
        end)

        return frame
    end

    function self:Clear()
        for _, child in ipairs(self.Content:GetChildren()) do
            if not child:IsA("UIListLayout")
            and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
    end

    function self:Destroy()
        if self.Gui then
            self.Gui:Destroy()
        end
    end

    return self
end

-- Example:
-- local Window = VNX.new({Title = "VNX NEXUS"})
-- local Main = Window:CreateTab("Main")
-- Main:CreateButton("Test", function()
--     Window:Notify("Hello from VNX!")
-- end)

return VNX
