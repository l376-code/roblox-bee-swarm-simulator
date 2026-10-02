# Bee Swarm Simulator - Roblox Studio Starter

This project is a lightweight Bee Swarm-inspired Roblox game prototype. It gives you:
- bees that follow the player
- flowers that generate pollen
- honey and pollen progression
- upgrade system
- simple GUI

## How to use in Roblox Studio
1. Open Roblox Studio.
2. Create a new empty place.
3. In ReplicatedStorage, insert a ModuleScript named `BeeSwarmConfig` and paste the contents from `src/ReplicatedStorage/BeeSwarmConfig.lua`.
4. In ServerScriptService, insert a Script named `BeeSwarmServer` and paste the code from `src/ServerScriptService/BeeSwarmServer.lua`.
5. In StarterPlayer > StarterPlayerScripts, insert a LocalScript named `BeeSwarmClient` and paste the code from `src/StarterPlayer/StarterPlayerScripts/BeeSwarmClient.lua`.
6. Press Play.

## Gameplay loop
- Walk up to flowers in the garden.
- Press the Collect button or touch flowers to gather pollen.
- Earn honey and upgrade your bees.
- Buy more bees and improve your bee level.

## Notes
This is a prototype, not a full clone of Bee Swarm Simulator. It is designed to be easy to expand and customize.
