//
//  SessionManager.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 21.09.21.
//

import Foundation


class SessionManager {
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
        guard let data = data else { return print("HTTPS Request Failed \(String(describing: error))") }
        print(String(data: data, encoding: .utf8)!)
        
    }
    
    task.resume()
    }
 
    
    
}
