//
//  BLEScanner.swift
//  renttravel
//
//  Created by jackyshan on 2017/3/9.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEScanner: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: - 1、公共属性
    static let sharedInstance = BLEScanner()
    
    var bleOpenFail = {() -> () in}
    var bleOpenSucc = {() -> () in}
    
    // MARK: - 2、私有属性
    var centerManager: CBCentralManager?
    var bleViewerPerArr: Array<ScannerModel> = []
    
    // MARK: - 3、初始化
    private override init() {
        super.init()
        
        initLinstener()
    }
    
    func initLinstener() {
    }
    
    // MARK: - 4、视图
    
    // MARK: - 5、代理
    // MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state != .PoweredOn {
            switch central.state {
            case .Unknown:
                print("蓝牙未知原因")
                break
            case .Resetting:
                print("蓝牙连接超时")
                break
            case .Unsupported:
                print("不支持蓝牙4.0")
                break
            case .Unauthorized:
                print("连接失败")
                break
            case .PoweredOff:
                print("蓝牙未开启")
                break
            
            default:
                break
            }
            
            print(">>>设备不支持BLE或者未打开")
            bleOpenFail()
            stop()
        }
        else {
            print(">>>BLE状态正常")
            bleOpenSucc()
            centerManager!.scanForPeripheralsWithServices([CBUUID(string: "6E400000-B5A3-F393-E0A9-E50E24DCCA9E")], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
//            centerManager!.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

        print(">>>>扫描周边设备 .. 设备id:\(peripheral.identifier.UUIDString), rssi: \(RSSI.stringValue), advertisementData: \(advertisementData), peripheral: \(peripheral)")
//        if let data = advertisementData[""] {
//        }
        
//        peripheral.delegate = self
//        centerManager?.connectPeripheral(peripheral, options: nil)
    }
    
    // MARK: CBPeripheralDelegate
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("和周边设备连接成功。")
        peripheral.discoverServices(nil)
        print("扫描周边设备上的服务..")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error != nil {
            print("发现服务时发生错误: \(error)")
            return
        }
        
        print("发现服务 ..")
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("发现服务 \(service.UUID), 特性数: \(service.characteristics?.count)")
        
        for c in service.characteristics! {
            if let data = c.value {
                peripheral.readValueForCharacteristic(c)
                print("特性值byte： \(data.bytes)")
                print("特性值string： \(String(data: data, encoding: NSUTF8StringEncoding))")
            }
        }
    }
    
    // MARK: - 6、公共业务
    func start() {
        stop()
        
        centerManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    func stop() {
        bleViewerPerArr.removeAll()
        centerManager?.stopScan()
        centerManager = nil
    }
    
    // MARK: - 7、私有业务
    
    // MARK: - 8、其他
    deinit {
        if let appIdx = self.getClassName().rangeOfString(Tools.BundleName)?.endIndex {
            print("销毁"+self.getClassName().substringFromIndex(appIdx))
        }
    }
    
}

struct ScannerModel {
    var name: String?
}
