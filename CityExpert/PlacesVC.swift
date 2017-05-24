//
//  PlacesTypeVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 19/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var API_KEY = "AIzaSyBVz1dDxXIQij0wGw45AfIOiA2B8nZByn8";
    
    let VCU = ViewControllerUtils()
    
    var places = [Place]()
    
    var locationManager = CLLocationManager()

    var currentLocation = CLLocation()

    var type : String?
    

    @IBOutlet weak var navigationTitle: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
    let formattedType = type!.replacingOccurrences(of: "_", with: " ").capitalized
        
        navigationTitle.title = formattedType
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            
            let lat = String(currentLocation.coordinate.latitude)
            let lng = String(currentLocation.coordinate.longitude)
            
            currentLocation = locationManager.location!
            
            theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 9, animated: true)
            
            getNearestPlaces(type!, lat: lat, lng: lng)
            
        }
        

        
        var refreshControl: UIRefreshControl!
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(self.pullToRefreshData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightToGoBack))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    func swipeRightToGoBack(sender:UISwipeGestureRecognizer) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "PlacesTypeVC")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }
    
    func pullToRefreshData(_ refreshControl: UIRefreshControl) {
        
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            
            let allAnnotations = theMap.annotations
            theMap.removeAnnotations(allAnnotations)
            
            self.places.removeAll()
            
            
            let lat = String(currentLocation.coordinate.latitude)
            let lng = String(currentLocation.coordinate.longitude)
            
            currentLocation = locationManager.location!
            
            theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 9, animated: true)
            
            getNearestPlaces(type!, lat: lat, lng: lng)
            

            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("location")
                }
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "PlacesTypeVC")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let currentViewController: EachPlaceVC! = self.storyboard?.instantiateViewController(withIdentifier: "EachPlaceVC") as! EachPlaceVC
        
        currentViewController.place = places[(indexPath as NSIndexPath).row]
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PlacesCell")! as! PlacesCell
        

        
        cell.type.text = self.places[(indexPath as NSIndexPath).row].name
        
         cell.distance.text = self.places[(indexPath as NSIndexPath).row].distance + " Miles"
        return cell
        
    }
    

    func getNearestPlaces(_ type:String, lat:String, lng:String){
        
        VCU.showActivityIndicator(uiView: self.view)

        let url = URL(string:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + lat + "," + lng + "&radius=10000&types=" + type + "&key=" + API_KEY)
        
        let request = URLRequest(url:url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if error == nil {
                
                let swiftyJSON = JSON(data: data!)
                
                let results = swiftyJSON["results"].arrayValue
  
                for result in results {
                    
                    let name = result["name"].stringValue
                    let vicinity = result["vicinity"].stringValue
                    let lat = result["geometry"]["location"]["lat"].stringValue
                    let lng = result["geometry"]["location"]["lng"].stringValue
                    var image = "no photo"
                    
                    if let photos = result["photos"].arrayValue.first {
                        // photo = photos["photo_reference"].stringValue
                        
                        image = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + photos["photo_reference"].stringValue + "&key=" + self.API_KEY
                    }
                    
                    let placeLocation:CLLocation = CLLocation(latitude: Double(lat)!, longitude: Double(lng)!)
                    
                    let distance:CLLocationDistance = self.currentLocation.distance(from: placeLocation)
                    
                    let miles = String(round( self.ConvertMetersToMiles(round(distance))*10)/10 )
                    print("Distance: " + String(round( self.ConvertMetersToMiles(round(distance))*10)/10 ))
                    self.places.append(Place(name: name, vicinity: vicinity, latitude: lat, longitude: lng, distance: miles, image: image, type: type))
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.places.sort(by: { Double($1.distance) > Double($0.distance) })
                  // print(self.places.first?.image)
                    self.tableView.reloadData()
                    
                    for x in self.places {
                        let anotation = Anotation(latitude:Double(x.latitude)!, longitude: Double(x.longitude)!)
                        anotation.title = x.name
                        anotation.subtitle = String(round( self.ConvertMetersToMiles(round(Double(x.distance)!))*10)/10 ) + " Miles"
                        
                        theMap.addAnnotation(anotation)
                        
                    }
                    
                   self.VCU.hideActivityIndicator(uiView: self.view)
                }
                
            } else {
                
                print("There was an error")
            }
            
        }) 
        
        task.resume()
      
    }
    
    func ConvertMetersToMiles(_ meters : Double) -> Double{
    return (meters / 1609.344);
    }
 
}



