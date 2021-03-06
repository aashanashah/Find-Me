//
//  MapViewController.swift
//  Find Me
//
//  Created by Aashana on 10/31/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView : MKMapView!
    var currLocation:CLLocationCoordinate2D!
    let currannotation = MKPointAnnotation()
    var locationManager: CLLocationManager!
    var searchLoc = CLLocationCoordinate2D()
    var address : String!
    var coordinate : CLLocationCoordinate2D!
    var state : String!
    override func viewDidLoad() {
        self.title = "Choose your location"
        self.locationManager = CLLocationManager()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
      
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(gestureReconizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer)
    {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        //UserDefaults.setValue(coordinate, forKey: "UserCoordinates")
        self.coordinate = coordinate
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "My location"
        mapView.addAnnotation(annotation)
        getAddress(coordinate:coordinate) 
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        currLocation = manager.location!.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: currLocation, span: span)
        mapView.setRegion(region, animated: true)
        currannotation.coordinate = currLocation
        currannotation.title = "Current location"
        mapView.addAnnotation(currannotation)
        UserDefaults.standard.set(currLocation.latitude, forKey: "Latitude")
        UserDefaults.standard.set(currLocation.longitude, forKey: "Longitude")
    }
    
    func getAddress(coordinate:CLLocationCoordinate2D)
    {
        address = ""
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude:coordinate.latitude, longitude:coordinate.longitude), completionHandler: {
            placemarks, error in
            
            if error == nil && placemarks?.count != 0 {
                let placeMark = placemarks!.last
                if (placeMark?.name) != nil
                {
                    self.address.append((placeMark?.name!)! + ",")
                }
                if (placeMark?.locality) != nil
                {
                    self.address.append((placeMark?.locality!)! + ",")
                }
                if (placeMark?.administrativeArea) != nil
                {
                    self.address.append((placeMark?.administrativeArea!)! + ",")
                }
                if (placeMark?.postalCode) != nil
                {
                    self.address.append((placeMark?.postalCode!)! + ",")
                }
                if (placeMark?.country) != nil
                {
                    self.address.append((placeMark?.country!)! + ",")
                }
                self.checkAddress(address: self.address)
                
            }
        })
    }
    func checkAddress(address:String)
    {
        
        let alert = UIAlertController(title: "Verify Address", message: "Is this your chosen location?: "+address , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.returnData()}))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.resetData()}))
        self.present(alert, animated: true, completion: nil)
    }
    func returnData()
    {
        UserDefaults.standard.set(coordinate.latitude, forKey: "Latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "Longitude")
        self.navigationController?.popViewController(animated: true)
    }
    func resetData()
    {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        currannotation.title = "Current location"
        mapView.addAnnotation(currannotation)
        
    }

}
