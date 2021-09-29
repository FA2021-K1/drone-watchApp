//
//  SessionManager.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 21.09.21.
//

import Foundation
import SwiftUI


class SessionManager {
    var receivedData = ReceivedData()
    var state = State()
    
    var wifiConnectivity: WifiConnectivity
    let url: URL
    
    init(url: URL, wifiConnectivity: WifiConnectivity) {
        //initialize URL
        self.url = url
        self.wifiConnectivity = wifiConnectivity
    }
    
    
    func pushState(state: State) {
        self.state = state
    }
    
    
    func requestData(buoyID: Int) {
        //Request Object
        var request = URLRequest(url: url)
        // request.setValue("data/json", forHTTPHeaderField: "Content-Type")
        
        //Create data task -- defaults to GET //request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
            let str = String(decoding: data, as: UTF8.self)
            print("DATA NO ENCODING: \(str)")

            self.receivedData.data = data
            self.state.state = .btTurningBuoyOff
            self.receivedData.save(data: data, buoyId: buoyID)
                        
            } else {
                print("NO DATA -- ")
                self.state.state = .btTurningBuoyOff
            }
                   
            
            
        }
        
        task.resume()
    }
    
    func sendData(buoyID: Int) {
        //fetch json from UserDefaults
        //send json from UserDefaults
        //remove the object from UserDefaults
        
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        
        
        let sesh = URLSession(configuration: config)
        
        for id in 0...buoyID {
            if let data = (UserDefaults.standard.data(forKey: "\(id)")) {
             
                let str = String(decoding: data, as: UTF8.self)
                print("data from UserDefaults: \(str)")

              
                    // create post request
                    let url = url
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("*/*", forHTTPHeaderField: "Accept")
                    
                    // insert  data  to the request
                request.httpBody = data
                    let task = sesh.dataTask(with: request) { data, response, error in
                        if error != nil {
                            print("Errror here \(error!)")
                        } else {
                            
                            guard let data = data, error == nil else {
                                print(error?.localizedDescription ?? "No data")
                                return
                            }
                             
                            let str = String(decoding: data, as: UTF8.self)
                            print("Response: \(str)")
                            // transmission successful, now wait to disconnect
                           // let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                           // if let responseJSON = responseJSON as? String {
                           //     print("responseJSON!! : \(responseJSON.description)")
                            }
                        
                    }
                    
                    task.resume()
            } else {
                print("No data, nothing to send")
            }
        }
        self.state.state = .wifiWaitForDisconnect
    }

}
