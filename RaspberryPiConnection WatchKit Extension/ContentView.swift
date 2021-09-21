//
//  ContentView.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 08.09.21.
//

import SwiftUI

struct ContentView: View {
    let wifiConnectivity = WifiConnectivity()
    
    var body: some View {
        VStack {
        Text("Hello, World!")
            .padding()
            Button("Connect", action: {wifiConnectivity.connect()})
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
