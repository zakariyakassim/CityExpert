//
//  ViewController.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 14/06/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreLocation

class BusTimesContainerVC: UIViewController, UITabBarDelegate, UITableViewDataSource, CLLocationManagerDelegate {
   
    
var busTimes = [BusTimes]()
    
    var stopName : String?
    var atcocode : String?
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         getBusTimesFromURL("https://transportapi.com/v3/uk/bus/stop/"+atcocode!+"/live.json?app_id=03bf8009&app_key=d9307fd91b0247c607e098d5effedc97&group=route&nextbuses=no")
        
        // self.table.reloadData()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            
          //  currentLocation = locationManager.location!
            
        }
        

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("location")
                }
            }
        }
    }

    @IBAction func btnBack(sender: UIBarButtonItem) {
        
        let currentViewController: UIViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("NearbyStopsContainerView")
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        self.addSubview(currentViewController!.view, toView: self.view)
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        UIView.transitionWithView(parentView, duration: 0.5, options: UIViewAnimationOptions.TransitionCurlDown, animations: { _ in
            //   self.view.addSubview(subView)
            
            parentView.addSubview(subView)
            var viewBindingsDict = [String: AnyObject]()
            viewBindingsDict["subView"] = subView
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
                options: [], metrics: nil, views: viewBindingsDict))
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
                options: [], metrics: nil, views: viewBindingsDict))
            
            }, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busTimes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCellWithIdentifier("BusTimesCell")! as! BusTimesTableViewCell
        
        
        
        cell.routeName.setTitle(self.busTimes[indexPath.row].line_name, forState: .Normal)
        cell.routeName.layer.cornerRadius = 5
        
        cell.estimatedWait.setTitle(self.busTimes[indexPath.row].estimatedWait + " mins", forState: .Normal)
        cell.estimatedWait.layer.cornerRadius = 5
       // cell.estimatedWait.layer.borderWidth = 2
       // cell.estimatedWait.layer.borderColor = UIColor(rgba: "#CE193E").CGColor
       // cell.estimatedWait.backgroundColor = UIColor(rgba: "#eeeeee")

        cell.destination.text = self.busTimes[indexPath.row].direction
        
        cell.scheduledTime.text = self.busTimes[indexPath.row].best_departure_estimate
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let more = UITableViewRowAction(style: .Normal, title: "Reminder") { action, index in
            print("Reminder button tapped")
            let currentViewController: UIViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("CountdownTimerContainerView")
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            self.addSubview(currentViewController!.view, toView: self.view)
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        
        return [more]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    
    
    func getBusTimesFromURL(baseURL : String){
        
        
        
        let url = NSURL(string:baseURL)
        let request = NSURLRequest(URL:url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if error == nil {
                
                let swiftyJSON = JSON(data: data!)
                
                let code = swiftyJSON["atcocode"].stringValue
                
                print(code)

                //let departures = swiftyJSON["departures"].object
                
          // print( swiftyJSON["departures"]["177"].object)
               // print( swiftyJSON["departures"])
                
             /*   for departure in swiftyJSON["departures"] {
                    print("--------------------------------------")
                    print(departure)
                } */
                
                
            /*    "mode": "bus",
                "line": "N2",
                "line_name": "N2",
                "direction": "Whitehall",
                "operator": "TFL",
                "aimed_departure_time": null,
                "expected_departure_time": "01:20",
                "best_departure_estimate": "01:20",
                "source": "Countdown instant" */
                
                
                for (_, bus) in swiftyJSON["departures"] {
                    for (_, arrivals) in bus {
                        
                        
                       // print(content["line"].stringValue)
                        let line_name = arrivals["line_name"].stringValue
                        let direction = arrivals["direction"].stringValue
                        let best_departure_estimate = arrivals["best_departure_estimate"].stringValue
                        
                        

                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HHmm"
                       // dateFormatter.timeZone = NSTimeZone(name: "PST")
                        let currentTime = dateFormatter.stringFromDate(NSDate())
                        
                        
                        let time = best_departure_estimate.stringByReplacingOccurrencesOfString(":", withString: "")
                        print(Int(time)! - Int(currentTime)!)
                        
                        
                       /* let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        let selectedDate = dateFormatter.dateFromString(best_departure_estimate)
                        print(selectedDate) */
                        
                       // self.minutesFrom(selectedDate!)
                        
                      //  print(self.minutesFrom(selectedDate!))
                        
                      //  let laterDate = NSDate()
                      //  let currentDate = NSDate()
                        

                        
                       // print(interval.)
                        
                        self.busTimes.append(BusTimes(line_name: line_name, direction: direction, best_departure_estimate: best_departure_estimate, estimatedWait: String(Int(time)! - Int(currentTime)!)))
                        
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
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.busTimes.sortInPlace({ Int($1.estimatedWait) > Int($0.estimatedWait) })
                    
                     self.table.reloadData()
                }
                
            } else {
                
                print("There was an error")
            }
            
        }
        
        task.resume()
        
        print(busTimes.count)
    }

    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: NSDate(), options: []).minute
    }
    
}



