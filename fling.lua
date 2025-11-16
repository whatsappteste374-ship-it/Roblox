--[[
    DarkForge V2.2 - Ultimate Fling & Anti-Fling System (Compact Edition)
    Changes in 2.2:
    - More compact hub (reduced height, less useless padding)
    - Cleaner and reorganized layout
    - RightShift hotkey to open/close the hub
    - (Removed: minimize + close buttons as requested)
    - FPS and ping indicator at the top
    - Improved visual feedback on buttons
    - Small optimizations and fixes

    Requested adjustments:
    - Keep version 2.2
    - Remove old Anti-Fling (Shield/Anchor/Ghost based on own character)
    - New Anti-Fling: disable CanCollide of ALL other players (code integrated)
    - Shield continues as “Anti-Fling” only in name/GUI, but system is the new one you sent
    - Remove X close button of the hub
    - Remove minimize button
    - Make Refresh button stay inside the hub (position fixed)
    - Make the entire script English
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StatsService = game:GetService("Stats")

local Player = Players.LocalPlayer

-- Auto-copy Discord link
if setclipboard then
    setclipboard("https://discord.gg/q3un9ZAE84")
end

---------------------------------------------------------------------
-- Config V2.2
---------------------------------------------------------------------
local DarkForge = {
    Version = "2.2",
    Discord = "https://discord.gg/q3un9ZAE84",
    Settings = {
        FlingMode = "Normal", -- Normal, Aggressive, Spin
        AntiFlingEnabled = false, -- controls if the new anti-fling system is ON/OFF
        AutoRefresh = true,
        Notifications = true,
        SafetyChecks = true,
        RGBEffects = true,
        FlingOnlyAlive = true
    }
}

---------------------------------------------------------------------
-- Utils V2.2
---------------------------------------------------------------------
local Utils = {}

function Utils.SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[DarkForge " .. DarkForge.Version .. "] Error: " .. tostring(result))
        return false, result
    end
    return true, result
end

function Utils.Message(Title, Text, Time)
    if DarkForge.Settings.Notifications then
        Utils.SafeCall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = Title,
                Text = Text,
                Duration = Time or 3
            })
        end)
    end
end

function Utils.Tween(element, properties, duration)
    if not element then return end
    local tweenInfo = TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utils.IsPlayerValid(player)
    return player
        and player.Parent
        and player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")
end

function Utils.IsPlayerAlive(player)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

---------------------------------------------------------------------
-- GUI V2.2 (More Compact)
---------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkForgeFlingGUI_V2_2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 290, 0, 320)
MainFrame.Position = UDim2.new(0.5, -145, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(80, 80, 80)
Stroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DARKFORGE " .. DarkForge.Version
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- FPS / Ping Status
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0.4, -10, 1, 0)
InfoLabel.Position = UDim2.new(0.6, 0, 0, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "FPS: -- | Ping: --"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 11
InfoLabel.TextXAlignment = Enum.TextXAlignment.Right
InfoLabel.Parent = TitleBar

-- NOTE: Minimize and Close buttons REMOVED as requested

-- Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 26)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local FlingTab = Instance.new("TextButton")
FlingTab.Size = UDim2.new(0.5, 0, 1, -4)
FlingTab.Position = UDim2.new(0, 0, 0, 2)
FlingTab.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FlingTab.BorderSizePixel = 0
FlingTab.Text = "FLING"
FlingTab.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingTab.Font = Enum.Font.GothamBold
FlingTab.TextSize = 11
FlingTab.Parent = TabContainer

local AntiFlingTab = Instance.new("TextButton")
AntiFlingTab.Size = UDim2.new(0.5, 0, 1, -4)
AntiFlingTab.Position = UDim2.new(0.5, 0, 0, 2)
AntiFlingTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AntiFlingTab.BorderSizePixel = 0
AntiFlingTab.Text = "ANTI-FLING"
AntiFlingTab.TextColor3 = Color3.fromRGB(200, 200, 200)
AntiFlingTab.Font = Enum.Font.GothamBold
AntiFlingTab.TextSize = 11
AntiFlingTab.Parent = TabContainer

local TabCorner1 = Instance.new("UICorner")
TabCorner1.CornerRadius = UDim.new(0, 6)
TabCorner1.Parent = FlingTab

local TabCorner2 = TabCorner1:Clone()
TabCorner2.Parent = AntiFlingTab

