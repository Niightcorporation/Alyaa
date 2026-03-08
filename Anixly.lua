--[[
    Anixly - Sambung kata
    Fitur Lengkap dengan UI Keren (Versi Stabil)
    Theme: Tokyo Night Only + Minimize Feature
]]

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled

-- Anti Re-Execute
local ScriptName = "Anixly_alya"
if _G[ScriptName] then
    _G[ScriptName]()
end

local IsRunning = true
_G[ScriptName] = function()
    IsRunning = false
    if CoreGui:FindFirstChild("Anixly") then
        CoreGui.Anixly:Destroy()
    end
end

-- Sound Effect
local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://139658322785649"
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    Debris:AddItem(sound, 1)
end

-- Tokyo Night Theme (Only)
local THEME = {
    primary = Color3.fromRGB(0, 255, 255),       -- Cyan neon
    mid = Color3.fromRGB(255, 0, 255),           -- Magenta neon
    dark = Color3.fromRGB(10, 10, 30),           -- Hitam kebiruan
    headerBg = Color3.fromRGB(20, 20, 50),        -- Dark blue
    accent = Color3.fromRGB(255, 255, 0),         -- Yellow neon
    glow = Color3.fromRGB(255, 105, 180),         -- Hot pink
    activeTab = Color3.fromRGB(138, 43, 226),     -- Blue violet
    logText = Color3.fromRGB(200, 200, 255)       -- Light blue
}

-- UI Sizes
local UI_WIDTH = IsMobile and 300 or 460
local UI_HEIGHT = IsMobile and 250 or 310
local SIDEBAR_WIDTH = IsMobile and 85 or 105
local HEADER_HEIGHT = IsMobile and 42 or 46
local TEXT_SIZE_SMALL = IsMobile and 9 or 11
local COMPONENT_HEIGHT = IsMobile and 32 or 36
local TEXT_SIZE_NORMAL = IsMobile and 10 or 12
local TEXT_SIZE_LARGE = IsMobile and 13 or 15

-- Variables
local autoTypeEnabled = false
local autoEnterEnabled = true
local typeDelay = 0.03
local enterDelay = 0.08
local turnDelay = 1.5
local backspaceDelay = 0.02
local deleteDelay = 0.06
local humanModeEnabled = false
local noclipEnabled = false
local noclipConnection

-- Word categories
local wordCategories = {
    IF = {},
    X = {},
    NG = {},
    AI = {},
    KS = {},
    CY = {},
    UI = {},
    LY = {},
    RS = {},
    NS = {},
    ["SEMUA KATA SULIT"] = {}
}

local categoryToggles = {
    IF = false,
    X = false,
    NG = false,
    AI = false,
    KS = false,
    CY = false,
    UI = false,
    LY = false,
    RS = false,
    NS = false,
    ["SEMUA KATA SULIT"] = false
}

local usedWords = {}
local currentWord = ""
local wordLength = 0
local isTyping = false

-- Random words for human mode
local randomWords = {"wkwk", "receh", "noob", "lemah", "kasian", "santuy", "ezz", "lol", "mudah"}

