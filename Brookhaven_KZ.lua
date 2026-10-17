
--[[
    VICTOR HUB INFINITE X
    Ultimate Edition | Black & Red
    Local UI utilities for Roblox
    No combat automation or server exploits.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- 1. CONFIGURATION
--==================================================

local COLORS = {
    BG = Color3.fromRGB(13, 13, 17),
    PANEL = Color3.fromRGB(24, 24, 31),
    CARD = Color3.fromRGB(32, 32, 41),
    RED = Color3.fromRGB(215, 35, 54),
    WHITE = Color3.fromRGB(245, 245, 248),
    GRAY = Color3.fromRGB(165, 165, 180),
    GREEN = Color3.fromRGB(80, 215, 135)
}

local State = {
    notifications = true,
    compact = false,
    highContrast = false,
    fontScale = 1,
    currentPage = "Dashboard",
    quest = "",
    macros = {},
    recording = false,
    recordBuffer = {},
    events = {},
    profiles = {},
    plugins = {},
    favorites = {},
    startedAt = os.clock()
}

local old = playerGui:FindFirstChild("VictorHubInfiniteX")
if old then
    old:Destroy()
end

--==================================================
-- 2. UI HELPERS
--==================================================

local function make(class, props, parent)
    local obj = Instance.new(class)

    for key, value in pairs(props) do
        obj[key] = value
    end

    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, obj)
end

local function logEvent(message)
    table.insert(State.events, 1,
        os.date("%H:%M:%S") .. " | " .. tostring(message))

    while #State.events > 100 do
        table.remove(State.events)
    end

    print("[Victor Hub] " .. tostring(message))
end

local function notify(message)
    logEvent(message)

    if not State.notifications then
        return
    end

    local notice = make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 38),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = COLORS.CARD,
        TextColor3 = COLORS.WHITE,
        Text = tostring(message),
        TextWrapped = true,
        TextSize = 13 * State.fontScale,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0
    }, notificationArea)

    corner(notice, 8)

    task.delay(3, function()
        if notice.Parent then
            notice:Destroy()
        end
    end)
end

--==================================================
-- 3. ROOT INTERFACE
--==================================================

local gui = make("ScreenGui", {
    Name = "VictorHubInfiniteX",
    ResetOnSpawn = false,
    DisplayOrder = 50
}, playerGui)

local notificationArea = make("Frame", {
    Name = "Notifications",
    Size = UDim2.new(0, 270, 0, 180),
    Position = UDim2.new(1, -280, 0, 10),
    BackgroundTransparency = 1
}, gui)

make("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, notificationArea)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 600, 0, 410),
    Position = UDim2.new(0.5, -300, 0.5, -205),
    BackgroundColor3 = COLORS.BG,
    BorderSizePixel = 0
}, gui)
corner(main, 12)

make("UIStroke", {
    Color = COLORS.RED,
    Thickness = 1.5
}, main)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = COLORS.PANEL,
    BorderSizePixel = 0
}, main)
corner(top, 12)