-- Content area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -56)
ContentFrame.Position = UDim2.new(0, 0, 0, 56)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local FlingContent = Instance.new("Frame")
FlingContent.Size = UDim2.new(1, 0, 1, 0)
FlingContent.BackgroundTransparency = 1
FlingContent.Visible = true
FlingContent.Parent = ContentFrame

local AntiFlingContent = Instance.new("Frame")
AntiFlingContent.Size = UDim2.new(1, 0, 1, 0)
AntiFlingContent.BackgroundTransparency = 1
AntiFlingContent.Visible = false
AntiFlingContent.Parent = ContentFrame

---------------------------------------------------------------------
-- Fling Content
---------------------------------------------------------------------
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.Size = UDim2.new(1, -20, 0, 18)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "No target selected"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = FlingContent

-- Row 1: Only Alive + Mode
local TopOptionsFrame = Instance.new("Frame")
TopOptionsFrame.Position = UDim2.new(0, 10, 0, 18)
TopOptionsFrame.Size = UDim2.new(1, -20, 0, 26)
TopOptionsFrame.BackgroundTransparency = 1
TopOptionsFrame.Parent = FlingContent

local FlingAliveLabel = Instance.new("TextLabel")
FlingAliveLabel.Size = UDim2.new(0, 80, 1, 0)
FlingAliveLabel.BackgroundTransparency = 1
FlingAliveLabel.Text = "Only Alive:"
FlingAliveLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FlingAliveLabel.Font = Enum.Font.Gotham
FlingAliveLabel.TextSize = 11
FlingAliveLabel.TextXAlignment = Enum.TextXAlignment.Left
FlingAliveLabel.Parent = TopOptionsFrame

local FlingAliveToggle = Instance.new("TextButton")
FlingAliveToggle.Position = UDim2.new(0, 80, 0, 3)
FlingAliveToggle.Size = UDim2.new(0, 38, 0, 20)
FlingAliveToggle.BackgroundColor3 = DarkForge.Settings.FlingOnlyAlive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
FlingAliveToggle.BorderSizePixel = 0
FlingAliveToggle.Text = DarkForge.Settings.FlingOnlyAlive and "ON" or "OFF"
FlingAliveToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingAliveToggle.Font = Enum.Font.Gotham
FlingAliveToggle.TextSize = 10
FlingAliveToggle.Parent = TopOptionsFrame

local FlingAliveCorner = Instance.new("UICorner")
FlingAliveCorner.CornerRadius = UDim.new(0, 6)
FlingAliveCorner.Parent = FlingAliveToggle

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0, 70, 1, 0)
ModeLabel.Position = UDim2.new(0, 130, 0, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Mode:"
ModeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextSize = 11
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = TopOptionsFrame

local ModeDropdown = Instance.new("TextButton")
ModeDropdown.Position = UDim2.new(0, 170, 0, 3)
ModeDropdown.Size = UDim2.new(0, 90, 0, 20)
ModeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ModeDropdown.BorderSizePixel = 0
ModeDropdown.Text = DarkForge.Settings.FlingMode
ModeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeDropdown.Font = Enum.Font.Gotham
ModeDropdown.TextSize = 11
ModeDropdown.Parent = TopOptionsFrame

local ModeCorner = Instance.new("UICorner")
ModeCorner.CornerRadius = UDim.new(0, 6)
ModeCorner.Parent = ModeDropdown

-- Player list
local SelectionFrame = Instance.new("Frame")
SelectionFrame.Position = UDim2.new(0, 10, 0, 50)
SelectionFrame.Size = UDim2.new(1, -20, 0, 150)
SelectionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SelectionFrame.BorderSizePixel = 0
SelectionFrame.Parent = FlingContent

local SelectionCorner = Instance.new("UICorner")
SelectionCorner.CornerRadius = UDim.new(0, 8)
SelectionCorner.Parent = SelectionFrame

local SelectionTitle = Instance.new("TextLabel")
SelectionTitle.Size = UDim2.new(1, 0, 0, 18)
SelectionTitle.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
SelectionTitle.BorderSizePixel = 0
SelectionTitle.Text = "PLAYERS"
SelectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectionTitle.Font = Enum.Font.GothamBold
SelectionTitle.TextSize = 10
SelectionTitle.Parent = SelectionFrame

local SelectionTitleCorner = Instance.new("UICorner")
SelectionTitleCorner.CornerRadius = UDim.new(0, 8)
SelectionTitleCorner.Parent = SelectionTitle

local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Position = UDim2.new(0, 4, 0, 20)
PlayerScrollFrame.Size = UDim2.new(1, -8, 1, -24)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 3
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = SelectionFrame

-- Bottom buttons
local FlingButtonsFrame = Instance.new("Frame")
FlingButtonsFrame.Position = UDim2.new(0, 10, 0, 206)
FlingButtonsFrame.Size = UDim2.new(1, -20, 0, 100)
FlingButtonsFrame.BackgroundTransparency = 1
FlingButtonsFrame.Parent = FlingContent

local StartButton = Instance.new("TextButton")
StartButton.Position = UDim2.new(0, 0, 0, 0)
StartButton.Size = UDim2.new(0.5, -4, 0, 28)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
StartButton.BorderSizePixel = 0
StartButton.Text = "🚀 START"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 12
StartButton.Parent = FlingButtonsFrame

local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0.5, 4, 0, 0)
StopButton.Size = UDim2.new(0.5, -4, 0, 28)
StopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Text = "⏹️ STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 12
StopButton.Parent = FlingButtonsFrame

