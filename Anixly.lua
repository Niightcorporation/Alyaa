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
    if CoreGui:FindFirstChild("AnixlyHub") then
        CoreGui.AnixlyHub:Destroy()
    end
end

-- Input Helpers
local function isMouseClick(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch
end

local function isMouseMovement(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch
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
    primary = Color3.fromRGB(0, 255, 255),
    mid = Color3.fromRGB(255, 0, 255),
    dark = Color3.fromRGB(10, 10, 30),
    headerBg = Color3.fromRGB(20, 20, 50),
    accent = Color3.fromRGB(255, 255, 0),
    glow = Color3.fromRGB(255, 105, 180),
    activeTab = Color3.fromRGB(138, 43, 226),
    logText = Color3.fromRGB(200, 200, 255)
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

-- ===== DELAY SETTINGS =====
local typeDelay = 0.12      -- Jeda antar huruf mode cepat
local enterDelay = 0.15     -- Jeda sebelum enter
local turnDelay = 1.5       -- Jeda sebelum mulai ngetik
local backspaceDelay = 0.10 -- Jeda hapus huruf
local deleteDelay = 0.12    -- Jeda hapus tambahan

-- Variables
local autoTypeEnabled = false
local autoEnterEnabled = true
local humanModeEnabled = false
local noclipEnabled = false
local noclipConnection
local antiAfkEnabled = false
local antiAfkConnection
local antiAdminEnabled = false
local tuyulModeEnabled = false
local isTyping = false
local typingQueue = false
local lastAwalan = ""
local tuyulCounter = 0
local tuyulLimit = 3
local tuyulSpamMode = false
local tuyulSpamCount = 0

-- Word categories
local wordCategories = {
    IF = {}, X = {}, NG = {}, AI = {}, KS = {}, CY = {}, UI = {}, LY = {}, RS = {}, NS = {},
    AX = {}, LT = {}, TT = {}, 
    ["SEMUA KATA SULIT"] = {}
}

local categoryToggles = {
    IF = false, X = false, NG = false, AI = false, KS = false,
    CY = false, UI = false, LY = false, RS = false, NS = false,
    AX = false, LT = false, TT = false,
    ["SEMUA KATA SULIT"] = false
}

local usedWords = {}
local currentWord = ""
local wordLength = 0

-- Anti Admin keywords
local adminKeywords = {"admin", "owner", "developer", "pengembang", "staff", "moderator", "mod"}

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
ScreenGui.Name = "AnixlyHub"
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

-- Resize Handle
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 24, 0, 24)
ResizeHandle.BackgroundColor3 = THEME.mid
ResizeHandle.Text = "↘️"
ResizeHandle.TextColor3 = Color3.fromRGB(200, 160, 255)
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.TextSize = IsMobile and 12 or 14
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = ScreenGui

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 8)
ResizeCorner.Parent = ResizeHandle

local ResizeStroke = Instance.new("UIStroke")
ResizeStroke.Color = THEME.accent
ResizeStroke.Thickness = 1.5
ResizeStroke.Transparency = 0.1
ResizeStroke.Parent = ResizeHandle

-- Resize Functions
local isResizing = false
local resizeStartPos, startWidth, startHeight

local function clampSize(width, height)
    local minW = IsMobile and 260 or 300
    local maxW = IsMobile and 500 or 720
    local minH = IsMobile and 200 or 230
    local maxH = IsMobile and 480 or 600
    return math.clamp(width, minW, maxW), math.clamp(height, minH, maxH)
end

local function updateGlow()
    local mainPos = MainFrame.Position
    GlowWrapper.Position = UDim2.new(
        mainPos.X.Scale, mainPos.X.Offset - 2,
        mainPos.Y.Scale, mainPos.Y.Offset - 2
    )
    GlowWrapper.Size = UDim2.new(0, MainFrame.Size.X.Offset + 4, 0, MainFrame.Size.Y.Offset + 4)
end

local function updateResizeHandlePosition()
    local mainPos = MainFrame.Position
    local mainSize = MainFrame.Size
    local handleSize = ResizeHandle.Size.X.Offset
    
    ResizeHandle.Position = UDim2.new(
        mainPos.X.Scale, (mainPos.X.Offset + mainSize.X.Offset) - handleSize,
        mainPos.Y.Scale, (mainPos.Y.Offset + mainSize.Y.Offset) - handleSize
    )
end

RunService.RenderStepped:Connect(function()
    if MainFrame.Visible then
        updateResizeHandlePosition()
    end
end)
updateResizeHandlePosition()

ResizeHandle.InputBegan:Connect(function(input)
    if not isMouseClick(input) then return end
    isResizing = true
    resizeStartPos = input.Position
    startWidth = MainFrame.Size.X.Offset
    startHeight = MainFrame.Size.Y.Offset
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            isResizing = false
        end
    end)
end)

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

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Anixlyhub V2.0"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = TEXT_SIZE_LARGE
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Efek rainbow
local hue = 0
task.spawn(function()
    while IsRunning and TitleLabel do
        hue = (hue + 0.01) % 1
        TitleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        task.wait(0.05)
    end
end)

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
MinimizeBtn.TextSize = IsMobile and 14 or 16
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0, controlSize, 0, controlSize)
CloseBtn.Position = UDim2.new(1, -(controlSize + 6), 0.5, -controlSize / 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 50, 60)
CloseBtn.Image = "rbxassetid://6023426923"
CloseBtn.ImageColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
CloseBtn.ZIndex = 10

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    IsRunning = false
end)

-- Mini Icon
local MiniIcon = Instance.new("TextButton")
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, IsMobile and 45 or 60, 0, IsMobile and 45 or 60)
MiniIcon.Position = UDim2.new(0, 10, 0.5, -30)
MiniIcon.BackgroundColor3 = THEME.headerBg
MiniIcon.Text = "☕"
MiniIcon.TextColor3 = Color3.new(1, 1, 1)
MiniIcon.Font = Enum.Font.GothamBold
MiniIcon.TextSize = IsMobile and 30 or 40
MiniIcon.Visible = false
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
    ResizeHandle.Visible = false
    MiniIcon.Visible = true
    miniDragDist = 0
end)

MiniIcon.InputBegan:Connect(function(input)
    if not isMouseClick(input) then return end
    isDraggingMini = true
    miniDragDist = 0
    dragStartPos = input.Position
    miniStartPos = MiniIcon.Position
end)

MiniIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMini = false
        local dragDist = dragStartPos and (input.Position - dragStartPos).Magnitude or 999
        if dragDist <= 12 then
            playClickSound()
            MainFrame.Visible = true
            GlowWrapper.Visible = true
            ResizeHandle.Visible = true
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
    ResizeHandle.Visible = true
    MiniIcon.Visible = false
    miniDragDist = 0
end)

-- Dragging main frame
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(1, -(controlSize * 2 + 30), 1, 0)
dragButton.Position = UDim2.new(0, 0, 0, 0)
dragButton.BackgroundTransparency = 1
dragButton.Text = ""
dragButton.ZIndex = 5
dragButton.Parent = Header

local dragStart, dragStartPos

dragButton.InputBegan:Connect(function(input)
    if not isMouseClick(input) then return end
    dragStart = input.Position
    dragStartPos = MainFrame.Position
end)

UserInputService.InputChanged:Connect(function(input)
    if not isMouseMovement(input) then return end
    
    if isResizing then
        local delta = input.Position - resizeStartPos
        local newW, newH = clampSize(startWidth + delta.X, startHeight + delta.Y)
        MainFrame.Size = UDim2.new(0, newW, 0, newH)
        updateGlow()
        updateResizeHandlePosition()
        return
    end
    
    if dragStart then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
        GlowWrapper.Position = UDim2.new(
            MainFrame.Position.X.Scale, MainFrame.Position.X.Offset - 2,
            MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 2
        )
        updateResizeHandlePosition()
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

UserInputService.InputEnded:Connect(function(input)
    if isMouseClick(input) then
        dragStart = nil
        isResizing = false
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

local SideDivider = Instance.new("Frame")
SideDivider.Size = UDim2.new(0, 1, 1, -HEADER_HEIGHT)
SideDivider.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, HEADER_HEIGHT)
SideDivider.BackgroundColor3 = THEME.mid
SideDivider.BorderSizePixel = 0
SideDivider.Parent = MainFrame

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

-- Tab Buttons
local tabButtons = {}

local function createTabButton(icon, label, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IsMobile and 38 or 40)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
    
    if IsMobile then
        btn.Text = icon .. "\n" .. label
    else
        btn.Text = icon .. "  " .. label
    end
    
    btn.TextColor3 = Color3.fromRGB(120, 110, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = TEXT_SIZE_SMALL
    btn.TextXAlignment = IsMobile and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    btn.TextWrapped = true
    btn.Parent = Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 30, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn
    
    if not IsMobile then
        local btnPadding = Instance.new("UIPadding")
        btnPadding.PaddingLeft = UDim.new(0, 10)
        btnPadding.Parent = btn
    end
    
    table.insert(tabButtons, {btn = btn, stroke = btnStroke})
    return btn
end

local infoTab = createTabButton("📋", "INFO", 0)
local mainTab = createTabButton("⚡", "MAIN", 1)
local utilTab = createTabButton("🔧", "UTIL", 2)
local nyawaTab = createTabButton("❤️", "NYAWA", 3)

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
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollingEnabled = true
    container.ScrollBarImageTransparency = 0.5
    container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    container.Parent = contentArea
    return container
end

local infoContainer = createTabContainer()
local mainContainer = createTabContainer()
local utilContainer = createTabContainer()
local nyawaContainer = createTabContainer()

local function setupContainerLayout(container)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, IsMobile and 5 or 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = container
end

setupContainerLayout(infoContainer)
setupContainerLayout(mainContainer)
setupContainerLayout(utilContainer)
setupContainerLayout(nyawaContainer)

-- Tab switching function
local function highlightTab(activeBtn)
    for _, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.btn.TextColor3 = Color3.fromRGB(120, 110, 150)
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

local function switchTab(activeContainer, activeBtn)
    infoContainer.Visible = false
    mainContainer.Visible = false
    utilContainer.Visible = false
    nyawaContainer.Visible = false
    activeContainer.Visible = true
    highlightTab(activeBtn)
end

-- Tab click handlers
infoTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(infoContainer, infoTab)
end)

mainTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(mainContainer, mainTab)
end)

utilTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(utilContainer, utilTab)
end)

nyawaTab.MouseButton1Click:Connect(function()
    playClickSound()
    switchTab(nyawaContainer, nyawaTab)
end)

-- ==============================================
-- INFO TAB CONTENT
-- ==============================================
local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingLeft = UDim.new(0, 6)
infoPadding.PaddingRight = UDim.new(0, 6)
infoPadding.PaddingTop = UDim.new(0, 8)
infoPadding.PaddingBottom = UDim.new(0, 10)
infoPadding.Parent = infoContainer

local infoLayout = Instance.new("UIListLayout")
infoLayout.Padding = UDim.new(0, 8)
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Parent = infoContainer

-- Player Info Card
local playerCard = Instance.new("Frame")
playerCard.Size = UDim2.new(1, 0, 0, IsMobile and 80 or 90)
playerCard.LayoutOrder = 1
playerCard.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
playerCard.BorderSizePixel = 0
playerCard.Parent = infoContainer

local playerCardCorner = Instance.new("UICorner")
playerCardCorner.CornerRadius = UDim.new(0, 12)
playerCardCorner.Parent = playerCard

local playerCardStroke = Instance.new("UIStroke")
playerCardStroke.Color = THEME.mid
playerCardStroke.Thickness = 1.5
playerCardStroke.Transparency = 0.2
playerCardStroke.Parent = playerCard

local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, IsMobile and 54 or 64, 0, IsMobile and 54 or 64)
avatarFrame.Position = UDim2.new(0, 10, 0.5, -(IsMobile and 27 or 32))
avatarFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = playerCard

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarFrame

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = THEME.accent
avatarStroke.Thickness = 2
avatarStroke.Transparency = 0.1
avatarStroke.Parent = avatarFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = ""
avatarImage.ScaleType = Enum.ScaleType.Crop
avatarImage.Parent = avatarFrame

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(1, 0)
avatarImageCorner.Parent = avatarImage

task.spawn(function()
    local success, url = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if success and url then
        avatarImage.Image = url
    end
end)

local avatarOffset = (IsMobile and 54 or 64) + 20

local displayNameLabel = Instance.new("TextLabel")
displayNameLabel.Size = UDim2.new(1, -(avatarOffset + 8), 0, 22)
displayNameLabel.Position = UDim2.new(0, avatarOffset, 0, IsMobile and 14 or 18)
displayNameLabel.BackgroundTransparency = 1
displayNameLabel.Text = LocalPlayer.DisplayName
displayNameLabel.TextColor3 = Color3.new(1, 1, 1)
displayNameLabel.Font = Enum.Font.GothamBold
displayNameLabel.TextSize = IsMobile and 13 or 15
displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
displayNameLabel.Parent = playerCard

local userNameLabel = Instance.new("TextLabel")
userNameLabel.Size = UDim2.new(1, -(avatarOffset + 8), 0, 18)
userNameLabel.Position = UDim2.new(0, avatarOffset, 0, IsMobile and 34 or 40)
userNameLabel.BackgroundTransparency = 1
userNameLabel.Text = "@" .. LocalPlayer.Name
userNameLabel.TextColor3 = Color3.fromRGB(130, 110, 180)
userNameLabel.Font = Enum.Font.Gotham
userNameLabel.TextSize = IsMobile and 10 or 11
userNameLabel.TextXAlignment = Enum.TextXAlignment.Left
userNameLabel.Parent = playerCard

-- Stat Card
local statCard = Instance.new("Frame")
statCard.Size = UDim2.new(1, 0, 0, IsMobile and 108 or 118)
statCard.LayoutOrder = 2
statCard.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
statCard.BorderSizePixel = 0
statCard.Parent = infoContainer

local statCorner = Instance.new("UICorner")
statCorner.CornerRadius = UDim.new(0, 12)
statCorner.Parent = statCard

local statStroke = Instance.new("UIStroke")
statStroke.Color = THEME.mid
statStroke.Thickness = 1.5
statStroke.Transparency = 0.2
statStroke.Parent = statCard

local statTitle = Instance.new("TextLabel")
statTitle.Size = UDim2.new(1, -24, 0, 20)
statTitle.Position = UDim2.new(0, 12, 0, 8)
statTitle.BackgroundTransparency = 1
statTitle.Text = "📊 STATISTIK"
statTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
statTitle.Font = Enum.Font.GothamBold
statTitle.TextSize = IsMobile and 11 or 12
statTitle.TextXAlignment = Enum.TextXAlignment.Center
statTitle.Parent = statCard

local statDivider = Instance.new("Frame")
statDivider.Size = UDim2.new(1, -24, 0, 1)
statDivider.Position = UDim2.new(0, 12, 0, 30)
statDivider.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
statDivider.BorderSizePixel = 0
statDivider.Parent = statCard

local statItemHeight = IsMobile and 34 or 38

