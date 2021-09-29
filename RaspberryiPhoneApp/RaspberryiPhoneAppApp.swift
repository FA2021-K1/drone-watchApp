//
//  RaspberryiPhoneAppApp.swift
//  RaspberryiPhoneApp
//
//  Created by FA21 on 29.09.21.
//

import SwiftUI

@main
struct RaspberryiPhoneAppApp: App {
    var stateManager = StateManager()

    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(stateManager)
            }
        }
    }
}
