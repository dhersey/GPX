//
//  AppDelegate.swift
//  GPX
//
//  Created by Dave Hersey, Paracoders, LLC on 3/24/19.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static var geocoder: CLGeocoder? = nil
    static var locationManager: CLLocationManager? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.geocoder = CLGeocoder()
        AppDelegate.locationManager = CLLocationManager()
        return true
    }

    static func requestAccessIfNeeded() {
        if CLLocationManager.locationServicesEnabled() {
            guard let locationManager = AppDelegate.locationManager else { return }
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        } else {
            //TODO: Ask user to enable location services
        }
    }
    
    static func enableLocationServices(for delegate: CLLocationManagerDelegate) {
        guard let locationManager = AppDelegate.locationManager else { return }
        requestAccessIfNeeded()
        locationManager.delegate = delegate
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    static func disableLocationServices() {
        guard let locationManager = AppDelegate.locationManager else { return }
        locationManager.stopUpdatingLocation()
    }
}