-- Common words
local commonWords = {
    "abadi", "abai", "abang", "abdi", "abu", "acara", "ada", "adab", "adang", "adat", 
    "adik", "adil", "adu", "agama", "agar", "agen", "agung", "ahad", "ahli", "aib", 
    "air", "ajak", "ajar", "aju", "akad", "akal", "akan", "akar", "akhir", "akhlak",
    "akibat", "akta", "aktif", "aku", "akun", "akurat", "alam", "alami", "alang", "alasan",
    "alat", "album", "alfa", "algojo", "ali", "alias", "alih", "alim", "alir", "aliran",
    "alis", "alkali", "alkitab", "alkohol", "allah", "alpa", "alu", "alun", "alur", "aluran",
    "amal", "aman", "baca", "badan", "bagaimana", "baik", "banyak", "baru", "bawa", "bawah",
    "bebas", "belum", "benar", "bentuk", "besar", "biasa", "bisa", "bukan", "bulan", "bumi",
    "burung", "cahaya", "cinta", "coba", "dalam", "dan", "dapat", "dari", "datang", "dekat",
    "dengan", "depan", "di", "dia", "diri", "dua", "dulu", "dunia", "uhuk", "uhuy", "bca",
    "yanto", "ilang", "oho", "aiba", "eni", "ungik", "aqua", "aikido", "aku", "dia", "kamu",
    "saya", "mereka", "kami", "kita", "anda", "ini", "itu", "sini", "situ", "sana"
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Anixly"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Glow Effect
local GlowWrapper = Instance.new("Frame")
GlowWrapper.Name = "GlowWrapper"
GlowWrapper.Size = UDim2.new(0, UI_WIDTH + 4, 0, UI_HEIGHT + 4)
GlowWrapper.Position = UDim2.new(0.5, -(UI_WIDTH/2) - 2, 0.5, -(UI_HEIGHT/2) - 2)
GlowWrapper.BackgroundColor3 = THEME.glow
GlowWrapper.BackgroundTransparency = 0.6
GlowWrapper.BorderSizePixel = 0
GlowWrapper.ZIndex = 0
GlowWrapper.Parent = ScreenGui

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 18)
GlowCorner.Parent = GlowWrapper

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
MainFrame.Position = UDim2.new(0.5, -UI_WIDTH/2, 0.5, -UI_HEIGHT/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 13)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
Header.BackgroundColor3 = THEME.headerBg
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.primary),
    ColorSequenceKeypoint.new(0.6, THEME.mid),
    ColorSequenceKeypoint.new(1, THEME.dark)
})
HeaderGradient.Rotation = 135
HeaderGradient.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = THEME.accent
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local HeaderDot = Instance.new("Frame")
HeaderDot.Size = UDim2.new(0, 7, 0, 7)
HeaderDot.Position = UDim2.new(0, 10, 0.5, -3.5)
HeaderDot.BackgroundColor3 = THEME.accent
HeaderDot.BorderSizePixel = 0
HeaderDot.Parent = Header

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = HeaderDot

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 140, 1, 0)
TitleLabel.Position = UDim2.new(0, 22, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Anixly"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = TEXT_SIZE_LARGE
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Window Controls
local controlSize = IsMobile and 18 or 26

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, controlSize, 0, controlSize)
MinimizeBtn.Position = UDim2.new(1, -(controlSize * 2 + 10), 0.5, -controlSize / 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(250, 190, 0)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = IsMobile and 14 or 18
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, controlSize, 0, controlSize)
CloseBtn.Position = UDim2.new(1, -(controlSize + 6), 0.5, -controlSize / 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 50, 60)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = IsMobile and 16 or 20
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- Mini Icon (for minimized state)
local MiniIcon = Instance.new("TextButton")
MiniIcon.Name = "AnixlyMiniIcon"
MiniIcon.Size = UDim2.new(0, IsMobile and 45 or 60, 0, IsMobile and 45 or 60)
MiniIcon.Position = UDim2.new(0, 10, 0.5, -30)
MiniIcon.BackgroundColor3 = THEME.headerBg
MiniIcon.Text = "A"
MiniIcon.TextColor3 = Color3.new(1, 1, 1)
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextSize = IsMobile and 24 or 32
MiniIcon.Visible = false
MiniIcon.BorderSizePixel = 0
MiniIcon.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 14)
MiniCorner.Parent = MiniIcon

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = THEME.accent
MiniStroke.Thickness = 2
MiniStroke.Transparency = 0.1
MiniStroke.Parent = MiniIcon

-- Minimize Logic
local miniDragDist = 0
local isDraggingMini = false
local dragStartPos, miniStartPos

MinimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    MainFrame.Visible = false
    GlowWrapper.Visible = false
    MiniIcon.Visible = true
    miniDragDist = 0
end)

MiniIcon.InputBegan:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then return end
    
    isDraggingMini = true
    miniDragDist = 0
    dragStartPos = input.Position
    miniStartPos = MiniIcon.Position
    
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            isDraggingMini = false
        end
    end)
end)

MiniIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMini = false
        local dragDist = dragStartPos and (input.Position - dragStartPos).Magnitude or 999
        
        if dragDist <= 12 then
            playClickSound()
            MainFrame.Visible = true
            GlowWrapper.Visible = true
            MiniIcon.Visible = false
        end
        miniDragDist = 0
    end
end)

MiniIcon.MouseButton1Click:Connect(function()
    if IsMobile then return end
    
    if miniDragDist > 10 then
        miniDragDist = 0
        return
    end
    
    playClickSound()
    MainFrame.Visible = true
    GlowWrapper.Visible = true
    MiniIcon.Visible = false
    miniDragDist = 0
end)

