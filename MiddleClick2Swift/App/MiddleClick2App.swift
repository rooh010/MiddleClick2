//
//  MiddleClick2App.swift
//  MiddleClick2
//
//  SwiftUI app entry point with MenuBarExtra
//

import SwiftUI

@main
struct MiddleClick2App: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // MenuBarExtra is required for the app to stay running
        // We create NSStatusItem in AppDelegate, but need this for app lifecycle
        WindowGroup {
            EmptyView()
                .frame(width: 0, height: 0)
                .hidden()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 0, height: 0)
    }
}
