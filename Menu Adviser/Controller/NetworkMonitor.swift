//
//  NetworkReachability.swift
//  Menu Adviser
//
//  Created by Ivailo Nikolov on 7.12.24.
//

import SwiftUI
import Network

enum NetworkStatus: String {
    case wifi
    case cellular
    case unknown
    case noconnection
}

@Observable
class NetworkMonitor {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    
    var isConnected: Bool = true
    var connectionType: NetworkStatus = .unknown

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitorQueue")
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.isConnected = true
                    
                    if path.usesInterfaceType(.wifi) {
                        self.connectionType = .wifi
                    } else if path.usesInterfaceType(.cellular) {
                        self.connectionType = .cellular
                    }
                } else {
                    self.isConnected = false
                    self.connectionType = .noconnection
                }
            }
        }
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