local statData = {
    {
        labelL = "🏆 MENANG",
        labelR = "💀 KALAH",
        fnL = function()
            local success, value = pcall(function() return LocalPlayer.leaderstats.Wins.Value end)
            return success and tostring(value) or "-"
        end,
        fnR = function()
            local success, value = pcall(function() return LocalPlayer.leaderstats.Losses.Value end)
            return success and tostring(value) or "-"
        end,
        colorL = Color3.fromRGB(255, 200, 60),
        colorR = Color3.fromRGB(255, 90, 90)
    },
    {
        labelL = "📈 WIN RATE",
        labelR = "💰 KOIN",
        fnL = function()
            local wSuccess, wins = pcall(function() return LocalPlayer.leaderstats.Wins.Value end)
            local lSuccess, losses = pcall(function() return LocalPlayer.leaderstats.Losses.Value end)
            if not wSuccess or not lSuccess then return "-" end
            local total = wins + losses
            return total > 0 and math.floor((wins / total) * 100) .. "%" or "0%"
        end,
        fnR = function()
            local success, value = pcall(function() return LocalPlayer.leaderstats.Money.Value end)
            if not success then return "-" end
            local str = tostring(math.floor(value))
            local result = ""
            for i = 1, #str do
                result = result .. str:sub(i, i)
                if (#str - i) % 3 == 0 and i ~= #str then
                    result = result .. "."
                end
            end
            return "Rp" .. result
        end,
        colorL = Color3.fromRGB(80, 220, 120),
        colorR = Color3.fromRGB(255, 200, 60)
    }
}

local statRefs = {}

for i, data in ipairs(statData) do
    local yPos = 36 + (i - 1) * statItemHeight
    
    local labelL = Instance.new("TextLabel")
    labelL.Size = UDim2.new(0.5, 0, 0, 14)
    labelL.Position = UDim2.new(0, 0, 0, yPos)
    labelL.BackgroundTransparency = 1
    labelL.Text = data.labelL
    labelL.TextColor3 = Color3.fromRGB(140, 125, 175)
    labelL.Font = Enum.Font.GothamBold
    labelL.TextSize = IsMobile and 8 or 9
    labelL.TextXAlignment = Enum.TextXAlignment.Center
    labelL.Parent = statCard
    
    local valueL = Instance.new("TextLabel")
    valueL.Size = UDim2.new(0.5, 0, 0, 20)
    valueL.Position = UDim2.new(0, 0, 0, yPos + 15)
    valueL.BackgroundTransparency = 1
    valueL.Text = data.fnL()
    valueL.TextColor3 = data.colorL
    valueL.Font = Enum.Font.GothamBold
    valueL.TextSize = IsMobile and 15 or 17
    valueL.TextXAlignment = Enum.TextXAlignment.Center
    valueL.Parent = statCard
    
    local labelR = Instance.new("TextLabel")
    labelR.Size = UDim2.new(0.5, 0, 0, 14)
    labelR.Position = UDim2.new(0.5, 0, 0, yPos)
    labelR.BackgroundTransparency = 1
    labelR.Text = data.labelR
    labelR.TextColor3 = Color3.fromRGB(140, 125, 175)
    labelR.Font = Enum.Font.GothamBold
    labelR.TextSize = IsMobile and 8 or 9
    labelR.TextXAlignment = Enum.TextXAlignment.Center
    labelR.Parent = statCard
    
    local valueR = Instance.new("TextLabel")
    valueR.Size = UDim2.new(0.5, 0, 0, 20)
    valueR.Position = UDim2.new(0.5, 0, 0, yPos + 15)
    valueR.BackgroundTransparency = 1
    valueR.Text = data.fnR()
    valueR.TextColor3 = data.colorR
    valueR.Font = Enum.Font.GothamBold
    valueR.TextSize = IsMobile and 15 or 17
    valueR.TextXAlignment = Enum.TextXAlignment.Center
    valueR.Parent = statCard
    
    table.insert(statRefs, {vL = valueL, vR = valueR, fnL = data.fnL, fnR = data.fnR})
end

task.spawn(function()
    while task.wait(3) do
        if not IsRunning then break end
        pcall(function()
            for _, ref in ipairs(statRefs) do
                ref.vL.Text = ref.fnL()
                ref.vR.Text = ref.fnR()
            end
        end)
    end
end)

-- Note Card
local noteCard = Instance.new("Frame")
noteCard.Size = UDim2.new(1, 0, 0, 0)
noteCard.AutomaticSize = Enum.AutomaticSize.Y
noteCard.LayoutOrder = 3
noteCard.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
noteCard.BorderSizePixel = 0
noteCard.Parent = infoContainer

local noteCorner = Instance.new("UICorner")
noteCorner.CornerRadius = UDim.new(0, 12)
noteCorner.Parent = noteCard

local noteStroke = Instance.new("UIStroke")
noteStroke.Color = THEME.mid
noteStroke.Thickness = 1.5
noteStroke.Transparency = 0.2
noteStroke.Parent = noteCard

local notePadding = Instance.new("UIPadding")
notePadding.PaddingLeft = UDim.new(0, 12)
notePadding.PaddingRight = UDim.new(0, 12)
notePadding.PaddingTop = UDim.new(0, 10)
notePadding.PaddingBottom = UDim.new(0, 10)
notePadding.Parent = noteCard

local noteLayout = Instance.new("UIListLayout")
noteLayout.Padding = UDim.new(0, 6)
noteLayout.SortOrder = Enum.SortOrder.LayoutOrder
noteLayout.Parent = noteCard

local noteTitle = Instance.new("TextLabel")
noteTitle.Size = UDim2.new(1, 0, 0, 18)
noteTitle.LayoutOrder = 1
noteTitle.BackgroundTransparency = 1
noteTitle.Text = "Selamat datang di AnixlyHub!"
noteTitle.TextColor3 = Color3.fromRGB(200, 160, 255)
noteTitle.Font = Enum.Font.GothamBold
noteTitle.TextSize = IsMobile and 11 or 12
noteTitle.TextXAlignment = Enum.TextXAlignment.Left
noteTitle.Parent = noteCard

local noteDivider = Instance.new("Frame")
noteDivider.Size = UDim2.new(1, 0, 0, 1)
noteDivider.LayoutOrder = 2
noteDivider.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
noteDivider.BorderSizePixel = 0
noteDivider.Parent = noteCard

local notes = {
    {order = 3, text = "⚠️  Gunakan semaksimal mungkin,"},
    {order = 4, text = "     Jangan sampai ketahuan admin."},
    {order = 5, text = "⚠️  Aku ga bertanggung jawab apabila terkena banned."},
    {order = 6, text = "     Jangan Bar2."},
    {order = 7, text = "⚠️  Hati-hati kawan."},
    {order = 8, text = "     SCRIPT INI 100% FREE."},
    {order = 9, text = "Bismillahirramanirrahim Al-Fatihah."}
}

for _, note in ipairs(notes) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, note.text == "" and 4 or (IsMobile and 15 or 16))
    label.LayoutOrder = note.order
    label.BackgroundTransparency = 1
    label.Text = note.text
    label.TextColor3 = Color3.fromRGB(170, 155, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = IsMobile and 9 or 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = noteCard
end

-- Version Card
local versionCard = Instance.new("Frame")
versionCard.Size = UDim2.new(1, 0, 0, IsMobile and 36 or 40)
versionCard.LayoutOrder = 4
versionCard.BackgroundColor3 = Color3.fromRGB(14, 12, 24)
versionCard.BorderSizePixel = 0
versionCard.Parent = infoContainer

local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(0, 12)
versionCorner.Parent = versionCard

local versionStroke = Instance.new("UIStroke")
versionStroke.Color = THEME.mid
versionStroke.Thickness = 1.5
versionStroke.Transparency = 0.2
versionStroke.Parent = versionCard

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, -16, 1, 0)
versionLabel.Position = UDim2.new(0, 12, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Version: 2.0.0  •  Last update: 16 Mar 2026"
versionLabel.TextColor3 = Color3.fromRGB(100, 90, 140)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = IsMobile and 9 or 10
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Parent = versionCard

-- ==============================================
-- MAIN TAB CONTENT
-- ==============================================
local mainOrder = 1

-- AUTO FEATURES HEADER
local autoHeader = Instance.new("TextButton")
autoHeader.Size = UDim2.new(1, 0, 0, 35)
autoHeader.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
autoHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
autoHeader.Text = ""
autoHeader.AutoButtonColor = false
autoHeader.Parent = mainContainer

local autoHeaderCorner = Instance.new("UICorner")
autoHeaderCorner.CornerRadius = UDim.new(0, 8)
autoHeaderCorner.Parent = autoHeader

local autoHeaderStroke = Instance.new("UIStroke")
autoHeaderStroke.Color = THEME.mid
autoHeaderStroke.Thickness = 1
autoHeaderStroke.Transparency = 0.5
autoHeaderStroke.Parent = autoHeader

local autoIcon = Instance.new("TextLabel")
autoIcon.Size = UDim2.new(0, 18, 0, 18)
autoIcon.Position = UDim2.new(0, 10, 0.5, -9)
autoIcon.BackgroundTransparency = 1
autoIcon.Text = "⚡"
autoIcon.TextColor3 = THEME.accent
autoIcon.Font = Enum.Font.GothamBold
autoIcon.TextSize = 16
autoIcon.Parent = autoHeader

local autoTitle = Instance.new("TextLabel")
autoTitle.Size = UDim2.new(1, -80, 1, 0)
autoTitle.Position = UDim2.new(0, 35, 0, 0)
autoTitle.BackgroundTransparency = 1
autoTitle.Text = "AUTO FEATURES"
autoTitle.TextColor3 = THEME.logText
autoTitle.Font = Enum.Font.GothamBold
autoTitle.TextSize = 13
autoTitle.TextXAlignment = Enum.TextXAlignment.Left
autoTitle.Parent = autoHeader

local autoArrow = Instance.new("TextLabel")
autoArrow.Size = UDim2.new(0, 20, 0, 20)
autoArrow.Position = UDim2.new(1, -25, 0.5, -10)
autoArrow.BackgroundTransparency = 1
autoArrow.Text = "▼"
autoArrow.TextColor3 = THEME.accent
autoArrow.Font = Enum.Font.GothamBold
autoArrow.TextSize = 14
autoArrow.Parent = autoHeader

-- AUTO FEATURES CONTENT
local autoFeaturesContent = {}
local autoExpanded = true

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

-- Create Auto Features Toggles
autoFeaturesContent[1] = createToggleButton("Auto Answer", mainContainer, false, function(state) autoTypeEnabled = state end, mainOrder)
mainOrder = mainOrder + 1

autoFeaturesContent[2] = createToggleButton("Auto Submit", mainContainer, true, function(state) autoEnterEnabled = state end, mainOrder)
mainOrder = mainOrder + 1

autoFeaturesContent[3] = createToggleButton("Human Mode [🧠]", mainContainer, false, function(state) 
    humanModeEnabled = state 
    if state then
        print("👤 Human Mode AKTIF - Ngetik Lambat")
    else
        print("⚡ Mode Cepat AKTIF")
    end
end, mainOrder)
mainOrder = mainOrder + 1

-- Set initial visibility
for _, item in ipairs(autoFeaturesContent) do
    item.Visible = autoExpanded
end

autoHeader.MouseButton1Click:Connect(function()
    playClickSound()
    autoExpanded = not autoExpanded
    autoArrow.Text = autoExpanded and "▼" or "▶"
    for _, item in ipairs(autoFeaturesContent) do
        item.Visible = autoExpanded
    end
end)

-- ==============================================
-- DELAY SETTINGS HEADER (COLLAPSIBLE)
-- ==============================================
local delayHeader = Instance.new("TextButton")
delayHeader.Size = UDim2.new(1, 0, 0, 35)
delayHeader.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
delayHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
delayHeader.Text = ""
delayHeader.AutoButtonColor = false
delayHeader.Parent = mainContainer

local delayHeaderCorner = Instance.new("UICorner")
delayHeaderCorner.CornerRadius = UDim.new(0, 8)
delayHeaderCorner.Parent = delayHeader

local delayHeaderStroke = Instance.new("UIStroke")
delayHeaderStroke.Color = THEME.mid
delayHeaderStroke.Thickness = 1
delayHeaderStroke.Transparency = 0.5
delayHeaderStroke.Parent = delayHeader

local delayIcon = Instance.new("TextLabel")
delayIcon.Size = UDim2.new(0, 18, 0, 18)
delayIcon.Position = UDim2.new(0, 10, 0.5, -9)
delayIcon.BackgroundTransparency = 1
delayIcon.Text = "⏱️"
delayIcon.TextColor3 = THEME.accent
delayIcon.Font = Enum.Font.GothamBold
delayIcon.TextSize = 16
delayIcon.Parent = delayHeader

local delayTitle = Instance.new("TextLabel")
delayTitle.Size = UDim2.new(1, -80, 1, 0)
delayTitle.Position = UDim2.new(0, 35, 0, 0)
delayTitle.BackgroundTransparency = 1
delayTitle.Text = "DELAY SETTINGS"
delayTitle.TextColor3 = THEME.logText
delayTitle.Font = Enum.Font.GothamBold
delayTitle.TextSize = 13
delayTitle.TextXAlignment = Enum.TextXAlignment.Left
delayTitle.Parent = delayHeader

local delayArrow = Instance.new("TextLabel")
delayArrow.Size = UDim2.new(0, 20, 0, 20)
delayArrow.Position = UDim2.new(1, -25, 0.5, -10)
delayArrow.BackgroundTransparency = 1
delayArrow.Text = "▼"
delayArrow.TextColor3 = THEME.accent
delayArrow.Font = Enum.Font.GothamBold
delayArrow.TextSize = 14
delayArrow.Parent = delayHeader

-- DELAY SETTINGS CONTENT
local delayContent = {}
local delayExpanded = true

-- Slider function
local function createDelaySlider(parent, label, icon, minVal, maxVal, defaultMin, defaultMax, callbackMin, callbackMax, order)
    local itemHeight = IsMobile and 48 or 42
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, itemHeight)
    frame.LayoutOrder = order
    frame.BackgroundColor3 = Color3.fromRGB(13, 12, 22)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 7)
    frameCorner.Parent = frame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 80, 0, 14)
    iconLabel.Position = UDim2.new(0, 8, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon .. " " .. label
    iconLabel.TextColor3 = Color3.fromRGB(170, 155, 210)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = IsMobile and 8 or 9
    iconLabel.TextXAlignment = Enum.TextXAlignment.Left
    iconLabel.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 90, 0, 14)
    valueLabel.Position = UDim2.new(1, -94, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = IsMobile and 8 or 9
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local minValCurrent = defaultMin
    local maxValCurrent = defaultMax
    
    local function updateValueText()
        valueLabel.Text = string.format("%.2f", minValCurrent) .. " ~ " .. string.format("%.2f", maxValCurrent) .. "s"
        valueLabel.TextColor3 = THEME.logText
    end
    updateValueText()
    
    local sliderTrackSize = IsMobile and 32 or 26
    local trackHeight = IsMobile and 6 or 4
    local knobSize = IsMobile and 16 or 11
    local halfKnob = knobSize / 2
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, trackHeight)
    track.Position = UDim2.new(0, 8, 0, sliderTrackSize)
    track.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    track.BorderSizePixel = 0
    track.Parent = frame
    
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
    maxKnob.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
    maxKnob.BorderSizePixel = 0
    maxKnob.ZIndex = 3
    maxKnob.Parent = track
    
    local maxKnobCorner = Instance.new("UICorner")
    maxKnobCorner.CornerRadius = UDim.new(1, 0)
    maxKnobCorner.Parent = maxKnob
    
    local maxStroke = Instance.new("UIStroke")
    maxStroke.Color = THEME.accent
    maxStroke.Thickness = 1.5
    maxStroke.Parent = maxKnob
    
    local function roundToDec(val, dec)
        local mult = 10 ^ dec
        return math.floor(val * mult + 0.5) / mult
    end
    
    local function updateSlider()
        local minPercent = (minValCurrent - minVal) / (maxVal - minVal)
        local maxPercent = (maxValCurrent - minVal) / (maxVal - minVal)
        
        fill.Position = UDim2.new(minPercent, 0, 0, 0)
        fill.Size = UDim2.new(maxPercent - minPercent, 0, 1, 0)
        
        minKnob.Position = UDim2.new(minPercent, -halfKnob, 0.5, -halfKnob)
        maxKnob.Position = UDim2.new(maxPercent, -halfKnob, 0.5, -halfKnob)
        
        updateValueText()
    end
    updateSlider()
    
    local dragButton = Instance.new("TextButton")
    dragButton.Size = UDim2.new(1, 0, 0, sliderTrackSize + 10)
    dragButton.Position = UDim2.new(0, 0, 0.5, -(sliderTrackSize + 10)/2 + 10)
    dragButton.BackgroundTransparency = 1
    dragButton.Text = ""
    dragButton.ZIndex = 4
    dragButton.Parent = frame
    
    local draggingMin, draggingMax = false, false
    
    local function getPercentFromPos(xPos)
        local trackX = track.AbsolutePosition.X
        local trackW = track.AbsoluteSize.X
        return math.clamp((xPos - trackX) / trackW, 0, 1)
    end
    
    local function getValueFromPercent(pct)
        return roundToDec(minVal + pct * (maxVal - minVal), 2)
    end
    
    dragButton.InputBegan:Connect(function(input)
        if not isMouseClick(input) then return end
        
        local pct = getPercentFromPos(input.Position.X)
        local val = getValueFromPercent(pct)
        
        if math.abs(val - minValCurrent) <= math.abs(val - maxValCurrent) then
            draggingMin = true
        else
            draggingMax = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if not isMouseMovement(input) then return end
        if not (draggingMin or draggingMax) then return end
        
        local pct = getPercentFromPos(input.Position.X)
        local val = getValueFromPercent(pct)
        local eps = 0.01
        
        if draggingMin then
            minValCurrent = math.clamp(val, minVal, maxValCurrent - eps)
            callbackMin(minValCurrent)
        else
            maxValCurrent = math.clamp(val, minValCurrent + eps, maxVal)
            callbackMax(maxValCurrent)
        end
        
        updateSlider()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if isMouseClick(input) then
            draggingMin = false
            draggingMax = false
        end
    end)
    
    return frame
