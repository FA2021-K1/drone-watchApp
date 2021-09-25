//
//  State.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by FA21 on 25.09.21.
//

import Foundation

enum States: String {
    case disconnected
    case connectedToBuoy
    case connectedToScienceLab
    case waitForDisconnect = "Data transmitted, waiting to disconnect"
}

class State: ObservableObject {
    @Published var state: States
    
    
    init() {
        self.state = .disconnected
    }
}
