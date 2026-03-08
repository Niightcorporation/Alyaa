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

-- Hide Roblox Core Scripts
RunService.RenderStepped:Connect(function()
    pcall(function()
        local focusNav = CoreGui.RobloxGui:FindFirstChild("FocusNavigationCoreScriptsWrapper")
        if focusNav then
            focusNav.Visible = false
        end
    end)
end)

-- Mobile Check
local IsMobile = UserInputService.TouchEnabled

-- UI Sizes
local UI_WIDTH = IsMobile and 300 or 460
local UI_HEIGHT = IsMobile and 250 or 310
local SIDEBAR_WIDTH = IsMobile and 85 or 105
local HEADER_HEIGHT = IsMobile and 42 or 46
local TEXT_SIZE_SMALL = IsMobile and 9 or 11
local COMPONENT_HEIGHT = IsMobile and 32 or 36
local TEXT_SIZE_NORMAL = IsMobile and 10 or 12
local TEXT_SIZE_LARGE = IsMobile and 13 or 15

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

-- Themes (Hanya 3 Tema: Tokyo Night, Galaxy, Royal Purple)
local THEMES = {
    TOKYO_NIGHT = {
        primary = Color3.fromRGB(0, 255, 255),       -- Cyan neon
        mid = Color3.fromRGB(255, 0, 255),           -- Magenta neon
        dark = Color3.fromRGB(10, 10, 30),           -- Hitam kebiruan
        headerBg = Color3.fromRGB(20, 20, 50),        -- Dark blue
        accent = Color3.fromRGB(255, 255, 0),         -- Yellow neon
        glow = Color3.fromRGB(255, 105, 180),         -- Hot pink
        activeTab = Color3.fromRGB(138, 43, 226),     -- Blue violet
        logText = Color3.fromRGB(200, 200, 255)       -- Light blue
    },
    
    GALAXY = {
        primary = Color3.fromRGB(75, 0, 130),        -- Indigo
        mid = Color3.fromRGB(48, 25, 52),            -- Ungu gelap
        dark = Color3.fromRGB(10, 5, 20),            -- Hitam kebiruan
        headerBg = Color3.fromRGB(45, 15, 70),        -- Ungu deep
        accent = Color3.fromRGB(255, 215, 0),         -- Emas
        glow = Color3.fromRGB(138, 43, 226),          -- Violet
        activeTab = Color3.fromRGB(90, 30, 150),      -- Ungu medium
        logText = Color3.fromRGB(173, 216, 230)       -- Light blue
    },
    
    ROYAL = {
        primary = Color3.fromRGB(128, 0, 128),       -- Purple
        mid = Color3.fromRGB(85, 26, 139),           -- Blue violet
        dark = Color3.fromRGB(25, 10, 40),           -- Dark purple
        headerBg = Color3.fromRGB(75, 0, 130),        -- Indigo
        accent = Color3.fromRGB(255, 215, 0),         -- Gold
        glow = Color3.fromRGB(147, 112, 219),         -- Medium purple
        activeTab = Color3.fromRGB(106, 90, 205),     -- Slate blue
        logText = Color3.fromRGB(230, 230, 250)       -- Lavender
    }
}

local CurrentTheme = "TOKYO_NIGHT"  -- Default theme
local UI_Elements = {}

-- Apply Theme
local function applyTheme(themeName)
    local theme = THEMES[themeName]
    if not theme then return end
    
    CurrentTheme = themeName
    
    if UI_Elements.Header then
        UI_Elements.Header.BackgroundColor3 = theme.headerBg
    end
    
    if UI_Elements.HeaderGrad then
        UI_Elements.HeaderGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.primary),
            ColorSequenceKeypoint.new(0.6, theme.mid),
            ColorSequenceKeypoint.new(1, theme.dark)
        })
    end
    
    if UI_Elements.HeaderCover then
        UI_Elements.HeaderCover.BackgroundColor3 = theme.headerBg
    end
    
    if UI_Elements.HeaderLine then
        UI_Elements.HeaderLine.BackgroundColor3 = theme.accent
    end
    
    if UI_Elements.LineGrad then
        UI_Elements.LineGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.accent),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, theme.accent)
        })
    end
    
    if UI_Elements.HeaderDot then
        UI_Elements.HeaderDot.BackgroundColor3 = theme.accent
    end
    
    if UI_Elements.PremBadge then
        UI_Elements.PremBadge.BackgroundColor3 = theme.mid
    end
    
    if UI_Elements.BadgeGrad then
        UI_Elements.BadgeGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.accent),
            ColorSequenceKeypoint.new(1, theme.primary)
        })
    end
    
    if UI_Elements.GlowWrapper then
        UI_Elements.GlowWrapper.BackgroundColor3 = theme.glow
    end
    
    if UI_Elements.SideDivider then
        UI_Elements.SideDivider.BackgroundColor3 = theme.mid
    end
    
    if UI_Elements.DivGrad then
        UI_Elements.DivGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.mid),
            ColorSequenceKeypoint.new(0.5, theme.accent),
            ColorSequenceKeypoint.new(1, theme.mid)
        })
    end
    
    if UI_Elements.MiniIconStroke then
        UI_Elements.MiniIconStroke.Color = theme.accent
    end
    
    if UI_Elements.MiniIcon then
        UI_Elements.MiniIcon.BackgroundColor3 = theme.headerBg
    end
    
    if UI_Elements.DropMainBtn then
        UI_Elements.DropMainBtn.BackgroundColor3 = theme.mid
    end
    
    if UI_Elements.dropBtnGrad then
        UI_Elements.dropBtnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.primary),
            ColorSequenceKeypoint.new(1, theme.dark)
        })
    end
    
    if UI_Elements.dropStroke then
        UI_Elements.dropStroke.Color = theme.mid
    end
    
    if UI_Elements.logStroke then
        UI_Elements.logStroke.Color = theme.mid
    end
    
    if UI_Elements.LogAwalan then
        UI_Elements.LogAwalan.TextColor3 = theme.logText
    end
    
    if UI_Elements.ScrollBar then
        UI_Elements.ScrollBar.ScrollBarImageColor3 = theme.accent
    end
    
    for _, element in pairs(UI_Elements) do
        if type(element) == "table" and element.fill then
            element.fill.BackgroundColor3 = theme.primary
            element.knobMinStroke.Color = theme.accent
            element.knobMaxStroke.Color = theme.accent
            element.knobMax.BackgroundColor3 = theme.accent
            element.valLbl.TextColor3 = theme.logText
        end
    end
    
    if UI_Elements.activeTabColor then
        UI_Elements.activeTabColor.value = theme.activeTab
    end
    
    if UI_Elements.ResizeHandle then
        UI_Elements.ResizeHandle.BackgroundColor3 = theme.mid
    end
    
    if UI_Elements.ResizeStroke then
        UI_Elements.ResizeStroke.Color = theme.accent
    end
