
--[[
    VNX NEXUS UI V1
    Liquid Glass Edition
    Powered by VNX
]]

local VNX = {}
VNX.Version = "1.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(8, 11, 18),
    Surface = Color3.fromRGB(17, 22, 33),
    Surface2 = Color3.fromRGB(25, 32, 46),
    Accent = Color3.fromRGB(0, 145, 255),
    Accent2 = Color3.fromRGB(0, 210, 255),
    Text = Color3.fromRGB(240, 245, 255),
    Muted = Color3.fromRGB(145, 160, 185),
    Border = Color3.fromRGB(55, 75, 105)
}

local function Create(class, props, parent)
    local object = Instance.new(class)

    for key, value in pairs(props or {}) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 14)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Transparency = transparency or 0.5,
        Thickness = 1
    }, parent)
end

local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function Label(parent, text, size, color, font)
    return Create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or Theme.Text,
        TextSize = size or 14,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function VNX.new(config)
    config = config or {}

    local Window = {}
    Window.Tabs = {}

    local gui = Create("ScreenGui", {
        Name = "VNX_Nexus_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local parent

    if typeof(gethui) == "function" then
        local success, result = pcall(gethui)
        if success then
            parent = result
        end
    end

    if not parent then
        parent = CoreGui
    end

    gui.Parent = parent

    Window.Gui = gui

    -- MAIN WINDOW

    local Main = Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.fromOffset(760, 490),
        Position = UDim2.new(0.5, -380, 0.5, -245),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0
    }, gui)

    Corner(Main, 22)
    Stroke(Main, Theme.Accent, 0.25)

    local Gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 23, 40)),
            ColorSequenceKeypoint.new(0.5, Theme.Background),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 20, 34))
        }),
        Rotation = 35
    }, Main)

    -- SIDEBAR

    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 175, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 15, 25),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0
    }, Main)

    Corner(Sidebar, 22)

    local Logo = Label(
        Sidebar,
        "✦  VNX",
        25,
        Theme.Accent2,
        Enum.Font.GothamBold
    )
    Logo.Position = UDim2.fromOffset(20, 20)
    Logo.Size = UDim2.new(1, -30, 0, 35)

    local Brand = Label(
        Sidebar,
        "NEXUS UI",
        12,
        Theme.Muted,
        Enum.Font.GothamMedium
    )
    Brand.Position = UDim2.fromOffset(22, 53)
    Brand.Size = UDim2.new(1, -30, 0, 20)

    local Powered = Label(
        Sidebar,
        "POWERED BY VNX",
        10,
        Theme.Accent2,
        Enum.Font.GothamBold
    )
    Powered.Position = UDim2.new(0, 20, 1, -35)
    Powered.Size = UDim2.new(1, -30, 0, 20)

    -- HEADER

    local Header = Create("Frame", {
        Position = UDim2.fromOffset(175, 0),
        Size = UDim2.new(1, -175, 0, 65),
        BackgroundTransparency = 1
    }, Main)

    local Title = Label(
        Header,
        config.Title or "VNX NEXUS UI",
        20,
        Theme.Text,
        Enum.Font.GothamBold
    )
    Title.Position = UDim2.fromOffset(20, 5)
    Title.Size = UDim2.new(1, -180, 1, -10)

    local function HeaderButton(text, position)
        local button = Create("TextButton", {
            Size = UDim2.fromOffset(38, 38),
            Position = position,
            BackgroundColor3 = Theme.Surface2,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false
        }, Header)

        Corner(button, 13)
        Stroke(button, Theme.Border, 0.6)

        button.MouseEnter:Connect(function()
            Tween(button, {BackgroundColor3 = Theme.Accent}, 0.2)
        end)

        button.MouseLeave:Connect(function()
            Tween(button, {BackgroundColor3 = Theme.Surface2}, 0.2)
        end)

        return button
    end

    local Minimize = HeaderButton("—", UDim2.new(1, -132, 0, 13))
    local Close = HeaderButton("×", UDim2.new(1, -48, 0, 13))

    -- CONTENT

    local Content = Create("Frame", {
        Position = UDim2.fromOffset(190, 75),
        Size = UDim2.new(1, -205, 1, -90),
        BackgroundTransparency = 1
    }, Main)

    local TabButtons = Create("ScrollingFrame", {
        Size = UDim2.new(0, 145, 1, -95),
        Position = UDim2.fromOffset(15, 85),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new()
    }, Main)

    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabButtons)

    local Pages = Create("Folder", {
        Name = "Pages"
    }, Content)

    local ActiveTab

    local function SelectTab(tab)
        ActiveTab = tab

        for _, item in pairs(Window.Tabs) do
            Tween(item.Button, {
                BackgroundColor3 = item == tab and Theme.Accent or Theme.Surface
            }, 0.2)

            item.Page.Visible = item == tab
        end
    end

    -- NOTIFICATION

    function Window:Notify(message)
        local Notification = Create("Frame", {
            Size = UDim2.fromOffset(250, 75),
            Position = UDim2.new(1, 280, 0, 20),
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 0.04,
            BorderSizePixel = 0
        }, gui)

        Corner(Notification, 16)
        Stroke(Notification, Theme.Accent, 0.25)

        local Heading = Label(
            Notification,
            "✦  VNX NOTIFICATION",
            12,
            Theme.Accent2,
            Enum.Font.GothamBold
        )
        Heading.Position = UDim2.fromOffset(15, 8)
        Heading.Size = UDim2.new(1, -25, 0, 20)

        local Message = Label(
            Notification,
            tostring(message),
            13,
            Theme.Text
        )
        Message.Position = UDim2.fromOffset(15, 33)
        Message.Size = UDim2.new(1, -25, 0, 28)
        Message.TextWrapped = true

        Tween(Notification, {
            Position = UDim2.new(1, -270, 0, 20)
        }, 0.35)

        task.delay(3, function()
            if Notification.Parent then
                Tween(Notification, {
                    Position = UDim2.new(1, 280, 0, 20)
                }, 0.3)

                task.wait(0.35)
                Notification:Destroy()
            end
        end)
    end

    -- MINIMIZE PILL

    local Pill = Create("TextButton", {
        Name = "VNXFloatingPill",
        Size = UDim2.fromOffset(155, 43),
        Position = UDim2.new(0.5, -77, 1, 80),
        BackgroundColor3 = Theme.Surface,
        Text = "✦  VNX NEXUS",
        TextColor3 = Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Visible = true
    }, gui)

    Corner(Pill, 22)
    Stroke(Pill, Theme.Accent, 0.2)

    MakeDraggable(Main, Header)
    MakeDraggable(Pill, Pill)

    Minimize.MouseButton1Click:Connect(function()
        Tween(Main, {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        }, 0.2)

        task.wait(0.2)
        Main.Visible = false
        Pill.Visible = true

        Tween(Pill, {
            Position = UDim2.new(0.5, -77, 1, -75)
        }, 0.3)
    end)

    Pill.MouseButton1Click:Connect(function()
        Main.Visible = true
        Main.Size = UDim2.fromOffset(0, 0)
        Main.BackgroundTransparency = 1

        Tween(Main, {
            Size = UDim2.fromOffset(760, 490),
            BackgroundTransparency = 0.08
        }, 0.3)

        Tween(Pill, {
            Position = UDim2.new(0.5, -77, 1, 80)
        }, 0.2)

        task.wait(0.2)
        Pill.Visible = false
    end)

    Close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- CREATE TAB

    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name

        local Button = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = Theme.Surface,
            Text = "   " .. name,
            TextColor3 = Theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, TabButtons)

        Corner(Button, 12)

        local Page = Create("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new()
        }, Pages)

        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(
                0, 0, 0, Layout.AbsoluteContentSize.Y + 15
            )
        end)

        Tab.Button = Button
        Tab.Page = Page

        function Tab:AddCard(title, description)
            local Card = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 65),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.08,
                BorderSizePixel = 0
            }, Page)

            Corner(Card, 14)
            Stroke(Card, Theme.Border, 0.65)

            local T = Label(Card, title, 14, Theme.Text, Enum.Font.GothamBold)
            T.Position = UDim2.fromOffset(15, 8)
            T.Size = UDim2.new(1, -25, 0, 22)

            local D = Label(Card, description or "", 11, Theme.Muted)
            D.Position = UDim2.fromOffset(15, 33)
            D.Size = UDim2.new(1, -25, 0, 20)

            return Card
        end

        function Tab:CreateButton(text, callback)
            local Card = Tab:AddCard(text, "Tap to execute this action")

            local Button = Create("TextButton", {
                Size = UDim2.fromOffset(80, 32),
                Position = UDim2.new(1, -92, 0, 16),
                BackgroundColor3 = Theme.Accent,
                Text = "RUN  →",
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false
            }, Card)

            Corner(Button, 10)

            Button.MouseButton1Click:Connect(function()
                if callback then
                    task.spawn(callback)
                end
            end)

            return Card
        end

        function Tab:CreateToggle(text, default, callback)
            local Card = Tab:AddCard(text, "Enable or disable")

            local enabled = default == true

            local Toggle = Create("TextButton", {
                Size = UDim2.fromOffset(48, 26),
                Position = UDim2.new(1, -65, 0, 19),
                BackgroundColor3 = enabled and Theme.Accent or Theme.Surface2,
                Text = "",
                AutoButtonColor = false
            }, Card)

            Corner(Toggle, 15)

            local Circle = Create("Frame", {
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.fromOffset(enabled and 25 or 3, 3),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0
            }, Toggle)

            Corner(Circle, 12)

            local function Update()
                Tween(Toggle, {
                    BackgroundColor3 = enabled and Theme.Accent or Theme.Surface2
                }, 0.2)

                Tween(Circle, {
                    Position = UDim2.fromOffset(enabled and 25 or 3, 3)
                }, 0.2)

                if callback then
                    callback(enabled)
                end
            end

            Toggle.MouseButton1Click:Connect(function()
                enabled = not enabled
                Update()
            end)

            return {
                Set = function(_, value)
                    enabled = value == true
                    Update()
                end
            }
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)

            local Card = Tab:AddCard(text, "Adjust value")

            local Value = Label(Card, tostring(default), 13, Theme.Accent2, Enum.Font.GothamBold)
            Value.Position = UDim2.new(1, -65, 0, 8)
            Value.Size = UDim2.fromOffset(50, 20)
            Value.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Create("Frame", {
                Position = UDim2.fromOffset(15, 45),
                Size = UDim2.new(1, -30, 0, 6),
                BackgroundColor3 = Theme.Surface2,
                BorderSizePixel = 0
            }, Card)

            Corner(Bar, 8)

            local Fill = Create("Frame", {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent
            }, Bar)

            Corner(Fill, 8)

            local dragging = false
            local current = default

            local function SetValue(value)
                current = math.clamp(value, min, max)

                local percent = (current - min) / (max - min)

                Tween(Fill, {
                    Size = UDim2.new(percent, 0, 1, 0)
                }, 0.08)

                Value.Text = tostring(math.floor(current))

                if callback then
                    callback(current)
                end
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then
                    local percent = math.clamp(
                        (input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                        0, 1
                    )

                    SetValue(min + (max - min) * percent)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            return {
                Set = function(_, value)
                    SetValue(value)
                end
            }
        end

        function Tab:CreateDropdown(text, options, callback)
            options = options or {}

            local Card = Tab:AddCard(text, "Select an option")

            local Selected = Create("TextButton", {
                Size = UDim2.fromOffset(150, 34),
                Position = UDim2.new(1, -165, 0, 15),
                BackgroundColor3 = Theme.Surface2,
                Text = tostring(options[1] or "Select"),
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false
            }, Card)

            Corner(Selected, 10)

            local index = 1
            local opened = false

            Selected.MouseButton1Click:Connect(function()
                if #options == 0 then return end

                index = index % #options + 1
                Selected.Text = tostring(options[index])

                if callback then
                    callback(options[index])
                end
            end)

            return {
                Set = function(_, value)
                    for i, option in ipairs(options) do
                        if option == value then
                            index = i
                            Selected.Text = tostring(value)
                            if callback then callback(value) end
                            break
                        end
                    end
                end
            }
        end

        function Tab:CreateInput(text, callback)
            local Card = Tab:AddCard(text, "Enter text below")

            local Input = Create("TextBox", {
                Size = UDim2.new(1, -30, 0, 32),
                Position = UDim2.fromOffset(15, 29),
                BackgroundColor3 = Theme.Surface2,
                PlaceholderText = "Type something...",
                PlaceholderColor3 = Theme.Muted,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false
            }, Card)

            Corner(Input, 9)

            Input.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(Input.Text)
                end
            end)

            Card.Size = UDim2.new(1, -10, 0, 72)

            return Input
        end

        Button.MouseButton1Click:Connect(function()
            SelectTab(Tab)
        end)

        table.insert(Window.Tabs, Tab)

        TabButtons.CanvasSize = UDim2.new(
            0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10
        )

        if not ActiveTab then
            SelectTab(Tab)
        end

        return Tab
    end

    function Window:Clear()
        for _, tab in pairs(Window.Tabs) do
            tab.Page:Destroy()
            tab.Button:Destroy()
        end

        table.clear(Window.Tabs)
        ActiveTab = nil
    end

    function Window:Destroy()
        gui:Destroy()
    end

    Window:Notify("VNX Nexus UI V1 loaded!")

    return Window
end

return VNX
