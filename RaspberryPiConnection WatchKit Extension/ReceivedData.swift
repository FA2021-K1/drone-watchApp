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
class ReceivedData: ObservableObject {
    @Published var date = Date()
    @Published var buoyName: String = ""
    @Published var data: String = ""
    
    let defaults = UserDefaults.standard
    
    func save() {
        let dataArray = [buoyName, date, data] as [Any]
        defaults.set(dataArray, forKey: "\(buoyName) - \(date)")
    }
}
