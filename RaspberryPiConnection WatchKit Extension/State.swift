//
//  State.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by FA21 on 23.09.21.
//

import Foundation

enum States {
    case disconnected
    case connectedToBuoy
    case conntectedToScienceLab
    case waitToDisconnect
}

class State: ObservableObject {
    @Published var state: States
    
    init() {
        self.state = .disconnected
    }
    
    func tick() -> String {
        switch self.state {
        case .disconnected:
            // waitForNetwork
            print("disconnected, wait for networks")
        case .connectedToBuoy:
            // request data
            print("connected to buoy, request data")
        case .conntectedToScienceLab:
            // post data
            print("connected to science lab, send data")
        case .waitToDisconnect:
            print("data transmission done, wait for disconnect")
            // wait until network is disconnected, then go back to disconnected state
        }
        return "hello world"
    }
}
