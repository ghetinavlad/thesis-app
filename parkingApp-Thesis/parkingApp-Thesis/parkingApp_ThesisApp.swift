//
//  parkingApp_ThesisApp.swift
//  parkingApp-Thesis
//
//  Created by vladut on 3/10/22.
//

import SwiftUI
import Firebase


@main
struct parkingApp_ThesisApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
