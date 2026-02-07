# MiddleClick2 Swift Setup Guide

This guide walks you through setting up the Xcode project for the modern Swift rewrite.

## Quick Start

### Option 1: Create New Xcode Project (Recommended)

1. **Open Xcode and Create New Project**
   ```
   File → New → Project...
   ```

2. **Select Template**
   - Platform: **macOS**
   - Template: **App**
   - Click **Next**

3. **Configure Project**
   - Product Name: **MiddleClick2**
   - Team: (Select your team)
   - Organization Identifier: **com.middleclick2**
   - Bundle Identifier: **com.middleclick2.app** (auto-generated)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Click **Next**

4. **Choose Location**
   - Save in: `/Users/andy/repos/MiddleClick2`
   - Uncheck "Create Git repository" (already exists)
   - Click **Create**

5. **Clean Up Generated Files**
   ```
   Delete these auto-generated files (select and press Delete):
   - ContentView.swift
   - MiddleClick2App.swift (we'll replace it)
   - Assets.xcassets (we'll replace it)
   ```

6. **Add Source Files to Project**

   In Xcode:
   ```
   Right-click on MiddleClick2 group → Add Files to "MiddleClick2"...
   Navigate to: /Users/andy/repos/MiddleClick2/MiddleClick2Swift/
   ```

   Select these folders/files (⌘-click to multi-select):
   - App/ folder
   - Core/ folder
   - Bridges/ folder
   - Services/ folder
   - UI/ folder
   - Utilities/ folder
   - Resources/ folder

   Options:
   - ☑ Create groups
   - ☑ Add to targets: MiddleClick2
   - Click **Add**

7. **Configure Bridging Header**

   a. Select project in Navigator (top blue icon)
   b. Select "MiddleClick2" target
   c. Build Settings tab
   d. Search for "bridging"
   e. Double-click "Objective-C Bridging Header"
   f. Enter: `Bridges/MultitouchSupport.h`

8. **Add Framework Search Paths**

   Still in Build Settings:
   a. Search for "framework search"
   b. Double-click "Framework Search Paths"
   c. Click **+** button
   d. Enter: `/System/Library/PrivateFrameworks`
   e. Press Enter

9. **Add Other Linker Flags**

   Still in Build Settings:
   a. Search for "other linker"
   b. Double-click "Other Linker Flags"
   c. Click **+** button
   d. Enter: `-framework`
   e. Click **+** again
   f. Enter: `MultitouchSupport`

10. **Link Frameworks**

    a. Select "MiddleClick2" target
    b. Go to "General" tab
    c. Scroll to "Frameworks and Libraries"
    d. Click **+** button
    e. Add these frameworks:
       - CoreGraphics.framework
       - ApplicationServices.framework
       - IOKit.framework

    Note: MultitouchSupport.framework won't appear in the list because it's private.
    That's okay - we linked it via "Other Linker Flags".

11. **Configure Entitlements**

    a. Select "MiddleClick2" target
    b. Go to "Signing & Capabilities" tab
    c. Look for "Code Signing Entitlements" field
    d. Enter: `Resources/MiddleClick2.entitlements`

12. **Set Deployment Target**

    a. Select "MiddleClick2" target
    b. Go to "General" tab
    c. Under "Minimum Deployments"
    d. Set "macOS" to: **13.0**

13. **Configure Info.plist**

    a. Select "MiddleClick2" target
    b. Go to "Info" tab
    c. Check that these keys exist (add if missing):
       - `LSBackgroundOnly`: YES (Boolean)
       - `NSHighResolutionCapable`: YES (Boolean)
       - `LSApplicationCategoryType`: public.app-category.utilities

