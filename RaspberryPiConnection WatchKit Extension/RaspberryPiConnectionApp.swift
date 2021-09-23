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
    var wifiConnectivity = WifiConnectivity(buoy: Buoy(ssid: "BuoyAP", password: "drone@12", url: URL(string: "http://192.168.10.50/v1/sensors")!))
    var receivedData = ReceivedData()
    
    
    init() {
        wifiConnectivity.checkForCurrentNetwork()
    }
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environmentObject(receivedData).environmentObject(wifiConnectivity)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
