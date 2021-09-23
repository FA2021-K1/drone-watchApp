//
//  Lab.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 23.09.21.
//

import Foundation

struct Lab {
    let ssid: String
    let password: String
    let url: URL
    
    init(ssid: String, password: String, url: URL) {
        self.ssid = ssid
        self.password = password
        self.url = url
    }
}
