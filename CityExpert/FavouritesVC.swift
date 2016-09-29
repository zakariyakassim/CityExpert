//
//  FavouritesVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 24/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit

class FavouritesVC : UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentViewController: FavouriteStopsVC! = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteStopsVC") as! FavouriteStopsVC
        currentViewController.prevView = self.view
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
    }
}
