//
//  MultitouchTypes.swift
//  MiddleClick2
//
//  Swift wrappers and utilities for C multitouch types
//

import Foundation
import CoreGraphics

// Swift-friendly wrapper for touch point data
struct TouchPoint {
    let position: CGPoint
    let velocity: CGPoint
    let size: Float
    let angle: Float
    let majorAxis: Float
    let minorAxis: Float

    init(from finger: Finger) {
        self.position = CGPoint(
            x: CGFloat(finger.normalized.pos.x),
            y: CGFloat(finger.normalized.pos.y)
        )
        self.velocity = CGPoint(
            x: CGFloat(finger.normalized.vel.x),
            y: CGFloat(finger.normalized.vel.y)
        )
        self.size = finger.size
        self.angle = finger.angle
        self.majorAxis = finger.majorAxis
        self.minorAxis = finger.minorAxis
    }
}

// Callback context for bridging C callbacks to Swift
final class MultitouchCallbackContext {
    static let shared = MultitouchCallbackContext()

    var gestureDetector: GestureDetector?

    private init() {}

    func handleCallback(
        fingerCount: Int,
        fingers: UnsafeMutablePointer<Finger>?,
        timestamp: Double
    ) {
        guard let fingers = fingers else { return }

        // Convert C array to Swift array
        let fingerArray = Array(UnsafeBufferPointer(start: fingers, count: fingerCount))

        // Process through gesture detector
        gestureDetector?.processFingers(fingerArray, count: fingerCount)
    }
}