end

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Anixly"
ScreenGui.Parent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Glow Effect
local GlowWrapper = Instance.new("Frame")
GlowWrapper.Name = "GlowWrapper"
GlowWrapper.Size = UDim2.new(0, UI_WIDTH + 4, 0, UI_HEIGHT + 4)
GlowWrapper.Position = UDim2.new(0.5, -(UI_WIDTH/2) - 2, 0.5, -(UI_HEIGHT/2) - 2)
GlowWrapper.BackgroundColor3 = Color3.fromRGB(100, 40, 200)
GlowWrapper.BackgroundTransparency = 0.6
GlowWrapper.BorderSizePixel = 0
GlowWrapper.ZIndex = 0
GlowWrapper.Parent = ScreenGui

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 18)
GlowCorner.Parent = GlowWrapper
UI_Elements.GlowWrapper = GlowWrapper

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
ResizeHandle.Size = UDim2.new(0, IsMobile and 24 or 24, 0, IsMobile and 24 or 24)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(65, 15, 160)
ResizeHandle.Text = ""
ResizeHandle.TextColor3 = Color3.fromRGB(200, 160, 255)
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.TextSize = IsMobile and 12 or 14
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = ScreenGui

-- Icon untuk Resize Handle
local ResizeIcon = Instance.new("ImageLabel")
ResizeIcon.Size = UDim2.new(1, -4, 1, -4)
ResizeIcon.Position = UDim2.new(0, 2, 0, 2)
ResizeIcon.BackgroundTransparency = 1
ResizeIcon.Image = "rbxassetid://6023426915" -- Icon resize
ResizeIcon.ImageColor3 = Color3.fromRGB(200, 160, 255)
ResizeIcon.Parent = ResizeHandle

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 8)
ResizeCorner.Parent = ResizeHandle

local ResizeStroke = Instance.new("UIStroke")
ResizeStroke.Color = Color3.fromRGB(150, 80, 255)
ResizeStroke.Thickness = 1.5
ResizeStroke.Transparency = 0.1
ResizeStroke.Parent = ResizeHandle

UI_Elements.ResizeHandle = ResizeHandle
UI_Elements.ResizeStroke = ResizeStroke

-- Resize Functions
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

-- Resize Logic
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
    updateResizeHandlePosition()
end

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
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
HeaderCover.BackgroundColor3 = Color3.fromRGB(55, 15, 120)
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header
HeaderCover.ZIndex = Header.ZIndex - 1

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 30, 220)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(65, 15, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 10, 100))
})
HeaderGradient.Rotation = 135
HeaderGradient.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local LineGradient = Instance.new("UIGradient")
LineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 80, 255))
})
LineGradient.Parent = HeaderLine

local HeaderDot = Instance.new("Frame")
HeaderDot.Size = UDim2.new(0, 7, 0, 7)
HeaderDot.Position = UDim2.new(0, 10, 0.5, -3.5)
HeaderDot.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
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

UI_Elements.Header = Header
UI_Elements.HeaderGrad = HeaderGradient
UI_Elements.HeaderCover = HeaderCover
UI_Elements.HeaderLine = HeaderLine
UI_Elements.LineGrad = LineGradient
UI_Elements.HeaderDot = HeaderDot

-- Premium Badge (PC Only)
if not IsMobile then
    local PremiumBadge = Instance.new("Frame")
    PremiumBadge.Size = UDim2.new(0, 64, 0, 17)
    PremiumBadge.Position = UDim2.new(0, 130, 0.5, -8.5)
    PremiumBadge.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
    PremiumBadge.BorderSizePixel = 0
    PremiumBadge.Parent = Header
    
    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(1, 0)
    BadgeCorner.Parent = PremiumBadge
    
    local BadgeGradient = Instance.new("UIGradient")
    BadgeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 40, 200))
    })
    BadgeGradient.Parent = PremiumBadge
    
    local BadgeText = Instance.new("TextLabel")
    BadgeText.Size = UDim2.new(1, 0, 1, 0)
    BadgeText.BackgroundTransparency = 1
    BadgeText.Text = "PREMIUM"
    BadgeText.TextColor3 = Color3.new(1, 1, 1)
    BadgeText.Font = Enum.Font.GothamBold
    BadgeText.TextSize = 9
    BadgeText.Parent = PremiumBadge
    
    UI_Elements.PremBadge = PremiumBadge
    UI_Elements.BadgeGrad = BadgeGradient
end

-- Window Controls
local controlSize = IsMobile and 18 or 26

-- Minimize Button dengan logo Alya
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, controlSize, 0, controlSize)
MinimizeBtn.Position = UDim2.new(1, -(controlSize * 2 + 10), 0.5, -controlSize / 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(250, 190, 0)
MinimizeBtn.Text = ""
MinimizeBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = IsMobile and 11 or 16
MinimizeBtn.Parent = Header

-- Logo Alya untuk minimize (tsundere rushidere)
local MinIcon = Instance.new("ImageLabel")
MinIcon.Size = UDim2.new(1, -4, 1, -4)
MinIcon.Position = UDim2.new(0, 2, 0, 2)
MinIcon.BackgroundTransparency = 1
MinIcon.Image = "https://files.catbox.moe/lw0byv.jpg" -- ID logo Alya (ganti dengan ID yang sesuai)
MinIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinIcon.Parent = MinimizeBtn

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, controlSize, 0, controlSize)
CloseBtn.Position = UDim2.new(1, -(controlSize + 6), 0.5, -controlSize / 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 50, 60)
CloseBtn.Text = ""
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = IsMobile and 14 or 11
CloseBtn.Parent = Header

local CloseIcon = Instance.new("ImageLabel")
CloseIcon.Size = UDim2.new(1, -4, 1, -4)
CloseIcon.Position = UDim2.new(0, 2, 0, 2)
CloseIcon.BackgroundTransparency = 1
CloseIcon.Image = "rbxassetid://6023426923" -- Icon close
CloseIcon.ImageColor3 = Color3.new(1, 1, 1)
CloseIcon.Parent = CloseBtn

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

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
SideDivider.BackgroundColor3 = Color3.fromRGB(70, 30, 140)
SideDivider.BorderSizePixel = 0
SideDivider.Parent = MainFrame

