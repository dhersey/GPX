//
//  LocationViewController.swift
//  GPX
//
//  Created by Dave Hersey, Paracoders, LLC on 3/24/19.
//

import UIKit
import CoreLocation

protocol LocationViewControllerDelegate: AnyObject {
    func newLocationName(_ name: String)
}

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var startStopBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var lastLocationNameLabel: UILabel!
    @IBOutlet weak var lastLocationDetailsTextView: UITextView!
    
    var updatingLocations = false {
        didSet {
            if updatingLocations {
                AppDelegate.enableLocationServices(for: self)
            } else {
                AppDelegate.disableLocationServices()
            }
            
            DispatchQueue.main.async {
                self.startStopBarButtonItem.title = self.updatingLocations ? "Stop updating" : "Start updating"
            }
        }
    }

    weak var locNameDelegate: LocationViewControllerDelegate?
    
    var lastLocationName: String? {
        didSet {
            if lastLocationName?.isEmpty ?? true { lastLocationName = "unknown" }
            locNameDelegate?.newLocationName(lastLocationName!)
            guard isViewLoaded else { return }
            DispatchQueue.main.async {
                self.lastLocationNameLabel.text = self.lastLocationName
            }
        }
    }
    
    var lastLocationDetails: CLPlacemark? {
        didSet {
            guard isViewLoaded else { return }
            let details = lastLocationDetails
            DispatchQueue.main.async {
                self.lastLocationDetailsTextView.text = (details != nil) ? "\(details!)" : ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopBarButtonItem.title = "Start updating"
        lastLocationDetailsTextView.layer.borderWidth = 1
        lastLocationDetailsTextView.layer.borderColor = UIColor.darkGray.cgColor
        lastLocationDetailsTextView.layer.cornerRadius = 16
        lastLocationDetailsTextView.layer.masksToBounds = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        AppDelegate.geocoder?.reverseGeocodeLocation(firstLocation) { [weak self] placemarks, _ in
            guard let strongSelf = self else { return }
            if let place = placemarks?.first {
                strongSelf.lastLocationName = place.name ?? ""
                strongSelf.lastLocationDetails = place
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager:didFailWithError: \(error)")
    }

    @IBAction func toggleLocationUpdates() {
        updatingLocations.toggle()
    }
}
