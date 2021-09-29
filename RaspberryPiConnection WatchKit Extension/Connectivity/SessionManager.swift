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
        print("am here!")
        var request = URLRequest(url: url)
       // request.setValue("data/json", forHTTPHeaderField: "Content-Type")
        
        //Create data task -- defaults to GET //request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print(error!)
                self.state.state = .btTurningBuoyOff
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                        print("JSON received: \(json)")
                        // print("buoyId")
                        self.receivedData.data = json
                        self.receivedData.save(data: json, buoyId: buoyID)
                        self.state.state = .btTurningBuoyOff
                        
                        
                    } else {
                        print("JSON is not an array of dictionaries")
                    }
                } catch let error as NSError {
                    print(error)
                    self.state.state = .btTurningBuoyOff
                }
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
            if let data = UserDefaults.standard.object(forKey: "\(id)") {
            print("data from UserDefaults: \(data)")
         
            if let jsonData2 = try? JSONSerialization.data(withJSONObject: UserDefaults.standard.object(forKey: "\(id)") as? [String: Any] ?? "no data found") {
              
                // create post request
                let url = url
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // insert json data to the request
                request.httpBody = jsonData2
                let task = sesh.dataTask(with: request) { data, response, error in
                    if error != nil {
                        print("Errror here \(error!)")
                    } else {
                    
                            print(data!)
                            guard let data = data, error == nil else {
                                print(error?.localizedDescription ?? "No data")
                                return
                            }
                            // transmission successful, now wait to disconnect
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let responseJSON = responseJSON as? [String: String] {
                                print(responseJSON)
                            } else {
                                print("NO RESPONSE")
                            }
                        
                    }
                }
                
                task.resume()
            }
            } else {
                print("No data, nothing to send")
            }
        }
        self.state.state = .wifiWaitForDisconnect
    }
}
