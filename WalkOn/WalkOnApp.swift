import SwiftUI
@main
struct WalkOnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        _ = HealthManager()
    }
}
