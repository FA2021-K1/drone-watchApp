//
//  WifiConnectivity.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 09.09.21.
//

import Foundation
import NetworkExtension
import SwiftUI

enum States: String {
    case disconnected
    case connectedToBuoy
    case connectedToScienceLab
    case waitForDisconnect = "Data transmitted, waiting to disconnect"
}


class WifiConnectivity: ObservableObject {
    
    let hotspotConfigBuoy: NEHotspotConfiguration
    let hotspotConfigLab: NEHotspotConfiguration
    let buoy: Buoy
    let lab: Lab
    @Published var state: States
    @Published var connectedNetwork = ""
    @Published var isConnected = "disconnected"
    @Published var receivedData = ""
        
    init(buoy: Buoy, lab: Lab) {
        self.hotspotConfigBuoy = NEHotspotConfiguration(ssid: buoy.ssid, passphrase: buoy.password, isWEP: false)
        //self.hotspotConfig.joinOnce = true
        self.buoy = buoy
        self.hotspotConfigLab = NEHotspotConfiguration(ssid: lab.ssid, passphrase: lab.password, isWEP: false)
        self.lab = lab
        self.state = .disconnected
    }
    
    func tick() -> String {
        switch self.state {
        case .disconnected:
            // waitForNetwork
            //print("disconnected, wait for networks")
            self.checkForCurrentNetwork(waitForDisconnect: false)
        case .connectedToBuoy:
            // request data
            let sessionBuoy = SessionManager(url: self.buoy.url, wifiConnectivity: self)
            sessionBuoy.requestData()
            //print("connected to buoy, request data")
        case .connectedToScienceLab:
            // post data
            let sessionLab = SessionManager(url: self.lab.url, wifiConnectivity: self)
            // change once lab is available
            self.state = .waitForDisconnect
            //sessionLab.sendData()
            //print("connected to science lab, send data")
        case .waitForDisconnect:
            self.checkForCurrentNetwork(waitForDisconnect: true)
            //print("data transmission done, wait for disconnect")
            // wait until network is disconnected, then go back to disconnected state
        }
        return "hello world"
    }
        
    
    func checkForCurrentNetwork(waitForDisconnect: Bool) {
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (ssidsArray) in
            
         //   print("ssidsArray: \(ssidsArray)")
            guard ssidsArray.contains(self.buoy.ssid) else {
                self.connect(hotspotConfig: self.hotspotConfigBuoy)
                return
            }
            
            guard ssidsArray.contains(self.lab.ssid) else {
                self.connect(hotspotConfig: self.hotspotConfigLab)
                return
            }
        }
        NEHotspotNetwork.fetchCurrent() { [self]
            (networkOptional) in
            
            guard let network = networkOptional else {
                self.connectedNetwork = ""
                self.isConnected = "disconnected"
                print("access of current network information failed")
                self.state = .disconnected
                return
            }
            if waitForDisconnect && network.ssid == self.connectedNetwork {
                // we wait for disconnect and are still connected to the same network
                self.state = .waitForDisconnect
                return
            }
            //print(network.ssid)
            // if we expect to be connected
           
            self.connectedNetwork = network.ssid
            if network.ssid == self.buoy.ssid {
//                _ = self.requestData
                self.state = .connectedToBuoy
                
                self.isConnected = "connected"
                
                // call function to retrieve data
            
            }
            if network.ssid == self.lab.ssid {
                self.state = .connectedToScienceLab
                self.isConnected = "connected"

            }
        }
    }
    
   

    
    func connect(hotspotConfig: NEHotspotConfiguration) {
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[] (error) in
            if let error = error {
                print("error = ",error)
            }
            else {
                print("Success!")
            }
        }
        
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (ssidsArray) in
            for ssid in ssidsArray {
                print("ssid = ",ssid)
            }
        }
        
    }
    
    
}





