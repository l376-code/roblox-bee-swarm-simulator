local BeeSwarmConfig = {
    FlowerCooldown = 3,
    PollenPerFlower = 12,
    HoneyPerPollen = 1,
    StartingHoney = 0,
    StartingPollen = 0,
    UpgradeCosts = {
        [1] = 25,
        [2] = 80,
        [3] = 170,
        [4] = 300,
        [5] = 500,
        [6] = 750,
        [7] = 1000,
        [8] = 1500,
        [9] = 2200,
        [10] = 3200,
    },
    BeePetOffset = Vector3.new(0, 4, 0),
    CollectRange = 20,
    WorldSize = 140,
}

return BeeSwarmConfig