-- Dragging for main frame
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(1, -(controlSize * 2 + 30), 1, 0)
dragButton.Position = UDim2.new(0, 0, 0, 0)
dragButton.BackgroundTransparency = 1
dragButton.Text = ""
dragButton.ZIndex = 5
dragButton.Parent = Header

local dragStart, dragStartPos

dragButton.InputBegan:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then return end
    
    dragStart = input.Position
    dragStartPos = MainFrame.Position
    
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragStart = nil
        end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then return end
    
    if dragStart then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
        MainFrame.Position = newPos
        GlowWrapper.Position = UDim2.new(
            newPos.X.Scale, newPos.X.Offset - 2,
            newPos.Y.Scale, newPos.Y.Offset - 2
        )
        return
    end
    
    if isDraggingMini then
        local delta = input.Position - dragStartPos
        miniDragDist = delta.Magnitude
        MiniIcon.Position = UDim2.new(
            miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X,
            miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -HEADER_HEIGHT)
Sidebar.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT)
Sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 16)
SidebarCorner.Parent = Sidebar

-- Sidebar Divider
local SideDivider = Instance.new("Frame")
SideDivider.Size = UDim2.new(0, 1, 1, -HEADER_HEIGHT)
SideDivider.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, HEADER_HEIGHT)
SideDivider.BackgroundColor3 = THEME.mid
SideDivider.BorderSizePixel = 0
SideDivider.Parent = MainFrame

-- Sidebar Layout
local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, IsMobile and 4 or 5)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, IsMobile and 8 or 12)
SidebarPadding.PaddingLeft = UDim.new(0, IsMobile and 4 or 7)
SidebarPadding.PaddingRight = UDim.new(0, IsMobile and 4 or 7)
SidebarPadding.Parent = Sidebar

-- Content Area
local contentOffset = SIDEBAR_WIDTH + 7
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -(contentOffset + 4), 1, -(HEADER_HEIGHT + 6))
contentArea.Position = UDim2.new(0, contentOffset, 0, HEADER_HEIGHT + 4)
contentArea.BackgroundTransparency = 1
contentArea.Parent = MainFrame

-- Tab Containers
local function createTabContainer()
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.ScrollBarThickness = IsMobile and 3 or 2
    container.ScrollBarImageColor3 = THEME.accent
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.Parent = contentArea
    return container
end

local mainContainer = createTabContainer()
local utilContainer = createTabContainer()
local tpContainer = createTabContainer()

-- Layout for containers
local function setupContainerLayout(container)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, IsMobile and 5 or 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = container
end

setupContainerLayout(mainContainer)
setupContainerLayout(utilContainer)
setupContainerLayout(tpContainer)

-- Sidebar Tab Buttons
local tabButtons = {}

local function createTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IsMobile and 45 or 48)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = TEXT_SIZE_NORMAL
    btn.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 30, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn
    
    table.insert(tabButtons, {btn = btn, stroke = btnStroke})
    return btn
end

local mainTab = createTabButton("MAIN", 1)
local utilTab = createTabButton("UTILITY", 2)
local tpTab = createTabButton("TELEPORT", 3)

-- Tab Switching
local function switchTab(activeContainer, activeBtn)
    mainContainer.Visible = false
    utilContainer.Visible = false
    tpContainer.Visible = false
    activeContainer.Visible = true
    
    for _, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
    end
    
    activeBtn.BackgroundColor3 = THEME.activeTab
    activeBtn.TextColor3 = Color3.new(1, 1, 1)
    for _, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = THEME.accent
            tab.stroke.Transparency = 0.1
        end
    end
end

-- Click handlers
mainTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(mainContainer, mainTab)
end)

utilTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(utilContainer, utilTab)
end)

tpTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(tpContainer, tpTab)
end)

-- Section Header Function
local function createSectionHeader(title, order)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.LayoutOrder = order
    header.BackgroundTransparency = 1
    header.Parent = mainContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = THEME.logText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -10, 0, 1)
    line.Position = UDim2.new(0, 10, 1, -2)
    line.BackgroundColor3 = THEME.mid
    line.BorderSizePixel = 0
    line.Parent = header
    
    return header
end

