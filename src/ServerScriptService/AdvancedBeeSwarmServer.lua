local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local BeeSwarmConfig = require(ReplicatedStorage:WaitForChild("BeeSwarmConfig"))
local ShopConfig = require(ReplicatedStorage:WaitForChild("ShopConfig"))
local QuestConfig = require(ReplicatedStorage:WaitForChild("QuestConfig"))
local InventoryModule = require(ReplicatedStorage:WaitForChild("InventoryModule"))

local function ensureFolder(parent, name)
    local folder = parent:FindFirstChild(name)
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = parent
    end
    return folder
end

local remotesFolder = ensureFolder(ReplicatedStorage, "BeeSwarmRemotes")

local collectRemote = remotesFolder:FindFirstChild("CollectPollen") or Instance.new("RemoteEvent", remotesFolder)
if not remotesFolder:FindFirstChild("CollectPollen") then collectRemote.Name = "CollectPollen" end

local upgradeRemote = remotesFolder:FindFirstChild("UpgradeBee") or Instance.new("RemoteEvent", remotesFolder)
if not remotesFolder:FindFirstChild("UpgradeBee") then upgradeRemote.Name = "UpgradeBee" end

local buyItemRemote = remotesFolder:FindFirstChild("BuyItem") or Instance.new("RemoteEvent", remotesFolder)
if not remotesFolder:FindFirstChild("BuyItem") then buyItemRemote.Name = "BuyItem" end

local useItemRemote = remotesFolder:FindFirstChild("UseItem") or Instance.new("RemoteEvent", remotesFolder)
if not remotesFolder:FindFirstChild("UseItem") then useItemRemote.Name = "UseItem" end

local getQuestsRemote = remotesFolder:FindFirstChild("GetQuests") or Instance.new("RemoteFunction", remotesFolder)
if not remotesFolder:FindFirstChild("GetQuests") then getQuestsRemote.Name = "GetQuests" end

local completeQuestRemote = remotesFolder:FindFirstChild("CompleteQuest") or Instance.new("RemoteEvent", remotesFolder)
if not remotesFolder:FindFirstChild("CompleteQuest") then completeQuestRemote.Name = "CompleteQuest" end

local playerData = {}
local activeFlowers = {}

local function makeLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local honey = Instance.new("IntValue")
    honey.Name = "Honey"
    honey.Value = BeeSwarmConfig.StartingHoney
    honey.Parent = leaderstats

    local pollen = Instance.new("IntValue")
    pollen.Name = "Pollen"
    pollen.Value = BeeSwarmConfig.StartingPollen
    pollen.Parent = leaderstats

    local beeLevel = Instance.new("IntValue")
    beeLevel.Name = "BeeLevel"
    beeLevel.Value = 1
    beeLevel.Parent = leaderstats

    local bees = Instance.new("IntValue")
    bees.Name = "Bees"
    bees.Value = 1
    bees.Parent = leaderstats

    return {Honey = honey, Pollen = pollen, BeeLevel = beeLevel, Bees = bees}
end

local function getPlayerData(player)
    if not playerData[player] then
        playerData[player] = {
            Leaderstats = makeLeaderstats(player),
            BeeLevel = 1,
            Bees = 1,
            Pollen = BeeSwarmConfig.StartingPollen,
            Honey = BeeSwarmConfig.StartingHoney,
            Inventory = InventoryModule:create(),
            Quests = {},
            UpgradesOwned = {},
            ProductionMultiplier = 1,
            CompletedQuests = {},
            FlowerTouches = 0,
            UpgradeCount = 0,
            HoneyMultiplier = 1,
            HoneyMultiplierEndTime = 0,
            PollenMultiplier = 1,
            PollenMultiplierEndTime = 0,
        }
        
        for _, quest in ipairs(QuestConfig.Quests) do
            playerData[player].Quests[quest.Id] = {
                id = quest.Id,
                name = quest.Name,
                description = quest.Description,
                requirement = quest.Requirement,
                type = quest.Type,
                reward = quest.Reward,
                progress = 0,
                completed = false,
            }
        end
    end
    return playerData[player]
