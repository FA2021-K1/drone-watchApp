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
    @EnvironmentObject  var wifiConnectivity:WifiConnectivity
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    /*@State private var counter = 0
    
    func getIncremented() -> Int {
        self.counter = self.counter + 1
        return self.counter
    }*/
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Connected to: \(wifiConnectivity.connectedNetwork)")
                .padding()
                .onReceive(timer) { input in
                    wifiConnectivity.checkForCurrentNetwork()
                }
                Text("Received from: \(receivedData.buoyName)")
                Text("data: \(receivedData.data)")
                if #available(watchOSApplicationExtension 8.0, *) {
                    TimelineView(.periodic(from: Date.now, by: 1)) { context in
                        Text("\(context.date.description)")
                        //Text("Seconds running \(getIncremented())")
                    }
                } else {
                    // Fallback on earlier versions
                    Text("please update to use always on functionality")
                }
                           
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
