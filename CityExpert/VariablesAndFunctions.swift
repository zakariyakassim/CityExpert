//
//  VariablesAndFunctions.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 01/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import Foundation
import MapKit
import UIKit

var theMap = MKMapView()
var container = UIView()
    
func addMap(_ view: UIView){
    theMap.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2.5)
    theMap.mapType = MKMapType.standard
    theMap.isZoomEnabled = true
    theMap.isScrollEnabled = true
    theMap.showsUserLocation = true
    theMap.isMultipleTouchEnabled = true
     view.addSubview(theMap)

    
   
}


func addContainerView(_ view: UIView){
    container.frame = CGRect(x: 0, y: view.frame.height/2.5, width: view.frame.width, height: view.frame.height - view.frame.height/2.5)

    
    
    
    view.addSubview(container)

}


func addSubview(_ subView:UIView, toView parentView:UIView) {
    
    
    UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions(), animations: {
        
        subView.alpha = 0.0
        
        }, completion: nil)
    
    UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions(), animations: {
        
        subView.alpha = 1.0
        
        }, completion: nil)
    
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        
        
    
    
   /* UIView.transitionWithView(parentView, duration: 0.5, options: UIViewAnimationOptions.anim, animations: { _ in
        //   self.view.addSubview(subView)
        
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        
        }, completion: nil) */
    
}


extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy:MM:dd:HH:mm"
      //  dateStringFormatter.timeZone = NSTimeZone(name: "UTC")
       // dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
       // (self as NSDate).init(timeInterval:0, since:d)
        self.init(timeInterval:0, since:d)
    }
}




func minutesFrom(_ date: Date) -> Int{
    return (Calendar.current as NSCalendar).components(.minute, from: Date(), to: date, options: []).minute!
}



func getMinutesDifference(_ time:String) -> String{
    
    
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy:MM:dd"
    let date = dateFormatter.string(from: Date())
    
    let DateAndTime = Date(dateString: date+":"+time)
    
   print(date+":"+time)
    
    print(DateAndTime)
    
    print(minutesFrom(DateAndTime))
    print(Date())
    print("")
    
    return String(minutesFrom(DateAndTime)+1)
}
















func loadImageFromUrl(_ url: String, view: UIImageView){
    
    // Create Url from string
    let url = URL(string: url)!
    
    // Download task:
    // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
        // if responseData is not null...
        if let data = responseData{
            
            // execute in UI thread
            DispatchQueue.main.async(execute: { () -> Void in
                view.image = UIImage(data: data)
            })
        }
    }) 
    
    // Run task
    task.resume()
}