end

local function createBeePet(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local beeModel = Instance.new("Model")
    beeModel.Name = player.Name .. "_BeePet"
    beeModel.Parent = Workspace

    local beeBody = Instance.new("Part")
    beeBody.Name = "BeeBody"
    beeBody.Size = Vector3.new(1.5, 1.2, 1.2)
    beeBody.Color = Color3.fromRGB(255, 215, 0)
    beeBody.Material = Enum.Material.SmoothPlastic
    beeBody.Shape = Enum.PartType.Cylinder
    beeBody.CanCollide = false
    beeBody.Anchored = false
    beeBody.Parent = beeModel

    local leftWing = Instance.new("Part")
    leftWing.Size = Vector3.new(0.5, 0.8, 1)
    leftWing.Color = Color3.fromRGB(255, 255, 255)
    leftWing.Material = Enum.Material.SmoothPlastic
    leftWing.CanCollide = false
    leftWing.Anchored = false
    leftWing.Parent = beeModel

    local rightWing = leftWing:Clone()
    rightWing.Parent = beeModel

    local weld1 = Instance.new("WeldConstraint")
    weld1.Part0 = beeBody
    weld1.Part1 = leftWing
    weld1.Parent = beeBody

    local weld2 = Instance.new("WeldConstraint")
    weld2.Part0 = beeBody
    weld2.Part1 = rightWing
    weld2.Parent = beeBody

    local rootWeld = Instance.new("WeldConstraint")
    rootWeld.Part0 = root
    rootWeld.Part1 = beeBody
    rootWeld.Parent = root

    local offset = BeeSwarmConfig.BeePetOffset
    local beeCFrame = CFrame.new(offset)
    beeBody.CFrame = root.CFrame * beeCFrame

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not player.Parent or not char.Parent or not root.Parent then
            connection:Disconnect()
            beeModel:Destroy()
            return
        end

        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local target = root.Position + Vector3.new(0, 4, 0) + root.CFrame.LookVector * 2
            local desiredAngle = tick() * 12
            beeBody.CFrame = CFrame.new(target) * CFrame.Angles(0, desiredAngle, 0)
        end
    end)

    beeModel.PrimaryPart = beeBody
    return beeModel
end

local function refreshBeePet(player)
    if playerData[player] and playerData[player].BeePet then
        playerData[player].BeePet:Destroy()
    end

    local beePet = createBeePet(player)
    playerData[player].BeePet = beePet
end