make("TextLabel", {
    Position = UDim2.new(0, 14, 0, 0),
    Size = UDim2.new(1, -150, 1, 0),
    BackgroundTransparency = 1,
    Text = "VICTOR HUB  /  INFINITE X",
    TextColor3 = COLORS.RED,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local function uiButton(parent, text, pos, size, callback)
    local b = make("TextButton", {
        Position = pos,
        Size = size,
        BackgroundColor3 = COLORS.CARD,
        Text = text,
        TextColor3 = COLORS.WHITE,
        Font = Enum.Font.GothamMedium,
        TextSize = 13 * State.fontScale,
        TextWrapped = true,
        BorderSizePixel = 0,
        AutoButtonColor = true
    }, parent)

    corner(b, 7)
    b.Activated:Connect(callback)

    return b
end

local minimize = uiButton(
    top, "-", UDim2.new(1, -86, 0, 8),
    UDim2.new(0, 32, 0, 32), function()
        body.Visible = not body.Visible
        main.Size = body.Visible
            and UDim2.new(0, 600, 0, 410)
            or UDim2.new(0, 600, 0, 48)
    end
)

uiButton(
    top, "X", UDim2.new(1, -44, 0, 8),
    UDim2.new(0, 32, 0, 32), function()
        gui:Destroy()
    end
)

body = make("Frame", {
    Name = "Body",
    Position = UDim2.new(0, 10, 0, 58),
    Size = UDim2.new(1, -20, 1, -68),
    BackgroundTransparency = 1
}, main)

local sidebar = make("ScrollingFrame", {
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 155, 1, 0),
    BackgroundColor3 = COLORS.PANEL,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, body)
corner(sidebar, 8)

make("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, sidebar)

make("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 7),
    PaddingRight = UDim.new(0, 7),
    PaddingBottom = UDim.new(0, 8)
}, sidebar)

local content = make("ScrollingFrame", {
    Position = UDim2.new(0, 165, 0, 0),
    Size = UDim2.new(1, -165, 1, 0),
    BackgroundColor3 = COLORS.PANEL,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, body)
corner(content, 8)

local pageTitle
local pageDescription
local pageContent
local pageButtons = {}

local function clearPage()
    for _, child in ipairs(content:GetChildren()) do
        child:Destroy()
    end
end

local function newPage(title, description)
    clearPage()
    State.currentPage = title

    pageTitle = make("TextLabel", {
        Position = UDim2.new(0, 14, 0, 10),
        Size = UDim2.new(1, -28, 0, 30),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = COLORS.RED,
        TextSize = 19 * State.fontScale,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, content)

    pageDescription = make("TextLabel", {
        Position = UDim2.new(0, 14, 0, 42),
        Size = UDim2.new(1, -28, 0, 42),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = COLORS.GRAY,
        TextSize = 12 * State.fontScale,
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, content)

    pageContent = make("Frame", {
        Position = UDim2.new(0, 10, 0, 88),
        Size = UDim2.new(1, -20, 0, 800),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y
    }, content)

    make("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, pageContent)
end

local function actionButton(text, callback)
    local b = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = COLORS.CARD,
        Text = text,
        TextColor3 = COLORS.WHITE,
        TextSize = 13 * State.fontScale,
        Font = Enum.Font.GothamMedium,
        TextWrapped = true,
        BorderSizePixel = 0
    }, pageContent)

    corner(b, 7)
    b.Activated:Connect(callback)
    return b
end

local function textLabel(text, height)
    return make("TextLabel", {
        Size = UDim2.new(1, 0, 0, height or 60),
        BackgroundColor3 = COLORS.BG,
        Text = text,
        TextColor3 = COLORS.WHITE,
        TextSize = 13 * State.fontScale,
        Font = Enum.Font.Code,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        BorderSizePixel = 0
    }, pageContent)
end

local function textInput(placeholder, defaultText)
    local box = make("TextBox", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = COLORS.BG,
        TextColor3 = COLORS.WHITE,
        PlaceholderColor3 = COLORS.GRAY,
        PlaceholderText = placeholder,
        Text = defaultText or "",
        TextSize = 13 * State.fontScale,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        BorderSizePixel = 0
    }, pageContent)

    corner(box, 7)
    return box
end

--==================================================
-- 4. CHARACTER STATS
--==================================================

local function getStats()
    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")
    local root = character
        and character:FindFirstChild("HumanoidRootPart")

    local data = player:FindFirstChild("Data")
    local level = data and data:FindFirstChild("Level")

    local lines = {
        "Player: " .. player.Name,
        "Level: " .. (level and tostring(level.Value)
            or "Unavailable"),
        "Health: " .. (humanoid
            and math.floor(humanoid.Health) .. "/" ..
                math.floor(humanoid.MaxHealth)
            or "Unavailable"),
        "WalkSpeed: " .. (humanoid
            and tostring(math.floor(humanoid.WalkSpeed))
            or "Unavailable"),
        "Position: " .. (root
            and string.format("%.1f, %.1f, %.1f",
                root.Position.X,
                root.Position.Y,
                root.Position.Z)
            or "Unavailable"),
        "Session: " .. math.floor(os.clock() - State.startedAt)
            .. " seconds"
    }

    return table.concat(lines, "\n")
end

--==================================================
-- 5. MODULE PAGES
--==================================================

local function dashboard()
    newPage("Dashboard", "Victor Hub Infinite X | Local status")

    local stats = textLabel(getStats(), 150)

    actionButton("Refresh statistics", function()
        stats.Text = getStats()
    end)

    actionButton("Show notification", function()
        notify("Victor Hub is running.")
    end)
end

local function commandPalette()
    newPage("Command Palette", "Search registered safe commands.")

    local input = textInput("Search commands...")
    local results = textLabel("", 220)

    local function search()
        local q = input.Text:lower()
        local names = {
            "help", "stats", "quest", "fruit",
            "map", "events", "profiles", "settings"
        }

        local found = {}

        for _, name in ipairs(names) do
            if name:find(q, 1, true) then
                table.insert(found, name)
            end
        end

        results.Text = table.concat(found, "\n")
    end

    actionButton("Search", search)

    actionButton("Run stats", function()
        notify(getStats())
    end)

    actionButton("Help", function()
        notify("Use the sidebar to open each module.")
    end)
end

-- Macro recorder: records menu actions, not game controls.
local function macroPage()
    newPage("Macro Recorder",
        "Records safe actions inside this menu only.")

    local macroName = textInput("Macro name", "MyMacro")
    local status = textLabel("Recording: OFF\nSaved macros: 0", 60)

    actionButton("Start recording", function()
        State.recording = true
        State.recordBuffer = {}
        notify("Macro recording started.")
        status.Text = "Recording: ON"
    end)

    actionButton("Record sample menu action", function()
        if State.recording then
            table.insert(State.recordBuffer, "show_stats")
            logEvent("Recorded menu action")
        else
            notify("Start recording first.")
        end
    end)

    actionButton("Stop and save", function()
        State.recording = false
        State.macros[macroName.Text] =
            table.clone(State.recordBuffer)

        status.Text = "Recording: OFF\nSaved: " ..
            macroName.Text .. "\nActions: " ..
            #State.recordBuffer

        notify("Menu macro saved for this session.")
    end)

    actionButton("List saved macros", function()
        local names = {}

        for name, _ in pairs(State.macros) do
            table.insert(names, name)
        end

        status.Text = "Macros:\n" ..
            (#names > 0 and table.concat(names, "\n")
                or "No macros saved")
    end)

    actionButton("Replay menu macro", function()
        local macro = State.macros[macroName.Text]

        if not macro then
            notify("Macro not found.")
            return
        end

        for _, action in ipairs(macro) do
            if action == "show_stats" then
                notify(getStats())
            end
        end
    end)
end

local function questPlanner()
    newPage("Quest Planner",
        "Organize objectives; nothing is auto-farmed.")

    local input = textInput("Enter mission or objective", State.quest)
    local current = textLabel("Current objective: " ..
        (State.quest ~= "" and State.quest or "None"), 65)

    actionButton("Save objective", function()
        State.quest = input.Text
        current.Text = "Current objective: " ..
            (State.quest ~= "" and State.quest or "None")
        logEvent("Quest objective updated")
    end)

    actionButton("Mark objective complete", function()
        if State.quest == "" then
            notify("No objective selected.")
            return
        end

        logEvent("Completed manually: " .. State.quest)
        State.quest = ""
        current.Text = "Current objective: None"
        notify("Objective marked complete.")
    end)
end

local FRUITS = {
    ["Rocket"] = "Common fruit. Consult the game for current details.",
    ["Spin"] = "Common fruit. Consult the game for current details.",
    ["Flame"] = "Elemental-themed fruit. Details may change.",
    ["Ice"] = "Ice-themed fruit. Details may change.",
    ["Light"] = "Light-themed fruit. Details may change.",
    ["Magma"] = "Magma-themed fruit. Details may change.",
    ["Buddha"] = "Transformation-themed fruit. Details may change.",
    ["Portal"] = "Mobility-themed fruit. Details may change.",
    ["Dragon"] = "Dragon-themed fruit. Details may change."
}

local function fruitEncyclopedia()
    newPage("Fruit Encyclopedia",
        "Reference information, not live inventory access.")

    local input = textInput("Search fruit name...")
    local results = textLabel("", 220)

    actionButton("Search encyclopedia", function()
        local query = input.Text:lower()
        local found = {}

        for name, description in pairs(FRUITS) do
            if query == "" or name:lower():find(query, 1, true) then
                table.insert(found, name .. ": " .. description)
            end
        end

        table.sort(found)
        results.Text = #found > 0 and table.concat(found, "\n\n")
            or "No matching entries."
    end)
end

local function mapExplorer()
    newPage("Map Explorer",
        "Displays your current local coordinates.")

    local coords = textLabel("Coordinates unavailable.", 90)

    actionButton("Refresh coordinates", function()
        local character = player.Character
        local root = character
            and character:FindFirstChild("HumanoidRootPart")

        if root then
            local p = root.Position
            coords.Text = string.format(
                "X: %.2f\nY: %.2f\nZ: %.2f",
                p.X, p.Y, p.Z
            )
        else
            coords.Text = "Character unavailable."
        end
    end)
end

local function eventLogPage()
    newPage("Event Log", "Recent local events.")

    local output = textLabel("", 240)

    actionButton("Refresh log", function()
        output.Text = #State.events > 0
            and table.concat(State.events, "\n")
            or "No events recorded."
    end)

    actionButton("Clear log", function()
        table.clear(State.events)
        output.Text = "Log cleared."
    end)
end

local function pluginManager()
    newPage("Plugin Manager",
        "Manage built-in modules; arbitrary code is not loaded.")

    local status = textLabel("", 100)

    actionButton("Register sample plugin", function()
        State.plugins["Example"] = {
            enabled = true,
            description = "Safe demonstration plugin"
        }

        logEvent("Example plugin registered")
        status.Text = "Example plugin: registered and enabled."
    end)

    actionButton("List plugins", function()
        local lines = {}

        for name, plugin in pairs(State.plugins) do
            table.insert(lines, name .. " | " ..
                plugin.description .. " | " ..
                (plugin.enabled and "ON" or "OFF"))
        end

        status.Text = #lines > 0 and table.concat(lines, "\n")
            or "No plugins registered."
    end)

    actionButton("Disable example plugin", function()
        if State.plugins["Example"] then
            State.plugins["Example"].enabled = false
            status.Text = "Example plugin disabled."
        end
    end)
end

local function profileManager()
    newPage("Profile Manager",
        "Save settings in memory during this session.")

    local input = textInput("Profile name", "Default")
    local status = textLabel("No profile selected.", 80)

    actionButton("Save profile", function()
        State.profiles[input.Text] = {
            notifications = State.notifications,
            compact = State.compact,
            highContrast = State.highContrast,
            fontScale = State.fontScale
        }

        status.Text = "Saved profile: " .. input.Text
        logEvent("Profile saved: " .. input.Text)
    end)

    actionButton("Load profile", function()
        local profile = State.profiles[input.Text]

        if not profile then
            notify("Profile not found.")
            return
        end

        State.notifications = profile.notifications
        State.compact = profile.compact
        State.highContrast = profile.highContrast
        State.fontScale = profile.fontScale

        status.Text = "Loaded: " .. input.Text ..
            "\nReopen pages to refresh styling."
        logEvent("Profile loaded: " .. input.Text)
    end)

    actionButton("List profiles", function()
        local names = {}

        for name in pairs(State.profiles) do
            table.insert(names, name)
        end

        status.Text = #names > 0 and table.concat(names, "\n")
            or "No saved profiles."
    end)
end

local function mobileHUD()
    newPage("Mobile HUD",
        "Touch-friendly shortcuts for the interface.")

    actionButton("Show player stats", function()
        notify(getStats())
    end)

    actionButton("Open quest planner", function()
        questPlanner()
    end)

    actionButton("Show current objective", function()
        notify(State.quest ~= "" and State.quest
            or "No active objective.")
    end)

    actionButton("Toggle compact mode", function()
        State.compact = not State.compact
        body.Size = State.compact
            and UDim2.new(1, -20, 1, -68)
            or UDim2.new(1, -20, 1, -68)
        notify("Compact mode: " ..
            (State.compact and "ON" or "OFF"))
    end)
end

local function accessibility()
    newPage("Accessibility",
        "Adjust interface preferences.")

    local status = textLabel("", 65)

    actionButton("Toggle high contrast", function()
        State.highContrast = not State.highContrast

        if State.highContrast then
            COLORS.PANEL = Color3.fromRGB(0, 0, 0)
            COLORS.CARD = Color3.fromRGB(45, 45, 45)
        else
            COLORS.PANEL = Color3.fromRGB(24