end

-- Create delay sliders
delayContent[1] = createDelaySlider(mainContainer, "NULIS", "⌨️", 0.01, 0.5, typeDelay, enterDelay, 
    function(v) typeDelay = v end, 
    function(v) enterDelay = v end, 
    mainOrder)
mainOrder = mainOrder + 1

delayContent[2] = createDelaySlider(mainContainer, "GILIRAN", "⏱️", 0.1, 3, turnDelay, turnDelay + 0.5, 
    function(v) turnDelay = v end, 
    function(v) turnDelay = v end, 
    mainOrder)
mainOrder = mainOrder + 1

delayContent[3] = createDelaySlider(mainContainer, "DELETE", "🗑️", 0.01, 0.3, backspaceDelay, deleteDelay, 
    function(v) backspaceDelay = v end, 
    function(v) deleteDelay = v end, 
    mainOrder)
mainOrder = mainOrder + 1

-- Set initial visibility
for _, item in ipairs(delayContent) do
    item.Visible = delayExpanded
end

delayHeader.MouseButton1Click:Connect(function()
    playClickSound()
    delayExpanded = not delayExpanded
    delayArrow.Text = delayExpanded and "▼" or "▶"
    for _, item in ipairs(delayContent) do
        item.Visible = delayExpanded
    end
end)

-- ==============================================
-- TUYUL MODE HEADER
-- ==============================================
local tuyulHeader = Instance.new("TextButton")
tuyulHeader.Size = UDim2.new(1, 0, 0, 35)
tuyulHeader.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
tuyulHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
tuyulHeader.Text = ""
tuyulHeader.AutoButtonColor = false
tuyulHeader.Parent = mainContainer

local tuyulHeaderCorner = Instance.new("UICorner")
tuyulHeaderCorner.CornerRadius = UDim.new(0, 8)
tuyulHeaderCorner.Parent = tuyulHeader

local tuyulHeaderStroke = Instance.new("UIStroke")
tuyulHeaderStroke.Color = THEME.mid
tuyulHeaderStroke.Thickness = 1
tuyulHeaderStroke.Transparency = 0.5
tuyulHeaderStroke.Parent = tuyulHeader

local tuyulIcon = Instance.new("TextLabel")
tuyulIcon.Size = UDim2.new(0, 18, 0, 18)
tuyulIcon.Position = UDim2.new(0, 10, 0.5, -9)
tuyulIcon.BackgroundTransparency = 1
tuyulIcon.Text = "👻"
tuyulIcon.TextColor3 = THEME.accent
tuyulIcon.Font = Enum.Font.GothamBold
tuyulIcon.TextSize = 16
tuyulIcon.Parent = tuyulHeader

local tuyulTitle = Instance.new("TextLabel")
tuyulTitle.Size = UDim2.new(1, -80, 1, 0)
tuyulTitle.Position = UDim2.new(0, 35, 0, 0)
tuyulTitle.BackgroundTransparency = 1
tuyulTitle.Text = "MODE TUYUL"
tuyulTitle.TextColor3 = THEME.logText
tuyulTitle.Font = Enum.Font.GothamBold
tuyulTitle.TextSize = 13
tuyulTitle.TextXAlignment = Enum.TextXAlignment.Left
tuyulTitle.Parent = tuyulHeader

local tuyulArrow = Instance.new("TextLabel")
tuyulArrow.Size = UDim2.new(0, 20, 0, 20)
tuyulArrow.Position = UDim2.new(1, -25, 0.5, -10)
tuyulArrow.BackgroundTransparency = 1
tuyulArrow.Text = "▼"
tuyulArrow.TextColor3 = THEME.accent
tuyulArrow.Font = Enum.Font.GothamBold
tuyulArrow.TextSize = 14
tuyulArrow.Parent = tuyulHeader

-- TUYUL MODE CONTENT
local tuyulContent = {}
local tuyulExpanded = true

-- Tuyul Mode Toggle
local tuyulToggleFrame = createToggleButton("Aktifkan Mode Tuyul", mainContainer, false, function(state)
    tuyulModeEnabled = state
    tuyulCounter = 0
    tuyulSpamMode = false
    tuyulSpamCount = 0
    if state then
        print("👻 Mode Tuyul AKTIF - Limit: " .. tuyulLimit .. " jawab benar")
    else
        print("👻 Mode Tuyul NONAKTIF")
    end
end, mainOrder)
mainOrder = mainOrder + 1
table.insert(tuyulContent, tuyulToggleFrame)

-- Tuyul Limit Setting
local limitFrame = Instance.new("Frame")
limitFrame.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT + 5)
limitFrame.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
limitFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
limitFrame.BorderSizePixel = 0
limitFrame.Parent = mainContainer
table.insert(tuyulContent, limitFrame)

local limitCorner = Instance.new("UICorner")
limitCorner.CornerRadius = UDim.new(0, 8)
limitCorner.Parent = limitFrame

local limitStroke = Instance.new("UIStroke")
limitStroke.Color = THEME.mid
limitStroke.Thickness = 1
limitStroke.Transparency = 0.6
limitStroke.Parent = limitFrame

