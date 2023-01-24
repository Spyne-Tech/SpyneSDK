//
//  BackgroundAppRefreshManager.swift
//  BGAppRefresh
//
//  Created by Robert Ryan on 1/19/21.
//  Copyright © 2021 Robert Ryan. All rights reserved.
//

import Foundation
import UserNotifications
import BackgroundTasks
import os.log

@available(iOS 14.0, *)
private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BackgroundAppRefreshManager")
private let backgroundTaskIdentifier = "com.BGAppRefresh.refresh"

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    private init() { }
}

// MARK: Public methods

extension BackgroundTaskManager {

    func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: .main, launchHandler: handleTask(_:))
    }
    
    func handleTask(_ task: BGTask) {
        
        scheduleAppRefresh()

        show(message: task.identifier)

        let request = performRequest { error in
            task.setTaskCompleted(success: error == nil)
        }

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            request.cancel()
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)

        var message = "Scheduled"
        do {
            try BGTaskScheduler.shared.submit(request)
            if #available(iOS 14.0, *) {
                logger.log("task request submitted to scheduler")
                if BackgroundUpload.isUploadRunning {
                    SpyneSDK.upload.uploadParent(type: StringCons.rechabilityChanges, serviceStartedBy: "App Background")
                }
                
                if !BackgroundUploadVideo.isVideoUploadRunning{
                    SpyneSDK.uploadVideo.uploadParent(type: StringCons.rechabilityChanges, serviceStartedBy: "App Background Video Upload")
                }
                
            } else {
                // Fallback on earlier versions
            }
            #warning("add breakpoint at previous line")

            // at (lldb) prompt, type:
            //
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.robertmryan.BGAppRefresh.bgapprefresh"]
        } catch BGTaskScheduler.Error.notPermitted {
            message = "BGTaskScheduler.shared.submit notPermitted"
        } catch BGTaskScheduler.Error.tooManyPendingTaskRequests {
            message = "BGTaskScheduler.shared.submit tooManyPendingTaskRequests"
        } catch BGTaskScheduler.Error.unavailable {
            message = "BGTaskScheduler.shared.submit unavailable"
        } catch {
            message = "BGTaskScheduler.shared.submit \(error.localizedDescription)"
        }
        show(message: message)
    }
}

// MARK: - Private utility methods

private extension BackgroundTaskManager {

    func show(message: String) {
        if #available(iOS 14.0, *) {
            logger.debug("\(message, privacy: .public)")
        } else {
            // Fallback on earlier versions
        }
        let content = UNMutableNotificationContent()
        content.title = "AppRefresh task"
        content.body = message
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                if #available(iOS 14.0, *) {
                    logger.error("\(message, privacy: .public) error: \(error.localizedDescription, privacy: .public)")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }

    @discardableResult
    func performRequest(completion: @escaping (Error?) -> Void) -> URLSessionTask {
        if #available(iOS 14.0, *) {
            logger.debug("starting bg network request")
        } else {
            // Fallback on earlier versions
        }

        let url = URL(string: "https://httpbin.org/get")!
        let task = URLSession.shared.dataTask(with: url) { _, _, error in
            if #available(iOS 14.0, *) {
                logger.debug("finished bg network request")
            } else {
                // Fallback on earlier versions
            }
            completion(error)
        }

        task.resume()

        return task
    }
}