-- Toggle Button Function
local function createToggleButton(text, parent, defaultState, callback, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
    frame.LayoutOrder = order
    frame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(55, 30, 100)
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.4
    frameStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 200, 230)
    label.Font = Enum.Font.GothamBold
    label.TextSize = TEXT_SIZE_NORMAL
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleWidth = IsMobile and 48 or 44
    local toggleHeight = IsMobile and 26 or 22
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggle.Position = UDim2.new(1, -(toggleWidth + 6), 0.5, -toggleHeight / 2)
    toggle.BackgroundColor3 = defaultState and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local knobSize = IsMobile and 20 or 16
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, knobSize, 0, knobSize)
    knob.Position = defaultState and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    
    local state = defaultState
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(30, 180, 110) or Color3.fromRGB(180, 40, 50)
        knob.Position = state and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
        playClickSound()
        callback(state)
    end)
    
    return frame
end

-- Slider Function
local function createSlider(parent, icon, label, minV, maxV, defMin, defMax, dec, suf, cbMin, cbMax, order)
    local itemHeight = IsMobile and 48 or 42
    
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, itemHeight)
    row.LayoutOrder = order
    row.BackgroundColor3 = Color3.fromRGB(13, 12, 22)
    row.BorderSizePixel = 0
    row.Parent = parent
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 70, 0, 20)
    iconLabel.Position = UDim2.new(0, 10, 0, 5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon .. " " .. label
    iconLabel.TextColor3 = Color3.fromRGB(170, 155, 210)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = IsMobile and 9 or 10
    iconLabel.TextXAlignment = Enum.TextXAlignment.Left
    iconLabel.Parent = row
    
    local formatStr = "%." .. dec .. "f"
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 100, 0, 20)
    valueLabel.Position = UDim2.new(1, -105, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = IsMobile and 9 or 10
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = row
    
    local knobSize = IsMobile and 16 or 11
    local sliderTrackSize = IsMobile and 32 or 26
    local trackHeight = IsMobile and 6 or 4
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, trackHeight)
    track.Position = UDim2.new(0, 10, 0, sliderTrackSize)
    track.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    track.BorderSizePixel = 0
    track.Parent = row
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = THEME.primary
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local minKnob = Instance.new("Frame")
    minKnob.Size = UDim2.new(0, knobSize, 0, knobSize)
    minKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    minKnob.BorderSizePixel = 0
    minKnob.ZIndex = 3
    minKnob.Parent = track
    
    local minKnobCorner = Instance.new("UICorner")
    minKnobCorner.CornerRadius = UDim.new(1, 0)
    minKnobCorner.Parent = minKnob
    
    local minStroke = Instance.new("UIStroke")
    minStroke.Color = THEME.accent
    minStroke.Thickness = 1.5
    minStroke.Parent = minKnob
    
    local maxKnob = Instance.new("Frame")
    maxKnob.Size = UDim2.new(0, knobSize, 0, knobSize)
    maxKnob.BackgroundColor3 = THEME.accent
    maxKnob.BorderSizePixel = 0
    maxKnob.ZIndex = 3
    maxKnob.Parent = track
    
    local maxKnobCorner = Instance.new("UICorner")
    maxKnobCorner.CornerRadius = UDim.new(1, 0)
    maxKnobCorner.Parent = maxKnob
    
    local maxStroke = Instance.new("UIStroke")
    maxStroke.Color = Color3.fromRGB(200, 150, 255)
    maxStroke.Thickness = 1.5
    maxStroke.Parent = maxKnob
    
    local halfKnob = knobSize / 2
    local minVal, maxVal = defMin, defMax
    
    local function updateSlider()
        local minPercent = (minVal - minV) / (maxV - minV)
        local maxPercent = (maxVal - minV) / (maxV - minV)
        
        fill.Position = UDim2.new(minPercent, 0, 0, 0)
        fill.Size = UDim2.new(maxPercent - minPercent, 0, 1, 0)
        
        minKnob.Position = UDim2.new(minPercent, -halfKnob, 0.5, -halfKnob)
        maxKnob.Position = UDim2.new(maxPercent, -halfKnob, 0.5, -halfKnob)
        
        valueLabel.Text = string.format(formatStr, minVal) .. " ~ " .. string.format(formatStr, maxVal) .. suf
        valueLabel.TextColor3 = THEME.logText
    end
    updateSlider()
    
    local dragButton = Instance.new("TextButton")
    dragButton.Size = UDim2.new(1, 0, 0, sliderTrackSize * 2)
    dragButton.Position = UDim2.new(0, 0, 0.5, -sliderTrackSize)
    dragButton.BackgroundTransparency = 1
    dragButton.Text = ""
    dragButton.ZIndex = 4
    dragButton.Parent = track
    
    local draggingMin, draggingMax = false, false
    
    local function getPercentFromPos(xPos)
        local trackX = track.AbsolutePosition.X
        local trackW = track.AbsoluteSize.X
        return math.clamp((xPos - trackX) / trackW, 0, 1)
    end
    
    local function roundToDec(val)
        local mult = 10 ^ dec
        return math.floor(val * mult + 0.5) / mult
    end
    
    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        
        local pct = getPercentFromPos(input.Position.X)
        local val = roundToDec(minV + pct * (maxV - minV))
        
        if math.abs(val - minVal) <= math.abs(val - maxVal) then
            draggingMin = true
        else
            draggingMax = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not (draggingMin or draggingMax) then return end
        
        local pct = getPercentFromPos(input.Position.X)
        local val = roundToDec(minV + pct * (maxV - minV))
        local eps = 1 / (10 ^ dec)
        
        if draggingMin then
            minVal = math.clamp(val, minV, maxVal - eps)
            cbMin(minVal)
        else
            maxVal = math.clamp(val, minVal + eps, maxV)
            cbMax(maxVal)
        end
        
        updateSlider()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMin = false
            draggingMax = false
        end
    end)
