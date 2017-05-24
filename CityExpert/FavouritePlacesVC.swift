//
//  FavouritePlacesVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 03/08/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreData
class FavouritePlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var table: UITableView!
    
        var fetchedPlaces: [FavPlaces]!
    @IBOutlet weak var stopsAndPlacesSegControll: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        stopsAndPlacesSegControll.selectedSegmentIndex = 1
        
        do{
            
            
            //let fetch = NSFetchRequest(entityName: "FavPlaces")
            
            
            let fetch: NSFetchRequest<FavPlaces>
            if #available(iOS 10.0, OSX 10.12, *) {
                fetch = FavPlaces.fetchRequest() as! NSFetchRequest<FavPlaces>
            } else {
                fetch = NSFetchRequest(entityName: "FavPlaces")
            }
            
            fetchedPlaces = try self.managedObjectContext.fetch(fetch) 
        } catch {
            fatalError("Failed to fetch: \(error)")
        }

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightToGoBack))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    func swipeRightToGoBack(sender:UISwipeGestureRecognizer) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuContainerView")
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
    
    @IBAction func stopsAndPlacesSegControll(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            
            let currentViewController: FavouriteStopsVC! = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteStopsVC") as! FavouriteStopsVC
            currentViewController.prevView = self.view
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
        case 1:
            
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FavouritePlacesVC")
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
        default:
            break;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "FavPlacesCell")! as! FavPlacesCell
        
        
        cell.distance.text = fetchedPlaces[(indexPath as NSIndexPath).row].distance
        cell.name.text = fetchedPlaces[(indexPath as NSIndexPath).row].name
        
       // cell.stopName.addTarget(self, action: #selector(self.stopNameAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let currentViewController: EachPlaceVC! = self.storyboard?.instantiateViewController(withIdentifier: "EachPlaceVC") as! EachPlaceVC
        
        
        
        currentViewController.fromFav = true
        
        currentViewController.place = Place(name: fetchedPlaces[(indexPath as NSIndexPath).row].name!, vicinity: fetchedPlaces[(indexPath as NSIndexPath).row].vicinity!, latitude: fetchedPlaces[(indexPath as NSIndexPath).row].latitude!, longitude: fetchedPlaces[(indexPath as NSIndexPath).row].longitude!, distance: fetchedPlaces[(indexPath as NSIndexPath).row].distance!, image: fetchedPlaces[(indexPath as NSIndexPath).row].image!, type: fetchedPlaces[(indexPath as NSIndexPath).row].type!)
        
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }

    
}