local limitLabel = Instance.new("TextLabel")
limitLabel.Size = UDim2.new(0.5, -5, 1, 0)
limitLabel.Position = UDim2.new(0, 10, 0, 0)
limitLabel.BackgroundTransparency = 1
limitLabel.Text = "Limit Jawab Benar:"
limitLabel.TextColor3 = Color3.fromRGB(210, 200, 230)
limitLabel.Font = Enum.Font.GothamBold
limitLabel.TextSize = TEXT_SIZE_NORMAL
limitLabel.TextXAlignment = Enum.TextXAlignment.Left
limitLabel.Parent = limitFrame

local limitBox = Instance.new("TextBox")
limitBox.Size = UDim2.new(0.4, 0, 0.7, 0)
limitBox.Position = UDim2.new(0.5, 5, 0.15, 0)
limitBox.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
limitBox.Text = tostring(tuyulLimit)
limitBox.TextColor3 = Color3.new(1, 1, 1)
limitBox.Font = Enum.Font.GothamBold
limitBox.TextSize = TEXT_SIZE_NORMAL
limitBox.PlaceholderText = "1-10"
limitBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 120)
limitBox.ClearTextOnFocus = false
limitBox.Parent = limitFrame

local limitBoxCorner = Instance.new("UICorner")
limitBoxCorner.CornerRadius = UDim.new(0, 6)
limitBoxCorner.Parent = limitBox

limitBox.FocusLost:Connect(function(enterPressed)
    local val = tonumber(limitBox.Text)
    if val and val >= 1 and val <= 10 then
        tuyulLimit = math.floor(val)
        print("👻 Tuyul limit diubah ke: " .. tuyulLimit)
    else
        limitBox.Text = tostring(tuyulLimit)
    end
end)

-- Tuyul Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: " .. (tuyulModeEnabled and "Aktif" or "Nonaktif") .. " | Progress: 0/" .. tuyulLimit
statusLabel.TextColor3 = THEME.logText
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = TEXT_SIZE_SMALL
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainContainer
table.insert(tuyulContent, statusLabel)

-- Update status periodically
task.spawn(function()
    while IsRunning do
        task.wait(1)
        if tuyulModeEnabled then
            statusLabel.Text = "Status: Aktif | Progress: " .. tuyulCounter .. "/" .. tuyulLimit .. (tuyulSpamMode and " [SPAM MODE]" or "")
        else
            statusLabel.Text = "Status: Nonaktif | Progress: 0/" .. tuyulLimit
        end
    end
end)

-- Set initial visibility
for _, item in ipairs(tuyulContent) do
    item.Visible = tuyulExpanded
end

tuyulHeader.MouseButton1Click:Connect(function()
    playClickSound()
    tuyulExpanded = not tuyulExpanded
    tuyulArrow.Text = tuyulExpanded and "▼" or "▶"
    for _, item in ipairs(tuyulContent) do
        item.Visible = tuyulExpanded
    end
end)

-- ==============================================
-- KATA SULIT HEADER
-- ==============================================
local kataHeader = Instance.new("TextButton")
kataHeader.Size = UDim2.new(1, 0, 0, 35)
kataHeader.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
kataHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
kataHeader.Text = ""
kataHeader.AutoButtonColor = false
kataHeader.Parent = mainContainer

local kataHeaderCorner = Instance.new("UICorner")
kataHeaderCorner.CornerRadius = UDim.new(0, 8)
kataHeaderCorner.Parent = kataHeader

local kataHeaderStroke = Instance.new("UIStroke")
kataHeaderStroke.Color = THEME.mid
kataHeaderStroke.Thickness = 1
kataHeaderStroke.Transparency = 0.5
kataHeaderStroke.Parent = kataHeader

local kataIcon = Instance.new("TextLabel")
kataIcon.Size = UDim2.new(0, 18, 0, 18)
kataIcon.Position = UDim2.new(0, 10, 0.5, -9)
kataIcon.BackgroundTransparency = 1
kataIcon.Text = "⚔️"
kataIcon.TextColor3 = THEME.accent
kataIcon.Font = Enum.Font.GothamBold
kataIcon.TextSize = 16
kataIcon.Parent = kataHeader

local kataTitle = Instance.new("TextLabel")
kataTitle.Size = UDim2.new(1, -80, 1, 0)
kataTitle.Position = UDim2.new(0, 35, 0, 0)
kataTitle.BackgroundTransparency = 1
kataTitle.Text = "KATA SULIT"
kataTitle.TextColor3 = THEME.logText
kataTitle.Font = Enum.Font.GothamBold
kataTitle.TextSize = 13
kataTitle.TextXAlignment = Enum.TextXAlignment.Left
kataTitle.Parent = kataHeader

local kataArrow = Instance.new("TextLabel")
kataArrow.Size = UDim2.new(0, 20, 0, 20)
kataArrow.Position = UDim2.new(1, -25, 0.5, -10)
kataArrow.BackgroundTransparency = 1
kataArrow.Text = "▼"
kataArrow.TextColor3 = THEME.accent
kataArrow.Font = Enum.Font.GothamBold
kataArrow.TextSize = 14
kataArrow.Parent = kataHeader

-- Kata Sulit Dropdown Button
local kataSulitBtn = Instance.new("TextButton")
kataSulitBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
kataSulitBtn.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
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
kataDropdown.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
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
local categories = {"IF", "X", "NG", "AI", "CY", "UI", "KS", "RS", "NS", "AX", "LT", "TT", "LY", "SEMUA KATA SULIT"}

-- Kata Sulit content array
local kataContent = {kataSulitBtn, kataDropdown}
local kataExpanded = true

for _, item in ipairs(kataContent) do
    item.Visible = kataExpanded
end

kataHeader.MouseButton1Click:Connect(function()
    playClickSound()
    kataExpanded = not kataExpanded
    kataArrow.Text = kataExpanded and "▼" or "▶"
    for _, item in ipairs(kataContent) do
        item.Visible = kataExpanded
    end
end)

local function getCategoryCount(cat)
    if cat == "SEMUA KATA SULIT" then
        local total = 0
        for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "RS", "NS", "AX", "LT", "TT", "LY"}) do
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
        local isSelected = categoryToggles[cat]
        local count = getCategoryCount(cat)
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, categoryHeight)
        btn.Position = UDim2.new(0, 5, 0, (i - 1) * categoryHeight + 2)
        btn.BackgroundColor3 = isSelected and Color3.fromRGB(80, 30, 170) or Color3.fromRGB(28, 25, 42)
        btn.Text = ""
        btn.Parent = kataDropdown
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        
        -- Nama kategori + jumlah kata
        local catLabel = Instance.new("TextLabel")
        catLabel.Size = UDim2.new(0, 80, 1, 0)
        catLabel.Position = UDim2.new(0, 10, 0, 0)
        catLabel.BackgroundTransparency = 1
        catLabel.Text = cat
        catLabel.TextColor3 = isSelected and Color3.new(1, 1, 1) or Color3.fromRGB(160, 150, 190)
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
        countLabel.TextColor3 = isSelected and THEME.accent or Color3.fromRGB(120, 100, 150)
        countLabel.Font = Enum.Font.Gotham
        countLabel.TextSize = TEXT_SIZE_SMALL
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.Parent = btn
        
        if isSelected then
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
                    for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "RS", "NS", "AX", "LT", "TT", "LY"}) do
                        categoryToggles[c] = false
                    end
                end
            else
                categoryToggles[cat] = not categoryToggles[cat]
                local anyOn = false
                for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "RS", "NS", "AX", "LT", "TT", "LY"}) do
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

kataSulitBtn.MouseButton1Click:Connect(function()
    playClickSound()
    dropdownOpen = not dropdownOpen
    kataSulitBtn.Text = dropdownOpen and "SET KATA SULIT ▲" or "SET KATA SULIT ▼"
    
    local dropdownHeight = #categories * categoryHeight + 5
    kataDropdown:TweenSize(
        UDim2.new(1, 0, 0, dropdownOpen and dropdownHeight or 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.3,
        true
    )
    
    updateCategoryButtons()
end)

-- ==============================================
-- INFORMATION SECTION (AWALAN & KATA)
-- ==============================================
local infoSectionHeader = Instance.new("TextButton")
infoSectionHeader.Size = UDim2.new(1, 0, 0, 35)
infoSectionHeader.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
infoSectionHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
infoSectionHeader.Text = ""
infoSectionHeader.AutoButtonColor = false
infoSectionHeader.Parent = mainContainer

local infoSectionCorner = Instance.new("UICorner")
infoSectionCorner.CornerRadius = UDim.new(0, 8)
infoSectionCorner.Parent = infoSectionHeader

local infoSectionStroke = Instance.new("UIStroke")
infoSectionStroke.Color = THEME.mid
infoSectionStroke.Thickness = 1
infoSectionStroke.Transparency = 0.5
infoSectionStroke.Parent = infoSectionHeader

local infoSectionIcon = Instance.new("TextLabel")
infoSectionIcon.Size = UDim2.new(0, 18, 0, 18)
infoSectionIcon.Position = UDim2.new(0, 10, 0.5, -9)
infoSectionIcon.BackgroundTransparency = 1
infoSectionIcon.Text = "📝"
infoSectionIcon.TextColor3 = THEME.accent
infoSectionIcon.Font = Enum.Font.GothamBold
infoSectionIcon.TextSize = 16
infoSectionIcon.Parent = infoSectionHeader

local infoSectionTitle = Instance.new("TextLabel")
infoSectionTitle.Size = UDim2.new(1, -80, 1, 0)
infoSectionTitle.Position = UDim2.new(0, 35, 0, 0)
infoSectionTitle.BackgroundTransparency = 1
infoSectionTitle.Text = "INFORMATION"
infoSectionTitle.TextColor3 = THEME.logText
infoSectionTitle.Font = Enum.Font.GothamBold
infoSectionTitle.TextSize = 13
infoSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
infoSectionTitle.Parent = infoSectionHeader

local infoSectionArrow = Instance.new("TextLabel")
infoSectionArrow.Size = UDim2.new(0, 20, 0, 20)
infoSectionArrow.Position = UDim2.new(1, -25, 0.5, -10)
infoSectionArrow.BackgroundTransparency = 1
infoSectionArrow.Text = "▼"
infoSectionArrow.TextColor3 = THEME.accent
infoSectionArrow.Font = Enum.Font.GothamBold
infoSectionArrow.TextSize = 14
infoSectionArrow.Parent = infoSectionHeader

-- Information Content
local infoSectionContent = {}
local infoSectionExpanded = true

local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, 0, 0, 80)
logFrame.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
logFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainContainer
table.insert(infoSectionContent, logFrame)

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 8)
logCorner.Parent = logFrame

