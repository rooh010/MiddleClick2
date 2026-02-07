# MiddleClick2

Modern Swift rewrite of MiddleClick - Three-finger tap middle-click emulation for macOS.

This repository is a fork of the original MiddleClick project. It focuses on modern macOS support,
Swift-based maintenance, and better reliability on current hardware.

## Features

- **Three-Finger Tap**: Tap with three fingers to emulate middle-click
- **Three-Finger Click**: Hold three fingers to enable Cmd-click mode
- **Menu Bar App**: Clean SwiftUI interface with mode selector
- **Reliable Wake Handling**: Improved device restart after sleep/wake
- **Background Operation**: Runs silently in the menu bar

## Requirements

- macOS 13.0 (Ventura) or later (updated for modern macOS releases)
- MacBook with multitouch trackpad or Magic Mouse
- Xcode 15.0+ (for building from source)

## Installation

### From Source

1. **Clone the repository**
   ```bash
   git clone https://github.com/rooh010/MiddleClick2.git
   cd MiddleClick2
   ```

2. **Open the project**
   ```bash
   open MiddleClick2.xcodeproj
   ```

3. **Build and run** (⌘R in Xcode)

4. **Grant permissions**
   - System Settings → Privacy & Security → Accessibility
   - Add MiddleClick2.app to allowed apps

### Pre-built Binary

Download from [Releases](https://github.com/rooh010/MiddleClick2/releases)

## Usage

1. **Launch the app** - Look for the mouse icon in your menu bar (top-right)
2. **Three-finger tap** on your trackpad while hovering over a link
3. **Link opens in new tab** - Just like middle-clicking with a mouse!

### Modes

- **3 Finger Tap** (default): Quick tap to middle-click
- **3 Finger Click**: Hold three fingers to temporarily enable Cmd-click

Switch modes via the menu bar icon.

## Architecture

Built with modern Swift best practices:

- **Clean Architecture**: Separated Core, Services, UI, and Bridges layers
- **Type Safety**: 100% Swift with proper error handling
- **Memory Safety**: ARC replaces manual retain/release
- **SwiftUI**: Modern menu bar integration with MenuBarExtra
- **Testable**: Protocol-oriented design with dependency injection

### Project Structure

```
MiddleClick2Swift/
├── App/                    # Application lifecycle
├── Core/                   # Business logic (gesture detection, click emulation)
├── Bridges/                # C interop for MultitouchSupport framework
├── Services/               # System services (wake monitoring, device lifecycle)
├── UI/                     # SwiftUI menu bar interface
└── Utilities/              # Logging and constants
```

## Building

```bash
# Build debug version
xcodebuild -project MiddleClick2.xcodeproj -scheme MiddleClick2 -configuration Debug -derivedDataPath build

# Build release version
xcodebuild -project MiddleClick2.xcodeproj -scheme MiddleClick2 -configuration Release -derivedDataPath build

# Run built app
open build/Build/Products/Debug/MiddleClick2.app
```

## Releasing

Releases are created by GitHub Actions when you push a version tag:

1. Tag the commit (use a `v` prefix):
   ```bash
   git tag v2.0.1
   git push origin v2.0.1
   ```
2. The workflow builds a **Release** app and uploads a zip to GitHub Releases.

## Development

### Requirements

- Xcode 15.0+
- macOS 13.0+ SDK
- Swift 5.9+

### Key Components

- **MultitouchManager**: Device enumeration and callback registration
- **GestureDetector**: State machine for gesture recognition
- **ClickEmulator**: CGEvent-based click simulation
- **DeviceLifecycleManager**: Improved wake/sleep handling

### Debugging

View logs in Console.app:
```bash
log show --predicate 'subsystem == "com.middleclick2.app"' --last 5m
```

## Improvements Over Original

| Aspect | Original (Objective-C) | MiddleClick2 (Swift) |
|--------|----------------------|---------------------|
| **Language** | Objective-C | Swift 5.9+ |
| **Memory** | Manual (retain/release) | ARC |
| **UI** | NSStatusItem | SwiftUI MenuBarExtra |
| **Architecture** | Monolithic | Clean layers |
| **Lines of Code** | ~440 (3 files) | ~900 (14 files) |
| **Error Handling** | Silent failures | Swift errors |
| **Logging** | NSLog | OSLog |
| **Testability** | None | Protocol-oriented |
| **Deployment** | macOS 10.6+ | macOS 13.0+ |
| **Wake Handling** | Basic | Improved with cancellation |

## Troubleshooting

### App doesn't work

1. **Grant Accessibility permissions**
   - System Settings → Privacy & Security → Accessibility
   - Add MiddleClick2.app

2. **Check logs**
   ```bash
   log show --predicate 'subsystem == "com.middleclick2.app"' --last 5m
   ```

3. **Restart the app**
   ```bash
   killall MiddleClick2
   open build/MiddleClick2.app
   ```

### No multitouch devices found

- Ensure you're on a MacBook with trackpad or have Magic Mouse connected
- Try restarting your Mac
- Check that MultitouchSupport framework is accessible

### Menu bar icon not visible

- Check that app is running: `ps aux | grep MiddleClick2`
- Verify macOS 13.0+ (MenuBarExtra requires Ventura or later)

## Credits

- **Original MiddleClick**: [cl3m/MiddleClick](https://github.com/cl3m/MiddleClick)
- **Modern Rewrite**: 2026
- **Multitouch API**: Based on [steike's multitouch code](http://www.steike.com/code/multitouch/)

## License

Same as original MiddleClick project.

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Version History

### 2.0.0 (2026-02-06)
- Complete Swift rewrite
- Modern SwiftUI menu bar interface
- Improved wake/sleep handling
- Clean architecture with separated concerns
- Type-safe error handling
- Structured logging

### 1.x (Original)
- Objective-C implementation
- Basic functionality

## Links

- [Original MiddleClick](https://github.com/cl3m/MiddleClick)
- [Issues](https://github.com/rooh010/MiddleClick2/issues)
- [Releases](https://github.com/rooh010/MiddleClick2/releases)