local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Position = UDim2.new(0, 0, 0, 32)
SelectAllButton.Size = UDim2.new(0.5, -4, 0, 24)
SelectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SelectAllButton.BorderSizePixel = 0
SelectAllButton.Text = "✅ ALL"
SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllButton.Font = Enum.Font.Gotham
SelectAllButton.TextSize = 11
SelectAllButton.Parent = FlingButtonsFrame

local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Position = UDim2.new(0.5, 4, 0, 32)
DeselectAllButton.Size = UDim2.new(0.5, -4, 0, 24)
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DeselectAllButton.BorderSizePixel = 0
DeselectAllButton.Text = "❌ NONE"
DeselectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllButton.Font = Enum.Font.Gotham
DeselectAllButton.TextSize = 11
DeselectAllButton.Parent = FlingButtonsFrame

local RefreshButton = Instance.new("TextButton")
RefreshButton.Position = UDim2.new(0, 0, 0, 60)
RefreshButton.Size = UDim2.new(1, 0, 0, 24)
RefreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
RefreshButton.BorderSizePixel = 0
RefreshButton.Text = "🔄 REFRESH"
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshButton.Font = Enum.Font.Gotham
RefreshButton.TextSize = 11
RefreshButton.Parent = FlingButtonsFrame

for _, button in ipairs({StartButton, StopButton, SelectAllButton, DeselectAllButton, RefreshButton}) do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = button
end

---------------------------------------------------------------------
-- Anti-Fling Content (GUI for the new system)
---------------------------------------------------------------------
local AntiFlingStatus = Instance.new("TextLabel")
AntiFlingStatus.Position = UDim2.new(0, 10, 0, 0)
AntiFlingStatus.Size = UDim2.new(1, -20, 0, 18)
AntiFlingStatus.BackgroundTransparency = 1
AntiFlingStatus.Text = "Anti-Fling: INACTIVE"
AntiFlingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiFlingStatus.Font = Enum.Font.Gotham
AntiFlingStatus.TextSize = 11
AntiFlingStatus.TextXAlignment = Enum.TextXAlignment.Left
AntiFlingStatus.Parent = AntiFlingContent

local DescriptionFrame = Instance.new("Frame")
DescriptionFrame.Position = UDim2.new(0, 10, 0, 26)
DescriptionFrame.Size = UDim2.new(1, -20, 0, 190)
DescriptionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
DescriptionFrame.BorderSizePixel = 0
DescriptionFrame.Parent = AntiFlingContent

local DescriptionCorner = Instance.new("UICorner")
DescriptionCorner.CornerRadius = UDim.new(0, 8)
DescriptionCorner.Parent = DescriptionFrame

local DescriptionTitle = Instance.new("TextLabel")
DescriptionTitle.Size = UDim2.new(1, 0, 0, 20)
DescriptionTitle.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
DescriptionTitle.BorderSizePixel = 0
DescriptionTitle.Text = "ANTI-FLING SYSTEM"
DescriptionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DescriptionTitle.Font = Enum.Font.GothamBold
DescriptionTitle.TextSize = 10
DescriptionTitle.Parent = DescriptionFrame

local DescriptionTitleCorner = Instance.new("UICorner")
DescriptionTitleCorner.CornerRadius = UDim.new(0, 8)
DescriptionTitleCorner.Parent = DescriptionTitle

