//
//  ReceivedData.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 22.09.21.
//

import Foundation
import SwiftUI
import Network

//Model
class ReceivedData {
    var date = Date()
    var data: Data = Data()
    let defaults = UserDefaults.standard
   
    
    func save(data: Data,buoyId: Int) {
        defaults.set(data, forKey: "\(buoyId)")
    }
}
