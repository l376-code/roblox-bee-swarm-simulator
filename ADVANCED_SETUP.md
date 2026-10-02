# Advanced Bee Swarm Simulator - Setup Guide

This is the advanced version with shop, inventory, and quests systems.

## Setup Instructions

### 1. Create Modules in ReplicatedStorage

- **BeeSwarmConfig** (ModuleScript) - Paste from `src/ReplicatedStorage/BeeSwarmConfig.lua`
- **ShopConfig** (ModuleScript) - Paste from `src/ReplicatedStorage/ShopConfig.lua`
- **QuestConfig** (ModuleScript) - Paste from `src/ReplicatedStorage/QuestConfig.lua`
- **InventoryModule** (ModuleScript) - Paste from `src/ReplicatedStorage/InventoryModule.lua`

### 2. Create Remotes in ReplicatedStorage > BeeSwarmRemotes

The server will auto-create these, but you can pre-create them:
- `CollectPollen` (RemoteEvent)
- `UpgradeBee` (RemoteEvent)
- `BuyItem` (RemoteEvent)
- `UseItem` (RemoteEvent)
- `GetQuests` (RemoteFunction)
- `CompleteQuest` (RemoteEvent)

### 3. Create Server Script in ServerScriptService

- **AdvancedBeeSwarmServer** (Script) - Paste from `src/ServerScriptService/AdvancedBeeSwarmServer.lua`

### 4. Create Client Script in StarterPlayer > StarterPlayerScripts

- **AdvancedBeeSwarmClient** (LocalScript) - Paste from `src/StarterPlayer/StarterPlayerScripts/AdvancedBeeSwarmClient.lua`

### 5. Press Play!

## Features

### Shop System
- Buy upgrades to increase production
- Buy consumable items (Royal Jelly, Pollinator Boost)
- Buy building items (Bee House, Flower Seeds)
- Visual shop UI with item descriptions and costs

### Inventory
- Manage consumable and building items
- Use items for temporary bonuses or permanent effects
- Limited inventory slots (20 max)

### Quest System
- Complete objectives for bonus honey
- Track progress in real-time
- 8 different quest types
- Claim rewards when completed

### Item Effects
- **Royal Jelly**: 2x honey production for 5 minutes
- **Flower Seed**: Spawn 5 new flowers in the garden
- **Pollinator Boost**: 3x pollen for 2 minutes
- **Upgrades**: Permanent production bonuses

### Quests Available
1. First Flight - Collect 100 pollen (50 honey reward)
2. Sweet Success - Earn 200 honey (75 honey reward)
3. Bee Commander - Upgrade bees 5 times (150 honey reward)
4. Flower Power - Collect from 50 flowers (100 honey reward)
5. Hive Master - Reach bee level 10 (300 honey reward)
6. Golden Touch - Earn 1000 honey (200 honey reward)
7. Swarm Leader - Have 20 bees (250 honey reward)
8. Ultimate Beekeeper - Reach bee level 25 (500 honey reward)

## Customization

Edit config files to adjust:
- Shop items and prices
- Quest requirements and rewards
- Production multipliers
- Item effects and durations
- Flower spawn rates and counts

## Gameplay Tips

- Buy upgrades early to boost production
- Use Royal Jelly and Pollinator Boost for bursts of resources
- Plant Flower Seeds to increase collection points
- Track quests to earn passive bonuses
- Upgrade bees consistently for exponential growth