local DescriptionText = Instance.new("TextLabel")
DescriptionText.Position = UDim2.new(0, 6, 0, 24)
DescriptionText.Size = UDim2.new(1, -12, 1, -28)
DescriptionText.BackgroundTransparency = 1
DescriptionText.Text =
    "🛡 New Anti-Fling:\n" ..
    "- Disables CanCollide for ALL other players.\n" ..
    "- Stops their body from pushing yours.\n" ..
    "- Works continuously while ON.\n\n" ..
    "NOTE: Your character stays normal; only other\n" ..
    "players lose collision locally for you."
DescriptionText.TextColor3 = Color3.fromRGB(200, 200, 200)
DescriptionText.Font = Enum.Font.Gotham
DescriptionText.TextSize = 11
DescriptionText.TextXAlignment = Enum.TextXAlignment.Left
DescriptionText.TextYAlignment = Enum.TextYAlignment.Top
DescriptionText.Parent = DescriptionFrame

local AntiFlingButtonsFrame = Instance.new("Frame")
AntiFlingButtonsFrame.Position = UDim2.new(0, 10, 0, 225)
AntiFlingButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
AntiFlingButtonsFrame.BackgroundTransparency = 1
AntiFlingButtonsFrame.Parent = AntiFlingContent

local ActivateAntiFling = Instance.new("TextButton")
ActivateAntiFling.Size = UDim2.new(1, 0, 0, 32)
ActivateAntiFling.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ActivateAntiFling.BorderSizePixel = 0
ActivateAntiFling.Text = "🛡 ANTI-FLING: OFF"
ActivateAntiFling.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateAntiFling.Font = Enum.Font.GothamBold
ActivateAntiFling.TextSize = 12
ActivateAntiFling.Parent = AntiFlingButtonsFrame

local AntiFlingCorner = Instance.new("UICorner")
AntiFlingCorner.CornerRadius = UDim.new(0, 6)
AntiFlingCorner.Parent = ActivateAntiFling

-- Floating toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "⚡ DARKFORGE " .. DarkForge.Version
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 10
ToggleButton.TextWrapped = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Transparency = 0.7
ToggleStroke.Parent = ToggleButton

---------------------------------------------------------------------
-- Main variables
---------------------------------------------------------------------
local SelectedTargets = {}
local PlayerCheckboxes = {}
local FlingActive = false

-- new anti-fling variables
local AntiFlingConnection = nil
local TrackedPlayers = {}
local TrackedConnections = {}

---------------------------------------------------------------------
-- Player List
---------------------------------------------------------------------
local function CountSelectedTargets()
    local count = 0
    for _ in pairs(SelectedTargets) do
        count += 1
    end
    return count
end

local function CountValidTargets()
    local count = 0
    for _, plr in pairs(SelectedTargets) do
        if Utils.IsPlayerValid(plr)
            and (not DarkForge.Settings.FlingOnlyAlive or Utils.IsPlayerAlive(plr)) then
            count += 1
        end
    end
    return count
end

