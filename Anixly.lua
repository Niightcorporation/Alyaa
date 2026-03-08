--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

--[[
    Anixly - Sambung kata
    Fitur Lengkap dengan UI Keren
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

-- Tokyo Night Theme
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
local typeDelay = 0.12
local enterDelay = 0.15
local turnDelay = 2.0
local backspaceDelay = 0.10
local deleteDelay = 0.12
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

-- Header (HEADER DOT DIHAPUS)
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

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 140, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
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

-- Mini Icon (for minimized state) dengan ICON ANIME
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Name = "AnixlyMiniIcon"
MiniIcon.Size = UDim2.new(0, IsMobile and 45 or 60, 0, IsMobile and 45 or 60)
MiniIcon.Position = UDim2.new(0, 10, 0.5, -30)
MiniIcon.BackgroundColor3 = THEME.headerBg
MiniIcon.Image = "rbxassetid://110893481851143"  -- Icon anime girl
MiniIcon.ImageColor3 = Color3.new(1, 1, 1)
MiniIcon.ScaleType = Enum.ScaleType.Fit
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

-- Sidebar Tab Buttons dengan ICON
local tabButtons = {}

local function createTabButton(iconId, label, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IsMobile and 48 or 52)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    btn.Text = ""
    btn.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 30, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, IsMobile and 22 or 28, 0, IsMobile and 22 or 28)
    icon.Position = UDim2.new(0.5, - (IsMobile and 11 or 14), 0.25, 0)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(120, 110, 150)
    icon.Name = "Icon"
    icon.Parent = btn
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, 0, 0, 15)
    labelText.Position = UDim2.new(0, 0, 0.7, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(120, 110, 150)
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = IsMobile and 9 or 10
    labelText.Name = "Label"
    labelText.Parent = btn
    
    table.insert(tabButtons, {btn = btn, stroke = btnStroke, icon = icon, label = labelText})
    return btn
end

-- Tab Buttons dengan Icon
local mainTab = createTabButton("rbxassetid://6023426941", "MAIN", 1)
local utilTab = createTabButton("rbxassetid://6023426937", "UTILITY", 2)
local tpTab = createTabButton("rbxassetid://6023426935", "TELEPORT", 3)

-- Highlight Tab Function
local function highlightTab(activeBtn)
    for _, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
        tab.icon.ImageColor3 = Color3.fromRGB(120, 110, 150)
        tab.label.TextColor3 = Color3.fromRGB(120, 110, 150)
    end
    
    activeBtn.BackgroundColor3 = THEME.activeTab
    
    for _, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = THEME.accent
            tab.stroke.Transparency = 0.1
            tab.icon.ImageColor3 = Color3.new(1, 1, 1)
            tab.label.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

-- Tab Switching
local function switchTab(activeContainer, activeBtn)
    mainContainer.Visible = false
    utilContainer.Visible = false
    tpContainer.Visible = false
    activeContainer.Visible = true
    highlightTab(activeBtn)
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

-- Fungsi untuk membuat Section Header dengan tombol expand/collapse
local function createCollapsibleHeader(title, iconId, container, contentList, order)
    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.LayoutOrder = order
    header.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
    header.Text = ""
    header.AutoButtonColor = false
    header.Parent = container
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local headerStroke = Instance.new("UIStroke")
    headerStroke.Color = THEME.mid
    headerStroke.Thickness = 1
    headerStroke.Transparency = 0.5
    headerStroke.Parent = header
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 10, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = THEME.accent
    icon.Parent = header
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = THEME.logText
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Arrow indicator
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = THEME.accent
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.Parent = header
    
    local expanded = true
    local content = contentList
    
    -- Sembunyikan/tampilkan konten
    for _, item in ipairs(content) do
        item.Visible = expanded
    end
    
    header.MouseButton1Click:Connect(function()
        playClickSound()
        expanded = not expanded
        arrow.Text = expanded and "▼" or "▶"
        
        for _, item in ipairs(content) do
            item.Visible = expanded
        end
        
        -- Update canvas size
        task.wait(0.05)
        local canvasSize = container.CanvasSize
        container.CanvasSize = UDim2.new(0, 0, 0, canvasSize.Y.Offset)
    end)
    
    return header
end

-- Toggle Button Function dengan efek neon
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
    
    -- Neon stroke
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = THEME.mid
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.6
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
    
    -- Glow untuk toggle
    local toggleGlow = Instance.new("UIStroke")
    toggleGlow.Color = defaultState and Color3.fromRGB(30, 255, 110) or Color3.fromRGB(255, 40, 50)
    toggleGlow.Thickness = 2
    toggleGlow.Transparency = 0.5
    toggleGlow.Parent = toggle
    
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
        toggleGlow.Color = state and Color3.fromRGB(30, 255, 110) or Color3.fromRGB(255, 40, 50)
        knob.Position = state and UDim2.new(1, -(knobSize + 3), 0.5, -knobSize / 2) or UDim2.new(0, 3, 0.5, -knobSize / 2)
        playClickSound()
        callback(state)
    end)
    
    return frame
