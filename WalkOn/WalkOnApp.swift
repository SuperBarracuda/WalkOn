import SwiftUI
@main
struct WalkOnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        let healthManager = HealthManager()
    }
}
