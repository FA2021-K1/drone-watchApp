//
//  WifiConnectivity.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 09.09.21.
//

import Foundation
import NetworkExtension
import SwiftUI




class WifiConnectivity: ObservableObject {
   
    let hotspotConfigBuoy: NEHotspotConfiguration
    let hotspotConfigLab: NEHotspotConfiguration
    let buoy: Buoy
    let lab: Lab
  
    @Published var connectedNetwork = ""
    @Published var isConnected = "disconnected"
    @Published var state = State()
    
    init(buoy: Buoy, lab: Lab) {
        self.hotspotConfigBuoy = NEHotspotConfiguration(ssid: buoy.ssid, passphrase: buoy.password, isWEP: false)
        //self.hotspotConfig.joinOnce = true
        self.buoy = buoy
        self.hotspotConfigLab = NEHotspotConfiguration(ssid: lab.ssid, passphrase: lab.password, isWEP: false)
        self.lab = lab
    }
    
   
    func pushState(state:State) {
        self.state = state
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
                if self.state.state == .wifiWaitForDisconnect {
                    self.state.state = .waitingForBuoyOrScienceLab // reset to original state
                }
                return
            }
            if waitForDisconnect && network.ssid == self.connectedNetwork {
                // we wait for disconnect and are still connected to the same network
                self.state.state = .wifiWaitForDisconnect
                return
            }
            //print(network.ssid)
            // if we expect to be connected
           
            self.connectedNetwork = network.ssid
            if network.ssid == self.buoy.ssid {
//                _ = self.requestData
                self.state.state = .wifiConnectedToBuoy
                
                self.isConnected = "connected"
                
                // call function to retrieve data
            
            }
            if network.ssid == self.lab.ssid {
                self.state.state = .wifiConnectedToScienceLab
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





