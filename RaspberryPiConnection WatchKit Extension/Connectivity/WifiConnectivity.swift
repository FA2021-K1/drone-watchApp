//
//  WifiConnectivity.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 09.09.21.
//

import Foundation
import NetworkExtension


class WifiConnectivity {
    let hotspotConfig = NEHotspotConfiguration(ssid: "lionfish", passphrase: "Raspberry", isWEP: false)
    let url = URL(string: "http://4c08f81d-f725-4d2f-87fc-58bb61a0450b.mock.pstmn.io/data")!
    
    func checkForCurrentNetwork() {
        let session = SessionManager(url: url)

        NEHotspotNetwork.fetchCurrent() {
            (networkOptional) in
            guard let network = networkOptional else {
                print("access of current network information failed")
                return
            }
            print(network.ssid)
            if network.ssid == "lionfish" {
                //session.requestData()

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





