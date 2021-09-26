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
          // VStack {
               
                // Text("Received from: \(receivedData.buoyName)")
              //  Text("data: \(receivedData.data)")
         
                if #available(watchOSApplicationExtension 8.0, *) {
                    TimelineView(.periodic(from: Date.now, by: 3)) { context in
                        VStack {
//
//                            if stateManager.tick() {
                            Text("Drone2Buoy App \(stateManager.tick().description)")
                            
//                            } else {
                               // Text("update State")
//                            }
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
                    //Text(stateManager.ticktock ? "tick" : "tock")
                } else {
                    // Fallback on earlier versions
                }
//            Text("\(wifiConnectivity.receivedData)")
//            Text("Connected to Pi: \(ble.connected)")
//            Text("Pi turned \(ble.status.rawValue)")
//            Text("\(wifiConnectivity.receivedData)")
                    }
                
          
               
                           
    }
        }