end

-- Build Main Tab
local order = 1
createSectionHeader("AUTO FEATURES", order)
order = order + 1

createToggleButton("Auto Answer", mainContainer, false, function(state) autoTypeEnabled = state end, order)
order = order + 1

createToggleButton("Auto Submit", mainContainer, true, function(state) autoEnterEnabled = state end, order)
order = order + 1

createToggleButton("Human Mode", mainContainer, false, function(state) humanModeEnabled = state end, order)
order = order + 1

createSectionHeader("DELAY SETTINGS", order)
order = order + 1

createSlider(mainContainer, "⌨", "Write", 0.01, 1, 0.03, 0.08, 2, "s", 
    function(v) typeDelay = v end, 
    function(v) enterDelay = v end, order)
order = order + 1

createSlider(mainContainer, "⏱", "Turn", 0.1, 5, 1.5, 2.5, 1, "s",
    function(v) turnDelay = v end,
    function(v) turnDelay = v end, order)
order = order + 1

createSlider(mainContainer, "⌫", "Backspace", 0.01, 1, 0.02, 0.06, 2, "s",
    function(v) backspaceDelay = v end,
    function(v) deleteDelay = v end, order)
order = order + 1

createSectionHeader("INFORMATION", order)
order = order + 1

local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, 0, 0, 70)
logFrame.LayoutOrder = order
logFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainContainer
order = order + 1

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 8)
logCorner.Parent = logFrame

local logStroke = Instance.new("UIStroke")
logStroke.Color = Color3.fromRGB(80, 40, 140)
logStroke.Thickness = 1
logStroke.Transparency = 0.4
logStroke.Parent = logFrame

local awalanLabel = Instance.new("TextLabel")
awalanLabel.Size = UDim2.new(1, -10, 0, 25)
awalanLabel.Position = UDim2.new(0, 10, 0, 5)
awalanLabel.BackgroundTransparency = 1
awalanLabel.Text = "AWALAN: -"
awalanLabel.TextColor3 = THEME.logText
awalanLabel.Font = Enum.Font.GothamBold
awalanLabel.TextSize = IsMobile and 12 or 14
awalanLabel.TextXAlignment = Enum.TextXAlignment.Left
awalanLabel.Parent = logFrame

local kataLabel = Instance.new("TextLabel")
kataLabel.Size = UDim2.new(1, -10, 0, 35)
kataLabel.Position = UDim2.new(0, 10, 0, 30)
kataLabel.BackgroundTransparency = 1
kataLabel.Text = "-"
kataLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
kataLabel.Font = Enum.Font.GothamBold
kataLabel.TextSize = IsMobile and 16 or 18
kataLabel.TextXAlignment = Enum.TextXAlignment.Left
kataLabel.Parent = logFrame

-- Build Utility Tab
local utilOrder = 1

-- Noclip toggle
createToggleButton("NOCLIP", utilContainer, false, function(state)
    noclipEnabled = state
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
    end
end, utilOrder)
utilOrder = utilOrder + 1

