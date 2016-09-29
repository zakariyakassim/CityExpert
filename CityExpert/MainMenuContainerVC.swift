//
//  ViewController.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 14/06/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit


class MainMenuContainerVC: UIViewController {
   

    @IBOutlet weak var btnBus: UIButton!

    @IBOutlet weak var btnFavourites: UIButton!
    
    @IBOutlet weak var btnPlaces: UIButton!
    
    @IBOutlet weak var btnNotifyMe: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
        let allOverlays = theMap.overlays
        theMap.removeOverlays(allOverlays)
        
        self.btnBus.layer.cornerRadius = 10
        self.btnFavourites.layer.cornerRadius = 10
        self.btnPlaces.layer.cornerRadius = 10
        self.btnNotifyMe.layer.cornerRadius = 10
        
        self.btnBus.imageEdgeInsets = UIEdgeInsetsMake(20,20,20,20)
        self.btnFavourites.imageEdgeInsets = UIEdgeInsetsMake(20,20,20,20)
        self.btnPlaces.imageEdgeInsets = UIEdgeInsetsMake(20,20,20,20)
        self.btnNotifyMe.imageEdgeInsets = UIEdgeInsetsMake(20,20,20,20)
        
        
      /*  if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenterCoordinate(coor, animated: true)
        }
        
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, zoomLevel: 15, animated: true) */
  
    }


    

    
    @IBAction func btnBus(_ sender: UIButton) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "NearbyStopsContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }
    
    @IBAction func btnFav(_ sender: UIButton) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteVC")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }
    
    @IBAction func btnPlaces(_ sender: UIButton) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "PlacesTypeVC")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }
    
    
    @IBAction func NotifyMe(_ sender: UIButton) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "NotifyMeVC")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
        
    }
    
    
   }

