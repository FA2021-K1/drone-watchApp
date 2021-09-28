//
//  StateManager.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by FA21 on 25.09.21.
//

import Foundation
import SwiftUI



class StateManager: ObservableObject {
    @Published var state = State()
    @Published var ticktock: Bool = false
    @Published var wifiConnectivity = WifiConnectivity(
        buoy: Buoy(ssid: "BuoyAP", password: "drone@12", url: URL(string: "http://192.168.10.50/v1/data")!),
        lab: Lab(ssid: "LS1 FA", password: "ls1.internet", url: URL(string: "https://data.fa.ase.in.tum.de/v1/measurements/drone")!))
        
    @Published var bluetoothConnectivity = BluetoothConnectivity()
    
    
        init() {
            self.wifiConnectivity.pushState(state: self.state)
            self.bluetoothConnectivity.pushState(state: self.state)
            self.bluetoothConnectivity.initBluetooth()
        }
    
    func tick() -> Bool {
        print("Tick Tock, current state: \(self.state.state.rawValue)")

        switch self.state.state {
        case .btModuleStartup:
            print("waiting for bt to turn on")
        case .waitingForBuoyOrScienceLab:
            self.bluetoothConnectivity.waitForBuoy() // start scanning for peripherals
            self.wifiConnectivity.pushState(state: state)
            self.wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: false)
        
        case .btTurningBuoyOn:
            self.bluetoothConnectivity.setPiPower()
            
        case .wifiWaitingForConnectionToBuoy: // only waiting for
            self.wifiConnectivity.pushState(state: state)
            self.wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: false)
        
        case .wifiConnectedToBuoy:
            // request data
            let sessionBuoy = SessionManager(url: self.wifiConnectivity.buoy.url, wifiConnectivity: self.wifiConnectivity)
            sessionBuoy.pushState(state: self.state)
            sessionBuoy.requestData()
            //print("connected to buoy, request data")
            
        case .wifiConnectedToScienceLab:
            // post data
            let sessionLab = SessionManager(url: self.wifiConnectivity.lab.url, wifiConnectivity: self.wifiConnectivity)
            // change once lab is available
            sessionLab.pushState(state: self.state)
            sessionLab.sendData()
            //reset buoyId because the data received are now deleted from UserDefaults 
            sessionLab.buoyId = -1

            //print("connected to science lab, send data")
        
        case .btTurningBuoyOff:
            self.bluetoothConnectivity.setPiPower()
            print("automatically switch to initial state for now, reenable bt turn off later")
            self.state.state = .waitingForBuoyOrScienceLab
            
        case .wifiWaitForDisconnect:
            self.wifiConnectivity.pushState(state: state)
            self.wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: true)
            //print("data transmission done, wait for disconnect")
            // wait until network is disconnected, then go back to disconnected state
        
        }
        //self.ticktock = !self.ticktock
        return true
    }
}
