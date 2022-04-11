//
//  CheckInternetConnection.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/10/22.
//

import Foundation
import Network

class InternetConnectionObserver: ObservableObject {
    let monitor = NWPathMonitor()
    @Published var isConnectionOn: Bool = true {
        didSet {
                NotificationCenter.default.post(name: .noInternetConnection, object: isConnectionOn)
        }
    }
    
    func checkInternetConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnectionOn = true
            } else {
                self.isConnectionOn = false
            }
        }
    }
}

