//
//  BGTaskScheduler+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/15/25.
//

import BackgroundTasks
import Foundation

extension BGTaskScheduler {
    
    public static var bgTaskId {
        if let bundleID = Bundle.main.bundleIdentifier {
            return "\(bundleID).backgroundTask"
        }
        return ""
    }
    
    public static func schedule() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        let request = BGProcessingTaskRequest(
            identifier: BGTaskScheduler.bgTaskId
        )
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        try? BGTaskScheduler.shared.submit(request)
    }
}
