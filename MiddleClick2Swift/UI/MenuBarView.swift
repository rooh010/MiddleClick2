//
//  MenuBarView.swift
//  MiddleClick2
//
//  SwiftUI menu bar content
//  Ported from TrayMenu.m:26-83
//

import SwiftUI
import ApplicationServices

struct MenuBarView: View {
    @AppStorage("clickMode") private var clickModeRawValue: String = ClickMode.tap.rawValue
    @State private var accessibilityEnabled: Bool = AXIsProcessTrusted()
    private let accessibilityTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    private var clickMode: Binding<ClickMode> {
        Binding(
            get: { ClickMode(rawValue: clickModeRawValue) ?? .tap },
            set: {
                clickModeRawValue = $0.rawValue
                NotificationCenter.default.post(
                    name: .clickModeChanged,
                    object: $0
                )
            }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Accessibility: \(accessibilityEnabled ? "Enabled" : "Disabled")")
                .foregroundStyle(accessibilityEnabled ? .green : .red)

            Divider()

            Button("About MiddleClick2") {
                openAbout()
            }

            Divider()

            Picker("Mode", selection: clickMode) {
                ForEach(ClickMode.allCases, id: \.self) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.inline)
            .labelsHidden()

            Divider()

            Button("Quit") {
                NSApp.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .onAppear(perform: refreshAccessibilityStatus)
        .onReceive(accessibilityTimer) { _ in
            refreshAccessibilityStatus()
        }
    }

    private func openAbout() {
        if let url = URL(string: Constants.githubURL) {
            NSWorkspace.shared.open(url)
        }
    }

    private func refreshAccessibilityStatus() {
        accessibilityEnabled = AXIsProcessTrusted()
    }
}

// MARK: - Notification Name
extension Notification.Name {
    static let clickModeChanged = Notification.Name("clickModeChanged")
}
