import UIKit
import BackgroundTasks

// Two ways to run work when the app isn't in the foreground.

// MARK: - 1. Finish a task after the user backgrounds the app (~30s window).

enum BackgroundTaskRunner {

    // Wrap important, short work so iOS doesn't suspend you mid-way.
    static func runProtected(_ work: @escaping () -> Void) {
        var taskID: UIBackgroundTaskIdentifier = .invalid
        taskID = UIApplication.shared.beginBackgroundTask(withName: "SaveWork") {
            // Called if time runs out — clean up and end.
            UIApplication.shared.endBackgroundTask(taskID)
            taskID = .invalid
        }

        DispatchQueue.global().async {
            work()
            // ALWAYS end the task or the OS may kill the app.
            UIApplication.shared.endBackgroundTask(taskID)
            taskID = .invalid
        }
    }
}

// MARK: - 2. Real periodic background refresh with BGTaskScheduler (iOS 13+).
//
// Setup (once):
//   • Target → Signing & Capabilities → + Background Modes → Background fetch + Background processing.
//   • Info.plist → "Permitted background task scheduler identifiers" (BGTaskSchedulerPermittedIdentifiers)
//     → add "com.yourapp.refresh".
//   • Register the handler in AppDelegate.didFinishLaunching (see register()).

enum BackgroundScheduler {

    static let refreshID = "com.yourapp.refresh"

    // Call from application(_:didFinishLaunchingWithOptions:).
    static func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: refreshID, using: nil) { task in
            handleAppRefresh(task as! BGAppRefreshTask)
        }
    }

    // Ask the system to run us again later (typically from sceneDidEnterBackground).
    static func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: refreshID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // no sooner than 15 min
        try? BGTaskScheduler.shared.submit(request)
    }

    private static func handleAppRefresh(_ task: BGAppRefreshTask) {
        scheduleAppRefresh() // always re-schedule the next run

        let work = Task {
            // Do a quick fetch/sync here.
            // let items = try await APIService.shared.fetchUsers()
            task.setTaskCompleted(success: true)
        }

        // The system may reclaim time — cancel gracefully if so.
        task.expirationHandler = {
            work.cancel()
            task.setTaskCompleted(success: false)
        }
    }
}
