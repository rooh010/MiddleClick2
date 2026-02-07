//
//  DeviceLifecycleManager.swift
//  MiddleClick2
//
//  Manages device restart logic with improved reliability
//  Addresses auto-restart-after-wake issues from original implementation
//

import Foundation

final class DeviceLifecycleManager {
    private let multitouchManager: MultitouchManager
    private let restartDelay: TimeInterval
    private var restartWorkItem: DispatchWorkItem?
    private let queue = DispatchQueue(label: "com.middleclick2.devicelifecycle", qos: .userInitiated)

    init(
        multitouchManager: MultitouchManager,
        restartDelay: TimeInterval = Constants.restartDelay
    ) {
        self.multitouchManager = multitouchManager
        self.restartDelay = restartDelay
    }

    func restartDevicesAfterWake() {
        Logger.info("Scheduling device restart after \(restartDelay)s delay...")

        // Cancel any pending restart to avoid multiple restarts
        restartWorkItem?.cancel()

        // Create new work item for delayed restart
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            Logger.info("Performing scheduled device restart...")
            self.multitouchManager.restartDevices()
            Logger.info("Device restart completed")
        }

        restartWorkItem = workItem

        // Schedule delayed restart
        queue.asyncAfter(
            deadline: .now() + restartDelay,
            execute: workItem
        )

        Logger.info("Device restart scheduled successfully")
    }

    func cancelPendingRestart() {
        if restartWorkItem != nil {
            Logger.info("Cancelling pending device restart")
            restartWorkItem?.cancel()
            restartWorkItem = nil
        }
    }

    deinit {
        cancelPendingRestart()
    }
}
