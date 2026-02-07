//
//  SystemEventMonitor.swift
//  MiddleClick2
//
//  Monitors system wake/sleep events
//  Ported from WakeObserver.m
//

import Foundation
import Cocoa

final class SystemEventMonitor {
    var onWake: (() -> Void)?

    private let notificationCenter = NSWorkspace.shared.notificationCenter

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

        Logger.info("System event monitoring started")
    }

    func stopMonitoring() {
        Logger.info("Stopping system event monitoring...")
        notificationCenter.removeObserver(self)
        Logger.info("System event monitoring stopped")
    }

    @objc private func handleWake(_ notification: Notification) {
        Logger.info("Wake notification received: \(notification.name.rawValue)")
        onWake?()
    }

    deinit {
        stopMonitoring()
    }
}
