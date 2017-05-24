//
//  ViewController.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 14/06/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreLocation


class BusTimesContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
   
       let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
        @IBOutlet weak var navigationTitle: UINavigationItem!
    
      let VCU = ViewControllerUtils()
    
var busTimes = [BusTimes]()
    
 var fromFav = false
    
    var stopName : String?
    var atcocode : String?
    var stopLatitude : String?
    var stopLongitude : String?
    var stopDistance : String?
    
    @IBOutlet weak var btnAddFav: UIBarButtonItem!
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = self.stopName
        
        btnAddFav.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Arial", size: 20)!], for: UIControlState())
        
        if(ifStopExist(atcocode!)){
            btnAddFav.title = "★"
        }
        
        let allAnnotations = theMap.annotations
        theMap.removeAnnotations(allAnnotations)
        
         getBusTimesFromURL("https://transportapi.com/v3/uk/bus/stop/"+atcocode!+"/live.json?app_id=03bf8009&app_key=d9307fd91b0247c607e098d5effedc97&group=route&nextbuses=no")
        
        print("https://transportapi.com/v3/uk/bus/stop/"+atcocode!+"/live.json?app_id=03bf8009&app_key=d9307fd91b0247c607e098d5effedc97&group=route&nextbuses=no")
        // self.table.reloadData()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
          //  currentLocation = locationManager.location!
            
        }
        
        let stopLocation = CLLocation(latitude: Double(stopLatitude!)!, longitude: Double(stopLongitude!)!)
        
        theMap.setCenterCoordinate(stopLocation.coordinate, zoomLevel: 15, animated: true)
      
        let anotation = Anotation(latitude:Double(stopLatitude!)!, longitude: Double(stopLongitude!)!)
        anotation.title = stopName
        anotation.subtitle = String(round( self.ConvertMetersToMiles(round(Double(stopDistance!)!))*10)/10 ) + " Miles"
        
        theMap.addAnnotation(anotation)
        
        theMap.selectAnnotation(anotation, animated: true)
        
        
        var refreshControl: UIRefreshControl!
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(self.pullToRefreshData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightToGoBack))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        
        
    }
    
    
    func swipeRightToGoBack(sender:UISwipeGestureRecognizer) {
        
        if(fromFav){
            
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteStopsVC")
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
        }else{
            
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "NearbyStopsContainerView")
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
        }
        
    }
    
    func pullToRefreshData(_ refreshControl: UIRefreshControl) {
        self.busTimes.removeAll()
        self.getBusTimesFromURL("https://transportapi.com/v3/uk/bus/stop/"+atcocode!+"/live.json?app_id=03bf8009&app_key=d9307fd91b0247c607e098d5effedc97&group=route&nextbuses=no")
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func ConvertMetersToMiles(_ meters : Double) -> Double{
        return (meters / 1609.344);
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
        
        if(fromFav){
            
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteStopsVC")
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
        }else{
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewController(withIdentifier: "NearbyStopsContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BusTimesCell")! as! BusTimesTableViewCell
        
        
        
        cell.routeName.setTitle(self.busTimes[(indexPath as NSIndexPath).row].line_name, for: UIControlState())
        cell.routeName.layer.cornerRadius = 5
        
        cell.estimatedWait.setTitle(self.busTimes[(indexPath as NSIndexPath).row].estimatedWait + " mins", for: UIControlState())
        cell.estimatedWait.layer.cornerRadius = 5
       // cell.estimatedWait.layer.borderWidth = 2
       // cell.estimatedWait.layer.borderColor = UIColor(rgba: "#CE193E").CGColor
       // cell.estimatedWait.backgroundColor = UIColor(rgba: "#eeeeee")

        cell.destination.text = self.busTimes[(indexPath as NSIndexPath).row].direction
        
        cell.scheduledTime.text = self.busTimes[(indexPath as NSIndexPath).row].best_departure_estimate
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        
        
        
        let alertController = UIAlertController(title: nil, message: self.busTimes[(indexPath as NSIndexPath).row].line_name + " to " + self.busTimes[(indexPath as NSIndexPath).row].direction, preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // do nothing
        }
        
        
        alertController.addAction(cancelAction)
        
        /*  let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
         // ...
         }
         alertController.addAction(OKAction) */
        
        let deleteAction = UIAlertAction(title: "Reminder", style: .destructive) { (action) in
            // print(action)
            
            
           
            
            let currentViewController: CountdownTimerContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "CountdownTimerContainerView") as! CountdownTimerContainerVC
            currentViewController.count = Int(self.busTimes[(indexPath as NSIndexPath).row].estimatedWait)!*60
            currentViewController.busAndDestination = self.busTimes[(indexPath as NSIndexPath).row].line_name + " to " + self.busTimes[(indexPath as NSIndexPath).row].direction
            
            
            currentViewController.stopName = self.stopName!
            currentViewController.atcocode = self.atcocode!
            currentViewController.stopLatitude = self.stopLatitude!
            currentViewController.stopLongitude = self.stopLongitude!
            currentViewController.stopDistance = self.stopDistance!
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
            
            
            
            
        }
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true) {
            // ...
        }

        
        
        
        
        
        
        
        
        
        

        
    }
    
    
   /*  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          //  objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    } */
    
    
    
    
    
   /*   func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Reminder") { action, index in
            print("Reminder button tapped")
            
            let currentViewController: CountdownTimerContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "CountdownTimerContainerView") as! CountdownTimerContainerVC
            currentViewController.count = Int(self.busTimes[(indexPath as NSIndexPath).row].estimatedWait)!*60
            currentViewController.busAndDestination = self.busTimes[(indexPath as NSIndexPath).row].line_name + " to " + self.busTimes[(indexPath as NSIndexPath).row].direction
            
            
            currentViewController.stopName = self.stopName!
            currentViewController.atcocode = self.atcocode!
            currentViewController.stopLatitude = self.stopLatitude!
            currentViewController.stopLongitude = self.stopLongitude!
            currentViewController.stopDistance = self.stopDistance!
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
        }
        more.backgroundColor = UIColor.lightGray
        
        
        return [more]
    } */
    
    
    
   /* func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
        
        
        
    }
    
    
     private func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {
        
        
        
        
        let more = UITableViewRowAction(style: .normal, title: "Reminder") { action, index in
            print("Reminder button tapped")
            
            let currentViewController: CountdownTimerContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "CountdownTimerContainerView") as! CountdownTimerContainerVC
            currentViewController.count = Int(self.busTimes[(indexPath as NSIndexPath).row].estimatedWait)!*60
            currentViewController.busAndDestination = self.busTimes[(indexPath as NSIndexPath).row].line_name + " to " + self.busTimes[(indexPath as NSIndexPath).row].direction
            

            currentViewController.stopName = self.stopName!
            currentViewController.atcocode = self.atcocode!
            currentViewController.stopLatitude = self.stopLatitude!
            currentViewController.stopLongitude = self.stopLongitude!
            currentViewController.stopDistance = self.stopDistance!
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
        }
        more.backgroundColor = UIColor.lightGray
        
        
        return [more]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    } */
    

    
    
    @IBAction func favouriteAction(_ sender: UIBarButtonItem) {
        if(!ifStopExist(atcocode!)){
            
            
            addStop(stopName!, atcocode: atcocode!, latitude: stopLatitude!, longitude: stopLongitude!, distance: stopDistance!)
        
            btnAddFav.title = "★"
        
       DoneHUD.showInView(self.view, message: "Added to Favourites")
            
        } else {
            deleteEachStop(atcocode!)
            
            btnAddFav.title = "☆"
        }
        
    }

    
    
    
    func getBusTimesFromURL(_ baseURL : String){
        
        
        VCU.showActivityIndicator(uiView: self.view)
        
        let url = URL(string:baseURL)
        let request = URLRequest(url:url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if error == nil {
                
                let swiftyJSON = JSON(data: data!)
                
                
                for (_, bus) in swiftyJSON["departures"] {
                    for (_, arrivals) in bus {

                        let line_name = arrivals["line_name"].stringValue
                        let direction = arrivals["direction"].stringValue
                        let best_departure_estimate = arrivals["best_departure_estimate"].stringValue
                        let estimatedWait = String(getMinutesDifference(best_departure_estimate))
                        
                        
                        

                     /*   let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HHmm"
                       // dateFormatter.timeZone = NSTimeZone(name: "PST")
                        let currentTime = dateFormatter.stringFromDate(NSDate())
                        
                        
                        let time = best_departure_estimate.stringByReplacingOccurrencesOfString(":", withString: "")
                        print(Int(time)! - Int(currentTime)!) */
                        
                        
                       /* let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        let selectedDate = dateFormatter.dateFromString(best_departure_estimate)
                        print(selectedDate) */
                        
                       // self.minutesFrom(selectedDate!)
                        
                      //  print(self.minutesFrom(selectedDate!))
                        
                      //  let laterDate = NSDate()
                      //  let currentDate = NSDate()
                        

                        
                       // print(interval.)
                        
                        self.busTimes.append(BusTimes(line_name: line_name, direction: direction, best_departure_estimate: best_departure_estimate, estimatedWait: estimatedWait!))
                        
                    }
                }
                
               // print(departures)
               /* //print(self.selectedLevel)
                for departure in departures {
                    
                    print(departure.stringValue)
                    
                    
                    
                /*    let routeName = arrivals["routeName"].stringValue
                    let destination = arrivals["destination"].stringValue
                    let estimatedWait = arrivals["estimatedWait"].stringValue
                    let scheduledTime = arrivals["scheduledTime"].stringValue
              
                    
                  //  let fullName = "First Last"
                    let ss = scheduledTime.characters.split{$0 == ":"}.map(String.init)
                    // or simply:
                    // let fullNameArr = fullName.characters.split{" "}.map(String.init)
                    
                    let hourAdded = String(Int(ss[0])! + 1)+":"+ss[1]
                    
                   // print(routeName)
                    self.busTimes.append(BusTimes(routeName: routeName, destination: destination, estimatedWait: estimatedWait, scheduledTime:  hourAdded)) */
                    
                    
                } */
                
                DispatchQueue.main.async {
                    
                    self.busTimes.sort(by: { Int($1.estimatedWait)! > Int($0.estimatedWait)! })
                    
                     self.tableView.reloadData()
                    
                     self.VCU.hideActivityIndicator(uiView: self.view)
                }
                
            } else {
                
                print("There was an error")
            }
            
        })
        
        task.resume()
        
        print(busTimes.count)
    }


    
    
    
    
    
}