local DivGradient = Instance.new("UIGradient")
DivGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 30, 140)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 60, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 30, 140))
})
DivGradient.Rotation = 90
DivGradient.Parent = SideDivider

UI_Elements.SideDivider = SideDivider
UI_Elements.DivGrad = DivGradient

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

-- Mini Icon (for minimized state) - juga pakai logo Alya
local MiniIcon = Instance.new("ImageButton")
MiniIcon.Name = "AnixlyMiniIcon"
MiniIcon.Size = UDim2.new(0, IsMobile and 45 or 60, 0, IsMobile and 45 or 60)
MiniIcon.Position = UDim2.new(0, 10, 0.5, -30)
MiniIcon.BackgroundColor3 = Color3.fromRGB(55, 15, 130)
MiniIcon.Image = "https://files.catbox.moe/lw0byv.jpg" -- Logo Alya untuk minimized state
MiniIcon.Visible = false
MiniIcon.BorderSizePixel = 0
MiniIcon.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 14)
MiniCorner.Parent = MiniIcon

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(150, 80, 255)
MiniStroke.Thickness = 2
MiniStroke.Transparency = 0.1
MiniStroke.Parent = MiniIcon

UI_Elements.MiniIcon = MiniIcon
UI_Elements.MiniIconStroke = MiniStroke

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

-- Content Area
local contentOffset = SIDEBAR_WIDTH + 7
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -(contentOffset + 4), 1, -(HEADER_HEIGHT + 6))
contentArea.Position = UDim2.new(0, contentOffset, 0, HEADER_HEIGHT + 4)
contentArea.BackgroundTransparency = 1
contentArea.Parent = MainFrame

-- Tab Content Containers
local function createTabContainer()
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.ScrollBarThickness = 0
    container.Parent = contentArea
    return container
end

-- Main Tab (Speed Settings)
local mainContainer = createTabContainer()
mainContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
mainContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainContainer.ScrollBarThickness = IsMobile and 3 or 2
mainContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
mainContainer.ScrollBarImageTransparency = 0
mainContainer.ScrollingDirection = Enum.ScrollingDirection.Y
UI_Elements.ScrollBar = mainContainer

-- Util Tab
local utilContainer = createTabContainer()

-- Util Tab Layout
local utilLayout = Instance.new("UIListLayout")
utilLayout.Padding = UDim.new(0, 8)
utilLayout.SortOrder = Enum.SortOrder.LayoutOrder
utilLayout.Parent = utilContainer
utilContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
utilContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
utilContainer.ScrollBarThickness = IsMobile and 3 or 2
utilContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
utilContainer.ScrollBarImageTransparency = 0
utilContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local utilPadding = Instance.new("UIPadding")
utilPadding.PaddingLeft = UDim.new(0, 6)
utilPadding.PaddingRight = UDim.new(0, 6)
utilPadding.PaddingTop = UDim.new(0, 8)
utilPadding.PaddingBottom = UDim.new(0, 10)
utilPadding.Parent = utilContainer

-- Tab Switching
local function switchTab(activeContainer)
    mainContainer.Visible = false
    utilContainer.Visible = false
    nitpContainer.Visible = false
    activeContainer.Visible = true
end

-- Sidebar Tab Buttons
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
    labelText.Parent = btn
    
    table.insert(tabButtons, {btn = btn, stroke = btnStroke, icon = icon, label = labelText})
    return btn
end

local function highlightTab(activeBtn)
    for _, tab in pairs(tabButtons) do
        tab.btn.BackgroundColor3 = Color3.fromRGB(20, 18, 32)
        tab.stroke.Color = Color3.fromRGB(50, 30, 90)
        tab.stroke.Transparency = 0.6
        tab.icon.ImageColor3 = Color3.fromRGB(120, 110, 150)
        tab.label.TextColor3 = Color3.fromRGB(120, 110, 150)
    end
    
    local theme = THEMES[CurrentTheme]
    local activeColor = theme and theme.activeTab or Color3.fromRGB(65, 20, 150)
    local accentColor = theme and theme.accent or Color3.fromRGB(150, 80, 255)
    
    activeBtn.BackgroundColor3 = activeColor
    
    for _, tab in pairs(tabButtons) do
        if tab.btn == activeBtn then
            tab.stroke.Color = accentColor
            tab.stroke.Transparency = 0.1
            tab.icon.ImageColor3 = Color3.new(1, 1, 1)
            tab.label.TextColor3 = Color3.new(1, 1, 1)
        end
    end
end

-- Teleport Tab
local tpContainer = createTabContainer()
tpContainer.ScrollingDirection = Enum.ScrollingDirection.Y

-- TP Tab Layout
local tpLayout = Instance.new("UIListLayout")
tpLayout.Padding = UDim.new(0, 8)
tpLayout.SortOrder = Enum.SortOrder.LayoutOrder
tpLayout.Parent = tpContainer
tpContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tpContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
tpContainer.ScrollBarThickness = IsMobile and 3 or 2
tpContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 80, 255)
tpContainer.ScrollBarImageTransparency = 0
tpContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local tpPadding = Instance.new("UIPadding")
tpPadding.PaddingLeft = UDim.new(0, 6)
tpPadding.PaddingRight = UDim.new(0, 6)
tpPadding.PaddingTop = UDim.new(0, 8)
tpPadding.PaddingBottom = UDim.new(0, 10)
tpPadding.Parent = tpContainer

