//
//  ShowUsersViewController.swift
//  Find Me
//
//  Created by Aashana on 11/4/17.
//  Copyright © 2017 Aashana. All rights reserved.
//

import UIKit
import MapKit

class ShowUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    var list : NSArray!
    @IBOutlet var userTable : UITableView!
    @IBOutlet var mapView : MKMapView!
    let cellReuseIdentifier = "UsersTableViewCell"
    var annotitle : String!
    var address : String!
    var searchLoc : CLLocationCoordinate2D!

    override func viewDidLoad() {
        if list.count > 0
        {
            userTable.reloadData()
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
                        
                        let span = MKCoordinateSpanMake(0.8, 0.8)
                        let region = MKCoordinateRegion(center: location, span: span)
                        mapView.setRegion(region, animated: true)
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
        }
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UsersTableViewCell = self.userTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UsersTableViewCell
        if let name = list[indexPath.row] as? [String:AnyObject] {
            cell.name.text = name["nickname"] as? String
        }
        if let city = list[indexPath.row] as? [String:AnyObject] {
            cell.city.text = (city["city"] as? String)! + ","
        }
        if let state = list[indexPath.row] as? [String:AnyObject] {
            cell.state.text = (state["state"] as? String)! + ","
        }
        if let country = list[indexPath.row] as? [String:AnyObject] {
            cell.country.text = country["country"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 135.0
    }
    @IBAction func segmentValueChanged(sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            userTable.isHidden = false
            mapView.isHidden=true
        }
        else
        {
            userTable.isHidden = true
            mapView.isHidden=false
        }
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
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let searchregion = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(searchregion, animated: true)
        if let Location = searchPlacemark.location
        {
            searchAnnotation.coordinate = Location.coordinate
        }
        self.mapView.addAnnotation(searchAnnotation)
    }
}

