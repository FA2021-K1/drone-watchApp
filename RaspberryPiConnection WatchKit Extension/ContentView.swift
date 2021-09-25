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
    @EnvironmentObject  var wifiConnectivity: WifiConnectivity
    @EnvironmentObject var ble: BluetoothConnectivity

    
    
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
                    TimelineView(.periodic(from: Date.now, by: 2)) { context in
                        VStack {
                            
                            Text("\(wifiConnectivity.tick())")
                            Text("State: \(wifiConnectivity.state.rawValue)")
                            Text("WiFi status \(wifiConnectivity.isConnected)")
                            Text("Connected to \(wifiConnectivity.connectedNetwork)")
                            if wifiConnectivity.isConnected == "connected" {
                                Text("Connected to \(wifiConnectivity.connectedNetwork)")
                            } else {
                                Text("Last connected to \(wifiConnectivity.connectedNetwork)")
                            }
                            Text("\(wifiConnectivity.receivedData)")
                            
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            Text("\(wifiConnectivity.receivedData)")
            Text("Connected to Pi: \(ble.connected)")
            Text("Pi turned \(ble.status.rawValue)")
            Text("\(wifiConnectivity.receivedData)")
                    }
                
          
               
                           
    }
        }