-- TP Buttons
local function createTPButton(text, location, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IsMobile and 42 or 38)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
    btn.Text = ""
    btn.TextColor3 = Color3.fromRGB(200, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = TEXT_SIZE_NORMAL
    btn.Parent = tpContainer
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 8, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6023426935" -- Icon lokasi
    icon.ImageColor3 = Color3.fromRGB(200, 190, 220)
    icon.Parent = btn
    
    -- Text
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, -30, 1, 0)
    btnLabel.Position = UDim2.new(0, 30, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = text
    btnLabel.TextColor3 = Color3.fromRGB(200, 190, 220)
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.TextSize = TEXT_SIZE_NORMAL
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.Parent = btn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(70, 35, 130)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.4
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        playClickSound()
        
        -- Cari lokasi
        local target = workspace:FindFirstChild(location)
        if not target then
            print("⚠️ " .. location .. " tidak ditemukan!")
            return
        end
        
        -- Cari part untuk teleport
        local targetPart
        for _, obj in ipairs(target:GetDescendants()) do
            if obj:IsA("BasePart") then
                targetPart = obj
                break
            end
        end
        
        -- Jika tidak ada part, gunakan target itu sendiri jika dia BasePart
        if not targetPart and target:IsA("BasePart") then
            targetPart = target
        end
        
        if not targetPart then
            print("⚠️ Tidak ada BasePart di " .. location .. "!")
            return
        end
        
        -- Teleport
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 0))
            print("⚡ Teleport ke " .. text)
        end
    end)
    
    return btn
end

-- Tambahkan button teleport
createTPButton("Bambu Lava", "ParkourBambu2", 1)
createTPButton("Lobby", "MainSpawn", 2)
createTPButton("Arena 1", "Arena1", 3)
createTPButton("Arena 2", "Arena2", 4)
createTPButton("Shop", "ShopArea", 5)

-- Icon IDs: 
-- Main: bolt
-- Utility: gear
-- Teleport: location
local mainTab = createTabButton("rbxassetid://6023426941", "MAIN", 1) -- Icon bolt
local utilTab = createTabButton("rbxassetid://6023426937", "UTILITY", 2) -- Icon gear
local tpTab = createTabButton("rbxassetid://6023426935", "TELEPORT", 3) -- Icon location

-- Speed Settings Variables
local autoTypeEnabled = false
local autoEnterEnabled = true
local typeDelay = 0.03
local enterDelay = 0.08
local turnDelay = 1.5
local backspaceDelay = 0.02
local deleteDelay = 0.06
local humanModeEnabled = false

-- Random words for human mode
local randomWords = {"wkwk", "receh", "noob", "lemah", "kasian", "santuy", "ezz", "wkwk", "lol", "mudah"}

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

-- Main Tab Layout
local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, IsMobile and 5 or 7)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = mainContainer

local mainPadding = Instance.new("UIPadding")
mainPadding.PaddingLeft = UDim.new(0, 5)
mainPadding.PaddingRight = UDim.new(0, 5)
mainPadding.PaddingTop = UDim.new(0, 5)
mainPadding.PaddingBottom = UDim.new(0, 10)
mainPadding.Parent = mainContainer

-- Fungsi untuk membuat Section Header
local function createSectionHeader(title, iconId, order)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -4, 0, 30)
    header.LayoutOrder = order
    header.BackgroundTransparency = 1
    header.Parent = mainContainer
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 5, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = THEMES[CurrentTheme].accent
    icon.Parent = header
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = THEMES[CurrentTheme].logText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = header
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -35, 0, 1)
    line.Position = UDim2.new(0, 30, 1, -2)
    line.BackgroundColor3 = THEMES[CurrentTheme].mid
    line.BorderSizePixel = 0
    line.Parent = header
    
    return header
end

