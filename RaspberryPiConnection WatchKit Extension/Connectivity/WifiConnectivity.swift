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
    let url = URL(string: "https://4c08f81d-f725-4d2f-87fc-58bb61a0450b.mock.pstmn.io")!
    
    
    func connect() {
        let session = SessionManager(url: url)
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[] (error) in
           if let error = error {
              print("error = ",error)
            session.requestData()
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





