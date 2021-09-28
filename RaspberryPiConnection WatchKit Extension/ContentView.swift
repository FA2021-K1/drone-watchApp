//
//  ContentView.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 08.09.21.
//

import SwiftUI


@available(iOS 15.0, *)
struct ContentView: View {
   // @EnvironmentObject var connected: Bool
    @EnvironmentObject var receivedData: ReceivedData
    @EnvironmentObject var stateManager: StateManager
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    /*@State private var counter = 0

    func getIncremented() -> Int {
        self.counter = self.counter + 1
        return self.counter
    }*/
    
    var body: some View {
        ScrollView {
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
                        Text("\(stateManager.wifiConnectivity.receivedData)")
                    }
                }
//                    Text(stateManager.ticktock ? "tick" : "tock")
            } else {
                Text("please update to watchos 8 or later")
                // Fallback on earlier versions
            }
        }
    }
}