local logStroke = Instance.new("UIStroke")
logStroke.Color = THEME.mid
logStroke.Thickness = 1
logStroke.Transparency = 0.5
logStroke.Parent = logFrame

-- AWALAN Label
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

-- Kata Label
local kataLabel = Instance.new("TextLabel")
kataLabel.Size = UDim2.new(1, -10, 0, 30)
kataLabel.Position = UDim2.new(0, 10, 0, 35)
kataLabel.BackgroundTransparency = 1
kataLabel.Text = "-"
kataLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
kataLabel.Font = Enum.Font.GothamBold
kataLabel.TextSize = IsMobile and 16 or 18
kataLabel.TextXAlignment = Enum.TextXAlignment.Left
kataLabel.Parent = logFrame

-- Search Box
local searchLabel = Instance.new("TextLabel")
searchLabel.Size = UDim2.new(0, 70, 0, 25)
searchLabel.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
searchLabel.BackgroundTransparency = 1
searchLabel.Text = "Cari Kata:"
searchLabel.TextColor3 = Color3.fromRGB(180, 170, 210)
searchLabel.Font = Enum.Font.GothamBold
searchLabel.TextSize = 12
searchLabel.TextXAlignment = Enum.TextXAlignment.Left
searchLabel.Parent = mainContainer
table.insert(infoSectionContent, searchLabel)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, 0, 0, 28)
searchBox.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
searchBox.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
searchBox.Text = ""
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.PlaceholderText = "1-3 huruf (contoh: ka)"
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 90, 120)
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainContainer
table.insert(infoSectionContent, searchBox)

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchBox

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = THEME.primary
searchStroke.Thickness = 1
searchStroke.Transparency = 0.5
searchStroke.Parent = searchBox

-- Result Frame
local resultFrame = Instance.new("ScrollingFrame")
resultFrame.Size = UDim2.new(1, 0, 0, 80)
resultFrame.LayoutOrder = mainOrder
mainOrder = mainOrder + 1
resultFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
resultFrame.BorderSizePixel = 0
resultFrame.ScrollBarThickness = 4
resultFrame.ScrollBarImageColor3 = THEME.accent
resultFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
resultFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
resultFrame.Parent = mainContainer
table.insert(infoSectionContent, resultFrame)

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 6)
resultCorner.Parent = resultFrame

local resultStroke = Instance.new("UIStroke")
resultStroke.Color = THEME.mid
resultStroke.Thickness = 1
resultStroke.Transparency = 0.5
resultStroke.Parent = resultFrame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -10, 0, 0)
resultLabel.Position = UDim2.new(0, 5, 0, 5)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Hasil: -"
resultLabel.TextColor3 = THEME.logText
resultLabel.Font = Enum.Font.Gotham
resultLabel.TextSize = 12
resultLabel.TextWrapped = true
resultLabel.TextXAlignment = Enum.TextXAlignment.Left
resultLabel.TextYAlignment = Enum.TextYAlignment.Top
resultLabel.AutomaticSize = Enum.AutomaticSize.Y
resultLabel.Parent = resultFrame

-- Set initial visibility
for _, item in ipairs(infoSectionContent) do
    item.Visible = infoSectionExpanded
end

infoSectionHeader.MouseButton1Click:Connect(function()
    playClickSound()
    infoSectionExpanded = not infoSectionExpanded
    infoSectionArrow.Text = infoSectionExpanded and "▼" or "▶"
    for _, item in ipairs(infoSectionContent) do
        item.Visible = infoSectionExpanded
    end
end)

-- ==============================================
-- UTILITY TAB CONTENT
-- ==============================================
local utilOrder = 1

-- UTILITY HEADER
local utilMainHeader = Instance.new("TextButton")
utilMainHeader.Size = UDim2.new(1, 0, 0, 35)
utilMainHeader.LayoutOrder = utilOrder
utilOrder = utilOrder + 1
utilMainHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
utilMainHeader.Text = ""
utilMainHeader.AutoButtonColor = false
utilMainHeader.Parent = utilContainer

local utilMainHeaderCorner = Instance.new("UICorner")
utilMainHeaderCorner.CornerRadius = UDim.new(0, 8)
utilMainHeaderCorner.Parent = utilMainHeader

local utilMainHeaderStroke = Instance.new("UIStroke")
utilMainHeaderStroke.Color = THEME.mid
utilMainHeaderStroke.Thickness = 1
utilMainHeaderStroke.Transparency = 0.5
utilMainHeaderStroke.Parent = utilMainHeader

local utilMainIcon = Instance.new("TextLabel")
utilMainIcon.Size = UDim2.new(0, 18, 0, 18)
utilMainIcon.Position = UDim2.new(0, 10, 0.5, -9)
utilMainIcon.BackgroundTransparency = 1
utilMainIcon.Text = "🔧"
utilMainIcon.TextColor3 = THEME.accent
utilMainIcon.Font = Enum.Font.GothamBold
utilMainIcon.TextSize = 16
utilMainIcon.Parent = utilMainHeader

local utilMainTitle = Instance.new("TextLabel")
utilMainTitle.Size = UDim2.new(1, -80, 1, 0)
utilMainTitle.Position = UDim2.new(0, 35, 0, 0)
utilMainTitle.BackgroundTransparency = 1
utilMainTitle.Text = "UTILITY FEATURES"
utilMainTitle.TextColor3 = THEME.logText
utilMainTitle.Font = Enum.Font.GothamBold
utilMainTitle.TextSize = 13
utilMainTitle.TextXAlignment = Enum.TextXAlignment.Left
utilMainTitle.Parent = utilMainHeader

local utilMainArrow = Instance.new("TextLabel")
utilMainArrow.Size = UDim2.new(0, 20, 0, 20)
utilMainArrow.Position = UDim2.new(1, -25, 0.5, -10)
utilMainArrow.BackgroundTransparency = 1
utilMainArrow.Text = "▼"
utilMainArrow.TextColor3 = THEME.accent
utilMainArrow.Font = Enum.Font.GothamBold
utilMainArrow.TextSize = 14
utilMainArrow.Parent = utilMainHeader

-- Utility Content
local utilContent = {}
local utilExpanded = true

-- Noclip toggle
utilContent[1] = createToggleButton("NOCLIP", utilContainer, false, function(state)
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

-- Anti AFK toggle
utilContent[2] = createToggleButton("ANTI AFK", utilContainer, false, function(state)
    antiAfkEnabled = state
    if state then
        antiAfkConnection = LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
        end
    end
end, utilOrder)
utilOrder = utilOrder + 1

-- Anti Admin toggle
utilContent[3] = createToggleButton("ANTI ADMIN", utilContainer, false, function(state)
    antiAdminEnabled = state
    if state then
        print("🛡️ Anti Admin AKTIF")
        antiAdminCheck()
    else
        print("🛡️ Anti Admin NONAKTIF")
    end
end, utilOrder)
utilOrder = utilOrder + 1

-- Respawn button
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT)
respawnBtn.LayoutOrder = utilOrder
utilOrder = utilOrder + 1
respawnBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
respawnBtn.Text = "RESPAWN"
respawnBtn.TextColor3 = Color3.fromRGB(200, 190, 220)
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextSize = TEXT_SIZE_NORMAL
respawnBtn.Parent = utilContainer
table.insert(utilContent, respawnBtn)

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
utilOrder = utilOrder + 1
rejoinBtn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
rejoinBtn.Text = "REJOIN SERVER"
rejoinBtn.TextColor3 = Color3.fromRGB(200, 190, 220)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = TEXT_SIZE_NORMAL
rejoinBtn.Parent = utilContainer
table.insert(utilContent, rejoinBtn)

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

-- Set initial visibility
for _, item in ipairs(utilContent) do
    item.Visible = utilExpanded
end

utilMainHeader.MouseButton1Click:Connect(function()
    playClickSound()
    utilExpanded = not utilExpanded
    utilMainArrow.Text = utilExpanded and "▼" or "▶"
    for _, item in ipairs(utilContent) do
        item.Visible = utilExpanded
    end
end)

-- Anti Admin function
local function isAdminName(name)
    local clean = (name:lower()):gsub("[^%a%d]", "")
    for _, keyword in ipairs(adminKeywords) do
        if clean:find(keyword, 1, true) then
            return true, keyword
        end
    end
    return false
end

local function antiAdminCheck()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isAdmin, keyword = isAdminName(player.Name)
            if not isAdmin then
                isAdmin, keyword = isAdminName(player.DisplayName)
            end
            if isAdmin then
                print("🛡️ ADMIN DETECTED: " .. player.Name .. " [" .. keyword .. "] — Pindah server!")
                awalanLabel.Text = "⚠️ ADMIN: " .. player.Name
                kataLabel.Text = "Pindah server..."
                task.wait(0.5)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
                return
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if not antiAdminEnabled then return end
    task.wait(1)
    antiAdminCheck()
