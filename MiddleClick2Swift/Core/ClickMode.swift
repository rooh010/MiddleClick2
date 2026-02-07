//
//  ClickMode.swift
//  MiddleClick2
//
//  Created by Modern Swift Rewrite
//

import Foundation

enum ClickMode: String, Codable, CaseIterable {
    case tap    // Triple tap and release for middle click
    case hold   // Hold Cmd key while 3 fingers down

    var displayName: String {
        switch self {
        case .tap:
            return "3 Finger Tap"
        case .hold:
            return "3 Finger Click"
        }
    }
}