-- Respawn button
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
respawnBtn.LayoutOrder = utilOrder
respawnBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
respawnBtn.Text = "RESPAWN"
respawnBtn.TextColor3 = Color3.fromRGB(200, 190, 220)
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextSize = TEXT_SIZE_NORMAL
respawnBtn.Parent = utilContainer
utilOrder = utilOrder + 1

local respawnCorner = Instance.new("UICorner")
respawnCorner.CornerRadius = UDim.new(0, 8)
respawnCorner.Parent = respawnBtn

local respawnStroke = Instance.new("UIStroke")
respawnStroke.Color = Color3.fromRGB(70, 35, 130)
respawnStroke.Thickness = 1
respawnStroke.Transparency = 0.4
respawnStroke.Parent = respawnBtn

respawnBtn.MouseButton1Click:Connect(function()
    playClickSound()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- Rejoin button
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
rejoinBtn.LayoutOrder = utilOrder
rejoinBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
rejoinBtn.Text = "REJOIN SERVER"
rejoinBtn.TextColor3 = Color3.fromRGB(200, 190, 220)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = TEXT_SIZE_NORMAL
rejoinBtn.Parent = utilContainer
utilOrder = utilOrder + 1

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 8)
rejoinCorner.Parent = rejoinBtn

local rejoinStroke = Instance.new("UIStroke")
rejoinStroke.Color = Color3.fromRGB(70, 35, 130)
rejoinStroke.Thickness = 1
rejoinStroke.Transparency = 0.4
rejoinStroke.Parent = rejoinBtn

