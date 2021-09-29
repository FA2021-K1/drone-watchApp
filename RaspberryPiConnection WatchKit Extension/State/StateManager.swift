//
//  StateManager.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by FA21 on 25.09.21.
//

import Foundation
import SwiftUI

#if os(iOS)
import Combine
#endif


class StateManager: ObservableObject {
    @Published var state = State()
    @Published var ticktock: Bool = false
    @Published var wifiConnectivity = WifiConnectivity(
        buoy: Buoy(ssid: "BuoyAP", password: "drone@12", url: URL(string: "http://192.168.10.50/v1/data")!),
        lab: Lab(ssid: "LS1 FA", password: "ls1.internet", url: URL(string: "https://data.fa.ase.in.tum.de/v1/measurements/drone")!))
    
    @Published var bluetoothConnectivity = BluetoothConnectivity()
     var buoyID = 0
    
#if os(iOS)
    var cancellable1 : AnyCancellable?
    var cancellable2 : AnyCancellable?
#endif
    
    init() {
        self.wifiConnectivity.pushState(state: self.state)
        self.bluetoothConnectivity.pushState(state: self.state)
        self.bluetoothConnectivity.initBluetooth()
        #if os(iOS)
        print("iphone version")
        cancellable1 = wifiConnectivity.objectWillChange.sink { (_) in
            self.objectWillChange.send()
        }
        cancellable2 = bluetoothConnectivity.objectWillChange.sink { (_) in
            self.objectWillChange.send()}
#endif
    }
    
    func tick(date: Date) -> String {
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
            // 1  request data
            let sessionBuoy = SessionManager(url: self.wifiConnectivity.buoy.url, wifiConnectivity: self.wifiConnectivity)
            sessionBuoy.pushState(state: self.state)
            sessionBuoy.requestData(buoyID: buoyID)
            // 2 append buoyID to receive data from next buoy
            buoyID += 1
        case .wifiConnectedToScienceLab:
            // post data
            let sessionLab = SessionManager(url: self.wifiConnectivity.lab.url, wifiConnectivity: self.wifiConnectivity)
            // change once lab is available
            sessionLab.pushState(state: self.state)
            //1 -- send data to lab
            sessionLab.sendData(buoyID: buoyID)
            //2 -- delete data from UserDefaults
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            //3 -- reset buoyId because the data received are now deleted from UserDefaults
            buoyID = 0
            print("Data transmitted to ScienceLab and deleted all data from UserDefaults!")
        case .btTurningBuoyOff:
            self.bluetoothConnectivity.setPiPower()
            print("automatically switch to initial state for now, reenable bt turn off later")
            self.state.state = .waitingForBuoyOrScienceLab
        case .wifiWaitForDisconnect:
            self.wifiConnectivity.pushState(state: state)
            self.wifiConnectivity.checkForCurrentNetwork(waitForDisconnect: true)
        }
        return date.description
    }
}
