//
//  RaspberryiPhoneAppApp.swift
//  RaspberryiPhoneApp
//
//  Created by FA21 on 29.09.21.
//

import SwiftUI

@main
struct RaspberryiPhoneAppApp: App {
    //EnvironmentObject
   
   
  //  var receivedData = ReceivedData()
    var stateManager = StateManager()
    
    init() {
        
        
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
             //       .environmentObject(receivedData)
                    .environmentObject(stateManager)
            }
        }
    }
}