local function buildFlowerGarden()
    local garden = Workspace:FindFirstChild("BeeGarden")
    if not garden then
        garden = Instance.new("Folder")
        garden.Name = "BeeGarden"
        garden.Parent = Workspace
    end

    if #garden:GetChildren() > 0 then
        return
    end

    for i = 1, 24 do
        local flower = Instance.new("Part")
        flower.Name = "Flower"
        flower.Size = Vector3.new(2, 2, 2)
        flower.Shape = Enum.PartType.Cylinder
        flower.Material = Enum.Material.SmoothPlastic
        flower.Color = Color3.fromRGB(255, 255, 0)
        flower.CanCollide = false
        flower.Anchored = true
        flower.Parent = garden

        local stem = Instance.new("Part")
        stem.Name = "Stem"
        stem.Size = Vector3.new(0.4, 3, 0.4)
        stem.Color = Color3.fromRGB(40, 180, 90)
        stem.Material = Enum.Material.Grass
        stem.CanCollide = false
        stem.Anchored = true
        stem.Parent = garden

        local angle = (i / 24) * math.pi * 2
        local radius = 25 + (i % 5) * 7
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius

        flower.CFrame = CFrame.new(x, 1.5, z) * CFrame.Angles(0, 0, math.rad(90))
        stem.CFrame = CFrame.new(x, 1.5, z)

        flower:SetAttribute("FlowerActive", true)
        flower:SetAttribute("CooldownEnd", 0)
        activeFlowers[flower] = true

        flower.Touched:Connect(function(hit)
            local character = hit.Parent
            if not character then
                return
            end

            local player = Players:GetPlayerFromCharacter(character)
            if not player then
                return
            end

            if flower:GetAttribute("FlowerActive") == false then
                return
            end

            local data = getPlayerData(player)
            local leaderstats = data.Leaderstats
            local basePollen = BeeSwarmConfig.PollenPerFlower + (data.BeeLevel * 5) + (data.Bees * 2)
            local pollenMultiplier = data.PollenMultiplierEndTime > tick() and data.PollenMultiplier or 1
            local pollenGain = math.floor(basePollen * pollenMultiplier)
            local honeyMultiplier = data.HoneyMultiplierEndTime > tick() and data.HoneyMultiplier or 1
            local honeyGain = math.floor(pollenGain * BeeSwarmConfig.HoneyPerPollen * honeyMultiplier * data.ProductionMultiplier)

            leaderstats.Pollen.Value += pollenGain
            leaderstats.Honey.Value += honeyGain
            data.Pollen += pollenGain
            data.Honey += honeyGain
            data.FlowerTouches += 1

            flower:SetAttribute("FlowerActive", false)
            flower.Color = Color3.fromRGB(120, 120, 120)

            task.delay(BeeSwarmConfig.FlowerCooldown, function()
                if flower.Parent then
                    flower:SetAttribute("FlowerActive", true)
                    flower.Color = Color3.fromRGB(255, 255, 0)
                end
            end)
        end)
    end
end

