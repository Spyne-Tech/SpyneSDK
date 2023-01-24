//
//  ConnectionManager.swift
//  Spyne
//
//  Created by Vijay Parmar on 26/08/21.
//  Copyright © 2021 Spyne. All rights reserved.
//

import Foundation
class ConnectionManager {

static let sharedInstance = ConnectionManager()
private var reachability : Reachability!

func observeReachability(){
    self.reachability = try? Reachability()
    NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    do {
        try self.reachability.startNotifier()
    }
    catch(let error) {
        print("Error occured while starting reachability notifications : \(error.localizedDescription)")
    }
}

@objc func reachabilityChanged(note: Notification) {
    let reachability = note.object as! Reachability
    switch reachability.connection {
    case .cellular:
        print("Network available via Cellular Data.")
        break
    case .wifi:
        print("Network available via WiFi.")
        break
    case .unavailable:
        print("Network is not available.")
        break
    }
  }
}
