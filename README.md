# Flight Skills

Flight Skills is a XP / Skill system resource that enables you to add a progression system to your server.

## Features

- Server Sided Exports for adding, setting, checking and removing
- Client Sided Exports for checking
- Decay system (lose xp with time)
- Hidden skills (hide skills from the menu)
- Custom levels / skill

## Installation

1. Download the latest release of Flight Skills from the [GitHub repository](https://github.com/elajnabe/flight-skills).
2. Extract the downloaded ZIP file.
3. Copy the `flight-skills` folder into your FiveM server's `resources` directory.
4. Add `start flight-skills` to your server.cfg file.
5. Restart your FiveM server.

## Configuration

Flight Skills can be customized by modifying the `config.lua` file located in the `flight-skills` resource folder. This file allows you to adjust various settings such as adding more skills, removing default ones, adjusting their levels, labels, icons and more..

## Usage

### Client Side Exports

```lua

-- Get the skill value for a specific skill
local skillValue = exports['flight-skills']:getSkill(skill)
-- example:
local skillValue = exports['flight-skills']:getSkill("fishing")
print(skillValue.xp, skillValue.level)

-- Get the XP value for a specific skill
local xpValue = exports['flight-skills']:getXP(skill)
-- example:
local xpValue = exports['flight-skills']:getXP("fishing")
if xpValue then
    print("You can use this fishing rod.")
else
    print("You can't use this fishing rod.")
end

-- Get the level value for a specific skill
local levelValue = exports['flight-skills']:getLevel(skill)
-- example:
local levelValue = exports['flight-skills']:getLevel("fishing")
if levelValue >= 2 then
    print("You can fish here")
else
    print("You can't fish here")
end

-- Check if a player has a certain amount of XP for a specific skill
local hasXP = exports['flight-skills']:hasXP(skill, amount)
-- example:
local hasXP = exports['flight-skills']:getSkill("fishing", 100)
if hasXP then
    print("You can use this fishing rod.")
else
    print("You can't use this fishing rod.")
end

-- Check if a player has a certain level for a specific skill
local hasLevel = exports['flight-skills']:hasLevel(skill, amount)
-- example:
local hasLevel = exports['flight-skills']:getSkill("fishing", 2)
if hasLevel then
    print("You can fish here")
else
    print("You can't fish here")
end
```

### Server Side Exports

```lua
-- Get the skill value for a specific player and skill
local skillValue = exports['flight-skills']:getSkill(source, skill)
-- example:
local skillValue = exports['flight-skills']:getSkill(1, "fishing")
if xpValue > 2 then
    print("Fishing Level: " .. skillValue.level)
    print("Fishing XP: " .. skillValue.xp)
end

-- Get the XP value for a specific player and skill
local xpValue = exports['flight-skills']:getXP(source, skill)
-- example:
local xpValue = exports['flight-skills']:getXP(1, "fishing")
if xpValue > 2 then
    print("Fishing XP: " .. xpValue)
end

-- Get the level value for a specific player and skill
local levelValue = exports['flight-skills']:getLevel(source, skill)
-- example:
local levelValue = exports['flight-skills']:getLevel(1, "fishing")
if levelValue > 2 then
    print("Fishing Level: " .. levelValue)
end

-- Set the XP value for a specific player and skill
exports['flight-skills']:setXP(source, skill, amount)
-- example:
exports['flight-skills']:setXP(1, "fishing", 0)
-- Add XP to a specific player and skill
exports['flight-skills']:addXP(source, skill, amount)
-- example:
exports['flight-skills']:addXP(1, "fishing", 10)

-- Remove XP from a specific player and skill
exports['flight-skills']:removeXP(source, skill, amount)
-- example:
exports['flight-skills']:removeXP(1, "fishing", 5)
```

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue on the [GitHub repository](https://github.com/elajnabe/flight-skills/issues) or submit a pull request.

## License

Flight Skills is licensed under the MIT License. See the [LICENSE](https://github.com/elajnabe/flight-skills/blob/main/LICENSE) file for more details.