-- Speed Settings Frame
local function createSpeedSettings(parent, order)
    local itemHeight = IsMobile and 48 or 42
    local totalHeight = (28 + 3 * itemHeight) + 6
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, totalHeight)
    frame.LayoutOrder = order
    frame.BackgroundColor3 = Color3.fromRGB(12, 11, 20)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 11)
    frameCorner.Parent = frame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(60, 30, 110)
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.3
    frameStroke.Parent = frame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
    header.BorderSizePixel = 0
    header.Parent = frame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 11)
    headerCorner.Parent = header
    
    local headerCover = Instance.new("Frame")
    headerCover.Size = UDim2.new(1, 0, 0.5, 0)
    headerCover.Position = UDim2.new(0, 0, 0.5, 0)
    headerCover.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
    headerCover.BorderSizePixel = 0
    headerCover.Parent = header
    
    local headerIcon = Instance.new("ImageLabel")
    headerIcon.Size = UDim2.new(0, 16, 0, 16)
    headerIcon.Position = UDim2.new(0, 8, 0.5, -8)
    headerIcon.BackgroundTransparency = 1
    headerIcon.Image = "rbxassetid://6023426941" -- Icon bolt
    headerIcon.ImageColor3 = Color3.fromRGB(180, 140, 255)
    headerIcon.Parent = header
    
    local headerText = Instance.new("TextLabel")
    headerText.Size = UDim2.new(1, -30, 1, 0)
    headerText.Position = UDim2.new(0, 28, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = "Delay Settings"
    headerText.TextColor3 = Color3.fromRGB(180, 140, 255)
    headerText.Font = Enum.Font.GothamBold
    headerText.TextSize = 10
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    headerText.Parent = header
    
    -- Sliders
    local sliders = {
        {
            icon = "⌨", -- Icon keyboard
            label = "Write",
            minV = 0.01,
            maxV = 1,
            defMin = 0.03,
            defMax = 0.08,
            dec = 2,
            suf = "s",
            cbMin = function(v) typeDelay = v end,
            cbMax = function(v) enterDelay = v end
        },
        {
            icon = "rbxassetid://6023426925", -- Icon clock
            label = "Delay Turn",
            minV = 0.1,
            maxV = 5,
            defMin = 1.5,
            defMax = 2.5,
            dec = 1,
            suf = "s",
            cbMin = function(v) turnDelay = v end,
            cbMax = function(v) turnDelay = v end
        },
        {
            icon = "rbxassetid://6023426929", -- Icon backspace
            label = "Backspace",
            minV = 0.01,
            maxV = 1,
            defMin = 0.02,
            defMax = 0.06,
            dec = 2,
            suf = "s",
            cbMin = function(v) backspaceDelay = v end,
            cbMax = function(v) deleteDelay = v end
        }
    }
    
    -- Set initial values
    for _, s in ipairs(sliders) do
        s.cbMin(s.defMin)
        s.cbMax(s.defMax)
    end
    
    local knobSize = IsMobile and 16 or 11
    local sliderHeight = IsMobile and 20 or 12
    
    for i, s in ipairs(sliders) do
        local yPos = 28 + (i - 1) * itemHeight
        
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -10, 0, itemHeight - 4)
        row.Position = UDim2.new(0, 5, 0, yPos)
        row.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(16, 14, 26) or Color3.fromRGB(13, 12, 22)
        row.BorderSizePixel = 0
        row.Parent = frame
        
        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 7)
        rowCorner.Parent = row
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 8, 0, 4)
        icon.BackgroundTransparency = 1
        icon.Image = s.icon
        icon.ImageColor3 = Color3.fromRGB(170, 155, 210)
        icon.Parent = row
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 70, 0, 14)
        iconLabel.Position = UDim2.new(0, 28, 0, 4)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = s.label
        iconLabel.TextColor3 = Color3.fromRGB(170, 155, 210)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = IsMobile and 8 or 9
        iconLabel.TextXAlignment = Enum.TextXAlignment.Left
        iconLabel.Parent = row
        
        local formatStr = "%." .. s.dec .. "f"
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 90, 0, 14)
        valueLabel.Position = UDim2.new(1, -94, 0, 4)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = IsMobile and 8 or 9
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = row
        
        local minVal, maxVal = s.defMin, s.defMax
        
        local function updateValueText()
            valueLabel.Text = string.format(formatStr, minVal) .. " ~ " .. string.format(formatStr, maxVal) .. s.suf
            local theme = THEMES[CurrentTheme]
            valueLabel.TextColor3 = theme and theme.logText or Color3.fromRGB(150, 100, 255)
        end
        updateValueText()
        
        local sliderTrackSize = IsMobile and 32 or 26
        local trackHeight = IsMobile and 6 or 4
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -16, 0, trackHeight)
        track.Position = UDim2.new(0, 8, 0, sliderTrackSize)
        track.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
        track.BorderSizePixel = 0
        track.Parent = row
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track
        
        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
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
        minStroke.Color = Color3.fromRGB(150, 80, 255)
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
        maxStroke.Color = Color3.fromRGB(200, 150, 255)
        maxStroke.Thickness = 1.5
        maxStroke.Parent = maxKnob
        
        local function roundToDec(val)
            local mult = 10 ^ s.dec
            return math.floor(val * mult + 0.5) / mult
        end
        
        local halfKnob = knobSize / 2
        
        local function updateSlider()
            local minPercent = (minVal - s.minV) / (s.maxV - s.minV)
            local maxPercent = (maxVal - s.minV) / (s.maxV - s.minV)
            
            fill.Position = UDim2.new(minPercent, 0, 0, 0)
            fill.Size = UDim2.new(maxPercent - minPercent, 0, 1, 0)
            
            minKnob.Position = UDim2.new(minPercent, -halfKnob, 0.5, -halfKnob)
            maxKnob.Position = UDim2.new(maxPercent, -halfKnob, 0.5, -halfKnob)
            
            updateValueText()
        end
        updateSlider()
        
        local dragButton = Instance.new("TextButton")
        dragButton.Size = UDim2.new(1, 0, 0, sliderHeight * 2)
        dragButton.Position = UDim2.new(0, 0, 0.5, -sliderHeight)
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
        
        local function getValueFromPercent(pct)
            return roundToDec(s.minV + pct * (s.maxV - s.minV))
        end
        
        dragButton.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and 
               input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            
            local pct = getPercentFromPos(input.Position.X)
            local val = getValueFromPercent(pct)
            
            if math.abs(val - minVal) <= math.abs(val - maxVal) then
                draggingMin = true
            else
                draggingMax = true
            end
        end)
        
        local inputChangedConn
        inputChangedConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and 
               input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            
            if not (draggingMin or draggingMax) then return end
            
            local pct = getPercentFromPos(input.Position.X)
            local val = getValueFromPercent(pct)
            local eps = 1 / (10 ^ s.dec)
            
            if draggingMin then
                minVal = math.clamp(val, s.minV, maxVal - eps)
                s.cbMin(minVal)
            else
                maxVal = math.clamp(val, minVal + eps, s.maxV)
                s.cbMax(maxVal)
            end
            
            updateSlider()
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                draggingMin = false
                draggingMax = false
            end
        end)
        
        table.insert(UI_Elements, {
            fill = fill,
            knobMinStroke = minStroke,
            knobMaxStroke = maxStroke,
            valLbl = valueLabel,
            knobMax = maxKnob
        })
    end
    
    return frame
end

-- Toggle Button
local function createToggleButton(text, parent, defaultState, callback, order)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, COMPONENT_HEIGHT)
    frame.LayoutOrder = order
    frame.BackgroundColor3 = Color3.fromRGB(16, 15, 24)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 9)
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

-- Membuat Section dan Menambahkan Komponen dengan urutan yang benar (SESUAI PERMINTAAN)
local currentOrder = 1

-- Section 1: Auto Features (PERTAMA)
createSectionHeader("AUTO FEATURES", "rbxassetid://6023426919", currentOrder)
currentOrder = currentOrder + 1

-- Add toggles dalam urutan yang benar
createToggleButton("Auto Answer", mainContainer, false, function(state)
    autoTypeEnabled = state
end, currentOrder)
currentOrder = currentOrder + 1

createToggleButton("Auto Submit", mainContainer, true, function(state)
    autoEnterEnabled = state
end, currentOrder)
currentOrder = currentOrder + 1

createToggleButton("Human Mode", mainContainer, false, function(state)
    humanModeEnabled = state
end, currentOrder)
currentOrder = currentOrder + 1

-- Section 2: Information (KEDUA)
createSectionHeader("INFORMATION", "rbxassetid://6023426923", currentOrder)
currentOrder = currentOrder + 1

-- Log Frame
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, -4, 0, IsMobile and 55 or 50)
logFrame.LayoutOrder = currentOrder
currentOrder = currentOrder + 1
logFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
logFrame.BorderSizePixel = 0
logFrame.Parent = mainContainer

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 9)
logCorner.Parent = logFrame

local logStroke = Instance.new("UIStroke")
logStroke.Color = Color3.fromRGB(80, 40, 140)
logStroke.Thickness = 1
logStroke.Transparency = 0.4
logStroke.Parent = logFrame

UI_Elements.logStroke = logStroke

local logIcon = Instance.new("ImageLabel")
logIcon.Size = UDim2.new(0, 18, 0, 18)
logIcon.Position = UDim2.new(0, 8, 0, 4)
logIcon.BackgroundTransparency = 1
logIcon.Image = "rbxassetid://6023426923"
logIcon.ImageColor3 = Color3.fromRGB(160, 100, 255)
logIcon.Parent = logFrame

