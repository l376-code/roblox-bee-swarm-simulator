local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotesFolder = ReplicatedStorage:WaitForChild("BeeSwarmRemotes")
local collectRemote = remotesFolder:WaitForChild("CollectPollen")
local upgradeRemote = remotesFolder:WaitForChild("UpgradeBee")
local buyItemRemote = remotesFolder:WaitForChild("BuyItem")
local useItemRemote = remotesFolder:WaitForChild("UseItem")
local getQuestsRemote = remotesFolder:WaitForChild("GetQuests")
local completeQuestRemote = remotesFolder:WaitForChild("CompleteQuest")

local ShopConfig = require(ReplicatedStorage:WaitForChild("ShopConfig"))

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BeeSwarmHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Stats Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
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
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = mainFrame
    offsetY += 28
end

local collectButton = Instance.new("TextButton")
collectButton.Size = UDim2.new(0, 100, 0, 35)
collectButton.Position = UDim2.new(0, 10, 1, -45)
collectButton.Text = "Collect"
collectButton.Font = Enum.Font.GothamBold
collectButton.TextSize = 14
collectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collectButton.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
collectButton.Parent = mainFrame

local upgradeButton = Instance.new("TextButton")
upgradeButton.Size = UDim2.new(0, 100, 0, 35)
upgradeButton.Position = UDim2.new(1, -110, 1, -45)
upgradeButton.Text = "Upgrade"
upgradeButton.Font = Enum.Font.GothamBold
upgradeButton.TextSize = 14
upgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeButton.BackgroundColor3 = Color3.fromRGB(75, 120, 255)
upgradeButton.Parent = mainFrame

local collectCorner = Instance.new("UICorner")
collectCorner.CornerRadius = UDim.new(0, 10)
collectCorner.Parent = collectButton

local upgradeCorner = Instance.new("UICorner")
upgradeCorner.CornerRadius = UDim.new(0, 10)
upgradeCorner.Parent = upgradeButton

-- Shop Frame
local shopFrame = Instance.new("Frame")
shopFrame.Size = UDim2.new(0, 400, 0, 500)
shopFrame.Position = UDim2.new(0, 360, 0, 20)
shopFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
shopFrame.BackgroundTransparency = 0.2
shopFrame.BorderSizePixel = 0
shopFrame.Parent = screenGui

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 14)
shopCorner.Parent = shopFrame

local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, -20, 0, 30)
shopTitle.Position = UDim2.new(0, 10, 0, 10)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "🛒 Shop"
shopTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
shopTitle.Font = Enum.Font.GothamBold
shopTitle.TextSize = 18
shopTitle.Parent = shopFrame

local shopScroll = Instance.new("ScrollingFrame")
shopScroll.Size = UDim2.new(1, -20, 1, -50)
shopScroll.Position = UDim2.new(0, 10, 0, 45)
shopScroll.BackgroundTransparency = 1
shopScroll.BorderSizePixel = 0
shopScroll.CanvasSize = UDim2.new(0, 0, 0, #ShopConfig.Items * 100)
shopScroll.Parent = shopFrame

local shopLayout = Instance.new("UIListLayout")
shopLayout.Padding = UDim.new(0, 10)
shopLayout.FillDirection = Enum.FillDirection.Vertical
shopLayout.SortOrder = Enum.SortOrder.LayoutOrder
shopLayout.Parent = shopScroll

for idx, shopItem in ipairs(ShopConfig.Items) do
    local itemBtn = Instance.new("TextButton")
    itemBtn.Size = UDim2.new(1, -20, 0, 80)
    itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    itemBtn.BorderSizePixel = 0
    itemBtn.Parent = shopScroll
    itemBtn.LayoutOrder = idx

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 10)
    itemCorner.Parent = itemBtn

    local itemName = Instance.new("TextLabel")
    itemName.Size = UDim2.new(1, -20, 0, 20)
    itemName.Position = UDim2.new(0, 10, 0, 5)
    itemName.BackgroundTransparency = 1
    itemName.Text = shopItem.Name .. " (" .. shopItem.Cost .. " 🍯)"
    itemName.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemName.Font = Enum.Font.GothamBold
    itemName.TextSize = 14
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.Parent = itemBtn

    local itemDesc = Instance.new("TextLabel")
    itemDesc.Size = UDim2.new(1, -20, 0, 30)
    itemDesc.Position = UDim2.new(0, 10, 0, 25)
    itemDesc.BackgroundTransparency = 1
    itemDesc.Text = shopItem.Description
    itemDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemDesc.Font = Enum.Font.Gotham
    itemDesc.TextSize = 12
    itemDesc.TextWrapped = true
    itemDesc.TextXAlignment = Enum.TextXAlignment.Left
    itemDesc.Parent = itemBtn

    local buyBtn = Instance.new("TextButton")
    buyBtn.Size = UDim2.new(0, 70, 0, 25)
    buyBtn.Position = UDim2.new(1, -80, 1, -30)
    buyBtn.Text = "Buy"
    buyBtn.Font = Enum.Font.GothamBold
    buyBtn.TextSize = 12
    buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    buyBtn.Parent = itemBtn

    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 8)
    buyCorner.Parent = buyBtn

    buyBtn.MouseButton1Click:Connect(function()
        buyItemRemote:FireServer(shopItem.Id)
    end)
