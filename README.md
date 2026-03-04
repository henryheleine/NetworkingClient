#  Networking Swift Package

📝 Prerequisites
    1.) The iOS app target should have "UIBackgroundModes": "processing" added to the Info.plist file
    
    2.) The iOS app target should have "BGTaskSchedulerPermittedIdentifiers": "$(PRODUCT_BUNDLE_IDENTIFIER).backgroundTask" added to the Info.plist file  

✨ Usage Example 
    3.) The iOS app target should call BGTaskScheduler.schedule() as close to app launch as possible to maximize the network profile building timeframe
    
    4.) The iOS app target should have the background task hook added to start the network profile builder
    e.g.
    ```swift
    import BackgroundTasks
    import SwiftUI

    @main
    struct ABInBevApp: App {
        var body: some Scene {
            WindowGroup {
                HomeView()
            }
            .backgroundTask(.appRefresh("com.example.myapp.backgroundTask")) {
                Task {
                    Networking().profile()
                }
            }
        }
    }
    ```
