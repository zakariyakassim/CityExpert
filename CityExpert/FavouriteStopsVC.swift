//
//  FavouriteStopsVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 25/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreData


class  FavouriteStopsVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

       var prevView : UIView?
    @IBOutlet weak var table: UITableView!
    
    var fetchedStops: [FavStops]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        do{
           // let fetch = NSFetchRequest(entityName: "FavStops")
            
            let fetch: NSFetchRequest<FavStops>
            if #available(iOS 10.0, OSX 10.12, *) {
                fetch = FavStops.fetchRequest() as! NSFetchRequest<FavStops>
            } else {
                fetch = NSFetchRequest(entityName: "FavStops")
            }
            
            fetchedStops = try self.managedObjectContext.fetch(fetch) 
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "FavStopTableViewCell")! as!FavStopTableViewCell

        
        cell.atcocode = fetchedStops[(indexPath as NSIndexPath).row].atcocode
        cell.stopName.setTitle(fetchedStops[(indexPath as NSIndexPath).row].name, for: UIControlState())
        
        cell.stopName.addTarget(self, action: #selector(self.stopNameAction), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func stopNameAction(_ sender:UIButton){
        
        let view = sender.superview!
        let cell = view.superview as! FavStopTableViewCell
        let indexPath = table.indexPath(for: cell)
        
        let currentViewController: BusTimesContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "BusTimesContainerView") as! BusTimesContainerVC
        
        currentViewController.fromFav = true
        
        currentViewController.atcocode = self.fetchedStops[((indexPath as NSIndexPath?)?.row)!].atcocode
        currentViewController.stopName = self.fetchedStops[((indexPath as NSIndexPath?)?.row)!].name
        currentViewController.stopLatitude = self.fetchedStops[((indexPath as NSIndexPath?)?.row)!].latitude
        currentViewController.stopLongitude = self.fetchedStops[((indexPath as NSIndexPath?)?.row)!].longitude
        currentViewController.stopDistance = self.fetchedStops[((indexPath as NSIndexPath?)?.row)!].distance
        
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

    
}