end

-- Fungsi untuk membuat input delay dengan efek neon
local function createDelayInput(label, defaultValue, callback, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
    frame.LayoutOrder = order
    frame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    frame.BorderSizePixel = 0
    frame.Parent = mainContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    -- Neon stroke
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = THEME.mid
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.6
    frameStroke.Parent = frame
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0, 100, 1, 0)
    labelText.Position = UDim2.new(0, 10, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(210, 200, 230)
    labelText.Font = Enum.Font.GothamBold
    labelText.TextSize = TEXT_SIZE_NORMAL
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = frame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 80, 0, 28)
    textBox.Position = UDim2.new(1, -90, 0.5, -14)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
    textBox.Text = tostring(defaultValue)
    textBox.TextColor3 = THEME.logText
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = TEXT_SIZE_NORMAL
    textBox.PlaceholderText = "0.00"
    textBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 120)
    textBox.Parent = frame
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    -- Neon stroke untuk textbox
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = THEME.primary
    textBoxStroke.Thickness = 1
    textBoxStroke.Transparency = 0.5
    textBoxStroke.Parent = textBox
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local value = tonumber(textBox.Text)
            if value then
                callback(value)
                -- Efek neon saat berhasil
                textBoxStroke.Color = THEME.accent
                textBoxStroke.Thickness = 2
                task.wait(0.2)
                textBoxStroke.Color = THEME.primary
                textBoxStroke.Thickness = 1
            else
                textBox.Text = tostring(defaultValue)
            end
        end
    end)
    
    return frame
end

-- Build Main Tab dengan Collapsible Sections
local order = 1

-- AUTO FEATURES SECTION (Collapsible)
local autoFeaturesContent = {}

-- Buat toggle buttons dan simpan dalam tabel
autoFeaturesContent[1] = createToggleButton("Auto Answer", mainContainer, false, function(state) autoTypeEnabled = state end, order + 1)
autoFeaturesContent[2] = createToggleButton("Auto Submit", mainContainer, true, function(state) autoEnterEnabled = state end, order + 2)

-- Header untuk AUTO FEATURES
createCollapsibleHeader("AUTO FEATURES", "rbxassetid://6023426919", mainContainer, autoFeaturesContent, order)
order = order + 3  -- +1 untuk header, +2 untuk konten

-- INFORMATION SECTION (Tetap, tidak collapsible)
local infoHeader = Instance.new("Frame")
infoHeader.Size = UDim2.new(1, 0, 0, 30)
infoHeader.LayoutOrder = order
infoHeader.BackgroundTransparency = 1
infoHeader.Parent = mainContainer
order = order + 1

local infoIcon = Instance.new("ImageLabel")
infoIcon.Size = UDim2.new(0, 18, 0, 18)
infoIcon.Position = UDim2.new(0, 5, 0.5, -9)
infoIcon.BackgroundTransparency = 1
infoIcon.Image = "rbxassetid://6023426923"
infoIcon.ImageColor3 = THEME.accent
infoIcon.Parent = infoHeader

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -35, 1, 0)
infoLabel.Position = UDim2.new(0, 30, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "INFORMATION"
infoLabel.TextColor3 = THEME.logText
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 13
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = infoHeader

local infoLine = Instance.new("Frame")
infoLine.Size = UDim2.new(1, -35, 0, 1)
infoLine.Position = UDim2.new(0, 30, 1, -2)
infoLine.BackgroundColor3 = THEME.mid
infoLine.BorderSizePixel = 0
infoLine.Parent = infoHeader

-- Log Frame
-- SECTION INFORMATION (cari bagian ini di kode Anda)
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, 0, 0, 120)  -- Tinggi ditambah jadi 120
logFrame.LayoutOrder = order
logFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainContainer
order = order + 1

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 8)
logCorner.Parent = logFrame

