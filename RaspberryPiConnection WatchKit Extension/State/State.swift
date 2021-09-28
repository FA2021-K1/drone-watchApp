//
//  State.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by FA21 on 25.09.21.
//

import Foundation

enum States: String {
    // Step -1 (setup)
    case btModuleStartup
    // Step 0: wait until we see a BT (buoy) or wifi (sciencelab) device
    case waitingForBuoyOrScienceLab
    // Step 0b: (only for buoy) turn buoy wifi on
    case btTurningBuoyOn
    // Step 1: wait for wifi connection
    case wifiWaitingForConnectionToBuoy
    // Step 2: once connected, get or put data
    case wifiConnectedToBuoy
    case wifiConnectedToScienceLab
    // Step 3: disconnect from wifi to be ready for new connection again
    // either turn buoy of or (for science lab) wait for automatic disconnect
    case btTurningBuoyOff
    case wifiWaitForDisconnect = "Data transmitted, waiting to disconnect wifi"
}

class State: ObservableObject {
    @Published var state: States
    
    
    init() {
        self.state = .btModuleStartup
    }
}
