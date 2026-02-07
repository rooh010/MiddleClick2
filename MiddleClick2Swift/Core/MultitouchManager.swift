//
//  MultitouchManager.swift
//  MiddleClick2
//
//  Device management and callback handling for multitouch input
//  Uses MultitouchBridge (Objective-C) for C callback compatibility
//

import Foundation
import CoreGraphics

enum MultitouchError: Error {
    case noDevicesFound
    case deviceStartFailed
    case callbackRegistrationFailed
    case frameworkNotAccessible

    var localizedDescription: String {
        switch self {
        case .noDevicesFound:
            return "No multitouch devices found"
        case .deviceStartFailed:
            return "Failed to start multitouch device"
        case .callbackRegistrationFailed:
            return "Failed to register multitouch callback"
        case .frameworkNotAccessible:
            return "MultitouchSupport framework is not accessible. This may be due to macOS security restrictions."
        }
    }
}

final class MultitouchManager {
    // MARK: - Properties
    private let bridge = MultitouchBridge.shared()!
    private let gestureDetector: GestureDetector
    private let clickEmulator: ClickEmulator

    // MARK: - Initialization
    init(
        gestureDetector: GestureDetector = GestureDetector(),
        clickEmulator: ClickEmulator = ClickEmulator()
    ) {
        self.gestureDetector = gestureDetector
        self.clickEmulator = clickEmulator
        setupGestureHandlers()
        setupCallbackObserver()
    }

    // MARK: - Public API
    func startMonitoring() throws {
        Logger.info("Starting multitouch monitoring...")

        guard bridge.startMonitoring() else {
            Logger.error("Failed to start multitouch monitoring")
            throw MultitouchError.noDevicesFound
        }

        Logger.info("Found \(bridge.deviceCount()) multitouch device(s)")
        Logger.info("Multitouch monitoring started successfully")
    }

    func stopMonitoring() {
        Logger.info("Stopping multitouch monitoring...")
        NotificationCenter.default.removeObserver(self, name: .MultitouchCallback, object: nil)
        bridge.stopMonitoring()
        Logger.info("Multitouch monitoring stopped")
    }

    func restartDevices() {
        Logger.info("Restarting multitouch devices...")
        bridge.restartDevices()
        Logger.info("Devices restarted successfully")
    }

    func setClickMode(_ mode: ClickMode) {
        gestureDetector.setMode(mode)
    }

    func getClickMode() -> ClickMode {
        return gestureDetector.mode
    }

    // MARK: - Private Methods
    private func setupGestureHandlers() {
        gestureDetector.onGestureRecognized = { [weak self] gesture in
            self?.handleGesture(gesture)
        }
    }

    private func setupCallbackObserver() {
        // Listen for touch events from the Objective-C bridge
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTouchNotification(_:)),
            name: .MultitouchCallback,
            object: nil
        )
    }

    @objc private func handleTouchNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let fingerCount = userInfo[MultitouchFingerCountKey] as? Int,
              let dataValue = userInfo[MultitouchFingerDataKey] as? NSValue else {
            return
        }

        let dataPtr = dataValue.pointerValue
        guard let fingers = dataPtr?.assumingMemoryBound(to: Finger.self) else {
            gestureDetector.processFingers([], count: fingerCount)
            return
        }

        let fingerArray = Array(UnsafeBufferPointer(start: fingers, count: fingerCount))
        gestureDetector.processFingers(fingerArray, count: fingerCount)
    }

    private func handleGesture(_ gesture: Gesture) {
        switch gesture {
        case .threeFingerTap(let location):
            clickEmulator.emulateMiddleClick(at: location)

        case .threeFingerPress:
            clickEmulator.pressCmdKey()

        case .threeFingerRelease:
            clickEmulator.releaseCmdKey()
        }
    }
}