rejoinBtn.MouseButton1Click:Connect(function()
    playClickSound()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Build Teleport Tab (Coming Soon)
local tpPlaceholder = Instance.new("TextLabel")
tpPlaceholder.Size = UDim2.new(1, 0, 0, 100)
tpPlaceholder.BackgroundTransparency = 1
tpPlaceholder.Text = "TELEPORT FEATURES\n(Coming Soon)"
tpPlaceholder.TextColor3 = Color3.fromRGB(150, 150, 150)
tpPlaceholder.Font = Enum.Font.GothamBold
tpPlaceholder.TextSize = 16
tpPlaceholder.TextWrapped = true
tpPlaceholder.Parent = tpContainer

-- Typing function
local function typeWord(word, length)
    if not IsRunning then return end
    
    wordLength = length or #word
    
    if humanModeEnabled then
        local mistakes = math.random(1, 2)
        local mistakeCount = 0
        
        if mistakeCount < mistakes and math.random() < 0.3 then
            mistakeCount = mistakeCount + 1
            task.wait(math.random() * 0.8 + 0.3)
        end
        
        local i = 1
        while i <= #word do
            if not IsRunning then return end
            
            if mistakeCount < mistakes and i > 1 and math.random() < 0.12 then
                mistakeCount = mistakeCount + 1
                task.wait(math.random() * 0.6 + 0.2)
            end
            
            if mistakeCount < mistakes and math.random() < 0.08 then
                mistakeCount = mistakeCount + 1
                
                local chars = "qwertyuiopasdfghjklzxcvbnm"
                local numTypos = math.random(1, 2)
                
                for _ = 1, numTypos do
                    local char = chars:sub(math.random(1, #chars), math.random(1, #chars))
                    local keyCode = Enum.KeyCode[char:upper()]
                    if keyCode then
                        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                        task.wait(0.01)
                        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                        task.wait(typeDelay + math.random() * (enterDelay - typeDelay))
                    end
                end
                
                task.wait(0.1 + math.random() * 0.2)
                
                for _ = 1, numTypos do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.03)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.04)
                end
            end
            
            if mistakeCount < mistakes and math.random() < 0.1 then
                mistakeCount = mistakeCount + 1
                
                local chars = "qwertyuiopasdfghjklzxcvbnm"
                local char = chars:sub(math.random(1, #chars), math.random(1, #chars))
                local keyCode = Enum.KeyCode[char:upper()]
                
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(typeDelay + math.random() * (enterDelay - typeDelay))
                    
                    task.wait(0.08 + math.random() * 0.15)
                    
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.03)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                    task.wait(0.05 + math.random() * 0.1)
                end
            end
            
            local char = word:sub(i, i):upper()
            local keyCode = Enum.KeyCode[char]
            
            if keyCode then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                task.wait(typeDelay + math.random() * (enterDelay - typeDelay))
            end
            
            i = i + 1
        end
        
        if mistakeCount < mistakes and math.random() < 0.15 then
            mistakeCount = mistakeCount + 1
            
            local randomWord = randomWords[math.random(1, #randomWords)]
            task.wait(0.2 + math.random() * 0.3)
            
            for j = 1, #randomWord do
                local char = randomWord:sub(j, j):upper()
                local keyCode = Enum.KeyCode[char]
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(typeDelay * 0.7 + (math.random() * enterDelay) * 0.5)
                end
            end
            
            task.wait(0.15 + math.random() * 0.2)
            
            for _ = 1, #randomWord do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                task.wait(0.03)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
                task.wait(0.03)
            end
            
            task.wait(0.1 + math.random() * 0.2)
            
            for j = 1, #word do
                local char = word:sub(j, j):upper()
                local keyCode = Enum.KeyCode[char]
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(typeDelay + math.random() * (enterDelay - typeDelay))
                end
            end
        end
    else
        for i = 1, #word do
            local char = word:sub(i, i):upper()
            local keyCode = Enum.KeyCode[char]
            
            if keyCode then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                task.wait(typeDelay + math.random() * (enterDelay - typeDelay))
            end
        end
    end
    
    if autoEnterEnabled then
        task.wait(backspaceDelay + math.random() * (deleteDelay - backspaceDelay))
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end
end

-- Auto type function
local function autoType()
    if not autoTypeEnabled or not IsRunning or isTyping then return end
    
    isTyping = true
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local matchUI = playerGui:FindFirstChild("MatchUI", true)
    local awalan = ""
    
    if matchUI then
        for _, obj in pairs(matchUI:GetDescendants()) do
            if (obj.Name == "WordServer" or obj.Name == "Word") and obj:IsA("TextLabel") and obj.Visible then
                local text = (obj.Text:gsub("%s+", "")):lower()
                if #text >= 1 and #text <= 4 then
                    awalan = text
                end
            end
        end
    end
    
    if awalan ~= "" then
        awalanLabel.Text = "AWALAN: " .. awalan:upper()
        
        local candidates = {}
        
        for _, word in ipairs(commonWords) do
            if word:sub(1, #awalan) == awalan and not usedWords[word] and #word > #awalan then
                table.insert(candidates, word)
            end
        end
        
        if #candidates > 0 then
            local chosen = candidates[math.random(1, #candidates)]
            
            print("🤖 Anixly: " .. chosen:upper() .. " | Awalan: " .. awalan:upper())
            kataLabel.Text = chosen:upper()
            currentWord = chosen
            
            typeWord(chosen:sub(#awalan + 1), #chosen)
            usedWords[chosen] = true
            
            task.wait(1)
            awalanLabel.Text = "AWALAN: -"
            kataLabel.Text = "-"
        end
    end
    
    task.wait(0.5)
    isTyping = false
end

-- Remote handler
local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if remotes then
    local matchRemote = remotes:FindFirstChild("MatchUI")
    if matchRemote then
        local function clearWord()
            local len = wordLength + 1
            for _ = 1, len do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
                task.wait(backspaceDelay + math.random() * (deleteDelay - backspaceDelay))
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
            end
            wordLength = 0
            task.wait(0.1)
        end
        
        matchRemote.OnClientEvent:Connect(function(event)
            if not IsRunning then return end
            
            if event == "StartTurn" or event == "YourTurn" then
                if not isTyping then
                    task.wait(turnDelay + math.random() * (turnDelay - turnDelay))
                    autoType()
                end
                
            elseif event == "Eliminated" or event == "EndMatch" or event == "HideMatchUI" then
                awalanLabel.Text = "AWALAN: -"
                kataLabel.Text = "-"
                
            elseif event == "Mistake" and autoTypeEnabled then
                local playerGui = LocalPlayer:WaitForChild("PlayerGui")
                local matchUI = playerGui:FindFirstChild("MatchUI", true)
                
                if matchUI then
                    local submitBtn = matchUI:FindFirstChild("WordSubmit", true)
                    if submitBtn and submitBtn.Visible and submitBtn.BackgroundTransparency < 0.6 then
                        if currentWord ~= "" then
                            usedWords[currentWord] = true
                        end
                        
                        print("⚠️ Anixly: Salah! Menghapus & Cari Baru...")
                        isTyping = true
                        clearWord()
                        isTyping = false
                        autoType()
                    end
                end
            end
        end)
    end
end

-- Close button handler
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    IsRunning = false
end)

-- Show main tab by default
switchTab(mainContainer, mainTab)

print("✅ Anixly Loaded")