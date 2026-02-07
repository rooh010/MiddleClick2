//
//  SystemEventMonitor.swift
//  MiddleClick2
//
//  Monitors system wake/sleep and screen lock events
//  Ported from WakeObserver.m
//

import Foundation
import Cocoa

final class SystemEventMonitor {
    var onWake: (() -> Void)?
    var onScreenUnlock: (() -> Void)?

    private let notificationCenter = NSWorkspace.shared.notificationCenter
    private let distributedNotificationCenter = DistributedNotificationCenter.default()

    func startMonitoring() {
        Logger.info("Starting system event monitoring...")

        // Observe both wake notifications for reliability
        notificationCenter.addObserver(
            self,
            selector: #selector(handleWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(handleWake),
            name: NSWorkspace.screensDidWakeNotification,
            object: nil
        )

        // Observe screen unlock via distributed notification center
        // This fires when the screen is unlocked after being locked
        distributedNotificationCenter.addObserver(
            self,
            selector: #selector(handleScreenUnlock),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )

        Logger.info("System event monitoring started (wake + screen unlock)")
    }

    func stopMonitoring() {
        Logger.info("Stopping system event monitoring...")
        notificationCenter.removeObserver(self)
        distributedNotificationCenter.removeObserver(self)
        Logger.info("System event monitoring stopped")
    }

    @objc private func handleWake(_ notification: Notification) {
        Logger.info("Wake notification received: \(notification.name.rawValue)")
        onWake?()
    }

    @objc private func handleScreenUnlock(_ notification: Notification) {
        Logger.info("Screen unlock notification received: \(notification.name.rawValue)")
        onScreenUnlock?()
    }

    deinit {
        stopMonitoring()
    }
}
