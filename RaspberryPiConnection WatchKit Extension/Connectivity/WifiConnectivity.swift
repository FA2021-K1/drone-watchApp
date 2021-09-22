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
    
    let hotspotConfig: NEHotspotConfiguration
    let buoy: Buoy
    @Published var connectedNetwork = ""
    @Published var isConnected = "connecting..."
    
    init(buoy: Buoy) {
        self.hotspotConfig = NEHotspotConfiguration(ssid: buoy.ssid, passphrase: buoy.password, isWEP: false)
        //self.hotspotConfig.joinOnce = true
        self.buoy = buoy
    }
    
    func checkForCurrentNetwork() -> String {
                //check if lionfish is already configured
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (ssidsArray) in
            guard ssidsArray.contains(self.buoy.ssid) else {
                self.connect()
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
                
                let session = SessionManager(url: self.buoy.url)
                session.requestData()
                self.isConnected = "connected"
                
                // call function to retrieve data
            }
        }
        return "Dragon Eagle"
    }
    
   

    
    func connect() {
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