end

-- Quests Frame
local questFrame = Instance.new("Frame")
questFrame.Size = UDim2.new(0, 350, 0, 500)
questFrame.Position = UDim2.new(1, -370, 0, 20)
questFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
questFrame.BackgroundTransparency = 0.2
questFrame.BorderSizePixel = 0
questFrame.Parent = screenGui

local questCorner = Instance.new("UICorner")
questCorner.CornerRadius = UDim.new(0, 14)
questCorner.Parent = questFrame

local questTitle = Instance.new("TextLabel")
questTitle.Size = UDim2.new(1, -20, 0, 30)
questTitle.Position = UDim2.new(0, 10, 0, 10)
questTitle.BackgroundTransparency = 1
questTitle.Text = "📋 Quests"
questTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
questTitle.Font = Enum.Font.GothamBold
questTitle.TextSize = 18
questTitle.Parent = questFrame

local questScroll = Instance.new("ScrollingFrame")
questScroll.Size = UDim2.new(1, -20, 1, -50)
questScroll.Position = UDim2.new(0, 10, 0, 45)
questScroll.BackgroundTransparency = 1
questScroll.BorderSizePixel = 0
questScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
questScroll.Parent = questFrame

local questLayout = Instance.new("UIListLayout")
questLayout.Padding = UDim.new(0, 10)
questLayout.FillDirection = Enum.FillDirection.Vertical
questLayout.SortOrder = Enum.SortOrder.LayoutOrder
questLayout.Parent = questScroll

local function refreshQuests()
    for _, child in ipairs(questScroll:GetChildren()) do
        if child:IsA("GuiObject") and child ~= questLayout then
            child:Destroy()
        end
    end

    local quests = getQuestsRemote:InvokeServer()
    if not quests then return end

    local layout_order = 1
    for questId, quest in pairs(quests) do
        local questBtn = Instance.new("TextButton")
        questBtn.Size = UDim2.new(1, -20, 0, 70)
        questBtn.BackgroundColor3 = quest.completed and Color3.fromRGB(50, 80, 50) or Color3.fromRGB(80, 60, 30)
        questBtn.BorderSizePixel = 0
        questBtn.Parent = questScroll
        questBtn.LayoutOrder = layout_order
        layout_order += 1

        local questBtnCorner = Instance.new("UICorner")
        questBtnCorner.CornerRadius = UDim.new(0, 10)
        questBtnCorner.Parent = questBtn

        local questName = Instance.new("TextLabel")
        questName.Size = UDim2.new(1, -20, 0, 20)
        questName.Position = UDim2.new(0, 10, 0, 5)
        questName.BackgroundTransparency = 1
        questName.Text = (quest.completed and "✓ " or "") .. quest.name .. " (+" .. quest.reward .. ")"
        questName.TextColor3 = Color3.fromRGB(255, 255, 255)
        questName.Font = Enum.Font.GothamBold
        questName.TextSize = 12
        questName.TextXAlignment = Enum.TextXAlignment.Left
        questName.Parent = questBtn

        local questDesc = Instance.new("TextLabel")
        questDesc.Size = UDim2.new(1, -20, 0, 25)
        questDesc.Position = UDim2.new(0, 10, 0, 25)
        questDesc.BackgroundTransparency = 1
        questDesc.Text = quest.description .. " (" .. quest.progress .. "/" .. quest.requirement .. ")"
        questDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        questDesc.Font = Enum.Font.Gotham
        questDesc.TextSize = 11
        questDesc.TextXAlignment = Enum.TextXAlignment.Left
        questDesc.Parent = questBtn

        if not quest.completed and quest.progress >= quest.requirement then
            local claimBtn = Instance.new("TextButton")
            claimBtn.Size = UDim2.new(0, 60, 0, 20)
            claimBtn.Position = UDim2.new(1, -70, 1, -25)
            claimBtn.Text = "Claim"
            claimBtn.Font = Enum.Font.GothamBold
            claimBtn.TextSize = 10
            claimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            claimBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
            claimBtn.Parent = questBtn

            local claimCorner = Instance.new("UICorner")
            claimCorner.CornerRadius = UDim.new(0, 6)
            claimCorner.Parent = claimBtn

            claimBtn.MouseButton1Click:Connect(function()
                completeQuestRemote:FireServer(questId)
                task.wait(0.5)
                refreshQuests()
            end)
        end
    end
end

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
refreshQuests()

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

while true do
    task.wait(2)
    refreshQuests()
end