local function awardNearestFlower(player)
    local character = player.Character
    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local nearestFlower = nil
    local nearestDistance = BeeSwarmConfig.CollectRange

    local garden = Workspace:FindFirstChild("BeeGarden")
    if not garden then
        return
    end

    for _, part in ipairs(garden:GetChildren()) do
        if part:IsA("Part") and part:GetAttribute("FlowerActive") == true then
            local distance = (part.Position - root.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestFlower = part
            end
        end
    end

    if not nearestFlower then
        return
    end

    local data = getPlayerData(player)
    local leaderstats = data.Leaderstats
    local basePollen = BeeSwarmConfig.PollenPerFlower + (data.BeeLevel * 5) + (data.Bees * 2)
    local pollenMultiplier = data.PollenMultiplierEndTime > tick() and data.PollenMultiplier or 1
    local pollenGain = math.floor(basePollen * pollenMultiplier)
    local honeyMultiplier = data.HoneyMultiplierEndTime > tick() and data.HoneyMultiplier or 1
    local honeyGain = math.floor(pollenGain * BeeSwarmConfig.HoneyPerPollen * honeyMultiplier * data.ProductionMultiplier)

    leaderstats.Pollen.Value += pollenGain
    leaderstats.Honey.Value += honeyGain
    data.Pollen += pollenGain
    data.Honey += honeyGain
    data.FlowerTouches += 1

    nearestFlower:SetAttribute("FlowerActive", false)
    nearestFlower.Color = Color3.fromRGB(120, 120, 120)

    task.delay(BeeSwarmConfig.FlowerCooldown, function()
        if nearestFlower.Parent then
            nearestFlower:SetAttribute("FlowerActive", true)
            nearestFlower.Color = Color3.fromRGB(255, 255, 0)
        end
    end)
end

local function upgradeBee(player)
    local data = getPlayerData(player)
    local leaderstats = data.Leaderstats
    local currentLevel = data.BeeLevel
    local cost = BeeSwarmConfig.UpgradeCosts[currentLevel] or BeeSwarmConfig.UpgradeCosts[#BeeSwarmConfig.UpgradeCosts]

    if leaderstats.Honey.Value < cost then
        return
    end

    leaderstats.Honey.Value -= cost
    data.Honey = leaderstats.Honey.Value
    data.BeeLevel += 1
    data.Bees += 1
    data.UpgradeCount += 1

    leaderstats.BeeLevel.Value = data.BeeLevel
    leaderstats.Bees.Value = data.Bees
end

local function buyItem(player, itemId)
    local data = getPlayerData(player)
    local leaderstats = data.Leaderstats
    local item = nil

    for _, shopItem in ipairs(ShopConfig.Items) do
        if shopItem.Id == itemId then
            item = shopItem
            break
        end
    end

    if not item then
        return false
    end

    if leaderstats.Honey.Value < item.Cost then
        return false
    end

    leaderstats.Honey.Value -= item.Cost
    data.Honey = leaderstats.Honey.Value

    if item.Type == "consumable" or item.Type == "building" then
        InventoryModule:addItem(data.Inventory, itemId, 1)
    elseif item.Type == "upgrade" then
        if not data.UpgradesOwned[itemId] then
            data.UpgradesOwned[itemId] = 0
        end
        data.UpgradesOwned[itemId] += 1

        if itemId == 1 then
            data.ProductionMultiplier += 0.05
        elseif itemId == 2 then
            -- Handled in pollen calculation
        elseif itemId == 6 then
            data.ProductionMultiplier += 0.25
        elseif itemId == 8 then
            -- Honey capacity upgrade
        end
    end

    return true
end

local function useItem(player, itemId)
    local data = getPlayerData(player)
    local item = InventoryModule:getItem(data.Inventory, itemId)

    if not item then
        return false
    end

    local shopItem = nil
    for _, si in ipairs(ShopConfig.Items) do
        if si.Id == itemId then
            shopItem = si
            break
        end
    end

    if not shopItem then
        return false
    end

    if itemId == 3 then -- Royal Jelly
        data.HoneyMultiplier = 2
        data.HoneyMultiplierEndTime = tick() + 300 -- 5 minutes
        InventoryModule:removeItem(data.Inventory, itemId, 1)
        return true
    elseif itemId == 5 then -- Flower Seed
        local garden = Workspace:FindFirstChild("BeeGarden")
        if garden then
            for i = 1, 5 do
                local flower = Instance.new("Part")
                flower.Name = "Flower"
                flower.Size = Vector3.new(2, 2, 2)
                flower.Shape = Enum.PartType.Cylinder
                flower.Material = Enum.Material.SmoothPlastic
                flower.Color = Color3.fromRGB(255, 200, 0)
                flower.CanCollide = false
                flower.Anchored = true
                flower.Parent = garden

                local stem = Instance.new("Part")
                stem.Name = "Stem"
                stem.Size = Vector3.new(0.4, 3, 0.4)
                stem.Color = Color3.fromRGB(40, 180, 90)
                stem.Material = Enum.Material.Grass
                stem.CanCollide = false
                stem.Anchored = true
                stem.Parent = garden

                local angle = math.random() * math.pi * 2
                local radius = 35 + math.random(10)
                local x = math.cos(angle) * radius
                local z = math.sin(angle) * radius

                flower.CFrame = CFrame.new(x, 1.5, z) * CFrame.Angles(0, 0, math.rad(90))
                stem.CFrame = CFrame.new(x, 1.5, z)

                flower:SetAttribute("FlowerActive", true)
                flower:SetAttribute("CooldownEnd", 0)

                flower.Touched:Connect(function(hit)
                    local character = hit.Parent
                    if not character then
                        return
                    end

                    local hitPlayer = Players:GetPlayerFromCharacter(character)
                    if not hitPlayer then
                        return
                    end

                    if flower:GetAttribute("FlowerActive") == false then
                        return
                    end

                    local hitData = getPlayerData(hitPlayer)
                    local hitLeaderstats = hitData.Leaderstats
                    local basePollen = BeeSwarmConfig.PollenPerFlower + (hitData.BeeLevel * 5) + (hitData.Bees * 2)
                    local pollenMultiplier = hitData.PollenMultiplierEndTime > tick() and hitData.PollenMultiplier or 1
                    local pollenGain = math.floor(basePollen * pollenMultiplier)
                    local honeyMultiplier = hitData.HoneyMultiplierEndTime > tick() and hitData.HoneyMultiplier or 1
                    local honeyGain = math.floor(pollenGain * BeeSwarmConfig.HoneyPerPollen * honeyMultiplier * hitData.ProductionMultiplier)

                    hitLeaderstats.Pollen.Value += pollenGain
                    hitLeaderstats.Honey.Value += honeyGain
                    hitData.Pollen += pollenGain
                    hitData.Honey += honeyGain
                    hitData.FlowerTouches += 1

                    flower:SetAttribute("FlowerActive", false)
                    flower.Color = Color3.fromRGB(120, 120, 120)

                    task.delay(BeeSwarmConfig.FlowerCooldown, function()
                        if flower.Parent then
                            flower:SetAttribute("FlowerActive", true)
                            flower.Color = Color3.fromRGB(255, 200, 0)
                        end
                    end)
                end)
            end
        end
        InventoryModule:removeItem(data.Inventory, itemId, 1)
        return true
    elseif itemId == 7 then -- Pollinator Boost
        data.PollenMultiplier = 3
        data.PollenMultiplierEndTime = tick() + 120 -- 2 minutes
        InventoryModule:removeItem(data.Inventory, itemId, 1)
        return true
    end

    return false
end

collectRemote.OnServerEvent:Connect(function(player)
    awardNearestFlower(player)
end)

upgradeRemote.OnServerEvent:Connect(function(player)
    upgradeBee(player)
end)

buyItemRemote.OnServerEvent:Connect(function(player, itemId)
    buyItem(player, itemId)
end)

useItemRemote.OnServerEvent:Connect(function(player, itemId)
    useItem(player, itemId)
end)

getQuestsRemote.OnServerInvoke = function(player)
    local data = getPlayerData(player)
    return data.Quests
end

completeQuestRemote.OnServerEvent:Connect(function(player, questId)
    local data = getPlayerData(player)
    if data.Quests[questId] and not data.Quests[questId].completed then
        local quest = data.Quests[questId]
        if quest.progress >= quest.requirement then
            quest.completed = true
            data.Leaderstats.Honey.Value += quest.reward
            data.Honey += quest.reward
            table.insert(data.CompletedQuests, questId)
        end
    end
end)

local function updateQuestProgress(player)
    local data = getPlayerData(player)
    if not data.Quests then return end

    for questId, quest in pairs(data.Quests) do
        if not quest.completed then
            if quest.type == "pollen" then
                quest.progress = data.Pollen
            elseif quest.type == "honey" then
                quest.progress = data.Honey
            elseif quest.type == "upgrades" then
                quest.progress = data.UpgradeCount
            elseif quest.type == "flower_touches" then
                quest.progress = data.FlowerTouches
            elseif quest.type == "bee_level" then
                quest.progress = data.BeeLevel
            elseif quest.type == "bee_count" then
                quest.progress = data.Bees
            end
        end
    end
end

local function onPlayerAdded(player)
    getPlayerData(player)

    player.CharacterAdded:Connect(function()
        task.delay(0.5, function()
            refreshBeePet(player)
        end)
    end)

    if player.Character then
        task.delay(0.5, function()
            refreshBeePet(player)
        end)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

RunService.Heartbeat:Connect(function()
    for player, data in pairs(playerData) do
        if player.Parent then
            updateQuestProgress(player)
        else
            playerData[player] = nil
        end
    end
end)

buildFlowerGarden()
