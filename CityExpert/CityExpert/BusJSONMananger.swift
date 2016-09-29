//
//  BusJSONMananger.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 14/06/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//


import UIKit

class BusJSONManager{
    
    
    var busTimes = [String]()
    
    struct BusTimes {
        
        var routeName : String
        var destination : String
        var estimatedWait : String
        var scheduledTime : String
        
    }

    
    
    
   // let baseURL = "https://raw.githubusercontent.com/anumanum/ModuleData/master/modules"
    
//http://countdown.tfl.gov.uk/stopBoard/52975
    
    func getBusTimesFromURL(baseURL : String){
        
    
        
        let url = NSURL(string:baseURL)
        let request = NSURLRequest(URL:url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if error == nil {
                
                let swiftyJSON = JSON(data: data!)
                let arrivals = swiftyJSON["arrivals"].arrayValue
                //print(self.selectedLevel)
                for arrivals in arrivals {
                    
                  //  let routeName = arrivals[0]["routeName"].stringValue
                    let destination = arrivals["destination"].stringValue
                //    let estimatedWait = arrivals["estimatedWait"].stringValue
                //    let scheduledTime = arrivals["scheduledTime"].stringValue
                    
                  //  let bustime = BusTimes(routeName: routeName, destination: destination, estimatedWait: estimatedWait, scheduledTime:  scheduledTime)

                   // self.busTimes.insert(bustime, atIndex: 0)
                    
                   // self.busTimes.append(BusTimes(routeName: routeName, destination: destination, estimatedWait: estimatedWait, scheduledTime:  scheduledTime))
                    self.busTimes.append(destination)
                   // print("1111")
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                   // self.moduleInfoTable.reloadData()
                }
                
            } else {
                
                print("There was an error")
            }
            
           // print(self.busTimes.count)
        }
        
        task.resume()

    }
    

    
    
    
    
    func test(){
        
     /*   let json = JSON(data: dataFromNetworking)
        if let userName = json[0]["user"]["name"].string {
            //Now you got your value
        } */
    }
    
    
    
  /*  func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    } */
    
    
    
}
