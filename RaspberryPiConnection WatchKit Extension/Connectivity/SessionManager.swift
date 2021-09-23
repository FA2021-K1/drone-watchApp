//
//  SessionManager.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 21.09.21.
//

import Foundation
import SwiftUI


class SessionManager {
    @EnvironmentObject var receivedData: ReceivedData
    let url: URL
    
    init(url: URL) {
    //initialize URL
        self.url = url
    }
    
    
   func requestData() {
    //Request Object
    var request = URLRequest(url: url)
//    request.setValue("data/json", forHTTPHeaderField: "Content-Type")
    //Create data task -- defaults to GET //request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else { return print("HTTP Request Failed \(String(describing: error))") }
        print("Received Data: \(String(describing: String(data: data, encoding: .utf8)))!")
        
    }
    
    task.resume()
    }
    
    func sendData() {
        // prepare json data
        let json: [String: Any] = ["message": "Hello Lab!"]
        //receivedData.data

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
    }
}
