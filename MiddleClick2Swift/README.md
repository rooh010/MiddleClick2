# MiddleClick2 - Modern Swift Implementation

A modern Swift rewrite of MiddleClick, bringing three-finger tap middle-click emulation to macOS with improved reliability and maintainability.

## Features

- **Three-Finger Tap**: Tap with three fingers to emulate middle-click
- **Three-Finger Click**: Hold three fingers to temporarily enable Cmd-click mode
- **Menu Bar Integration**: Modern SwiftUI MenuBarExtra interface
- **Reliable Wake Handling**: Improved device restart logic after system wake/sleep
- **Background Operation**: Runs as a menu bar app without dock icon

## Architecture

Built with modern Swift best practices:

- **Clean Architecture**: Separated Core, Services, UI, and Bridges layers
- **Type Safety**: Swift's type system eliminates entire classes of bugs
- **Memory Safety**: ARC replaces manual retain/release
- **Testable**: Protocol-oriented design with dependency injection
- **Modern UI**: SwiftUI MenuBarExtra for macOS 13+

## Project Structure

```
MiddleClick2Swift/
├── App/                    # Application lifecycle
│   ├── MiddleClick2App.swift
│   ├── AppDelegate.swift
│   └── Info.plist
├── Core/                   # Core business logic
│   ├── MultitouchManager.swift
│   ├── GestureDetector.swift
│   ├── ClickEmulator.swift
│   └── ClickMode.swift
├── Bridges/                # C interop
│   ├── MultitouchSupport.h
│   ├── MultitouchTypes.swift
│   └── CoreGraphicsExtensions.swift
├── Services/               # System services
│   ├── SystemEventMonitor.swift
│   └── DeviceLifecycleManager.swift
├── UI/                     # User interface
│   └── MenuBarView.swift
└── Utilities/              # Helpers
    ├── Logger.swift
    └── Constants.swift
```

## Building

### Prerequisites

- Xcode 15.0+
- macOS 13.0+ (Ventura or later)
- Swift 5.9+

### Setup Instructions

1. **Create New Xcode Project**:
   - Open Xcode
   - File → New → Project
   - Choose "macOS" → "App"
   - Product Name: MiddleClick2
   - Interface: SwiftUI
   - Language: Swift
   - Bundle Identifier: com.middleclick2.app

2. **Add Source Files**:
   - Delete the default ContentView.swift and other generated files
   - Add all files from this directory to the project
   - Maintain the folder structure (use groups)

3. **Configure Bridging Header**:
   - Build Settings → Swift Compiler - General
   - Objective-C Bridging Header: `MiddleClick2Swift/Bridges/MultitouchSupport.h`

4. **Configure Build Settings**:
   - Build Settings → Framework Search Paths: `/System/Library/PrivateFrameworks`
   - Build Settings → Other Linker Flags: `-framework MultitouchSupport`

5. **Link Frameworks**:
   - Target → General → Frameworks and Libraries
   - Add: `MultitouchSupport.framework` (manually link to `/System/Library/PrivateFrameworks/MultitouchSupport.framework`)
   - Add: `CoreGraphics.framework`
   - Add: `ApplicationServices.framework`
   - Add: `IOKit.framework`

6. **Configure Entitlements**:
   - File → New → File → Property List
   - Name: `MiddleClick2.entitlements`
   - Copy contents from `Resources/MiddleClick2.entitlements`
   - Target → Signing & Capabilities → Code Signing Entitlements: `MiddleClick2.entitlements`

7. **Set Deployment Target**:
   - Target → General → Deployment Info
   - macOS 13.0

8. **Set Info.plist**:
   - Use the Info.plist from `App/Info.plist`
   - Ensure LSBackgroundOnly is set to true

## Development

### Running the App

1. Build and run in Xcode (⌘R)
2. Check menu bar for the mouse icon
3. Try three-finger tap on trackpad
4. Check Console.app for logs with subsystem: `com.middleclick2.app`

### Testing

**Manual Tests**:
- Three-finger tap → middle-click (open link in new tab)
- Switch to "3 Finger Click" mode → Cmd key held while fingers down
- Put Mac to sleep and wake → verify multitouch still works
- Rapid wake/sleep cycles → verify no crashes

**Debug Logging**:
The app uses OSLog for structured logging. View logs in Console.app:
```
log stream --predicate 'subsystem == "com.middleclick2.app"' --level debug
```

### Troubleshooting

**Issue**: No multitouch devices found
- **Solution**: Check System Settings → Privacy & Security → Accessibility
- The app needs accessibility permissions to create CGEvents

**Issue**: Callbacks not firing
- **Solution**: Check that MultitouchSupport.framework is properly linked
- Verify bridging header path is correct

**Issue**: App doesn't appear in menu bar
- **Solution**: Check that LSBackgroundOnly is true in Info.plist
- Verify MenuBarExtra code is correct for macOS 13+

## Key Improvements Over Original

1. **Reliability**: Improved wake/sleep handling with cancellable delayed restarts
2. **Type Safety**: Swift eliminates pointer/memory bugs from C/Objective-C
3. **Maintainability**: Clean architecture with small, focused modules (150-250 lines each)
4. **Error Handling**: Proper Swift error propagation vs silent failures
5. **Modern UI**: SwiftUI MenuBarExtra vs manual NSStatusItem management
6. **Logging**: Structured OSLog vs scattered NSLog calls
7. **State Management**: Encapsulated state vs global variables
8. **Testability**: Protocol-oriented design enables unit testing

## Requirements

- macOS 13.0 (Ventura) or later
- MacBook with multitouch trackpad or Magic Mouse

## License

Same as original MiddleClick project.

## Credits

Modern Swift rewrite of [MiddleClick](https://github.com/cl3m/MiddleClick) by cl3m.

Core gesture detection algorithm ported from the original Objective-C implementation.