-- Neon stroke
local logStroke = Instance.new("UIStroke")
logStroke.Color = THEME.mid
logStroke.Thickness = 1
logStroke.Transparency = 0.5
logStroke.Parent = logFrame

-- Label AWALAN (YANG SUDAH ADA)
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

-- ========== KOLOM PENCARIAN (PASANG DI SINI) ==========
local searchLabel = Instance.new("TextLabel")
searchLabel.Size = UDim2.new(0, 70, 0, 25)
searchLabel.Position = UDim2.new(0, 10, 0, 30)
searchLabel.BackgroundTransparency = 1
searchLabel.Text = "Cari Kata:"
searchLabel.TextColor3 = Color3.fromRGB(180, 170, 210)
searchLabel.Font = Enum.Font.GothamBold
searchLabel.TextSize = 12
searchLabel.TextXAlignment = Enum.TextXAlignment.Left
searchLabel.Parent = logFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -90, 0, 28)
searchBox.Position = UDim2.new(0, 80, 0, 28)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
searchBox.Text = ""
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.PlaceholderText = "1-3 huruf (contoh: ka)"
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 120)
searchBox.ClearTextOnFocus = false
searchBox.Parent = logFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchBox

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = THEME.primary
searchStroke.Thickness = 1
searchStroke.Transparency = 0.5
searchStroke.Parent = searchBox

-- Hasil pencarian
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -20, 0, 40)
resultLabel.Position = UDim2.new(0, 10, 0, 60)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Hasil: -"
resultLabel.TextColor3 = THEME.logText
resultLabel.Font = Enum.Font.Gotham
resultLabel.TextSize = 12
resultLabel.TextWrapped = true
resultLabel.TextXAlignment = Enum.TextXAlignment.Left
resultLabel.TextYAlignment = Enum.TextYAlignment.Top
resultLabel.Parent = logFrame
-- ========== AKHIR KOLOM PENCARIAN ==========

-- Label kata terpilih (YANG SUDAH ADA)
local kataLabel = Instance.new("TextLabel")
kataLabel.Size = UDim2.new(1, -10, 0, 25)
kataLabel.Position = UDim2.new(0, 10, 0, 100)  -- Posisi disesuaikan (dari 90 jadi 100)
kataLabel.BackgroundTransparency = 1
kataLabel.Text = "-"
kataLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
kataLabel.Font = Enum.Font.GothamBold
kataLabel.TextSize = IsMobile and 16 or 18
kataLabel.TextXAlignment = Enum.TextXAlignment.Left
kataLabel.Parent = logFrame

-- SEMUA KATA SULIT SECTION (Collapsible - sudah ada dari sebelumnya)
local kataSulitHeader = Instance.new("TextButton")
kataSulitHeader.Size = UDim2.new(1, 0, 0, 35)
kataSulitHeader.LayoutOrder = order
kataSulitHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
kataSulitHeader.Text = ""
kataSulitHeader.AutoButtonColor = false
kataSulitHeader.Parent = mainContainer
order = order + 1

local kataHeaderCorner = Instance.new("UICorner")
kataHeaderCorner.CornerRadius = UDim.new(0, 8)
kataHeaderCorner.Parent = kataSulitHeader

local kataHeaderStroke = Instance.new("UIStroke")
kataHeaderStroke.Color = THEME.mid
kataHeaderStroke.Thickness = 1
kataHeaderStroke.Transparency = 0.5
kataHeaderStroke.Parent = kataSulitHeader

local kataIcon = Instance.new("ImageLabel")
kataIcon.Size = UDim2.new(0, 18, 0, 18)
kataIcon.Position = UDim2.new(0, 10, 0.5, -9)
kataIcon.BackgroundTransparency = 1
kataIcon.Image = "rbxassetid://6023426945"
kataIcon.ImageColor3 = THEME.accent
kataIcon.Parent = kataSulitHeader

local kataTitle = Instance.new("TextLabel")
kataTitle.Size = UDim2.new(1, -80, 1, 0)
kataTitle.Position = UDim2.new(0, 35, 0, 0)
kataTitle.BackgroundTransparency = 1
kataTitle.Text = "SEMUA KATA SULIT"
kataTitle.TextColor3 = THEME.logText
kataTitle.Font = Enum.Font.GothamBold
kataTitle.TextSize = 13
kataTitle.TextXAlignment = Enum.TextXAlignment.Left
kataTitle.Parent = kataSulitHeader

