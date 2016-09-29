//
//  NotifyMeVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 24/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class NotifyMeVC : UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var table: UITableView!
     var stops = [Stop]()
   // @IBOutlet weak var lblDistance: UILabel!
    var circleDistance = 300
    var circle:MKCircle!
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    var destinationLocation = CLLocation()
    
    
    @IBOutlet weak var lblSearching: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblSearching.isHidden = true
       
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            //catching the error.
        }
        
        
        
        let url = Bundle.main.url(forResource: "alarm1", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)

        } catch let error as NSError {
            print(error.description)
        }
        
        
        self.locationManager.allowsBackgroundLocationUpdates = true
        
      /*  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            self.loadStops("newacres")
            dispatch_async(dispatch_get_main_queue(), {
                // update some UI
                self.table.reloadData()
                });
            }); */
        
        theMap.delegate = self
        
        searchBar.layer.borderWidth = 0;
        searchBar.layer.borderColor = UIColor.clear.cgColor
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
        let allOverlays = theMap.overlays
        theMap.removeOverlays(allOverlays)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
            print("vvvvvvvvvv")
        }
        
      //  let lat = String(currentLocation.coordinate.latitude)
      //  let lng = String(currentLocation.coordinate.longitude)

        
        
        
      //  loadOverlayForRegionWithLatitude(destinationLocation.coordinate.latitude, andLongitude: destinationLocation.coordinate.longitude, radius: 100)
        
        
  

        
    }
   
    
/*   func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        
        let distance:CLLocationDistance = self.currentLocation.distance(from: destinationLocation)
        
        print("its upadating location")
    
       // print(player?.playing)
        
        if (Int(distance) < Int(circleDistance)) {
            print("its reached")
            
            let myBool: Bool! = player!.isPlaying
            
            print(myBool!)
            
            if (!myBool) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                player!.prepareToPlay()
                player!.play()
            }
       
           // self.playSound()
            
        }else{
            player?.stop()
        }
        
        
    } */
    

    
  /*  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let distance:CLLocationDistance = self.currentLocation.distanceFromLocation(destinationLocation)
        
        print("its reached")
        
        if (Int(distance) < Int(circleDistance)) {
            print("its reached")
            
            self.playSound()
        }else{
            player?.stop()
        }
        
    }
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        self.stops.removeAll()
        self.table.reloadData()
        
        self.lblSearching.isHidden = false
        
        // DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute:  
        
        DispatchQueue.global(qos: .background).async(execute: {
            // do some task
            self.loadStops((searchBar.text?.lowercased())!)
            
            DispatchQueue.main.async(execute: {
                // update some UI
                self.lblSearching.isHidden = true
                self.table.reloadData()
            });
        });
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {


    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm1", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            let myBool: Bool! = player.isPlaying
            
            print(myBool!)
            
            if (myBool!) {
            player.prepareToPlay()
            player.play()
            } else {
                
            }

            
          //  AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        circleDistance = Int(sender.value)
        
       
        
      //  print(currentValue)
        
        if(destinationLocation.coordinate.latitude != 0.0){
            self.loadOverlayForRegionWithLatitude(destinationLocation.coordinate.latitude, andLongitude: destinationLocation.coordinate.longitude, radius: circleDistance)
        }
        
    
       //lblDistance.text = "\(circleDistance)"
        
        
      /*  let distance:CLLocationDistance = self.currentLocation.distanceFromLocation(destinationLocation)
        
        if (Int(distance) < Int(circleDistance)) {
            print("its reached")
            self.playSound()
        }else{
            player?.stop()
        } */
       
        
      
        
    }
    
    

    func loadOverlayForRegionWithLatitude(_ latitude: Double, andLongitude longitude: Double, radius: Int) {
       

        theMap.removeOverlays(theMap.overlays)
        
        destinationLocation = CLLocation(latitude: latitude, longitude: longitude)

       //  theMap.setCenterCoordinate(destinationLocation.coordinate, zoomLevel: 10, animated: true)
        
        theMap.setCenter(destinationLocation.coordinate, animated: true)
        
        circle = MKCircle(center: destinationLocation.coordinate, radius: CLLocationDistance(radius))
        
      /*  var points: [CLLocation]
        points = [CLLocation(latitude: destinationLocation.coordinate.latitude, longitude: destinationLocation.coordinate.longitude), CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)]
        
        
        
        addPolyLineToMap(points)*/

      //  theMap.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 7, longitudeDelta: 7)), animated: true)

        
        
        theMap.add(circle)
    }
    
    
    
  /*  func addPolyLineToMap(_ locations: [CLLocation?])
    {
        var coordinates = locations.map({ _ in (location: CLLocation!) -> _ in
            return location.coordinate
        })
        
        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        theMap.add(polyline)
    } */
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "NotifyMeCell")! as! NotifyMeCell
        
        cell.stopName.text = stops[(indexPath as NSIndexPath).row].stopName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            self.loadOverlayForRegionWithLatitude(stops[(indexPath as NSIndexPath).row].latitude, andLongitude: stops[(indexPath as NSIndexPath).row].longitude, radius: circleDistance)
        
        
        theMap.removeAnnotations(theMap.annotations)
        
        let anotation = Anotation(latitude:stops[(indexPath as NSIndexPath).row].latitude, longitude: stops[(indexPath as NSIndexPath).row].longitude)
        anotation.title = stops[(indexPath as NSIndexPath).row].stopName

        
        theMap.addAnnotation(anotation)
        
       // theMap.selectAnnotation(anotation, animated: true)
    }
    
  
    
    func loadStops(_ text : String) {
        
       stops.removeAll()
        
        if let path = Bundle.main.path(forResource: "AllStops", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj = JSON(data: data)
                
                
                if jsonObj != JSON.null {
                    
                    for x in jsonObj.arrayValue {
                        
                      //  print( x["Stop_Name"].stringValue)
                        
                        if (x["Stop_Name"].stringValue.lowercased().contains(text)) {
                      
                            stops.append(Stop(stopName: x["Stop_Name"].stringValue.capitalized, latitude: x["Latitude"].doubleValue, longitude: x["Longitude"].doubleValue))
                        }
                        
                    }
                    
                    
                    
                    // print("jsonData:\(jsonObj)")
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
      
    }
    
    }



