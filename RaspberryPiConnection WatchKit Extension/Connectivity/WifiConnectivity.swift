//
//  WifiConnectivity.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 09.09.21.
//

import Foundation
import NetworkExtension
import SwiftUI




class WifiConnectivity {
    let stateManager: StateManager
    let hotspotConfigBuoy: NEHotspotConfiguration
    let hotspotConfigLab: NEHotspotConfiguration
    let buoy: Buoy
    let lab: Lab
  
        
    init(buoy: Buoy, lab: Lab, state: StateManager) {
        self.hotspotConfigBuoy = NEHotspotConfiguration(ssid: buoy.ssid, passphrase: buoy.password, isWEP: false)
        //self.hotspotConfig.joinOnce = true
        self.buoy = buoy
        self.hotspotConfigLab = NEHotspotConfiguration(ssid: lab.ssid, passphrase: lab.password, isWEP: false)
        self.lab = lab
        self.stateManager = state
    }
    
   
        
    
    func checkForCurrentNetwork(waitForDisconnect: Bool) {
                //check if lionfish is already configured
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (ssidsArray) in
            
            //print("ssidsArray: \(ssidsArray)")
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
                //self.connectedNetwork = ""
                self.stateManager.isConnected = "disconnected"
                print("access of current network information failed")
                self.stateManager.state = .disconnected
                return
            }
            if waitForDisconnect && network.ssid == self.connectedNetwork {
                // we wait for disconnect and are still connected to the same network
                self.stateManager.state = .waitForDisconnect
                return
            }
            //print(network.ssid)
            // if we expect to be connected
           
            self.stateManager.connectedNetwork = network.ssid
            if network.ssid == self.buoy.ssid {
//                _ = self.requestData
                self.stateManager.state = .connectedToBuoy
                
                self.stateManager.isConnected = "connected"
                
                // call function to retrieve data
            
            }
            if network.ssid == self.lab.ssid {
                self.stateManager.state = .connectedToScienceLab
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





