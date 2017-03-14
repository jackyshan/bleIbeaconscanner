//
//  IBeaconScanner.swift
//  renttravel
//
//  Created by jackyshan on 2017/3/10.
//  Copyright © 2017年 GCI. All rights reserved.
//

import UIKit

class IBeaconScanner: NSObject, CLLocationManagerDelegate {
    // MARK: - 1、公共属性
    static let sharedInstance = IBeaconScanner()
    
    // MARK: - 2、私有属性
    let locationManager = CLLocationManager()
    
    let beaconRegion: CLBeaconRegion = {
        let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "7B1C1C64-077E-4D23-9F49-7E644A13B5A9")!, identifier: "7B1C1C64-077E-4D23-9F49-7E644A13B5A9")
        region.notifyEntryStateOnDisplay = true
        return region
    }()
    
    // MARK: - 3、初始化
    private override init() {
        super.init()
    }
    
    // MARK: - 4、视图

    // MARK: - 5、代理
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            print("Location Access (Always) granted!")
        } else if status == .AuthorizedWhenInUse {
            print("Location Access (When In Use) granted!")
        } else if status == .Denied || status == .Restricted {
            print("Location Access (When In Use) denied!")
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print(">>>发现设备: becons: \(beacons)")
        print("------------------------------")
        for bc in beacons {
            print (bc.accuracy)
        }
    }
    
    // MARK: - 6、公共业务
    func start() {
        stop()
        
        locationManager.delegate = self
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func stop() {
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
        locationManager.delegate = nil
        
    }
    
    // MARK: - 7、私有业务
    
    // MARK: - 8、其他
    deinit {
        if let appIdx = self.getClassName().rangeOfString(Tools.BundleName)?.endIndex {
            print("销毁"+self.getClassName().substringFromIndex(appIdx))
        }
    }
}
