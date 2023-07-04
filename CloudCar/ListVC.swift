//
//  ListVC.swift
//  DemoFirebase
//
//  Created by Shubhdeep on 2023-06-27.
//

import Foundation
import UIKit
import MapKit

class ListVC : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var ListORMapViewSwitch : UISwitch! = {
        let mySwitch = UISwitch()
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.isOn = false
        mySwitch.addTarget(self, action: #selector(switchValueChanged(_ :)), for: .valueChanged)
        return mySwitch
    }()
    
    
    lazy var map : MKMapView = {
        
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        return map
    }()
    
    lazy var pageTableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
        
    }()
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        pageTableView.isHidden = sender.isOn
        map.isHidden = !sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        LocationServices.shared.locationManager.delegate = self
        view.backgroundColor = .white
        LocationServices.shared.locationManager.requestWhenInUseAuthorization()
        
        pageTableView.isHidden = false
        map.isHidden = true
        
        DispatchQueue.main.async {
            LocationServices.shared.locationManager.startUpdatingLocation()
        }
        
        
        view.addSubview(ListORMapViewSwitch)
        NSLayoutConstraint.activate([
            ListORMapViewSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            ListORMapViewSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            
        ])
        
        view.addSubview(pageTableView)
        NSLayoutConstraint.activate([
            pageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageTableView.topAnchor.constraint(equalTo: ListORMapViewSwitch.bottomAnchor, constant: 16),
            pageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(map)
        NSLayoutConstraint.activate([
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.topAnchor.constraint(equalTo: ListORMapViewSwitch.bottomAnchor, constant: 16),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
    
}

extension ListVC : UITableViewDelegate {
    
    
    
}

extension ListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.displayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        
        cell.nameLabel.text = DataManager.shared.displayUsers[indexPath.row]
        return cell
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            map.setRegion(viewRegion, animated: false)
            
            let pin = MKPointAnnotation()
            pin.coordinate = userLocation.coordinate
            map.addAnnotation(pin)
            
            LocationServices.shared.locationManager.stopUpdatingLocation() // Stop updating location after the initial zoom
        }
    }
    
    
    func geocodeAddress(_ address: String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemark, error) in
            if let error = error {
                print("Geocoding error")
                return
            }
            
            
        }
    }
        
}
