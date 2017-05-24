//
//  EachPlaceVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 20/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreLocation

class EachPlaceVC: UIViewController, CLLocationManagerDelegate {
    
   let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var btnAddFav: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    var currentLocation = CLLocation()
    
    var place: Place?
    
    var fromFav = false
    
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var navigationTitle: UINavigationItem!
 
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    let VCU = ViewControllerUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(ifPlaceExist((place?.vicinity)!)){
            btnAddFav.title = "★"
        }
        
        btnAddFav.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Arial", size: 20)!], for: UIControlState())
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
       navigationTitle.title = place?.name
        lblAddress.text = place?.vicinity
        lblDistance.text = (place?.distance)! + " Miles"
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locationManager.location!
            
        }
        
     //   let lat = String(currentLocation.coordinate.latitude)
    //    let lng = String(currentLocation.coordinate.longitude)
        
        currentLocation = locationManager.location!

        
        

        
        if let checkedUrl = URL(string: (place?.image)!) {
            imageView.contentMode = .scaleAspectFit
            downloadImage(checkedUrl)
        }
        
        
        
        let placeLocation = CLLocation(latitude: Double((place?.latitude)!)!, longitude: Double((place?.longitude)!)!)
        
        theMap.setCenterCoordinate(placeLocation.coordinate, zoomLevel: 15, animated: true)
        
        let anotation = Anotation(latitude:Double((place?.latitude)!)!, longitude: Double(place!.longitude)!)
        anotation.title = place?.name
        anotation.subtitle = String(round( self.ConvertMetersToMiles(round(Double((place?.distance)!)!))*10)/10 ) + " Miles"
        
        theMap.addAnnotation(anotation)
        
        theMap.selectAnnotation(anotation, animated: true)

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightToGoBack))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    func swipeRightToGoBack(sender:UISwipeGestureRecognizer) {
        
        if(fromFav){
            
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FavouritePlacesVC")
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
        }else{
            
            let currentViewController: PlacesVC! = self.storyboard?.instantiateViewController(withIdentifier: "PlacesVC") as! PlacesVC
            
            currentViewController.type = place?.type
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
        }
        
    }
    
    
    
    @IBAction func favouriteAction(_ sender: UIBarButtonItem) {
        if(!ifPlaceExist((place?.vicinity)!)){
            
            addPlace((place?.name)!, vicinity: (place?.vicinity)!, latitude: (place?.latitude)!, longitude: (place?.longitude)!, distance: (place?.distance)!, image: (place?.image)!, type: (place?.type)!)
            

            
            btnAddFav.title = "★"
            
            DoneHUD.showInView(self.view, message: "Added to Favourites")
            
        } else {

            deleteEachPlace((place?.vicinity)!)
            
            btnAddFav.title = "☆"
        }
        
    }
    
    
    
    
    
    
    func downloadImage(_ url: URL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ))
        getDataFromUrl(url: url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
  /*  func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        
        URLSession.shared.dataTask(with: url) {data, response, err in
            completion(data, response, err)
            }.resume()
        
       /* URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
            }) .resume() */
    } */
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        
        if(fromFav){
            
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FavouritePlacesVC")
                        
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
        }else{
            
            let currentViewController: PlacesVC! = self.storyboard?.instantiateViewController(withIdentifier: "PlacesVC") as! PlacesVC
            
            currentViewController.type = place?.type
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
        }
        

    }
    
    func ConvertMetersToMiles(_ meters : Double) -> Double{
        return (meters / 1609.344);
    }
    
}
