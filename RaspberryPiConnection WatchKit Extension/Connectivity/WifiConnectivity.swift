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
    @Published var isConnected = "connecting..."
    
    init(buoy: Buoy, lab: Lab) {
        self.hotspotConfigBuoy = NEHotspotConfiguration(ssid: buoy.ssid, passphrase: buoy.password, isWEP: false)
        //self.hotspotConfig.joinOnce = true
        self.buoy = buoy
        self.hotspotConfigLab = NEHotspotConfiguration(ssid: lab.ssid, passphrase: lab.password, isWEP: false)
        self.lab = lab
    }
    
    func checkForCurrentNetwork() -> String {
                //check if lionfish is already configured
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (ssidsArray) in
            
            print("ssidsArray: \(ssidsArray)")
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
                return
            }
            print(network.ssid)
            self.connectedNetwork = network.ssid
            if network.ssid == self.buoy.ssid {
//                _ = self.requestData
                
                let sessionBuoy = SessionManager(url: self.buoy.url)
                sessionBuoy.requestData()
                self.isConnected = "connected"
                
                // call function to retrieve data
            
            }
            if network.ssid == self.lab.ssid {
                let sessionLab = SessionManager(url: self.lab.url)
                sessionLab.sendData()
            }
            
           
        }
        return "Dragon Eagle"
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





