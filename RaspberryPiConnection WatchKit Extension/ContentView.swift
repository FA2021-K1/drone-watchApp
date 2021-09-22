//
//  ContentView.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 08.09.21.
//

import SwiftUI

struct ContentView: View {
   // @EnvironmentObject var connected: Bool
    @EnvironmentObject var receivedData: ReceivedData
    @EnvironmentObject  var wifiConnectivity:WifiConnectivity
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    
    var body: some View {
        VStack {
            Text("Connected to: \(wifiConnectivity.connectedNetwork)")
            .padding()
            .onReceive(timer) { input in
                wifiConnectivity.checkForCurrentNetwork()
            }
            Text("Received from: \(receivedData.buoyName)")
            Text("data: \(receivedData.data)")
                       
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
