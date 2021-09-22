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
    var wifiConnectivity = WifiConnectivity(buoy: Buoy(ssid: "lionfish", password: "Raspberry", url: URL(string: "https://4c08f81d-f725-4d2f-87fc-58bb61a0450b.mock.pstmn.io/data")!))
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
