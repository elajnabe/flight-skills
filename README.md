# Flight Skills

## Description

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

- `exports['flight-skills']:getSkill(skill)`
- `exports['flight-skills']:getXP(skill)`
- `exports['flight-skills']:getLevel(skill)`
- `exports['flight-skills']:hasXP(skill, amount)`
- `exports['flight-skills']:hasLevel(skill, amount)`

### Server Side Exports

- `exports['flight-skills']:getSkill(source, skill)`
- `exports['flight-skills']:getXP(source, skill)`
- `exports['flight-skills']:getLevel(source, skill)`
- `exports['flight-skills']:setXP(source, skill, amount)`
- `exports['flight-skills']:addXP(source, skill, amount)`
- `exports['flight-skills']:removeXP(source, skill, amount)`

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue on the [GitHub repository](https://github.com/elajnabe/flight-skills/issues) or submit a pull request.

## License

Flight Skills is licensed under the MIT License. See the [LICENSE](https://github.com/elajnabe/flight-skills/blob/main/LICENSE) file for more details.
