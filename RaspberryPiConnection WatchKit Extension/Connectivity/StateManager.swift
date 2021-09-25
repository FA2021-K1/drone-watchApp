//
//  StateManager.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by FA21 on 25.09.21.
//

import Foundation
import SwiftUI

enum States: String {
    case disconnected
    case connectedToBuoy
    case connectedToScienceLab
    case waitForDisconnect = "Data transmitted, waiting to disconnect"
}

class StateManager: ObservableObject {
    @Published var state: States
    @Published var ticktock: Bool
    
    @Published var connectedNetwork = ""
    @Published var isConnected = "disconnected"
    @Published var receivedData = ""
    
    
    var wifiConnectivity: WifiConnectivity
    
    init() {
        self.state = .disconnected
        self.ticktock = false
        self.wifiConnectivity =  WifiConnectivity(
            buoy: Buoy(ssid: "BuoyAP", password: "drone@12", url: URL(string: "http://192.168.10.50/v1/data")!),
            lab: Lab(ssid: "LS1 FA", password: "ls1.internet", url: URL(string: "http://192.168.1.199:8080/v1/measurements/test")!), state: self)
    }
    
    func tick() -> Bool {
        switch self.state {
        case .disconnected:
            // waitForNetwork
            //print("disconnected, wait for networks")
            self.wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: false)
        case .connectedToBuoy:
            // request data
            let sessionBuoy = SessionManager(url: self.wifiConnectivity.buoy.url, wifiConnectivity: self.wifiConnectivity)
            sessionBuoy.requestData()
            //print("connected to buoy, request data")
        case .connectedToScienceLab:
            // post data
            let sessionLab = SessionManager(url: self.wifiConnectivity.lab.url, wifiConnectivity: self.wifiConnectivity)
            // change once lab is available
            self.state = .waitForDisconnect
            //sessionLab.sendData()
            //print("connected to science lab, send data")
        case .waitForDisconnect:
            self.wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: true)
            //print("data transmission done, wait for disconnect")
            // wait until network is disconnected, then go back to disconnected state
        }
        self.ticktock = !self.ticktock
        return self.ticktock
    }
}
