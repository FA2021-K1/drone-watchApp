//
//  Setup.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 29.09.21.
//

import SwiftUI

struct Setup: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        VStack{
            Button("Setup Lab Wifi") {
                self.stateManager.wifiConnectivity.setupWifiScienceLab()
            }
            Button("Setup Buoy Wifi") {
                self.stateManager.wifiConnectivity.setupWifiBuoy()
            }
        }
    }
}

struct Setup_Previews: PreviewProvider {
    static var previews: some View {
        Setup()
    }
}