local awalanLabel = Instance.new("TextLabel")
awalanLabel.Size = UDim2.new(1, -30, 0, 22)
awalanLabel.Position = UDim2.new(0, 28, 0, 4)
awalanLabel.BackgroundTransparency = 1
awalanLabel.Text = "AWALAN: -"
awalanLabel.TextColor3 = Color3.fromRGB(160, 100, 255)
awalanLabel.Font = Enum.Font.GothamBold
awalanLabel.TextSize = IsMobile and 10 or 11
awalanLabel.TextXAlignment = Enum.TextXAlignment.Left
awalanLabel.Parent = logFrame

UI_Elements.LogAwalan = awalanLabel

local kataLabel = Instance.new("TextLabel")
kataLabel.Size = UDim2.new(1, -12, 0, 24)
kataLabel.Position = UDim2.new(0, 8, 0, 26)
kataLabel.BackgroundTransparency = 1
kataLabel.Text = "-"
kataLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
kataLabel.Font = Enum.Font.GothamBold
kataLabel.TextSize = IsMobile and 14 or 16
kataLabel.TextXAlignment = Enum.TextXAlignment.Left
kataLabel.Parent = logFrame

-- Section 3: Include Word (KETIGA)
createSectionHeader("INCLUDE WORD", "rbxassetid://6023426945", currentOrder)
currentOrder = currentOrder + 1

-- Kata Sulit Dropdown
local kataSulitBtn = Instance.new("TextButton")
kataSulitBtn.Size = UDim2.new(1, -4, 0, COMPONENT_HEIGHT)
kataSulitBtn.LayoutOrder = currentOrder
currentOrder = currentOrder + 1
kataSulitBtn.BackgroundColor3 = Color3.fromRGB(65, 20, 145)
kataSulitBtn.Text = ""
kataSulitBtn.TextColor3 = Color3.new(1, 1, 1)
kataSulitBtn.Font = Enum.Font.GothamBold
kataSulitBtn.TextSize = TEXT_SIZE_NORMAL
kataSulitBtn.Parent = mainContainer

local kataIcon = Instance.new("ImageLabel")
kataIcon.Size = UDim2.new(0, 18, 0, 18)
kataIcon.Position = UDim2.new(0, 8, 0.5, -9)
kataIcon.BackgroundTransparency = 1
kataIcon.Image = "rbxassetid://6023426945" -- Icon folder
kataIcon.ImageColor3 = Color3.new(1, 1, 1)
kataIcon.Parent = kataSulitBtn

local kataBtnText = Instance.new("TextLabel")
kataBtnText.Size = UDim2.new(1, -60, 1, 0)
kataBtnText.Position = UDim2.new(0, 30, 0, 0)
kataBtnText.BackgroundTransparency = 1
kataBtnText.Text = "SET KATA SULIT ▼"
kataBtnText.TextColor3 = Color3.new(1, 1, 1)
kataBtnText.Font = Enum.Font.GothamBold
kataBtnText.TextSize = TEXT_SIZE_NORMAL
kataBtnText.TextXAlignment = Enum.TextXAlignment.Left
kataBtnText.Parent = kataSulitBtn

local kataCorner = Instance.new("UICorner")
kataCorner.CornerRadius = UDim.new(0, 9)
kataCorner.Parent = kataSulitBtn

local kataGradient = Instance.new("UIGradient")
kataGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 30, 190)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 15, 120))
})
kataGradient.Parent = kataSulitBtn

UI_Elements.DropMainBtn = kataSulitBtn
UI_Elements.dropBtnGrad = kataGradient

-- Kata Sulit Dropdown Content
local kataDropdown = Instance.new("Frame")
kataDropdown.Size = UDim2.new(1, -4, 0, 0)
kataDropdown.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
kataDropdown.ClipsDescendants = true
kataDropdown.BorderSizePixel = 0
kataDropdown.Parent = mainContainer
kataDropdown.LayoutOrder = currentOrder
currentOrder = currentOrder + 1

local kataDropdownStroke = Instance.new("UIStroke")
kataDropdownStroke.Color = Color3.fromRGB(80, 35, 160)
kataDropdownStroke.Thickness = 1
kataDropdownStroke.Transparency = 0.3
kataDropdownStroke.Parent = kataDropdown

UI_Elements.dropStroke = kataDropdownStroke

local categoryHeight = IsMobile and 37 or 33
local dropdownOpen = false

local function updateCategoryButtons()
    for _, child in pairs(kataDropdown:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local categories = {"IF", "X", "NG", "AI", "CY", "UI", "KS", "LY", "RS", "NS", "SEMUA KATA SULIT"}
    
    for i, cat in ipairs(categories) do
        local isAllOn = categoryToggles["SEMUA KATA SULIT"] and cat ~= "SEMUA KATA SULIT"
        local isOn = categoryToggles[cat]
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -12, 0, IsMobile and 32 or 28)
        btn.Position = UDim2.new(0, 6, 0, (i - 1) * categoryHeight + 5)
        
        if isAllOn then
            btn.BackgroundColor3 = Color3.fromRGB(25, 22, 36)
        elseif isOn then
            btn.BackgroundColor3 = Color3.fromRGB(80, 30, 170)
        else
            btn.BackgroundColor3 = Color3.fromRGB(28, 25, 42)
        end
        
        btn.Text = ""
        
        if isAllOn then
            btn.TextColor3 = Color3.fromRGB(70, 65, 90)
        elseif isOn then
            btn.TextColor3 = Color3.new(1, 1, 1)
        else
            btn.TextColor3 = Color3.fromRGB(160, 150, 190)
        end
        
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = TEXT_SIZE_NORMAL
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = kataDropdown
        
        local checkIcon = Instance.new("ImageLabel")
        checkIcon.Size = UDim2.new(0, 14, 0, 14)
        checkIcon.Position = UDim2.new(0, 6, 0.5, -7)
        checkIcon.BackgroundTransparency = 1
        checkIcon.Image = isOn and "rbxassetid://6023426927" or "rbxassetid://6023426917" -- Check icon or empty
        checkIcon.ImageColor3 = isOn and Color3.new(1, 1, 1) or Color3.fromRGB(100, 90, 130)
        checkIcon.Parent = btn
        
        local catText = Instance.new("TextLabel")
        catText.Size = UDim2.new(1, -80, 1, 0)
        catText.Position = UDim2.new(0, 24, 0, 0)
        catText.BackgroundTransparency = 1
        catText.Text = cat
        catText.TextColor3 = btn.TextColor3
        catText.Font = Enum.Font.GothamBold
        catText.TextSize = TEXT_SIZE_NORMAL
        catText.TextXAlignment = Enum.TextXAlignment.Left
        catText.Parent = btn
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 7)
        btnCorner.Parent = btn
        
        if isOn then
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromRGB(130, 70, 220)
            btnStroke.Thickness = 1
            btnStroke.Transparency = 0.2
            btnStroke.Parent = btn
        end
        
        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(0, 60, 1, 0)
        countLabel.Position = UDim2.new(1, -64, 0, 0)
        countLabel.BackgroundTransparency = 1
        local count = #(wordCategories[cat] or {})
        countLabel.Text = count > 0 and count .. " kata" or "loading..."
        countLabel.TextColor3 = isAllOn and Color3.fromRGB(60, 55, 80) or Color3.fromRGB(120, 100, 180)
        countLabel.Font = Enum.Font.Gotham
        countLabel.TextSize = IsMobile and 8 or 9
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.ZIndex = btn.ZIndex + 1
        countLabel.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if isAllOn then return end
            
            playClickSound()
            
            if cat == "SEMUA KATA SULIT" then
                categoryToggles["SEMUA KATA SULIT"] = not categoryToggles["SEMUA KATA SULIT"]
                if categoryToggles["SEMUA KATA SULIT"] then
                    for _, c in ipairs(categories) do
                        if c ~= "SEMUA KATA SULIT" then
                            categoryToggles[c] = false
                        end
                    end
                end
            else
                categoryToggles[cat] = not categoryToggles[cat]
            end
            
            updateCategoryButtons()
        end)
    end
