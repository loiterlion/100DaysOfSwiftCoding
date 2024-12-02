//
//  ViewController.swift
//  Project 22 iBeacon
//
//  Created by Bruce on 2024/11/7.
//

import CoreLocation
import UIKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if !CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) { return }
            if !CLLocationManager.isRangingAvailable() { return }
            startScanning()
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 1234, minor: 5678, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 1234, minor: 5678)
        
        locationManager.startRangingBeacons(satisfying: constraint)
//        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            [unowned self] in
            switch distance {
            
            case .immediate:
                self.view.backgroundColor = .green
                self.distanceReading.text = "RIGHT HERE"
            case .near:
                self.view.backgroundColor = .yellow
                self.distanceReading.text = "NEAR"
            case .far:
                self.view.backgroundColor = .red
                self.distanceReading.text = "FAR"
            case .unknown:
                fallthrough
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
//        print(beacons)
//
//        if beacons.count > 0 {
//            let beacon = beacons[0]
//            update(distance: beacon.proximity)
//        } else {
//            update(distance: .unknown)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        print(beacons)
        
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}