14. **Update App Icon (Optional)**

    a. Open `Assets.xcassets` (create if it doesn't exist)
    b. Right-click → New App Icon
    c. Drag the `mouse.png` from the old project into the icon set

15. **Build and Run**

    Press ⌘R or click the Play button

    The app should:
    - Build without errors
    - Appear in the menu bar (look for mouse icon top-right)
    - Not appear in the Dock (LSBackgroundOnly = true)

## Verification Steps

### 1. Check Build Output
```
No errors or warnings (some warnings about private framework are okay)
```

### 2. Check Menu Bar
```
Mouse icon should appear in menu bar
Click it to see menu with:
- About MiddleClick2
- Mode picker (3 Finger Tap / 3 Finger Click)
- Quit
```

### 3. Test Functionality
```
1. Open a browser
2. Three-finger tap on a link
3. Verify middle-click behavior (link opens in new tab)
```

### 4. Check Logs
```
Open Console.app
Filter: subsystem:com.middleclick2.app
You should see:
- "MiddleClick2 v2.0.0 starting..."
- "Found X multitouch device(s)"
- "Multitouch monitoring started successfully"
```

## Troubleshooting

### Issue: "Cannot find 'Finger' in scope"

**Cause**: Bridging header not configured correctly

**Solution**:
1. Check bridging header path in Build Settings
2. Make sure it's: `Bridges/MultitouchSupport.h`
3. Check that the file exists at that path
4. Clean build folder (⌘⇧K) and rebuild

### Issue: "Undefined symbol: _MTDeviceCreateList"

**Cause**: MultitouchSupport.framework not linked

**Solution**:
1. Check "Other Linker Flags" in Build Settings
2. Should have: `-framework MultitouchSupport`
3. Check "Framework Search Paths" includes: `/System/Library/PrivateFrameworks`

### Issue: "Cannot find 'Logger' in scope"

**Cause**: Files not added to target properly

**Solution**:
1. Select each .swift file in Navigator
2. Check "Target Membership" in File Inspector (right sidebar)
3. Ensure "MiddleClick2" is checked

### Issue: App builds but menu bar icon doesn't appear

**Cause**: SwiftUI app structure issue

**Solution**:
1. Check that MiddleClick2App.swift has `@main` attribute
2. Check that Info.plist doesn't have custom `NSPrincipalClass`
3. Check deployment target is macOS 13.0+

### Issue: "No multitouch devices found" error

**Cause**: Private framework access issue or permissions

**Solution**:
1. Check System Settings → Privacy & Security → Accessibility
2. Add MiddleClick2.app to allowed apps
3. Ensure entitlements file is configured correctly
4. Try running with SIP partially disabled (for development)

## Advanced Configuration

### Disable Library Validation (Required for Private Frameworks)

Already configured in `MiddleClick2.entitlements`:
```xml
<key>com.apple.security.cs.disable-library-validation</key>
<true/>
```

### Disable App Sandbox

Already configured in `MiddleClick2.entitlements`:
```xml
<key>com.apple.security.app-sandbox</key>
<false/>
```

### Enable Hardened Runtime

1. Select target → Signing & Capabilities
2. Click **+ Capability**
3. Add "Hardened Runtime"
4. Under Hardened Runtime, enable:
   - ☑ Disable Library Validation

## Next Steps

1. **Test thoroughly** on your MacBook
2. **Fix any issues** that come up
3. **Remove old Objective-C code** once Swift version works
4. **Update main README** with new architecture
5. **Create release build** for distribution

## File Checklist

Ensure these files are in your Xcode project:

```
✓ App/MiddleClick2App.swift
✓ App/AppDelegate.swift
✓ App/Info.plist
✓ Core/ClickMode.swift
✓ Core/GestureDetector.swift
✓ Core/ClickEmulator.swift
✓ Core/MultitouchManager.swift
✓ Bridges/MultitouchSupport.h
✓ Bridges/MultitouchTypes.swift
✓ Bridges/CoreGraphicsExtensions.swift
✓ Services/SystemEventMonitor.swift
✓ Services/DeviceLifecycleManager.swift
✓ UI/MenuBarView.swift
✓ Utilities/Logger.swift
✓ Utilities/Constants.swift
✓ Resources/MiddleClick2.entitlements
```

## Build Settings Quick Reference

| Setting | Value |
|---------|-------|
| Deployment Target | macOS 13.0 |
| Swift Language Version | Swift 5 |
| Objective-C Bridging Header | `Bridges/MultitouchSupport.h` |
| Framework Search Paths | `/System/Library/PrivateFrameworks` |
| Other Linker Flags | `-framework MultitouchSupport` |
| Code Signing Entitlements | `Resources/MiddleClick2.entitlements` |

## Support

If you encounter issues not covered here:

1. Check Console.app logs (filter: `subsystem:com.middleclick2.app`)
2. Enable debug logging in Logger.swift
3. Check Xcode build logs for specific errors
4. Verify all files are added to target (File Inspector → Target Membership)

Good luck! 🚀
