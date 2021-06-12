//
//  WalkOnApp.swift
//  WalkOnWatch Extension
//
//  Created by Tristram Bates on 12/06/2021.
//

import SwiftUI

@main
struct WalkOnApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