local kataArrow = Instance.new("TextLabel")
kataArrow.Size = UDim2.new(0, 20, 0, 20)
kataArrow.Position = UDim2.new(1, -25, 0.5, -10)
kataArrow.BackgroundTransparency = 1
kataArrow.Text = "▼"
kataArrow.TextColor3 = THEME.accent
kataArrow.Font = Enum.Font.GothamBold
kataArrow.TextSize = 14
kataArrow.Parent = kataSulitHeader

-- Kata Sulit Dropdown Button
-- Kata Sulit Dropdown Button (teks dibuat normal)
local kataSulitBtn = Instance.new("TextButton")
kataSulitBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
kataSulitBtn.LayoutOrder = order
order = order + 1
kataSulitBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
kataSulitBtn.Text = "SET KATA SULIT ▼"
kataSulitBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
kataSulitBtn.Font = Enum.Font.Gotham  
kataSulitBtn.TextSize = TEXT_SIZE_NORMAL
kataSulitBtn.Parent = mainContainer

local kataBtnCorner = Instance.new("UICorner")
kataBtnCorner.CornerRadius = UDim.new(0, 8)
kataBtnCorner.Parent = kataSulitBtn

local kataBtnStroke = Instance.new("UIStroke")
kataBtnStroke.Color = THEME.mid
kataBtnStroke.Thickness = 1
kataBtnStroke.Transparency = 0.3
kataBtnStroke.Parent = kataSulitBtn

-- Kata Sulit Dropdown Content
local kataDropdown = Instance.new("Frame")
kataDropdown.Size = UDim2.new(1, 0, 0, 0)
kataDropdown.LayoutOrder = order
order = order + 1
kataDropdown.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
kataDropdown.ClipsDescendants = true
kataDropdown.BorderSizePixel = 0
kataDropdown.Parent = mainContainer

local kataDropdownStroke = Instance.new("UIStroke")
kataDropdownStroke.Color = THEME.mid
kataDropdownStroke.Thickness = 1
kataDropdownStroke.Transparency = 0.4
kataDropdownStroke.Parent = kataDropdown

local categoryHeight = IsMobile and 30 or 28
local dropdownOpen = false
local categories = {"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS", "SEMUA KATA SULIT"}

local function getCategoryCount(cat)
    if cat == "SEMUA KATA SULIT" then
        local total = 0
        for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS"}) do
            total = total + #wordCategories[c]
        end
        return total
    else
        return #wordCategories[cat]
    end
end

local function updateCategoryButtons()
    for _, child in pairs(kataDropdown:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for i, cat in ipairs(categories) do
        local isAllOn = cat == "SEMUA KATA SULIT" and categoryToggles["SEMUA KATA SULIT"]
        local isOn = cat == "SEMUA KATA SULIT" and categoryToggles["SEMUA KATA SULIT"] or categoryToggles[cat]
        local count = getCategoryCount(cat)
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, categoryHeight)
        btn.Position = UDim2.new(0, 5, 0, (i - 1) * categoryHeight + 2)
        btn.BackgroundColor3 = isOn and Color3.fromRGB(80, 30, 170) or Color3.fromRGB(28, 25, 42)
        btn.Text = ""
        btn.Parent = kataDropdown
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        
        -- Nama kategori
        local catLabel = Instance.new("TextLabel")
        catLabel.Size = UDim2.new(0, 80, 1, 0)
        catLabel.Position = UDim2.new(0, 10, 0, 0)
        catLabel.BackgroundTransparency = 1
        catLabel.Text = cat
        catLabel.TextColor3 = isOn and Color3.new(1, 1, 1) or Color3.fromRGB(160, 150, 190)
        catLabel.Font = Enum.Font.GothamBold
        catLabel.TextSize = TEXT_SIZE_NORMAL
        catLabel.TextXAlignment = Enum.TextXAlignment.Left
        catLabel.Parent = btn
        
        -- Jumlah kata
        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(0, 50, 1, 0)
        countLabel.Position = UDim2.new(1, -55, 0, 0)
        countLabel.BackgroundTransparency = 1
        countLabel.Text = "(" .. count .. ")"
        countLabel.TextColor3 = isOn and THEME.accent or Color3.fromRGB(120, 100, 150)
        countLabel.Font = Enum.Font.Gotham
        countLabel.TextSize = TEXT_SIZE_SMALL
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.Parent = btn
        
        if isOn then
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = THEME.accent
            btnStroke.Thickness = 1
            btnStroke.Transparency = 0.2
            btnStroke.Parent = btn
        end
        
        btn.MouseButton1Click:Connect(function()
            playClickSound()
            
            if cat == "SEMUA KATA SULIT" then
                local newState = not categoryToggles["SEMUA KATA SULIT"]
                categoryToggles["SEMUA KATA SULIT"] = newState
                if newState then
                    for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS"}) do
                        categoryToggles[c] = false
                    end
                end
            else
                categoryToggles[cat] = not categoryToggles[cat]
                -- Cek apakah semua non-SEMUA mati?
                local anyOn = false
                for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS"}) do
                    if categoryToggles[c] then
                        anyOn = true
                        break
                    end
                end
                if not anyOn then
                    categoryToggles["SEMUA KATA SULIT"] = false
                end
            end
            
            updateCategoryButtons()
        end)
    end
