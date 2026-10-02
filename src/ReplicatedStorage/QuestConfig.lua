local QuestConfig = {
    Quests = {
        {Id = 1, Name = "First Flight", Description = "Collect 100 pollen", Requirement = 100, Type = "pollen", Reward = 50},
        {Id = 2, Name = "Sweet Success", Description = "Earn 200 honey", Requirement = 200, Type = "honey", Reward = 75},
        {Id = 3, Name = "Bee Commander", Description = "Upgrade bees 5 times", Requirement = 5, Type = "upgrades", Reward = 150},
        {Id = 4, Name = "Flower Power", Description = "Collect from 50 flowers", Requirement = 50, Type = "flower_touches", Reward = 100},
        {Id = 5, Name = "Hive Master", Description = "Reach bee level 10", Requirement = 10, Type = "bee_level", Reward = 300},
        {Id = 6, Name = "Golden Touch", Description = "Earn 1000 honey", Requirement = 1000, Type = "honey", Reward = 200},
        {Id = 7, Name = "Swarm Leader", Description = "Have 20 bees", Requirement = 20, Type = "bee_count", Reward = 250},
        {Id = 8, Name = "Ultimate Beekeeper", Description = "Reach bee level 25", Requirement = 25, Type = "bee_level", Reward = 500},
    }
}

return QuestConfig
