//
//  VC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 01/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreLocation

class VC: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var btnQuickMenu: UIButton!
    
  //  var circleOverlay = MKCircle()
   // var circleRenderer = MKCircleRenderer()
//let radius: Double = 850000.0
    
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
      /*  let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(pushNotification), name: Notification.Name.UIApplicationWillResignActive, object: nil) */
        
        btnQuickMenu.layer.zPosition = 1;

        addMap(self.view)
        
         addQuickMenuButton(view: self.view, button: btnQuickMenu)
        
        addContainerView(self.view)
        
        let vc: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuContainerView")
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(vc!)
        addSubview(vc!.view, toView: container)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            
            
         
            theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 10, animated: true)
            
        }
        
       // let lat = String(currentLocation.coordinate.latitude)
       // let lng = String(currentLocation.coordinate.longitude)
        
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(VC.routeMapDoubleTapSelector(_:)))
        doubleTapGesture.numberOfTapsRequired = 3
        theMap.addGestureRecognizer(doubleTapGesture)
        
        

       // var anotation = Station(latitude: Double(lat)!, longitude: Double(lng)!)
        
     //   anotation.title = "My Crib Niggaaa"
        
      //  mapView.addAnnotation(anotation)
        
        
     //   let LAX = CLLocation(latitude: 33.9424955, longitude: -118.4080684)
      //  let JFK = CLLocation(latitude: 40.6397511, longitude: -73.7789256)
        
       // var coordinates = [LAX.coordinate, JFK.coordinate]
      //  let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        
       // mapView.addOverlay(geodesicPolyline)
        
        
    }
    
    
    @IBAction func btnQuickMenu(_ sender: UIButton) {
        

        
       // self.performSegue(withIdentifier: "quickMenuPopover", sender: self)
        
        theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 15, animated: true)
        
        print("quick menu pressed")
        
    }
    

    
    
  
    func routeMapDoubleTapSelector(_ sender: AnyObject) {
                    theMap.setCenterCoordinate((locationManager.location?.coordinate)!, zoomLevel: 10, animated: true)
        NSLog("double taps")
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
  

  /*  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blueColor()
        
        return renderer
    } */
    
}
