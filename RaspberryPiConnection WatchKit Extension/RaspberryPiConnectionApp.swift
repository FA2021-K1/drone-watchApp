//
//  RaspberryPiConnectionApp.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 08.09.21.
//

import SwiftUI

@main
struct RaspberryPiConnectionApp: App {
    
    //EnvironmentObject
    var timer = Timer()
   
    var stateManager = StateManager()
    var receivedData = ReceivedData()
    
    
    init() {
        

    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(receivedData)
                    .environmentObject(stateManager)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
