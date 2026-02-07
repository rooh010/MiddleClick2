//
//  ClickEmulator.swift
//  MiddleClick2
//
//  Created by Modern Swift Rewrite
//

import CoreGraphics
import Foundation

final class ClickEmulator {
    func emulateMiddleClick(at location: CGPoint) {
        Logger.debug("Emulating middle click at \(location)")

        let mouseDown = CGEvent(
            mouseEventSource: nil,
            mouseType: .otherMouseDown,
            mouseCursorPosition: location,
            mouseButton: .center
        )

        let mouseUp = CGEvent(
            mouseEventSource: nil,
            mouseType: .otherMouseUp,
            mouseCursorPosition: location,
            mouseButton: .center
        )

        mouseDown?.post(tap: .cghidEventTap)
        mouseUp?.post(tap: .cghidEventTap)

        Logger.debug("Middle click emulated successfully")
    }

    func pressCmdKey() {
        Logger.debug("Pressing Cmd key")

        let keyDown = CGEvent(
            keyboardEventSource: nil,
            virtualKey: Constants.cmdKeyCode,
            keyDown: true
        )
        keyDown?.post(tap: .cghidEventTap)
    }

    func releaseCmdKey() {
        Logger.debug("Releasing Cmd key")

        let keyUp = CGEvent(
            keyboardEventSource: nil,
            virtualKey: Constants.cmdKeyCode,
            keyDown: false
        )
        keyUp?.post(tap: .cghidEventTap)
    }
}
