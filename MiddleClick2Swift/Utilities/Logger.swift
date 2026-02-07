//
//  Logger.swift
//  MiddleClick2
//
//  Created by Modern Swift Rewrite
//

import Foundation
import os.log

enum Logger {
    private static let subsystem = "com.middleclick2.app"
    private static let logger = OSLog(subsystem: subsystem, category: "general")

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        os_log("%{public}@", log: logger, type: .info, formatMessage(message, file: file, function: function, line: line))
    }

    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        os_log("%{public}@", log: logger, type: .debug, formatMessage(message, file: file, function: function, line: line))
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        os_log("%{public}@", log: logger, type: .error, formatMessage(message, file: file, function: function, line: line))
    }

    private static func formatMessage(_ message: String, file: String, function: String, line: Int) -> String {
        let filename = (file as NSString).lastPathComponent
        return "[\(filename):\(line)] \(function) - \(message)"
    }
}