end)

task.spawn(function()
    while task.wait(5) do
        if not IsRunning then break end
        if antiAdminEnabled then
            antiAdminCheck()
        end
    end
end)

-- ==============================================
-- NYAWA TAB CONTENT
-- ==============================================
local nyawaOrder = 1

-- Nyawa Header
local nyawaMainHeader = Instance.new("TextButton")
nyawaMainHeader.Size = UDim2.new(1, 0, 0, 35)
nyawaMainHeader.LayoutOrder = nyawaOrder
nyawaOrder = nyawaOrder + 1
nyawaMainHeader.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
nyawaMainHeader.Text = ""
nyawaMainHeader.AutoButtonColor = false
nyawaMainHeader.Parent = nyawaContainer

local nyawaHeaderCorner = Instance.new("UICorner")
nyawaHeaderCorner.CornerRadius = UDim.new(0, 8)
nyawaHeaderCorner.Parent = nyawaMainHeader

local nyawaHeaderStroke = Instance.new("UIStroke")
nyawaHeaderStroke.Color = THEME.mid
nyawaHeaderStroke.Thickness = 1
nyawaHeaderStroke.Transparency = 0.5
nyawaHeaderStroke.Parent = nyawaMainHeader

local nyawaIcon = Instance.new("TextLabel")
nyawaIcon.Size = UDim2.new(0, 18, 0, 18)
nyawaIcon.Position = UDim2.new(0, 10, 0.5, -9)
nyawaIcon.BackgroundTransparency = 1
nyawaIcon.Text = "❤️"
nyawaIcon.TextColor3 = THEME.accent
nyawaIcon.Font = Enum.Font.GothamBold
nyawaIcon.TextSize = 16
nyawaIcon.Parent = nyawaMainHeader

local nyawaTitle = Instance.new("TextLabel")
nyawaTitle.Size = UDim2.new(1, -80, 1, 0)
nyawaTitle.Position = UDim2.new(0, 35, 0, 0)
nyawaTitle.BackgroundTransparency = 1
nyawaTitle.Text = "NYAWA PEMAIN"
nyawaTitle.TextColor3 = THEME.logText
nyawaTitle.Font = Enum.Font.GothamBold
nyawaTitle.TextSize = 13
nyawaTitle.TextXAlignment = Enum.TextXAlignment.Left
nyawaTitle.Parent = nyawaMainHeader

local nyawaArrow = Instance.new("TextLabel")
nyawaArrow.Size = UDim2.new(0, 20, 0, 20)
nyawaArrow.Position = UDim2.new(1, -25, 0.5, -10)
nyawaArrow.BackgroundTransparency = 1
nyawaArrow.Text = "▼"
nyawaArrow.TextColor3 = THEME.accent
nyawaArrow.Font = Enum.Font.GothamBold
nyawaArrow.TextSize = 14
nyawaArrow.Parent = nyawaMainHeader

-- Nyawa Content
local nyawaContent = {}
local nyawaExpanded = true

-- Refresh button frame
local refreshFrame = Instance.new("Frame")
refreshFrame.Size = UDim2.new(1, 0, 0, COMPONENT_HEIGHT + 5)
refreshFrame.LayoutOrder = nyawaOrder
nyawaOrder = nyawaOrder + 1
refreshFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
refreshFrame.BorderSizePixel = 0
refreshFrame.Parent = nyawaContainer
table.insert(nyawaContent, refreshFrame)

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 8)
refreshCorner.Parent = refreshFrame

local refreshStroke = Instance.new("UIStroke")
refreshStroke.Color = THEME.mid
refreshStroke.Thickness = 1
refreshStroke.Transparency = 0.6
refreshStroke.Parent = refreshFrame