end

local kataExpanded = true
local kataContent = {kataSulitBtn, kataDropdown}

for _, item in ipairs(kataContent) do
    item.Visible = kataExpanded
end

kataSulitHeader.MouseButton1Click:Connect(function()
    playClickSound()
    kataExpanded = not kataExpanded
    kataArrow.Text = kataExpanded and "▼" or "▶"
    
    for _, item in ipairs(kataContent) do
        item.Visible = kataExpanded
    end
end)

kataSulitBtn.MouseButton1Click:Connect(function()
    playClickSound()
    dropdownOpen = not dropdownOpen
    kataSulitBtn.Text = dropdownOpen and "SET KATA SULIT ▲" or "SET KATA SULIT ▼"
    
    kataDropdown:TweenSize(
        UDim2.new(1, 0, 0, dropdownOpen and #categories * categoryHeight + 5 or 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.3,
        true
    )
    
    updateCategoryButtons()
end)

-- DELAY SETTINGS SECTION (Collapsible)
local delaySettingsContent = {}

-- Buat delay inputs dan simpan dalam tabel
delaySettingsContent[1] = createDelayInput("Write Delay", typeDelay, function(v) typeDelay = v; enterDelay = v end, order)
order = order + 1
delaySettingsContent[2] = createDelayInput("Turn Delay", turnDelay, function(v) turnDelay = v end, order)
order = order + 1
delaySettingsContent[3] = createDelayInput("Backspace Delay", backspaceDelay, function(v) backspaceDelay = v; deleteDelay = v end, order)
order = order + 1

-- Header untuk DELAY SETTINGS
createCollapsibleHeader("DELAY SETTINGS", "rbxassetid://6023426925", mainContainer, delaySettingsContent, order)
order = order + 4  -- +1 untuk header, +3 untuk konten

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

-- Respawn button dengan icon
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
respawnBtn.LayoutOrder = utilOrder
respawnBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
respawnBtn.Text = ""
respawnBtn.Parent = utilContainer
utilOrder = utilOrder + 1

-- Icon untuk respawn
local respawnIcon = Instance.new("ImageLabel")
respawnIcon.Size = UDim2.new(0, 18, 0, 18)
respawnIcon.Position = UDim2.new(0, 10, 0.5, -9)
respawnIcon.BackgroundTransparency = 1
respawnIcon.Image = "rbxassetid://6023426939"
respawnIcon.ImageColor3 = Color3.fromRGB(200, 190, 220)
respawnIcon.Parent = respawnBtn

local respawnLabel = Instance.new("TextLabel")
respawnLabel.Size = UDim2.new(1, -35, 1, 0)
respawnLabel.Position = UDim2.new(0, 35, 0, 0)
respawnLabel.BackgroundTransparency = 1
respawnLabel.Text = "RESPAWN"
respawnLabel.TextColor3 = Color3.fromRGB(200, 190, 220)
respawnLabel.Font = Enum.Font.GothamBold
respawnLabel.TextSize = TEXT_SIZE_NORMAL
respawnLabel.TextXAlignment = Enum.TextXAlignment.Left
respawnLabel.Parent = respawnBtn

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

-- Rejoin button dengan icon
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
rejoinBtn.LayoutOrder = utilOrder
rejoinBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
rejoinBtn.Text = ""
rejoinBtn.Parent = utilContainer
utilOrder = utilOrder + 1

-- Icon untuk rejoin
local rejoinIcon = Instance.new("ImageLabel")
rejoinIcon.Size = UDim2.new(0, 18, 0, 18)
rejoinIcon.Position = UDim2.new(0, 10, 0.5, -9)
rejoinIcon.BackgroundTransparency = 1
rejoinIcon.Image = "rbxassetid://6023426921"
rejoinIcon.ImageColor3 = Color3.fromRGB(200, 190, 220)
rejoinIcon.Parent = rejoinBtn

local rejoinLabel = Instance.new("TextLabel")
rejoinLabel.Size = UDim2.new(1, -35, 1, 0)
rejoinLabel.Position = UDim2.new(0, 35, 0, 0)
rejoinLabel.BackgroundTransparency = 1
rejoinLabel.Text = "REJOIN SERVER"
rejoinLabel.TextColor3 = Color3.fromRGB(200, 190, 220)
rejoinLabel.Font = Enum.Font.GothamBold
rejoinLabel.TextSize = TEXT_SIZE_NORMAL
rejoinLabel.TextXAlignment = Enum.TextXAlignment.Left
rejoinLabel.Parent = rejoinBtn

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

-- Build Teleport Tab (Coming Soon) dengan icon
local tpPlaceholderFrame = Instance.new("Frame")
tpPlaceholderFrame.Size = UDim2.new(1, 0, 0, 100)
tpPlaceholderFrame.BackgroundTransparency = 1
tpPlaceholderFrame.LayoutOrder = 1
tpPlaceholderFrame.Parent = tpContainer

local tpIcon = Instance.new("ImageLabel")
tpIcon.Size = UDim2.new(0, 40, 0, 40)
tpIcon.Position = UDim2.new(0.5, -20, 0.2, 0)
tpIcon.BackgroundTransparency = 1
tpIcon.Image = "rbxassetid://6023426935"
tpIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
tpIcon.Parent = tpPlaceholderFrame

local tpPlaceholder = Instance.new("TextLabel")
tpPlaceholder.Size = UDim2.new(1, 0, 0, 30)
tpPlaceholder.Position = UDim2.new(0, 0, 0.6, 0)
tpPlaceholder.BackgroundTransparency = 1
tpPlaceholder.Text = "TELEPORT FEATURES"
tpPlaceholder.TextColor3 = Color3.fromRGB(150, 150, 150)
tpPlaceholder.Font = Enum.Font.GothamBold
tpPlaceholder.TextSize = 16
tpPlaceholder.Parent = tpPlaceholderFrame

local tpComingSoon = Instance.new("TextLabel")
tpComingSoon.Size = UDim2.new(1, 0, 0, 20)
tpComingSoon.Position = UDim2.new(0, 0, 0.8, 0)
tpComingSoon.BackgroundTransparency = 1
tpComingSoon.Text = "(Coming Soon)"
tpComingSoon.TextColor3 = Color3.fromRGB(120, 120, 120)
tpComingSoon.Font = Enum.Font.Gotham
tpComingSoon.TextSize = 14
tpComingSoon.Parent = tpPlaceholderFrame

-- Typing function
local function typeWord(word, length)
    if not IsRunning then return end
    
    wordLength = length or #word
    
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
        local specialCandidates = {}
        
        for cat, enabled in pairs(categoryToggles) do
            if enabled and cat ~= "SEMUA KATA SULIT" then
                for _, word in ipairs(wordCategories[cat]) do
                    if word:sub(1, #awalan) == awalan and not usedWords[word] and #word > #awalan then
                        table.insert(specialCandidates, word)
                    end
                end
            elseif enabled and cat == "SEMUA KATA SULIT" then
                for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS"}) do
                    for _, word in ipairs(wordCategories[c]) do
                        if word:sub(1, #awalan) == awalan and not usedWords[word] and #word > #awalan then
                            table.insert(specialCandidates, word)
                        end
                    end
                end
            end
        end
        
        if #specialCandidates > 0 then
            candidates = specialCandidates
        end
        
        if #candidates == 0 then
            for _, word in ipairs(commonWords) do
                if word:sub(1, #awalan) == awalan and not usedWords[word] and #word > #awalan then
                    table.insert(candidates, word)
                end
            end
        end
        
        if #candidates > 0 then
            local chosen = candidates[math.random(1, #candidates)]
            local category = "KBBI"
            
            for cat, enabled in pairs(categoryToggles) do
                if enabled then
                    if cat == "SEMUA KATA SULIT" then
                        for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS"}) do
                            if table.find(wordCategories[c], chosen) then
                                category = "KATA SULIT (" .. c .. ")"
                                break
                            end
                        end
                    elseif table.find(wordCategories[cat], chosen) then
                        category = "KATA SULIT (" .. cat .. ")"
                        break
                    end
                end
            end
            
            print("🤖 Anixly: " .. chosen:upper() .. " | Awalan: " .. awalan:upper() .. " | " .. category)
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

-- Fungsi pencarian kata (letakkan di bagian bawah, sebelum remote handler)
local allIndonesianWords = commonWords  -- Gunakan commonWords sebagai database awal

local function searchWords(prefix)
    if #prefix < 1 or #prefix > 3 then
        resultLabel.Text = "Hasil: (minimal 1, maksimal 3 huruf)"
        return
    end
    
    local results = {}
    prefix = prefix:lower()
    
    for _, word in ipairs(allIndonesianWords) do
        if word:sub(1, #prefix) == prefix then
            table.insert(results, word)
            if #results >= 20 then break end
        end
    end
    
    if #results > 0 then
        resultLabel.Text = "Hasil (" .. #results .. "+): " .. table.concat(results, ", ")
    else
        resultLabel.Text = "Hasil: Tidak ada kata dengan awalan '" .. prefix .. "'"
    end
end

-- Koneksi ke TextBox
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = searchBox.Text:gsub("%s+", "")
    if #text >= 1 and #text <= 3 then
        searchWords(text)
    else
        resultLabel.Text = "Hasil: (1-3 huruf saja)"
    end
end)

-- Load kata dari URL (opsional)
task.spawn(function()
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/geovedi/indonesian-wordlist/master/00-indonesian-wordlist.lst")
    end)
    
    if success and type(response) == "string" and #response > 1000 then
        local newWords = {}
        for line in string.gmatch(response, "[^\r\n]+") do
            local word = (line:gsub("%s+", "")):lower()
            if #word > 1 and string.match(word, "^%a+$") then
                table.insert(newWords, word)
            end
        end
        if #newWords > 1000 then
            allIndonesianWords = newWords
            print("✅ Database kata Indonesia dimuat! (" .. #newWords .. " kata)")
        end
    end
end)

-- Load word categories
task.spawn(function()
    local urls = {
        IF = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/IF.txt",
        X = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/X.txt",
        NG = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/NG.txt",
        AI = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/AI.txt",
        ["SEMUA KATA SULIT"] = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/sulit.txt",        
        CY = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/CY.txt",
        UI = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/UI.txt",
        KS = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/KS.txt", 
        LY = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/LY.txt",
        RS = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/RS.txt",
        NS = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/NS.txt"
    }
    
    for cat, url in pairs(urls) do
        task.spawn(function()
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            
            if success and type(response) == "string" then
                for line in string.gmatch(response, "[^\r\n]+") do
                    local word = (line:gsub("%s+", "")):lower()
                    if #word > 1 and string.match(word, "^%a+$") then
                        table.insert(wordCategories[cat], word)
                    end
                end
                print("🔥 Category " .. cat .. " Loaded! (" .. #wordCategories[cat] .. " kata)")
            end
        end)
    end
end)

-- Shuffle function
local function shuffleTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- Load common words
task.spawn(function()
    local urls = {
        "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/kamus.txt",
        "https://cdn.jsdelivr.net/gh/geovedi/indonesian-wordlist@master/00-indonesian-wordlist.lst",
        "https://raw.githubusercontent.com/geovedi/indonesian-wordlist/master/00-indonesian-wordlist.lst"
    }
    
    local allWords = {}
    
    for _, url in ipairs(urls) do
        if not IsRunning then break end
        
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and type(response) == "string" and #response > 1000 then
            for line in string.gmatch(response, "[^\r\n]+") do
                local word = (line:gsub("%s+", "")):lower()
                if #word > 1 and string.match(word, "^%a+$") then
                    table.insert(allWords, word)
                end
            end
        end
    end
    
    if #allWords > 1000 then
        for _, word in ipairs(allWords) do
            table.insert(commonWords, word)
        end
        shuffleTable(commonWords)
        print("✅ Anixly: " .. #commonWords .. " Kata Dimuat!")
    end
end)

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

print("✅ Anixly Loaded dengan Collapsible Sections & Header Dot Dihapus!")