local function UpdatePlayerStatus()
    for name, data in pairs(PlayerCheckboxes) do
        local plr = Players:FindFirstChild(name)
        if plr and data.StatusIndicator then
            data.StatusIndicator.BackgroundColor3 =
                (Utils.IsPlayerAlive(plr) and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
        end
    end
end

local function UpdateStatus()
    local count = CountSelectedTargets()
    local valid = CountValidTargets()

    if FlingActive then
        StatusLabel.Text = string.format("Flinging %d/%d | Mode: %s", valid, count, DarkForge.Settings.FlingMode)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        StatusLabel.Text = string.format("%d selected (%d valid) | Ready", count, valid)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    if DarkForge.Settings.AntiFlingEnabled then
        AntiFlingStatus.Text = "Anti-Fling: ACTIVE"
        AntiFlingStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
        ActivateAntiFling.Text = "🛡 ANTI-FLING: ON"
        ActivateAntiFling.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        AntiFlingStatus.Text = "Anti-Fling: INACTIVE"
        AntiFlingStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActivateAntiFling.Text = "🛡 ANTI-FLING: OFF"
        ActivateAntiFling.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end
end

local function RefreshPlayerList()
    for _, child in ipairs(PlayerScrollFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    PlayerCheckboxes = {}

    local layout = PlayerScrollFrame:FindFirstChildOfClass("UIListLayout")
    if not layout then
        layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)
        layout.Parent = PlayerScrollFrame
    end

    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)

    for _, plr in ipairs(players) do
        if plr ~= Player then
            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1, -4, 0, 22)
            entry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            entry.BorderSizePixel = 0
            entry.Parent = PlayerScrollFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = entry

            local checkbox = Instance.new("TextButton")
            checkbox.Size = UDim2.new(0, 16, 0, 16)
            checkbox.Position = UDim2.new(0, 4, 0.5, -8)
            checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            checkbox.BorderSizePixel = 0
            checkbox.Text = ""
            checkbox.Parent = entry

            local cbCorner = Instance.new("UICorner")
            cbCorner.CornerRadius = UDim.new(0, 3)
            cbCorner.Parent = checkbox

            local checkmark = Instance.new("TextLabel")
            checkmark.Size = UDim2.new(1, 0, 1, 0)
            checkmark.BackgroundTransparency = 1
            checkmark.Text = "✓"
            checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
            checkmark.TextSize = 12
            checkmark.Font = Enum.Font.GothamBold
            checkmark.Visible = SelectedTargets[plr.Name] ~= nil
            checkmark.Parent = checkbox

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -40, 1, 0)
            nameLabel.Position = UDim2.new(0, 24, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = plr.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 11
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = entry

            local statusIndicator = Instance.new("Frame")
            statusIndicator.Size = UDim2.new(0, 4, 0, 4)
            statusIndicator.Position = UDim2.new(1, -10, 0.5, -2)
            statusIndicator.BackgroundColor3 =
                (Utils.IsPlayerAlive(plr) and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0)
            statusIndicator.BorderSizePixel = 0
            statusIndicator.Parent = entry

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(1, 0)
            sCorner.Parent = statusIndicator

            local clickArea = Instance.new("TextButton")
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.ZIndex = 2
            clickArea.Parent = entry

            clickArea.MouseButton1Click:Connect(function()
                if SelectedTargets[plr.Name] then
                    SelectedTargets[plr.Name] = nil
                    checkmark.Visible = false
                    Utils.Tween(checkbox, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.15)
                else
                    SelectedTargets[plr.Name] = plr
                    checkmark.Visible = true
                    Utils.Tween(checkbox, {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}, 0.15)
                end
                UpdateStatus()
            end)

            PlayerCheckboxes[plr.Name] = {
                Entry = entry,
                Checkmark = checkmark,
                Checkbox = checkbox,
                StatusIndicator = statusIndicator
            }
        end
    end

    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 4)
    UpdatePlayerStatus()
end

local function ToggleAllPlayers(select)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local data = PlayerCheckboxes[plr.Name]
            if data then
                if select then
                    SelectedTargets[plr.Name] = plr
                    data.Checkmark.Visible = true
                    Utils.Tween(data.Checkbox, {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}, 0.15)
                else
                    SelectedTargets[plr.Name] = nil
                    data.Checkmark.Visible = false
                    Utils.Tween(data.Checkbox, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.15)
                end
            end
        end
    end
    UpdateStatus()
end

---------------------------------------------------------------------
-- Fling System
---------------------------------------------------------------------
local FlingSystem = {}

function FlingSystem.SafeFlingCheck(TargetPlayer)
    if not Utils.IsPlayerValid(TargetPlayer) then
        return false, "Target player not valid"
    end

    if not Player.Character then
        return false, "Your character not found"
    end

    local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        return false, "Your humanoid not found"
    end

    if Humanoid.Health <= 0 then
        return false, "You are dead"
    end

    if DarkForge.Settings.FlingOnlyAlive and not Utils.IsPlayerAlive(TargetPlayer) then
        return false, "Target is dead"
    end

    return true
end

