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
    @Published var state = State()
    @Published var buoyId = 0
    
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
    
   func requestData() {
       //Request Object
       print("am here!")
       var request = URLRequest(url: url)
      // request.setValue("data/json", forHTTPHeaderField: "Content-Type")
          
       //Create data task -- defaults to GET //request.httpMethod = "GET"
       let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
           if error != nil {
                   print(error!)
                 } else {
                   do {
                       if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                       print("JSON received: \(json)")
                           print("buoyId")
                           self.buoyId += 1
                           self.receivedData.data = json
                           self.receivedData.save(data: json, buoyId: self.buoyId)
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
    
    func sendData() {
        //fetch json from UserDefaults
        //send json from UserDefaults
        //remove the object from UserDefaults
       
       
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
      
        
        let sesh = URLSession(configuration: config)

        for buoyId in [0,1] {
            let data = UserDefaults.standard.string(forKey: "\(buoyId)")
            print("data from UserDefaults: \(data ?? "No data found")")
            print("buoy ID: \(buoyId)")
            if let jsonData2 = try? JSONSerialization.data(withJSONObject: UserDefaults.standard.string(forKey: "\(buoyId)") ?? ["message": "no data found"]) {
          //  print("jsonData2)
    
        //let jsonData = try? JSONSerialization.data(withJSONObject: receivedData.data)

        // create post request
        let url = url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData2

        
       
                
                let task = sesh.dataTask(with: request) { data, response, error in
                    print(data!)
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            // transmission successful, now wait to disconnect
      
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: String] {
                print(responseJSON)
            }
        }
                
        task.resume()
            }
        }
        self.state.state = .wifiWaitForDisconnect
    }
}