end

kataSulitBtn.MouseButton1Click:Connect(function()
    playClickSound()
    dropdownOpen = not dropdownOpen
    kataBtnText.Text = dropdownOpen and "SET KATA SULIT ▲" or "SET KATA SULIT ▼"
    
    kataDropdown:TweenSize(
        UDim2.new(1, -4, 0, dropdownOpen and 9 * categoryHeight + 10 or 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.3,
        true
    )
    
    updateCategoryButtons()
end)

-- Section 4: Delay Settings (TERAKHIR)
createSectionHeader("DELAY SETTINGS", "rbxassetid://6023426941", currentOrder)
currentOrder = currentOrder + 1

-- Add speed settings
createSpeedSettings(mainContainer, currentOrder)
currentOrder = currentOrder + 1

-- Word lists
local usedWords = {}
local currentWord = ""
local wordLength = 0

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
    "yanto", "ilang", "oho", "aiba", "eni", "ungik", "aqua", "aikido"
}

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

-- Auto type state
local isTyping = false

-- Auto type function
local autoType = function()
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
            if enabled then
                for _, word in ipairs(wordCategories[cat]) do
                    if word:sub(1, #awalan) == awalan and not usedWords[word] and #word > #awalan then
                        table.insert(specialCandidates, word)
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
            local category = "KBBI (SEMUA)"
            
            for cat, enabled in pairs(categoryToggles) do
                if enabled and table.find(wordCategories[cat], chosen) then
                    category = "KATA SULIT (" .. cat .. ")"
                    break
                end
            end
            
            print("🤖 Anixly: " .. chosen:upper() .. " | Awalan: " .. awalan:upper() .. " | " .. category)
            kataLabel.Text = chosen:upper()
            currentWord = chosen
            
            typeWord(chosen:sub(#awalan + 1), #chosen)
            usedWords[chosen] = true
            
            task.wait(1)
            awalanLabel.Text = "AWALAN: "
            kataLabel.Text = "-"
        end
    end
    
    task.wait(0.5)
    isTyping = false
end

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
                print("🔥 Category " .. cat .. " Loaded!")
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

-- Dragging
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
    
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragStart = nil
        end
    end)
end)

-- Input handling
UserInputService.InputChanged:Connect(function(input)
    if not isMouseMovement(input) then return end
    
    if isResizing then
        local delta = input.Position - resizeStartPos
        local newW, newH = clampSize(startWidth + delta.X, startHeight + delta.Y)
        MainFrame.Size = UDim2.new(0, newW, 0, newH)
        updateGlow()
        return
    end
    
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
        isResizing = false
    end
end)

-- Noclip
local noclipEnabled = false
local noclipConnection

local function setNoclip(state)
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
end

-- Theme dropdown
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, 0, 0, IsMobile and 42 or 38)
themeBtn.LayoutOrder = 0
themeBtn.BackgroundColor3 = Color3.fromRGB(25, 22, 38)
themeBtn.Text = ""
themeBtn.TextColor3 = Color3.new(1, 1, 1)
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = TEXT_SIZE_NORMAL
themeBtn.Parent = utilContainer

local themeIcon = Instance.new("ImageLabel")
themeIcon.Size = UDim2.new(0, 18, 0, 18)
themeIcon.Position = UDim2.new(0, 8, 0.5, -9)
themeIcon.BackgroundTransparency = 1
themeIcon.Image = "rbxassetid://6023426921" -- Icon paint
themeIcon.ImageColor3 = Color3.new(1, 1, 1)
themeIcon.Parent = themeBtn

local themeBtnText = Instance.new("TextLabel")
themeBtnText.Size = UDim2.new(1, -60, 1, 0)
themeBtnText.Position = UDim2.new(0, 30, 0, 0)
themeBtnText.BackgroundTransparency = 1
themeBtnText.Text = "TEMA: TOKYO NIGHT ▼"
themeBtnText.TextColor3 = Color3.new(1, 1, 1)
themeBtnText.Font = Enum.Font.GothamBold
themeBtnText.TextSize = TEXT_SIZE_NORMAL
themeBtnText.TextXAlignment = Enum.TextXAlignment.Left
themeBtnText.Parent = themeBtn

local themeBtnCorner = Instance.new("UICorner")
themeBtnCorner.CornerRadius = UDim.new(0, 9)
themeBtnCorner.Parent = themeBtn

local themeBtnStroke = Instance.new("UIStroke")
themeBtnStroke.Color = Color3.fromRGB(150, 80, 255)
themeBtnStroke.Thickness = 1.5
themeBtnStroke.Transparency = 0.2
themeBtnStroke.Parent = themeBtn