function FlingSystem.NormalFling(TargetPlayer)
    local ok, reason = FlingSystem.SafeFlingCheck(TargetPlayer)
    if not ok then return false, reason end

    local Character = Player.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character

    if not TCharacter or not RootPart then return false, "Character or root part not found" end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart

    if not TRootPart then return false, "Target root part not found" end

    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end

    if THumanoid and THumanoid.Sit then
        return false, "Target is sitting"
    end

    getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0

    local BV = Instance.new("BodyVelocity")
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local TimeToWait = 1.5
    local startTime = tick()
    local Angle = 0

    repeat
        if RootPart and THumanoid and TRootPart then
            Angle += 100
            local moveDir = THumanoid.MoveDirection * math.min(TRootPart.Velocity.Magnitude / 1.25, 50)

            local basePosition = TRootPart.Position + Vector3.new(0, 1.5, 0)
            local offset = moveDir
            local rotation = CFrame.Angles(math.rad(Angle), 0, 0)

            RootPart.CFrame = CFrame.new(basePosition) * rotation + offset
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            RunService.Heartbeat:Wait()
        else
            break
        end
    until startTime + TimeToWait < tick() or not FlingActive

    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    if getgenv().OldPos then
        RootPart.CFrame = getgenv().OldPos
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.new()
                part.RotVelocity = Vector3.new()
            end
        end
    end

    if getgenv().FPDH then
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    end

    return true, "Success"
end

function FlingSystem.AggressiveFling(TargetPlayer)
    local success, reason = FlingSystem.NormalFling(TargetPlayer)
    if success then
        task.wait(0.1)
        return FlingSystem.NormalFling(TargetPlayer)
    end
    return success, reason
end

function FlingSystem.SpinFling(TargetPlayer)
    local ok, reason = FlingSystem.SafeFlingCheck(TargetPlayer)
    if not ok then return false, reason end

    local Character = Player.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character

    if not TCharacter or not RootPart then return false, "Character or root part not found" end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart

    if not TRootPart then return false, "Target root part not found" end

    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end

    getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0

    local BV = Instance.new("BodyVelocity")
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local TimeToWait = 2
    local startTime = tick()
    local SpinSpeed = 500

    repeat
        if RootPart and TRootPart then
            local angle = (tick() - startTime) * SpinSpeed
            local offset = Vector3.new(math.sin(angle) * 4, 2, math.cos(angle) * 4)

            RootPart.CFrame = CFrame.new(TRootPart.Position + offset) * CFrame.Angles(0, angle, 0)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 5, 9e7)
            RootPart.RotVelocity = Vector3.new(0, 9e8, 0)
            RunService.Heartbeat:Wait()
        else
            break
        end
    until startTime + TimeToWait < tick() or not FlingActive

    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    if getgenv().OldPos then
        RootPart.CFrame = getgenv().OldPos
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.new()
                part.RotVelocity = Vector3.new()
            end
        end
    end

    if getgenv().FPDH then
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    end

    return true, "Success"
end

function FlingSystem.FlingTarget(TargetPlayer)
    local mode = DarkForge.Settings.FlingMode
    if mode == "Aggressive" then
        return FlingSystem.AggressiveFling(TargetPlayer)
    elseif mode == "Spin" then
        return FlingSystem.SpinFling(TargetPlayer)
    else
        return FlingSystem.NormalFling(TargetPlayer)
    end
end

---------------------------------------------------------------------
-- NEW Anti-Fling System
---------------------------------------------------------------------
local function DisableCanCollide(part)
    if part:IsA("BasePart") and part.CanCollide then
        part.CanCollide = false
    end
end

local function TrackCharacterForAntiFling(character)
    -- apply immediately
    for _, part in pairs(character:GetChildren()) do
        DisableCanCollide(part)
    end

    -- also for new parts
    local con = character.ChildAdded:Connect(function(child)
        DisableCanCollide(child)
    end)
    table.insert(TrackedConnections, con)
end

local function TrackPlayerForAntiFling(player)
    if player == Player then return end
    if TrackedPlayers[player] then return end

    TrackedPlayers[player] = true

    if player.Character then
        TrackCharacterForAntiFling(player.Character)
    end

    local con = player.CharacterAdded:Connect(function(char)
        TrackCharacterForAntiFling(char)
    end)
    table.insert(TrackedConnections, con)
end

local AntiFlingSystem = {}

function AntiFlingSystem.Start()
    if DarkForge.Settings.AntiFlingEnabled then return end
    DarkForge.Settings.AntiFlingEnabled = true

    -- register existing players
    for _, plr in pairs(Players:GetPlayers()) do
        TrackPlayerForAntiFling(plr)
    end

    -- new players
    local conAdd = Players.PlayerAdded:Connect(function(plr)
        TrackPlayerForAntiFling(plr)
    end)
    table.insert(TrackedConnections, conAdd)

    -- main loop per frame
    AntiFlingConnection = RunService.RenderStepped:Connect(function()
        if not DarkForge.Settings.AntiFlingEnabled then return end
        for plr, _ in pairs(TrackedPlayers) do
            if plr and plr.Character then
                for _, part in pairs(plr.Character:GetChildren()) do
                    DisableCanCollide(part)
                end
            end
        end
    end)

    UpdateStatus()
    Utils.Message("Anti-Fling", "New anti-fling enabled (no collision from other players)", 3)
