//
//  GestureDetector.swift
//  MiddleClick2
//
//  Created by Modern Swift Rewrite
//  Ported from Controller.m:166-283
//

import Foundation
import CoreGraphics

enum Gesture {
    case threeFingerTap(location: CGPoint)
    case threeFingerPress
    case threeFingerRelease
}

final class GestureDetector {
    // MARK: - Properties
    private(set) var mode: ClickMode = .tap
    var onGestureRecognized: ((Gesture) -> Void)?

    // State tracking for tap mode
    private var touchStartTime: Date?
    private var initialPosition: CGPoint = .zero
    private var currentPosition: CGPoint = .zero
    private var maybeMiddleClick: Bool = false

    // State tracking for hold mode
    private var isPressed: Bool = false

    // MARK: - Public API
    func processFingers(_ fingers: [Finger], count: Int) {
        switch mode {
        case .tap:
            processTapMode(fingers: fingers, count: count)
        case .hold:
            processHoldMode(count: count)
        }
    }

    func setMode(_ mode: ClickMode) {
        Logger.info("Changing click mode to: \(mode.displayName)")
        self.mode = mode
        resetState()
    }

    // MARK: - Tap Mode Processing
    private func processTapMode(fingers: [Finger], count: Int) {
        switch count {
        case 0:
            handleTouchEnd()

        case 3:
            if touchStartTime == nil {
                startTracking()
            }
            handleThreeFingers(fingers)
            checkGestureTimeout()

        case let n where n > 3:
            cancelGesture()

        default:
            if touchStartTime == nil {
                startTracking()
            } else {
                checkGestureTimeout()
            }
        }
    }

    private func handleTouchEnd() {
        defer { resetState() }

        guard initialPosition != .zero else { return }

        let deltaX = abs(initialPosition.x - currentPosition.x)
        let deltaY = abs(initialPosition.y - currentPosition.y)
        let delta = Float(deltaX + deltaY)

        if delta < Constants.maxMovementThreshold {
            // Get current cursor location using CGEvent
            if let event = CGEvent(source: nil) {
                let cursorLocation = event.location
                Logger.debug("Three-finger tap detected, emitting gesture at \(cursorLocation)")
                onGestureRecognized?(.threeFingerTap(location: cursorLocation))
            }
        } else {
            Logger.debug("Gesture cancelled: movement delta \(delta) exceeds threshold")
        }
    }

    private func handleThreeFingers(_ fingers: [Finger]) {
        guard fingers.count >= 3 else { return }

        let sumX = fingers[0].normalized.pos.x +
                  fingers[1].normalized.pos.x +
                  fingers[2].normalized.pos.x
        let sumY = fingers[0].normalized.pos.y +
                  fingers[1].normalized.pos.y +
                  fingers[2].normalized.pos.y

        if maybeMiddleClick {
            // First detection of 3 fingers - save initial position
            initialPosition = CGPoint(x: CGFloat(sumX), y: CGFloat(sumY))
            currentPosition = initialPosition
            maybeMiddleClick = false
            Logger.debug("Three fingers detected, tracking position")
        } else {
            // Update current position for movement tracking
            currentPosition = CGPoint(x: CGFloat(sumX), y: CGFloat(sumY))
        }
    }

    // MARK: - Hold Mode Processing
    private func processHoldMode(count: Int) {
        if count == 3 && !isPressed {
            isPressed = true
            Logger.debug("Three fingers pressed, emitting press gesture")
            onGestureRecognized?(.threeFingerPress)
        } else if count == 0 && isPressed {
            isPressed = false
            Logger.debug("Fingers released, emitting release gesture")
            onGestureRecognized?(.threeFingerRelease)
        }
    }

    // MARK: - State Management
    private func startTracking() {
        touchStartTime = Date()
        maybeMiddleClick = true
        initialPosition = .zero
    }

    private func checkGestureTimeout() {
        guard maybeMiddleClick,
              let startTime = touchStartTime,
              Date().timeIntervalSince(startTime) > Constants.maxGestureDuration else {
            return
        }
        Logger.debug("Gesture timeout exceeded, cancelling")
        maybeMiddleClick = false
    }

    private func cancelGesture() {
        Logger.debug("Gesture cancelled: too many fingers")
        maybeMiddleClick = false
        initialPosition = .zero
        currentPosition = .zero
    }

    private func resetState() {
        touchStartTime = nil
        initialPosition = .zero
        currentPosition = .zero
        maybeMiddleClick = false
    }
}
