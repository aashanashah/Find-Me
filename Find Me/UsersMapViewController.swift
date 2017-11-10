//
//  UsersMapViewController.swift
//  Find Me
//
//  Created by Aashana on 11/8/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit
import MapKit

class UsersMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView : MKMapView!
    var list : NSArray!
    var annotitle : String!
    var address : String!
    var searchLoc : CLLocationCoordinate2D!
    var url : String!
    var taskurl : String!
    var dictLocation = Dictionary<String,String>()
    var spanLocation : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        if dictLocation["state"] != nil
        {
            spanLocation = dictLocation["state"]
        }
        else
        {
            spanLocation = dictLocation["country"]
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(spanLocation!, completionHandler: {(placemarks, error) -> Void in
            if let validPlacemark = placemarks?[0]{
                let location = validPlacemark.location?.coordinate
                let span = self.mapView.region.span
                let region = MKCoordinateRegion(center: location!, span: span)
                self.mapView.setRegion(region, animated: true)
                
            }
        })
        
        for item in list
        {
            address = ""
            if let dict = item as? [String:AnyObject]
            {
                address.append((dict["city"] as? String)!+",")
                address.append((dict["state"] as? String)!+",")
                address.append((dict["country"] as? String)!)
                annotitle = (dict["nickname"] as? String)!
                if dict["latitude"] as? String != "0.0"
                {
                    let latitude = dict["latitude"] as? Double
                    let longitude = dict["longitude"] as? Double
                    let location = CLLocationCoordinate2D(latitude: latitude!,longitude: longitude!)
                    let anno = MKPointAnnotation();
                    anno.coordinate = location;
                    anno.title = annotitle
                    mapView.addAnnotation(anno)
                }
                else
                {
                    
                    getMapBySource(mapView, address:address, title: "Your location", subtitle: "Your location")
                }
            }
            
        }
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getMapBySource(_ locationMap:MKMapView?, address:String?, title: String?, subtitle: String?)
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if placemarks == nil
            {
                let newAddress = address?.split{$0 == ","}.map(String.init)
                let add=newAddress![1]+","+newAddress![2]
                self.getMapBySource(self.mapView, address:add, title: "Your location", subtitle: "Your location")
            }
            else if let validPlacemark = placemarks?[0]{
                
                self.setSearch(LocCoordinate:(validPlacemark.location?.coordinate)!)
                if(self.searchLoc.latitude != 0.0 )
                {
                    self.setAnnotation(location: self.searchLoc)
                }
            }
        })
    }
    func setSearch(LocCoordinate:CLLocationCoordinate2D)
    {
        searchLoc=LocCoordinate
    }
    func setAnnotation(location:CLLocationCoordinate2D)
    {
        let searchPlacemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        let searchAnnotation = MKPointAnnotation()
        searchAnnotation.title = "My Location"
        
        if let Location = searchPlacemark.location
        {
            searchAnnotation.coordinate = Location.coordinate
        }
        self.mapView.addAnnotation(searchAnnotation)
    }
}
