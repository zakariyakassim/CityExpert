//
//  ViewController.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 14/06/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyStopsContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate  {

    var nearbyStops = [NearbyStop]()
    var distanceCollection = [String]()
    var storedOffsets = [Int: CGFloat]()
    var items = [[String]]()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
            
            let lat = String(currentLocation.coordinate.latitude)
            let lng = String(currentLocation.coordinate.longitude)
            
            self.getNearestStopsFromURL("https://transportapi.com/v3/uk/bus/stops/near.json?lat="+lat+"&lon="+lng+"&app_id=b0b41ffb&app_key=9a2d44ccb23903a53c88a592e3052eef")
            
        }
        

    
        var refreshControl: UIRefreshControl!
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(self.pullToRefreshData), for: UIControlEvents.valueChanged)
        table.addSubview(refreshControl)
        
        
    }
    
    func pullToRefreshData(_ refreshControl: UIRefreshControl) {
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
        self.nearbyStops.removeAll()
        
        let lat = String(currentLocation.coordinate.latitude)
        let lng = String(currentLocation.coordinate.longitude)
        
        self.getNearestStopsFromURL("https://transportapi.com/v3/uk/bus/stops/near.json?lat="+lat+"&lon="+lng+"&app_id=b0b41ffb&app_key=9a2d44ccb23903a53c88a592e3052eef")
        
        self.table.reloadData()
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
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearbyStops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = self.table.dequeueReusableCell(withIdentifier: "NearbyStopTableViewCell")! as! NearbyStopTableViewCell
        
        cell.atcocode = self.nearbyStops[(indexPath as NSIndexPath).row].atcocode
        cell.stopName.setTitle(self.nearbyStops[(indexPath as NSIndexPath).row].name, for: UIControlState())
        cell.stopName.addTarget(self, action: #selector(self.stopNameAction), for: UIControlEvents.touchUpInside)

        return cell
    }
    
    func stopNameAction(_ sender:UIButton){
        
        let view = sender.superview!
        let cell = view.superview as! NearbyStopTableViewCell
        let indexPath = table.indexPath(for: cell)

        let currentViewController: BusTimesContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "BusTimesContainerView") as! BusTimesContainerVC
        
        currentViewController.atcocode = self.nearbyStops[((indexPath as NSIndexPath?)?.row)!].atcocode
        currentViewController.stopName = self.nearbyStops[((indexPath as NSIndexPath?)?.row)!].name
        currentViewController.stopLatitude = self.nearbyStops[((indexPath as NSIndexPath?)?.row)!].latitude
        currentViewController.stopLongitude = self.nearbyStops[((indexPath as NSIndexPath?)?.row)!].longitude
        currentViewController.stopDistance = self.nearbyStops[((indexPath as NSIndexPath?)?.row)!].distance
        
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
    }

    func getNearestStopsFromURL(_ baseURL : String){
        
        print(baseURL)
        
        let url = URL(string:baseURL)
        let request = URLRequest(url:url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if error == nil {
                
                let swiftyJSON = JSON(data: data!)
                let arrivals = swiftyJSON["stops"].arrayValue

                for arrival in arrivals {
                    
                    let name = arrival["name"].stringValue
                    let distance = arrival["distance"].stringValue
                    let atcocode = arrival["atcocode"].stringValue
                    let latitude = arrival["latitude"].stringValue
                    let longitude = arrival["longitude"].stringValue
                   // let locality = arrival["locality"].stringValue
                    
                    self.nearbyStops.append(NearbyStop(name: name, distance: distance, atcocode: atcocode, latitude: latitude, longitude:  longitude ))

                  //  let ss = scheduledTime.characters.split{$0 == ":"}.map(String.init)
                  //  let hourAdded = String(Int(ss[0])! + 1)+":"+ss[1]
           
                }

                DispatchQueue.main.async {

                    for x in self.nearbyStops {
                        let anotation = Anotation(latitude:Double(x.latitude)!, longitude: Double(x.longitude)!)
                        anotation.title = x.name
                        anotation.subtitle = String(round( self.ConvertMetersToMiles(round(Double(x.distance)!))*10)/10 ) + " Miles"
                        
                      theMap.addAnnotation(anotation)
                        
                    }
                    
                    self.table.reloadData()
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


