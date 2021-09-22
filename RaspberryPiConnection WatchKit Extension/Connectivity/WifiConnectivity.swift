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
    let url: URL
    @Published var connectedNetwork = ""
    
    init(buoy: Buoy) {
        self.hotspotConfig = NEHotspotConfiguration(ssid: buoy.ssid, passphrase: buoy.password, isWEP: false)
        self.url = buoy.url
    }
    
    func checkForCurrentNetwork() {
        let session = SessionManager(url: url)
        
        //check if lionfish is already configured
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { (ssidsArray) in
            guard ssidsArray.contains("lionfish") else {
                self.connect()
                return
            }
        }
        NEHotspotNetwork.fetchCurrent() {
            (networkOptional) in
            guard let network = networkOptional else {
                print("access of current network information failed")
                return
            }
            print(network.ssid)
            self.connectedNetwork = network.ssid
            if network.ssid == "lionfish" {
                //     session.requestData()
                
                // call function to retrieve data
            }
        }
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





