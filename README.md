# screen-brightness-cli
Change the brightness of all panels (monitors) of a X11 screen using DDC or xrandr brightness trick to get over 100% brightnesses

# Brightness Control Script

This script adjusts the brightness of all connected screens to the same value. It allows users to increase, decrease, or set a specific brightness level using simple commands. 

## Author
- **Allan Laal**
- **Email:** allan@laal.ee
- **Repository:** [https://github.org/allanlaal/brightness](https://github.org/allanlaal/brightness)

## Requirements

- **ddcutil**: For controlling brightness on supported displays.
- **xrandr**: For controlling brightness on unsupported displays via a software method.

## Features

- Adjust brightness for all screens to the same level.
- Supports commands:
  - `up`: Increase brightness by 10%.
  - `down`: Decrease brightness by 10%.
  - `+X`: Increase brightness by X%.
  - `-X`: Decrease brightness by X%.
  - `[number]%`: Set brightness to the specified percentage.
- Uses `ddcutil` for hardware-level brightness control (preferred).
- Falls back to `xrandr` for software-level brightness control if necessary.

## Usage

Run the script with one of the following arguments:

```bash
./brightness.sh <command>
```

### Available Commands

1. **up**: Increases brightness by 10%.
   ```bash
   ./brightness.sh up
   ```

2. **down**: Decreases brightness by 10%.
   ```bash
   ./brightness.sh down
   ```

3. **+X / -X**: Increases or decreases brightness by X%.
   ```bash
   ./brightness.sh +20    # Increases brightness by 20%
   ./brightness.sh -15    # Decreases brightness by 15%
   ```

4. **[number]%**: Sets brightness to the specified percentage.
   ```bash
   ./brightness.sh 70%    # Sets brightness to 70%
   ```

### Display Current Brightness

Simply run the script with no arguments to display the current brightness of the screens.

```bash
./brightness.sh
```
