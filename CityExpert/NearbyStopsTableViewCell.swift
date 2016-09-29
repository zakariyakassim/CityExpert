//
//  BusTimesCollectionViewCell.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 14/06/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NearbyStopTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var directions = [String]()
    
    @IBOutlet weak var towards: UIButton!
    @IBOutlet weak var stopName: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var times: [Times] = []
    
    struct Times {
        var line_name : String
        var estimatedWait : String
    }

    var atcocode :String? {
        didSet{
            
            collectionView.delegate = self
            collectionView.dataSource = self
            times.removeAll()
            collectionView.reloadData()
            collectionView.backgroundColor = UIColor.clear
            
            self.getTimes("https://transportapi.com/v3/uk/bus/stop/"+atcocode!+"/live.json?app_id=03bf8009&app_key=d9307fd91b0247c607e098d5effedc97&group=route&nextbuses=yes")
            

            
        }
        willSet(newValue){
            times.removeAll()
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
          
        }
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! RoutesCollectionItem

            cell.route.setTitle(times[(indexPath as NSIndexPath).row].line_name, for: UIControlState())
            cell.route.layer.cornerRadius = 5
            cell.route.layer.borderWidth = 2
            cell.route.layer.borderColor = UIColor(rgba: "#C1C1C1").cgColor
            cell.lblEstimatedWait.text = times[(indexPath as NSIndexPath).row].estimatedWait + " mins"

        return cell
    }

    func getTimes(_ baseURL : String){
        
        print(baseURL)
        
        times.removeAll()
        self.directions.removeAll()
        
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
                        
                        if self.directions.contains(direction){
                            
                        }else{
                          self.directions.append(direction)
                        }
                        
                        
                        
                      //  self.direction = self.direction + direction + ", "
                        
                        print(estimatedWait)
                        //print(best_departure_estimate)

                      /*  let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HHmm"

                        let currentTime = dateFormatter.stringFromDate(NSDate())
                        let time = best_departure_estimate.stringByReplacingOccurrencesOfString(":", withString: "")
                        print(Int(time)! - Int(currentTime)!) */
  
                        self.times.append(Times(line_name: line_name, estimatedWait: estimatedWait!))

                    }
                }
         
                DispatchQueue.main.async {
                    
                    self.times.sort(by: { Int($1.estimatedWait) > Int($0.estimatedWait) })
                    
                   var totalTowards = ""
                  /*   for d in self.directions {
                    
                    totalTowards = totalTowards + " " + d
                    } */
                    
                    if (self.directions.count == 1){
                         totalTowards = self.directions[0]
                    }
                   
                    if (self.directions.count > 1){
                        totalTowards = self.directions[0] + ",  " + self.directions[1]+"..."
                    }
                    
                    if(self.directions.count == 0){
                        
                        self.towards.setTitle("No departures at this time.", for: UIControlState())
                        
                    } else {
                    
                    self.towards.setTitle("Towards: "+totalTowards, for: UIControlState())
                    }
                    
                 //   self.towards.setTitle(self.direction, forState: .Normal)
                    
                    self.collectionView.reloadData()
                    
                    
                    
                }
                
            } else {
                print("There was an error")
            }
        }) 
        
        task.resume()
        
    }

    
}
