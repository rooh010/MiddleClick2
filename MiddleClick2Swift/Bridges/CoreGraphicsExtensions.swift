//
//  CoreGraphicsExtensions.swift
//  MiddleClick2
//
//  Extensions and utilities for CoreGraphics types
//

import Foundation
import CoreGraphics
import AppKit

extension NSPoint {
    var asCGPoint: CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
}

extension CGPoint {
    static var currentCursorLocation: CGPoint {
        if let event = CGEvent(source: nil) {
            return event.location
        }
        return .zero
    }
}
