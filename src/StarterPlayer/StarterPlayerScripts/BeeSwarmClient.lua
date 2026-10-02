local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotesFolder = ReplicatedStorage:WaitForChild("BeeSwarmRemotes")
local collectRemote = remotesFolder:WaitForChild("CollectPollen")
local upgradeRemote = remotesFolder:WaitForChild("UpgradeBee")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BeeSwarmHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Bee Swarm Simulator"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local details = {
    Honey = Instance.new("TextLabel"),
    Pollen = Instance.new("TextLabel"),
    BeeLevel = Instance.new("TextLabel"),
    Bees = Instance.new("TextLabel"),
}

local offsetY = 45
for order, label in ipairs({"Honey", "Pollen", "BeeLevel", "Bees"}) do
    local textLabel = details[label]
    textLabel.Size = UDim2.new(1, -20, 0, 24)
    textLabel.Position = UDim2.new(0, 10, 0, offsetY)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = label .. ": 0"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 16
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = mainFrame
    offsetY += 28
end

local collectButton = Instance.new("TextButton")
collectButton.Size = UDim2.new(0, 120, 0, 40)
collectButton.Position = UDim2.new(0, 10, 1, -50)
collectButton.Text = "Collect"
collectButton.Font = Enum.Font.GothamBold
collectButton.TextSize = 16
collectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collectButton.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
collectButton.Parent = mainFrame

local upgradeButton = Instance.new("TextButton")
upgradeButton.Size = UDim2.new(0, 120, 0, 40)
upgradeButton.Position = UDim2.new(1, -130, 1, -50)
upgradeButton.Text = "Upgrade"
upgradeButton.Font = Enum.Font.GothamBold
upgradeButton.TextSize = 16
upgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeButton.BackgroundColor3 = Color3.fromRGB(75, 120, 255)
upgradeButton.Parent = mainFrame

local collectCorner = Instance.new("UICorner")
collectCorner.CornerRadius = UDim.new(0, 10)
collectCorner.Parent = collectButton

local upgradeCorner = Instance.new("UICorner")
upgradeCorner.CornerRadius = UDim.new(0, 10)
upgradeCorner.Parent = upgradeButton

local function refreshStats()
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        return
    end

    for statName, label in pairs(details) do
        local statValue = leaderstats:FindFirstChild(statName)
        if statValue then
            label.Text = statName .. ": " .. tostring(statValue.Value)
        end
    end
end

refreshStats()

local leaderstats = player:FindFirstChild("leaderstats")
if leaderstats then
    leaderstats.ChildAdded:Connect(refreshStats)
    leaderstats.ChildChanged:Connect(refreshStats)
end

collectButton.MouseButton1Click:Connect(function()
    collectRemote:FireServer()
end)

upgradeButton.MouseButton1Click:Connect(function()
    upgradeRemote:FireServer()
end)

player.CharacterAdded:Connect(function()
    task.wait(0.2)
    refreshStats()
end)
