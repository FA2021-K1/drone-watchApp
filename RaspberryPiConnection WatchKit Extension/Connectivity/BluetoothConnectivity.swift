//
//  BluetoothConnectivity.swift
//  RaspberryPiConnection WatchKit Extension
//
//  Created by Jessica Saroufim on 25.09.21.
//

import Foundation
import CoreBluetooth

public class BluetoothConnectivity: NSObject, ObservableObject{
    @Published var state = State()
    
    //the watch node
    var manager: CBCentralManager?
    //the peripheral
    var raspberryPi: CBPeripheral?
    
    var writeCharacteristic: CBCharacteristic?
    
    let serviceCBUUID = CBUUID(string: "686fc1ae-b815-48a4-9b26-300eaefd2b03")
    let characteristicsCBUUID = CBUUID(string: "77fc5631-ab53-44fb-a5c0-753b08423814")
       
    enum Mode: String {
        case ON
        case OFF
    }
    
    @Published var connected: String = "NO"
    @Published var status = Mode.OFF
    
    var receivedStatus: String = ""
    
    func initBluetooth() {
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func pushState(state:State) {
        self.state = state
    }
    
    // start scan if not scanning already
    func waitForBuoy() {
        guard let manager = manager else {
            print("bt manager is unexpectedly nil")
            return
        }
        if !manager.isScanning  {
            manager.scanForPeripherals(withServices: [serviceCBUUID])
        }
    }
    
    // true -> on, false -> off
    public func setPiPower() {
        guard let wrChar = writeCharacteristic else {
            print("Write characteristic not yet discovered!")
            return
        }
        raspberryPi?.readValue(for: wrChar) // read value, in reading callback write if necessary
    }
    
    private func updateMode() {
        guard let wrChar = writeCharacteristic else {
            print("Write characteristic not yet discovered!")
            return
        }
        switch (status, self.state.state) {
        case (.ON, .btTurningBuoyOn):
            self.state.state = .wifiWaitingForConnectionToBuoy
        case (.ON, .btTurningBuoyOff):
            let off = Data([0x4f, 0x46, 0x46])
            raspberryPi?.writeValue(off, for: wrChar, type: .withoutResponse)
            print("Wrote Value")
            status = .OFF
            self.state.state = .waitingForBuoyOrScienceLab // back to the beginning
        case (.OFF, .btTurningBuoyOn):
            let on = Data([0x4f, 0x4e])
            raspberryPi?.writeValue(on, for: wrChar, type: .withoutResponse)
            print("Wrote Value")
            status = .ON
            self.state.state = .wifiWaitingForConnectionToBuoy
        case (.OFF, .btTurningBuoyOff):
            self.state.state = .waitingForBuoyOrScienceLab // back to the beginning
        default:
            print("did not expect to end up in default case")
        }
    }
    
    
}

extension BluetoothConnectivity: CBCentralManagerDelegate {
    
   
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unsupported:
            print("BLE is Unsupported")
        case .unauthorized:
            print("BLE is Unauthorized")
        case .unknown:
            print("BLE is Unknown")
        case .resetting:
            print("BLE is Resetting")
        case .poweredOff:
            connected = "NO"
            print("BLE is Powered Off")
        case .poweredOn:
            print("BLE is Powered On")
            self.state.state = .waitingForBuoyOrScienceLab
//            print("2. scanning for peripherals 🔍")
        @unknown default:
            print("default")
        }
    }
    
    //start discovering peripherals and connecting to the raspberryPi
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Buoy-BLE-Server" {
            print("Pi detected")
            self.raspberryPi = peripheral
            raspberryPi?.delegate = self
            self.manager?.stopScan()
        }
        guard let peripheral = self.raspberryPi else {
            return
        }
        self.manager?.connect(peripheral, options: nil)
    }
    
    //to make sure peripheral is connected
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        connected = "YES"
        raspberryPi?.discoverServices([serviceCBUUID])
    }
    
    public func centralManager (_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected = "NO"
    
        print("Attempts to reconnect to \(peripheral.name ?? "No name")")
        if error != nil {
            print("Error 7 \(error?.localizedDescription ?? "reconnecting to the peripheral")")
            self.manager?.scanForPeripherals(withServices: nil, options: nil)
            return
        }
    }
}

//discover services provided by peripheral
extension BluetoothConnectivity: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        raspberryPi?.delegate = self
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics([characteristicsCBUUID], for: service)
        }
        
        
    }
    

    
    //discover characteristics of the services
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("characteristic \(characteristic)")
            self.state.state = .btTurningBuoyOn
            //asked to read a characteristic’s value
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
                writeCharacteristic = characteristic
            }
            if characteristic.uuid == self.characteristicsCBUUID {
                print("found the correct characteristics")
                self.state.state = .btTurningBuoyOn
            }
        }
    }
    
    //updates
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let error = error {
                print(error)
                return
            }
            guard let value = characteristic.value else {
                return
            }
        
        receivedStatus = String(bytes: value, encoding: .utf8) ?? "Nil"
        
        print("receivedStatus: \(receivedStatus)")
        
        switch receivedStatus {
        case "ON":
            status = .ON
        case "OFF":
            status = .OFF
        default:
            status = .OFF
        }
        self.updateMode()
    }

    }

    



