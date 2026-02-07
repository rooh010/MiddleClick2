//
//  Constants.swift
//  MiddleClick2
//
//  Created by Modern Swift Rewrite
//

import Foundation
import CoreGraphics

enum Constants {
    // App Info
    static let appName = "MiddleClick2"
    static let version = "2.0.0"
    static let githubURL = "https://github.com/rooh010/MiddleClick2"

    // Gesture Detection
    static let maxGestureDuration: TimeInterval = 0.5
    static let maxMovementThreshold: Float = 0.4

    // Device Lifecycle
    static let restartDelay: TimeInterval = 0.5
    static let deviceStopDelay: TimeInterval = 0.1

    // Keyboard
    static let cmdKeyCode: CGKeyCode = 55
}
