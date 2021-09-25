//
//  ContentView.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 08.09.21.
//

import SwiftUI

struct Counter {
   
}

struct ContentView: View {
   // @EnvironmentObject var connected: Bool
    @EnvironmentObject var receivedData: ReceivedData
    @EnvironmentObject var stateManager: StateManager
    @EnvironmentObject var wifiConnectivity: WifiConnectivity
    @EnvironmentObject var state: State
    
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
                            
                            if stateManager.tick() {
                                Text("Drone2Buoy App")
                            } else {
                                Text("update State")
                            }
                            Text("State: \(state.state.rawValue)")
                            Text("WiFi status \(wifiConnectivity.isConnected)")
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
                    Text("please update to watchOS 8 to use always on functionality")
                }
                           
            }
      //  }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
