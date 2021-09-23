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
    var wifiConnectivity = WifiConnectivity(
        buoy: Buoy(ssid: "BuoyAP", password: "drone@12", url: URL(string: "http://192.168.10.50/v1/data")!),
        lab: Lab(ssid: "LS1 FA", password: "ls1.internet", url: URL(string: "http://192.168.1.199:8080/v1/measurements/test")!))
    var receivedData = ReceivedData()
    
    
    init() {
     wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: false)
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(receivedData)
                    .environmentObject(wifiConnectivity)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