local refreshLabel = Instance.new("TextLabel")
refreshLabel.Size = UDim2.new(0.6, -10, 1, 0)
refreshLabel.Position = UDim2.new(0, 10, 0, 0)
refreshLabel.BackgroundTransparency = 1
refreshLabel.Text = "Status Nyawa Musuh:"
refreshLabel.TextColor3 = Color3.fromRGB(210, 200, 230)
refreshLabel.Font = Enum.Font.GothamBold
refreshLabel.TextSize = TEXT_SIZE_NORMAL
refreshLabel.TextXAlignment = Enum.TextXAlignment.Left
refreshLabel.Parent = refreshFrame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
refreshBtn.Position = UDim2.new(0.62, 5, 0.15, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
refreshBtn.Text = "🔄 REFRESH"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = TEXT_SIZE_SMALL
refreshBtn.Parent = refreshFrame

local refreshBtnCorner = Instance.new("UICorner")
refreshBtnCorner.CornerRadius = UDim.new(0, 6)
refreshBtnCorner.Parent = refreshBtn

-- Nyawa info frame
local nyawaInfo = Instance.new("Frame")
nyawaInfo.Size = UDim2.new(1, 0, 0, 80)
nyawaInfo.LayoutOrder = nyawaOrder
nyawaOrder = nyawaOrder + 1
nyawaInfo.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
nyawaInfo.BorderSizePixel = 0
nyawaInfo.Parent = nyawaContainer
table.insert(nyawaContent, nyawaInfo)

local nyawaInfoCorner = Instance.new("UICorner")
nyawaInfoCorner.CornerRadius = UDim.new(0, 8)
nyawaInfoCorner.Parent = nyawaInfo

local nyawaInfoStroke = Instance.new("UIStroke")
nyawaInfoStroke.Color = THEME.mid
nyawaInfoStroke.Thickness = 1
nyawaInfoStroke.Transparency = 0.5
nyawaInfoStroke.Parent = nyawaInfo

local nyawaStatus = Instance.new("TextLabel")
nyawaStatus.Size = UDim2.new(1, -10, 1, -10)
nyawaStatus.Position = UDim2.new(0, 5, 0, 5)
nyawaStatus.BackgroundTransparency = 1
nyawaStatus.Text = "Klik REFRESH untuk melihat nyawa musuh\natau bergabung ke match terlebih dahulu"
nyawaStatus.TextColor3 = THEME.logText
nyawaStatus.Font = Enum.Font.Gotham
nyawaStatus.TextSize = TEXT_SIZE_NORMAL
nyawaStatus.TextWrapped = true
nyawaStatus.TextXAlignment = Enum.TextXAlignment.Center
nyawaStatus.TextYAlignment = Enum.TextYAlignment.Center
nyawaStatus.Parent = nyawaInfo

-- Set initial visibility
for _, item in ipairs(nyawaContent) do
    item.Visible = nyawaExpanded
end

nyawaMainHeader.MouseButton1Click:Connect(function()
    playClickSound()
    nyawaExpanded = not nyawaExpanded
    nyawaArrow.Text = nyawaExpanded and "▼" or "▶"
    for _, item in ipairs(nyawaContent) do
        item.Visible = nyawaExpanded
    end
end)

-- Nyawa data
local nyawaData = {}
local nyawaInitialized = false

local function snapshotMatch()
    local currentTable = LocalPlayer:GetAttribute("CurrentTable")
    nyawaData = {}
    
    if not currentTable then
        nyawaStatus.Text = "Kamu belum berada dalam match"
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local success, tableVal = pcall(function() return player:GetAttribute("CurrentTable") end)
            if success and tableVal and tableVal == currentTable then
                local livesSuccess, livesVal = pcall(function() return player:GetAttribute("Lives") end)
                table.insert(nyawaData, {
                    player = player,
                    nama = player.Name,
                    lives = livesSuccess and livesVal or 2,
                    dead = false
                })
            end
        end
    end
    
    nyawaInitialized = true
    updateNyawaDisplay()
end

local function updateNyawaDisplay()
    if #nyawaData == 0 then
        nyawaStatus.Text = "Tidak ada musuh dalam match"
        return
    end
    
    local text = "NYAWA MUSUH:\n"
    for i, data in ipairs(nyawaData) do
        -- Check if still in match
        local currentTable = LocalPlayer:GetAttribute("CurrentTable")
        local success, tableVal = pcall(function() return data.player:GetAttribute("CurrentTable") end)
        
        if not success or tableVal ~= currentTable then
            data.dead = true
        else
            local livesSuccess, livesVal = pcall(function() return data.player:GetAttribute("Lives") end)
            if livesSuccess then
                data.lives = livesVal
                if livesVal <= 0 then
                    data.dead = true
                end
            end
        end
        
        local hearts = ""
        if data.dead then
            hearts = "💀 MATI"
        else
            for i = 1, data.lives do
                hearts = hearts .. "❤️"
            end
            for i = data.lives + 1, 2 do
                hearts = hearts .. "🖤"
            end
        end
        
        text = text .. i .. ". " .. data.nama .. ": " .. hearts .. "\n"
    end
    
    nyawaStatus.Text = text
end

refreshBtn.MouseButton1Click:Connect(function()
    playClickSound()
    refreshBtn.Text = "⏳..."
    snapshotMatch()
    task.wait(0.5)
    refreshBtn.Text = "🔄 REFRESH"
end)

LocalPlayer:GetAttributeChangedSignal("CurrentTable"):Connect(function()
    nyawaInitialized = false
    nyawaData = {}
    nyawaStatus.Text = "Klik REFRESH untuk melihat nyawa musuh"
end)

-- ==============================================
-- TYPING FUNCTIONS
-- ==============================================
local function typeWord(word, length)
    if not IsRunning then return end
    wordLength = length or #word
    
    if humanModeEnabled then
        -- HUMAN MODE LAMBAT (TANPA TYPO)
        for i = 1, #word do
            if not IsRunning then return end
            
            local char = word:sub(i, i):upper()
            local keyCode = Enum.KeyCode[char]
            
            if keyCode then
                -- Jeda antar huruf (lebih lambat)
                task.wait(math.random() * 0.15 + 0.1)  -- 0.1 - 0.25 detik
                
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
            end
        end
        
        -- Jeda sebelum enter
        task.wait(math.random() * 0.2 + 0.1)  -- 0.1 - 0.3 detik
        
    else
        -- MODE CEPAT (seperti biasa)
        for i = 1, #word do
            if not IsRunning then return end
            
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
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end
end

-- Fungsi hapus kata dengan backspace
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

-- Auto type function
local function autoType()
    -- Anti-stuck: timeout 5 detik
    local startTime = tick()
    
    if not autoTypeEnabled or not IsRunning or isTyping then 
        if autoTypeEnabled and not isTyping then
            typingQueue = true
        end
        return 
    end
    
    isTyping = true
    typingQueue = false
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local matchUI = playerGui:FindFirstChild("MatchUI", true)
    local awalan = ""
    
    -- Timeout untuk mencari awalan
    while not awalan and (tick() - startTime < 5) do
        if matchUI then
            for _, obj in pairs(matchUI:GetDescendants()) do
                if (obj.Name == "WordServer" or obj.Name == "Word") and obj:IsA("TextLabel") and obj.Visible then
                    local text = (obj.Text:gsub("%s+", "")):lower()
                    if #text >= 1 and #text <= 4 then
                        awalan = text
                        break
                    end
                end
            end
        end
        if not awalan then
            task.wait(0.1)
        end
    end
    
    -- Kalau timeout, reset
    if not awalan then
        isTyping = false
        return
    end
    
    -- Track perubahan awalan
    if awalan ~= lastAwalan then
        print("🔄 Awalan berubah: " .. awalan:upper() .. " (sebelumnya: " .. lastAwalan:upper() .. ")")
        lastAwalan = awalan
    end
    
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
            for _, c in ipairs({"IF", "X", "NG", "AI", "CY", "UI", "KS", "RS", "NS", "AX", "LT", "TT", "LY"}) do
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
        -- Coba maksimal 3 kali kalau kata yang dipilih ternyata sudah dipakai
        local maxAttempts = 3
        local chosen = nil
        
        for attempt = 1, maxAttempts do
            local candidate = candidates[math.random(1, #candidates)]
            if not usedWords[candidate] then
                chosen = candidate
                break
            end
        end
        
        -- Kalau semua kata sudah dipakai, reset usedWords?
        if not chosen then
            print("⚠️ Semua kata sudah dipakai, reset blacklist...")
            usedWords = {}
            chosen = candidates[math.random(1, #candidates)]
        end
        
        kataLabel.Text = chosen:upper()
        currentWord = chosen
        
        -- Tuyul mode logic
        if tuyulModeEnabled and not tuyulSpamMode then
            tuyulCounter = tuyulCounter + 1
            if tuyulCounter >= tuyulLimit then
                tuyulSpamMode = true
                tuyulSpamCount = 0
                print("👻 TUYUL MODE AKTIF! Akan mengirim jawaban acak 2x")
            end
        end
        
        -- If in spam mode, send random letters
        if tuyulSpamMode then
            tuyulSpamCount = tuyulSpamCount + 1
            print("👻 Tuyul spam ke-" .. tuyulSpamCount)
            
            -- Send random letters
            local randomChars = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
            local spamWord = ""
            for i = 1, math.random(2, 4) do
                spamWord = spamWord .. randomChars[math.random(1, #randomChars)]
            end
            
            for i = 1, #spamWord do
                local char = spamWord:sub(i, i)
                local keyCode = Enum.KeyCode[char]
                if keyCode then
                    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
                    task.wait(0.05)
                end
            end
            
            if autoEnterEnabled then
                task.wait(enterDelay)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.03)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
            
            if tuyulSpamCount >= 2 then
                tuyulSpamMode = false
                tuyulCounter = 0
                print("👻 Tuyul mode selesai")
            end
        else
            -- Normal typing
            typeWord(chosen:sub(#awalan + 1), #chosen)
            usedWords[chosen] = true
        end
        
        task.wait(1)
        awalanLabel.Text = "AWALAN: -"
        kataLabel.Text = "-"
    end
    
    task.wait(0.5)
    isTyping = false
    
    if typingQueue and autoTypeEnabled then
        task.spawn(autoType)
    end
end

-- Search function
local allIndonesianWords = commonWords

local function searchWords(prefix)
    if not resultLabel then return end
    
    if #prefix < 1 or #prefix > 3 then
        resultLabel.Text = "Hasil: (minimal 1, maksimal 3 huruf)"
        resultLabel.Size = UDim2.new(1, -10, 0, 0)
        return
    end
    
    local results = {}
    prefix = prefix:lower()
    
    for _, word in ipairs(allIndonesianWords) do
        if word:sub(1, #prefix) == prefix then
            table.insert(results, word)
        end
    end
    
    table.sort(results)
    
    if #results > 0 then
        local total = #results
        if total > 100 then
            local display = {}
            for i = 1, 100 do table.insert(display, results[i]) end
            resultLabel.Text = "Hasil (" .. total .. " kata, tampil 100): " .. table.concat(display, ", ")
        else
            resultLabel.Text = "Hasil (" .. total .. " kata): " .. table.concat(results, ", ")
        end
    else
        resultLabel.Text = "Hasil: Tidak ada kata dengan awalan '" .. prefix .. "'"
    end
    
    resultLabel.Size = UDim2.new(1, -10, 0, 0)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = searchBox.Text:gsub("%s+", "")
    if #text >= 1 and #text <= 3 then
        searchWords(text)
    else
        resultLabel.Text = "Hasil: (1-3 huruf saja)"
    end
end)

-- Load kata dari URL
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
        CY = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/CY.txt",
        UI = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/UI.txt",
        KS = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/KS.txt", 
        LY = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/LY.txt",
        RS = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/RS.txt",
        NS = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/NS.txt", 
        AX = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/AX.txt", 
        LT = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/LT.txt",
        TT = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/TT.txt",
        ["SEMUA KATA SULIT"] = "https://raw.githubusercontent.com/Niightcorporation/Sk-Alya/refs/heads/main/sulit.txt"
    }
    
    for cat, url in pairs(urls) do
        task.spawn(function()
            local success, response = pcall(function() return game:HttpGet(url) end)
            if success and type(response) == "string" then
                for line in string.gmatch(response, "[^\r\n]+") do
                    local word = (line:gsub("%s+", "")):lower()
                    if #word > 1 and string.match(word, "^%a+$") then
                        table.insert(wordCategories[cat], word)
                    end
                end
                print("🔥 Category " .. cat .. " Loaded! (" .. #wordCategories[cat] .. " kata)")
                updateCategoryButtons()
            end
        end)
    end
end)

-- Remote handler
local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if remotes then
    local matchRemote = remotes:FindFirstChild("MatchUI")
    if matchRemote then
        matchRemote.OnClientEvent:Connect(function(event)
            if not IsRunning then return end
            
            if event == "StartTurn" or event == "YourTurn" then
                if not isTyping and autoTypeEnabled then
                    task.wait(turnDelay + math.random() * (turnDelay * 0.2))
                    autoType()
                end
                
            elseif event == "Eliminated" or event == "EndMatch" or event == "HideMatchUI" then
                awalanLabel.Text = "AWALAN: -"
                kataLabel.Text = "-"
                usedWords = {}
                lastAwalan = ""
                tuyulCounter = 0
                tuyulSpamMode = false
                tuyulSpamCount = 0
                
            elseif event == "Mistake" and autoTypeEnabled then
                local playerGui = LocalPlayer:WaitForChild("PlayerGui")
                local matchUI = playerGui:FindFirstChild("MatchUI", true)
                
                if matchUI then
                    local submitBtn = matchUI:FindFirstChild("WordSubmit", true)
                    if submitBtn and submitBtn.Visible and submitBtn.BackgroundTransparency < 0.6 then
                        
                        -- Blacklist kata yang salah
                        if currentWord ~= "" then 
                            usedWords[currentWord] = true 
                            print("❌ Kata salah: " .. currentWord .. " - Dimasukkan blacklist")
                        end
                        
                        -- Reset state
                        isTyping = true
                        
                        -- Hapus kata yang salah
                        clearWord()
                        
                        -- Delay lebih lama sebelum coba lagi
                        task.wait(0.5)
                        
                        -- BACA ULANG AWALAN
                        local newAwalan = ""
                        for _, obj in pairs(matchUI:GetDescendants()) do
                            if (obj.Name == "WordServer" or obj.Name == "Word") and obj:IsA("TextLabel") and obj.Visible then
                                newAwalan = (obj.Text:gsub("%s+", "")):lower()
                                break
                            end
                        end
                        
                        -- Reset isTyping
                        isTyping = false
                        
                        -- Cari kata dengan awalan BARU
                        if newAwalan ~= "" and newAwalan ~= lastAwalan then
                            print("🔄 Awalan berubah: " .. newAwalan .. ", mencari kata baru...")
                            lastAwalan = newAwalan
                            task.wait(0.3)
                            autoType()
                        elseif newAwalan ~= "" then
                            print("⚠️ Awalan sama, coba kata lain...")
                            task.wait(0.3)
                            autoType()
                        end
                    end
                end
            end
        end)
    end
end

-- Show main tab by default
switchTab(mainContainer, mainTab)

print("✅ Anixly V2.0 Loaded - With Tuyul Mode, Anti Admin, & Nyawa Feature")