end

function AntiFlingSystem.Stop()
    if not DarkForge.Settings.AntiFlingEnabled then return end
    DarkForge.Settings.AntiFlingEnabled = false

    if AntiFlingConnection then
        AntiFlingConnection:Disconnect()
        AntiFlingConnection = nil
    end

    -- disconnect all events used by anti-fling
    for _, con in ipairs(TrackedConnections) do
        if typeof(con) == "RBXScriptConnection" then
            con:Disconnect()
        end
    end
    TrackedConnections = {}
    TrackedPlayers = {}

    -- we do NOT re-enable collision for other players, since this is local
    -- and Roblox will naturally reset on respawns / other updates.

    UpdateStatus()
    Utils.Message("Anti-Fling", "Anti-fling disabled", 2)
end

---------------------------------------------------------------------
-- Fling Management
---------------------------------------------------------------------
local function StartFling()
    if FlingActive then return end

    local validCount = CountValidTargets()
    if validCount == 0 then
        StatusLabel.Text = "No valid target selected!"
        Utils.Tween(StatusLabel, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
        task.wait(1)
        UpdateStatus()
        return
    end

    FlingActive = true
    UpdateStatus()
    Utils.Tween(StartButton, {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}, 0.2)
    Utils.Message("Fling Started", "Flinging " .. validCount .. " targets", 2)

    task.spawn(function()
        while FlingActive do
            local validTargets = {}

            for name, plr in pairs(SelectedTargets) do
                if Utils.IsPlayerValid(plr)
                    and (not DarkForge.Settings.FlingOnlyAlive or Utils.IsPlayerAlive(plr)) then
                    validTargets[name] = plr
                else
                    SelectedTargets[name] = nil
                    local cb = PlayerCheckboxes[name]
                    if cb then
                        cb.Checkmark.Visible = false
                        Utils.Tween(cb.Checkbox, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.15)
                    end
                end
            end

            for _, plr in pairs(validTargets) do
                if not FlingActive then break end
                local success, reason = Utils.SafeCall(FlingSystem.FlingTarget, plr)
                if not success then
                    warn("[Fling] Failed to fling " .. plr.Name .. ": " .. tostring(reason))
                end
                task.wait(0.2)
            end

            UpdateStatus()
            UpdatePlayerStatus()
            task.wait(0.4)
        end

        Utils.Tween(StartButton, {BackgroundColor3 = Color3.fromRGB(0, 180, 0)}, 0.2)
    end)
end

local function StopFling()
    if not FlingActive then return end
    FlingActive = false
    UpdateStatus()
    Utils.Tween(StartButton, {BackgroundColor3 = Color3.fromRGB(0, 180, 0)}, 0.2)
    Utils.Message("Fling Stopped", "Fling has been stopped", 2)
end

---------------------------------------------------------------------
-- Drag System
---------------------------------------------------------------------
local function MakeDraggable(element, handle)
    local dragging, dragInput, dragStart, startPos

    local function Update(input)
        local delta = input.Position - dragStart
        element.Position = UDim2.new(
            0,
            startPos.X.Offset + delta.X,
            0,
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = element.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

---------------------------------------------------------------------
-- Tabs
---------------------------------------------------------------------
local function SwitchToTab(tabName)
    if tabName == "Fling" then
        FlingContent.Visible = true
        AntiFlingContent.Visible = false
        FlingTab.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        FlingTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        AntiFlingTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        AntiFlingTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        FlingContent.Visible = false
        AntiFlingContent.Visible = true
        AntiFlingTab.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        AntiFlingTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        FlingTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        FlingTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

---------------------------------------------------------------------
-- Events
---------------------------------------------------------------------
FlingTab.MouseButton1Click:Connect(function()
    SwitchToTab("Fling")
end)

AntiFlingTab.MouseButton1Click:Connect(function()
    SwitchToTab("AntiFling")
end)

StartButton.MouseButton1Click:Connect(StartFling)
StopButton.MouseButton1Click:Connect(StopFling)
SelectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(true) end)
DeselectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(false) end)
RefreshButton.MouseButton1Click:Connect(RefreshPlayerList)