local themeDropdown = Instance.new("Frame")
themeDropdown.Size = UDim2.new(1, 0, 0, 0)
themeDropdown.BackgroundColor3 = Color3.fromRGB(14, 13, 22)
themeDropdown.ClipsDescendants = true
themeDropdown.BorderSizePixel = 0
themeDropdown.LayoutOrder = 1
themeDropdown.Parent = utilContainer

local themeDropdownCorner = Instance.new("UICorner")
themeDropdownCorner.CornerRadius = UDim.new(0, 9)
themeDropdownCorner.Parent = themeDropdown

local themeDropdownStroke = Instance.new("UIStroke")
themeDropdownStroke.Color = Color3.fromRGB(70, 35, 130)
themeDropdownStroke.Thickness = 1
themeDropdownStroke.Transparency = 0.4
themeDropdownStroke.Parent = themeDropdown

local themeColors = {
    TOKYO_NIGHT = Color3.fromRGB(0, 255, 255),
    GALAXY = Color3.fromRGB(255, 215, 0),
    ROYAL = Color3.fromRGB(255, 215, 0)
}

local themeList = {"TOKYO_NIGHT", "GALAXY", "ROYAL"}
local themeOpen = false
local themeItemHeight = IsMobile and 40 or 35

local function updateThemeDropdown()
    for _, child in pairs(themeDropdown:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for i, themeName in ipairs(themeList) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -12, 0, IsMobile and 34 or 30)
        item.Position = UDim2.new(0, 6, 0, (i - 1) * themeItemHeight + 5)
        item.BackgroundColor3 = CurrentTheme == themeName and Color3.fromRGB(30, 25, 50) or Color3.fromRGB(20, 18, 30)
        item.BorderSizePixel = 0
        item.Parent = themeDropdown
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 7)
        itemCorner.Parent = item
        
        if CurrentTheme == themeName then
            local itemStroke = Instance.new("UIStroke")
            itemStroke.Color = themeColors[themeName]
            itemStroke.Thickness = 1
            itemStroke.Transparency = 0.2
            itemStroke.Parent = item
        end
        
        local colorDot = Instance.new("Frame")
        colorDot.Size = UDim2.new(0, 10, 0, 10)
        colorDot.Position = UDim2.new(0, 10, 0.5, -5)
        colorDot.BackgroundColor3 = themeColors[themeName]
        colorDot.BorderSizePixel = 0
        colorDot.Parent = item
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = colorDot
        
        -- Format nama tema biar lebih bagus
        local displayName = themeName:gsub("_", " "):gsub("TOKYO NIGHT", "Tokyo Night"):gsub("GALAXY", "Galaxy"):gsub("ROYAL", "Royal Purple")
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -50, 1, 0)
        nameLabel.Position = UDim2.new(0, 28, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = displayName .. (CurrentTheme == themeName and "  ✓" or "")
        nameLabel.TextColor3 = CurrentTheme == themeName and themeColors[themeName] or Color3.fromRGB(180, 170, 200)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = TEXT_SIZE_NORMAL
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = item
        
        local selectBtn = Instance.new("TextButton")
        selectBtn.Size = UDim2.new(1, 0, 1, 0)
        selectBtn.BackgroundTransparency = 1
        selectBtn.Text = ""
        selectBtn.Parent = item
        
        selectBtn.MouseButton1Click:Connect(function()
            playClickSound()
            applyTheme(themeName)
            themeBtnText.Text = "TEMA: " .. displayName .. " ▼"
            themeBtnStroke.Color = themeColors[themeName]
            themeDropdownStroke.Color = themeColors[themeName]
            updateThemeDropdown()
        end)
    end
end

themeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    themeOpen = not themeOpen
    
    local displayName = CurrentTheme:gsub("_", " "):gsub("TOKYO NIGHT", "Tokyo Night"):gsub("GALAXY", "Galaxy"):gsub("ROYAL", "Royal Purple")
    themeBtnText.Text = "TEMA: " .. displayName .. (themeOpen and " ▲" or " ▼")
    
    themeDropdown:TweenSize(
        UDim2.new(1, 0, 0, themeOpen and #themeList * themeItemHeight + 10 or 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.3,
        true
    )
    
    updateThemeDropdown()
end)

-- Separator
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 1)
separator.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
separator.BorderSizePixel = 0
separator.LayoutOrder = 2
separator.Parent = utilContainer

-- Util buttons
local function createUtilButton(text, iconId, callback, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IsMobile and 42 or 38)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
    btn.Text = ""
    btn.TextColor3 = Color3.fromRGB(200, 190, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = TEXT_SIZE_NORMAL
    btn.Parent = utilContainer
    
    local btnIcon = Instance.new("ImageLabel")
    btnIcon.Size = UDim2.new(0, 18, 0, 18)
    btnIcon.Position = UDim2.new(0, 8, 0.5, -9)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = iconId
    btnIcon.ImageColor3 = Color3.fromRGB(200, 190, 220)
    btnIcon.Parent = btn
    
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, -30, 1, 0)
    btnLabel.Position = UDim2.new(0, 30, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = text
    btnLabel.TextColor3 = Color3.fromRGB(200, 190, 220)
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.TextSize = TEXT_SIZE_NORMAL
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.Parent = btn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(70, 35, 130)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.4
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        playClickSound()
        callback()
    end)
    
    return btn
end

createUtilButton("Respawn", "rbxassetid://6023426939", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end, 3)

createUtilButton("Rejoin Server", "rbxassetid://6023426921", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end, 4)

-- Noclip toggle
createToggleButton("NOCLIP", utilContainer, false, function(state)
    setNoclip(state)
end, 5)

-- Apply initial theme
applyTheme(CurrentTheme)

-- Tab click handlers
mainTab.MouseButton1Click:Connect(function()
    switchTab(mainContainer)
    highlightTab(mainTab)
    playClickSound()
end)

utilTab.MouseButton1Click:Connect(function()
    switchTab(utilContainer)
    highlightTab(utilTab)
    playClickSound()
end)

tpTab.MouseButton1Click:Connect(function()
    switchTab(tpContainer)
    highlightTab(tpTab)
    playClickSound()
end)

-- Show main tab by default
switchTab(mainContainer)
highlightTab(mainTab)

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    IsRunning = false
end)

-- Title animation
task.spawn(function()
    while IsRunning and task.wait() do
        TitleLabel.TextColor3 = Color3.fromHSV((tick() % 5) / 5, 0.7, 1)
    end
end)

print("✅ Anixly Loaded!")