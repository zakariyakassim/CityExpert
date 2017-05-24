import UIKit


     let IDKey = "IDKey" as NSObject
     let FireDateKey = "FireDateKey" as NSObject
    
public  func create(id: String, fireDate: NSDate, soundName: String? = nil, alertTitle: String? = nil, alertBody: String, alertAction: String? = nil) {
        let notification = UILocalNotification()
        notification.soundName = soundName
        
        notification.fireDate = fireDate as Date
        notification.timeZone = NSTimeZone.default
        
        
        notification.alertTitle = alertTitle
        notification.alertBody = alertBody
        
        
        notification.alertAction = alertAction
        if alertAction == nil {
            notification.hasAction = false
        }
        
        var userInfo = [NSObject : AnyObject]()

        userInfo[IDKey] = id as AnyObject?
        userInfo[FireDateKey] = NSDate()
        notification.userInfo = userInfo
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    public func find(id: String) -> UILocalNotification? {

        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            if let userInfo = notification.userInfo {
                if let key = userInfo[IDKey] as? String {
                    if key == id {
                        print("fouuuuuuuuuuuund")
                        return notification
                    }
                }
            }
        }
        
        return nil
    }
    
    public func delete(id: String) {
        if let notification = find(id: id) {
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