FlingAliveToggle.MouseButton1Click:Connect(function()
    DarkForge.Settings.FlingOnlyAlive = not DarkForge.Settings.FlingOnlyAlive
    FlingAliveToggle.BackgroundColor3 = DarkForge.Settings.FlingOnlyAlive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
    FlingAliveToggle.Text = DarkForge.Settings.FlingOnlyAlive and "ON" or "OFF"
    UpdateStatus()
end)

-- Toggle for the new Anti-Fling
ActivateAntiFling.MouseButton1Click:Connect(function()
    if DarkForge.Settings.AntiFlingEnabled then
        AntiFlingSystem.Stop()
    else
        AntiFlingSystem.Start()
    end
end)

-- NOTE: Close and Minimize button logic REMOVED

ToggleButton.MouseButton1Click:Connect(function()
    if not MainFrame.Visible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 290, 0, 0)
        Utils.Tween(MainFrame, {Size = UDim2.new(0, 290, 0, 320)}, 0.25)
    else
        Utils.Tween(MainFrame, {Size = UDim2.new(0, 290, 0, 0)}, 0.25)
        task.wait(0.25)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 290, 0, 320)
    end
end)

-- RightShift hotkey
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ToggleButton:Activate()
    end
end)

Players.PlayerAdded:Connect(function()
    if DarkForge.Settings.AutoRefresh then
        RefreshPlayerList()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if SelectedTargets[plr.Name] then
        SelectedTargets[plr.Name] = nil
    end
    if DarkForge.Settings.AutoRefresh then
        RefreshPlayerList()
    end
    UpdateStatus()
end)

-- Periodic update of player status
task.spawn(function()
    while ScreenGui.Parent do
        UpdatePlayerStatus()
        task.wait(2)
    end
end)

---------------------------------------------------------------------
-- RGB / FX + FPS / Ping
---------------------------------------------------------------------
task.spawn(function()
    local hue = 0
    local fpsCounter = 0
    local lastTime = tick()

    RunService.Heartbeat:Connect(function(dt)
        fpsCounter += 1
        local now = tick()
        if now - lastTime >= 1 then
            local fps = fpsCounter
            fpsCounter = 0
            lastTime = now

            local ping = "??"
            local network = StatsService:FindFirstChild("Network")
            if network then
                local incoming = network:FindFirstChild("ServerStatsItem")
                if incoming then
                    local data = incoming:FindFirstChild("Data Ping")
                    if data and data.GetValue then
                        local v = data:GetValue()
                        if v then
                            ping = math.floor(v)
                        end
                    end
                end
            end

            InfoLabel.Text = string.format("FPS: %d | Ping: %s", fps, tostring(ping))
        end

        if DarkForge.Settings.RGBEffects then
            hue = (hue + dt * 0.5) % 1
            Stroke.Color = Color3.fromHSV(hue, 0.8, 1)
            ToggleStroke.Color = Color3.fromHSV((hue + 0.5) % 1, 0.8, 1)

            if FlingActive then
                local pulse = math.abs(math.sin(tick() * 3)) * 0.3 + 0.7
                StartButton.BackgroundColor3 = Color3.fromHSV(hue, pulse, 1)
            end
        end
    end)
end)

---------------------------------------------------------------------
-- Auto-Respawn
---------------------------------------------------------------------
Player.CharacterAdded:Connect(function()
    -- when respawning, if anti-fling is enabled, reconfigure tracking
    if DarkForge.Settings.AntiFlingEnabled then
        AntiFlingSystem.Stop()
        task.wait(1)
        AntiFlingSystem.Start()
    end
end)

---------------------------------------------------------------------
-- Init
---------------------------------------------------------------------
MakeDraggable(MainFrame, TitleBar)
MakeDraggable(ToggleButton, ToggleButton)

RefreshPlayerList()
UpdateStatus()

Utils.Message("DarkForge " .. DarkForge.Version, "Compact Fling & New Anti-Fling Loaded!", 4)

print("⚡ DarkForge " .. DarkForge.Version .. " - Compact Ultimate Fling System Loaded")
print("🎯 Features: Multiple Fling Modes, New Anti-Fling (no collision from others), Compact UI")
print("📋 Discord: https://discord.gg/q3un9ZAE84")