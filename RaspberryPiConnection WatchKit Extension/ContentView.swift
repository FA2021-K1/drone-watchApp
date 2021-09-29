//
//  ContentView.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 08.09.21.
//

import SwiftUI


@available(iOS 15.0, *)
struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
   
    var body: some View {
        ScrollView {
            #if os(watchOS)
                if #available(watchOSApplicationExtension 8.0, *) {
                    TimelineView(.periodic(from: Date.now, by: 1)) { context in
                        VStack {
                            Text("Drone2Buoy App \(stateManager.tick(date: context.date))")
                            Text("State: \(stateManager.state.state.rawValue)")
                            Text("WiFi status \(stateManager.wifiConnectivity.isConnected)")
                            if stateManager.wifiConnectivity.isConnected == "connected" {
                                Text("Connected to \(stateManager.wifiConnectivity.connectedNetwork)")
                            } else {
                                Text("Last connected to \(stateManager.wifiConnectivity.connectedNetwork)")
                            }
                            Text("Connected to Pi: \(stateManager.bluetoothConnectivity.connected)")
                            Text("Pi turned \(stateManager.bluetoothConnectivity.status.rawValue)")
                            Text("Data received \(stateManager.receivedData.data.description)")
                            NavigationLink("Configuration") {
                                Setup().environmentObject(stateManager)
                            }
                        }
                    }
                } else {
                    // Fallback on earlier versions
                    Text("please update to watchos 8 or later")
                }
            #else
            VStack {
                Text("Drone2Buoy App")
                Text("State: \(stateManager.state.state.rawValue)")
                Text("WiFi status \(stateManager.wifiConnectivity.isConnected)")
                if stateManager.wifiConnectivity.isConnected == "connected" {
                    Text("Connected to \(stateManager.wifiConnectivity.connectedNetwork)")
                } else {
                    Text("Last connected to \(stateManager.wifiConnectivity.connectedNetwork)")
                }
                Text("Connected to Pi: \(stateManager.bluetoothConnectivity.connected)")
                Text("Pi turned \(stateManager.bluetoothConnectivity.status.rawValue)")
                Text("Data received \(stateManager.receivedData.data.description)")
                NavigationLink("Configuration") {
                    Setup().environmentObject(stateManager)
                }
            }.onReceive(timer) { input in stateManager.tick(date: Date())
            }
            #endif
        }
    }
}




