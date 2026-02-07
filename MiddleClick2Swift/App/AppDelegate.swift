//
//  AppDelegate.swift
//  MiddleClick2
//
//  Application lifecycle and dependency management
//  Ported from Controller.m:72-131 and TrayMenu.m initialization
//

import Cocoa
import Foundation
import ApplicationServices
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    // MARK: - Properties
    private var multitouchManager: MultitouchManager!
    private var systemEventMonitor: SystemEventMonitor!
    private var deviceLifecycleManager: DeviceLifecycleManager!
    private var statusItem: NSStatusItem!
    private var accessibilityItem: NSMenuItem!
    private var launchAtLoginItem: NSMenuItem!
    private let launchAtLoginKey = "launchAtLogin"

    // MARK: - Application Lifecycle
    func applicationDidFinishLaunching(_ notification: Notification) {
        if !ensureSingleInstance() {
            Logger.error("Another instance is already running. Exiting.")
            NSApp.terminate(nil)
            return
        }

        Logger.info("MiddleClick2 v\(Constants.version) starting...")

        // Hide dock icon (background-only app)
        NSApp.setActivationPolicy(.accessory)

        // Initialize managers
        setupManagers()

        // Start multitouch monitoring
        startMultitouchMonitoring()

        // Start system event monitoring
        startSystemMonitoring()

        // Prompt for Accessibility if not yet granted
        requestAccessibilityIfNeeded()

        // Observe mode changes from UI
        observeModeChanges()

        // Setup menu bar icon
        setupMenuBar()

        Logger.info("MiddleClick2 initialized successfully")
    }

    func applicationWillTerminate(_ notification: Notification) {
        Logger.info("MiddleClick2 terminating...")
        cleanup()
    }

    // MARK: - Setup
    private func setupManagers() {
        multitouchManager = MultitouchManager()
        systemEventMonitor = SystemEventMonitor()
        deviceLifecycleManager = DeviceLifecycleManager(
            multitouchManager: multitouchManager
        )
    }

    private func startMultitouchMonitoring() {
        do {
            try multitouchManager.startMonitoring()
            Logger.info("Multitouch monitoring started successfully")
        } catch {
            Logger.error("Failed to start multitouch monitoring: \(error.localizedDescription)")
            showErrorAlert(error: error)
        }
    }

    private func startSystemMonitoring() {
        systemEventMonitor.onWake = { [weak self] in
            self?.deviceLifecycleManager.restartDevicesAfterWake()
        }
        systemEventMonitor.onScreenUnlock = { [weak self] in
            self?.deviceLifecycleManager.restartDevicesAfterWake()
        }
        systemEventMonitor.startMonitoring()
    }

    private func observeModeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleModeChange),
            name: .clickModeChanged,
            object: nil
        )
    }

    @objc private func handleModeChange(_ notification: Notification) {
        if let mode = notification.object as? ClickMode {
            Logger.info("Click mode changed to: \(mode.displayName)")
            multitouchManager.setClickMode(mode)
        }
    }

    // MARK: - Error Handling
    private func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "MiddleClick2 Error"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }

    // MARK: - Cleanup
    private func cleanup() {
        multitouchManager.stopMonitoring()
        systemEventMonitor.stopMonitoring()
        deviceLifecycleManager.cancelPendingRestart()
    }

    // MARK: - Menu Bar Setup
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem.button else {
            Logger.error("Failed to create status item button")
            return
        }

        // Use SF Symbol for reliable display
        if let icon = NSImage(systemSymbolName: "computermouse.fill", accessibilityDescription: "MiddleClick2") {
            icon.isTemplate = true
            button.image = icon
            Logger.info("✅ Using SF Symbol mouse icon")
        } else if let icon = NSImage(systemSymbolName: "computermouse", accessibilityDescription: "MiddleClick2") {
            icon.isTemplate = true
            button.image = icon
            Logger.info("✅ Using SF Symbol mouse icon (outline)")
        } else {
            // Ultimate fallback: emoji
            button.title = "🖱️"
            Logger.info("Using emoji fallback")
        }

        button.toolTip = "MiddleClick2"

        // Create menu
        let menu = NSMenu()
        menu.delegate = self

        // Accessibility status (non-interactive)
        accessibilityItem = NSMenuItem(title: "Accessibility: Checking…", action: nil, keyEquivalent: "")
        accessibilityItem.isEnabled = false
        menu.addItem(accessibilityItem)
        menu.addItem(NSMenuItem.separator())

        // About item (fork)
        let aboutItem = NSMenuItem(
            title: "About MiddleClick2",
            action: #selector(openAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)

        launchAtLoginItem = NSMenuItem(
            title: "Launch at Login",
            action: #selector(toggleLaunchAtLogin),
            keyEquivalent: ""
        )
        launchAtLoginItem.target = self
        launchAtLoginItem.state = isLaunchAtLoginEnabled() ? .on : .off
        menu.addItem(launchAtLoginItem)

        menu.addItem(NSMenuItem.separator())

        // Mode submenu
        let modeItem = NSMenuItem(title: "Mode", action: nil, keyEquivalent: "")
        let modeMenu = NSMenu()

        let tapItem = NSMenuItem(
            title: "3 Finger Tap",
            action: #selector(setTapMode),
            keyEquivalent: ""
        )
        tapItem.target = self
        tapItem.state = .on

        let clickItem = NSMenuItem(
            title: "3 Finger Click",
            action: #selector(setClickMode),
            keyEquivalent: ""
        )
        clickItem.target = self

        modeMenu.addItem(tapItem)
        modeMenu.addItem(clickItem)
        modeItem.submenu = modeMenu
        menu.addItem(modeItem)

        menu.addItem(NSMenuItem.separator())

        // Quit item
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)

        statusItem.menu = menu

        Logger.info("Menu bar setup complete")
        updateAccessibilityStatus()
    }

    @objc private func openAbout() {
        if let url = URL(string: Constants.githubURL) {
            NSWorkspace.shared.open(url)
        }
    }

    private func requestAccessibilityIfNeeded() {
        guard !AXIsProcessTrusted() else { return }
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    @objc private func setTapMode() {
        multitouchManager.setClickMode(.tap)
        updateMenuCheckmarks()
    }

    @objc private func setClickMode() {
        multitouchManager.setClickMode(.hold)
        updateMenuCheckmarks()
    }

    private func updateMenuCheckmarks() {
        guard let menu = statusItem.menu else { return }

        // Find mode submenu items
        for item in menu.items {
            if let submenu = item.submenu {
                for subitem in submenu.items {
                    if subitem.title == "3 Finger Tap" {
                        subitem.state = multitouchManager.getClickMode() == .tap ? .on : .off
                    } else if subitem.title == "3 Finger Click" {
                        subitem.state = multitouchManager.getClickMode() == .hold ? .on : .off
                    }
                }
            }
        }
    }

    // MARK: - NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        updateAccessibilityStatus()
        launchAtLoginItem.state = isLaunchAtLoginEnabled() ? .on : .off
    }

    private func updateAccessibilityStatus() {
        let enabled = AXIsProcessTrusted()
        accessibilityItem.title = "Accessibility: \(enabled ? "Enabled" : "Disabled")"
    }

    // MARK: - Single Instance
    private func ensureSingleInstance() -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier else { return true }
        let running = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
        return running.count <= 1
    }

    // MARK: - Launch At Login
    private func isLaunchAtLoginEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: launchAtLoginKey)
    }

    @objc private func toggleLaunchAtLogin() {
        let newValue = !isLaunchAtLoginEnabled()
        setLaunchAtLoginEnabled(newValue)
        launchAtLoginItem.state = newValue ? .on : .off
    }

    private func setLaunchAtLoginEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            UserDefaults.standard.set(enabled, forKey: launchAtLoginKey)
        } catch {
            Logger.error("Failed to update launch-at-login: \(error.localizedDescription)")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
