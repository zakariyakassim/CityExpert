//
//  CountdownTimerContainerVC.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 11/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import AVFoundation



class CountdownTimerContainerVC: UIViewController {
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn11: UIButton!
    @IBOutlet weak var btn12: UIButton!
    @IBOutlet weak var btn13: UIButton!
    @IBOutlet weak var btn14: UIButton!
    @IBOutlet weak var btn15: UIButton!
    
    var isPlaying = false
    
    var vibrateTimes = 6
    
    @IBOutlet weak var countDown: UIButton!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    var buttons: [UIButton] = []
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    //var timer = NSTimer()
    
    var selectedMin = 0
    
    var count: Int?
    
    var stopName : String?
    var atcocode : String?
    var stopLatitude : String?
    var stopLongitude : String?
    var stopDistance : String?
    
    var timer = Timer()
    
    
    var busAndDestination: String?
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        if (isPlaying){
          player?.stop()
        self.btnBack.title = "Back"
            isPlaying = false
        }else{
        
        
        let currentViewController: BusTimesContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "BusTimesContainerView") as! BusTimesContainerVC
       
        currentViewController.stopName = self.stopName!
        currentViewController.atcocode = self.atcocode!
        currentViewController.stopLatitude = self.stopLatitude!
        currentViewController.stopLongitude = self.stopLongitude!
        currentViewController.stopDistance = self.stopDistance!
        
        
        
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitle.title = self.busAndDestination!
        
        countDown.setTitle("", for: UIControlState())
        countDown.layer.borderColor = UIColor(rgba: "#E31833").cgColor
       // btn1.layer.backgroundColor = UIColor.black.cgColor
      //  countDown.layer.borderWidth = 2
      //  countDown.layer.cornerRadius = 5
        
        
        
        
       // let notificationCenter = NotificationCenter.default
      //  notificationCenter.addObserver(self, selector: #selector(pushNotification), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        
       
        
        buttons.append(btn1)
        buttons.append(btn2)
        buttons.append(btn3)
        buttons.append(btn4)
        buttons.append(btn5)
        buttons.append(btn6)
        buttons.append(btn7)
        buttons.append(btn8)
        buttons.append(btn9)
        buttons.append(btn10)
        buttons.append(btn11)
        buttons.append(btn12)
        buttons.append(btn13)
        buttons.append(btn14)
        buttons.append(btn15)
        
        for button in buttons{

          //  button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.layer.cornerRadius = 2
            button.addTarget(self, action: #selector(action), for: UIControlEvents.touchUpInside)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        disableUnwantedKeys()
        
        
        
      //  let notificationCenter = NotificationCenter.default
        
        //UIApplicationDidEnterBackgroundNotification & UIApplicationWillEnterForegroundNotification shouldn't be quoted
       /* notificationCenter.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        notificationCenter.addObserver(self, selector: #selector(pushNotification), name: NSNotification.Name.UIApplicationWillResignActive, object: nil) */
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightToGoBack))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    func swipeRightToGoBack(sender:UISwipeGestureRecognizer) {
        
        let currentViewController: BusTimesContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "BusTimesContainerView") as! BusTimesContainerVC
        
        currentViewController.stopName = self.stopName!
        currentViewController.atcocode = self.atcocode!
        currentViewController.stopLatitude = self.stopLatitude!
        currentViewController.stopLongitude = self.stopLongitude!
        currentViewController.stopDistance = self.stopDistance!
        
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(currentViewController!)
        addSubview(currentViewController!.view, toView: self.view)
        
    }
        
    
    
    
    
    func pushNotification() {
        
        print("Background mode")
       // print(count!)
       // print(selectedMin*60)
       // print(count! - selectedMin*60)
      /*  let notification = UILocalNotification()
        notification.alertAction = "Go back to App"
        notification.soundName = "Morse.aiff"
        notification.alertBody = String(selectedMin) + " mins left."
        notification.alertTitle = self.busAndDestination!
        notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval(count! - (selectedMin*60))) as Date
        UIApplication.shared.scheduleLocalNotification(notification) */
        
      
        create(id: "zz", fireDate: NSDate(timeIntervalSinceNow: TimeInterval(count! - (selectedMin*60))), soundName: "Morse.aiff", alertTitle: self.busAndDestination!, alertBody: String(selectedMin) + " mins left.", alertAction: "Go back to App")
        
        
    }
    
    
    func didEnterBackground() {
      print("entered background")
    
      Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    
    }
    
    func didBecomeActive() {
       print("its active")
    }
    
    
    func update(_ timer: Timer) {
        
        print("yes")
        
        let minutes = count! / 60
        let seconds = count! % 60
        
        if(count! > 0) {

            countDown.setTitle(String(minutes) + ":" + String(seconds), for: UIControlState())
            count! = count! - 1
        }
        
        disableUnwantedKeys()
        
        if (count == (selectedMin*60)-1){
            print("done")
            
           // playSound()
            
            timer.invalidate()
        }
    }

    func playSound() {
        let url = Bundle.main.url(forResource: "alarm1", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            player.prepareToPlay()
            player.play()
            isPlaying = true
            self.btnBack.title = "Stop"

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error as NSError {
            print(error.description)
        }
    }

    func action(_ sender: UIButton){
        

        
        for button in buttons{
            button.isEnabled = true
            button.layer.backgroundColor = UIColor(rgba: "#CC0033").cgColor
        }
        
        sender.isEnabled = false
        sender.layer.backgroundColor = UIColor(rgba: "#df4b62").cgColor
        
        print(sender.currentTitle!)
        selectedMin = Int(sender.currentTitle!)!
        lblMessage.text = "Remind me in " + String(selectedMin) + " minutes."
        
        disableUnwantedKeys()
        
        
        let alertController = UIAlertController(title: nil, message: "Remind me in " + String(selectedMin) + " minutes.", preferredStyle: .actionSheet)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // do nothing
        }
        
        
        alertController.addAction(cancelAction)
        

        
        let addAction = UIAlertAction(title: "Add to Notifications", style: .destructive) { (action) in
            // print(action)
            
            LocalNotificationHelper.sharedInstance().cancelNotification(key: self.busAndDestination!)
            
            let userInfo = ["url" : "www.cityexpert.co.uk"]
            LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey(key: self.busAndDestination!, title: self.busAndDestination!, message: String(self.selectedMin) + " mins left.", date: NSDate(timeIntervalSinceNow: TimeInterval(self.count! - (self.selectedMin*60))), userInfo: userInfo as [NSObject : AnyObject]?)
            

            
            
            
            let currentViewController: BusTimesContainerVC! = self.storyboard?.instantiateViewController(withIdentifier: "BusTimesContainerView") as! BusTimesContainerVC
            
            currentViewController.stopName = self.stopName!
            currentViewController.atcocode = self.atcocode!
            currentViewController.stopLatitude = self.stopLatitude!
            currentViewController.stopLongitude = self.stopLongitude!
            currentViewController.stopDistance = self.stopDistance!
            
            
            
            currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChildViewController(currentViewController!)
            addSubview(currentViewController!.view, toView: self.view)
            
        }
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true) {
            // ...
        }

        
        

        
        
        
        
       // find(id: self.busAndDestination!)
        
      //  UIApplication.shared.cancelLocalNotification(find(id: self.busAndDestination!)!)
        
       // print("zaaaaaaaaaaaaaak " + String(describing: find(id: self.busAndDestination!)!))
        
     //   create(id: self.busAndDestination!, fireDate: NSDate(timeIntervalSinceNow: TimeInterval(count! - (selectedMin*60))), soundName: "Morse.aiff", alertTitle: self.busAndDestination!, alertBody: String(selectedMin) + " mins left.", alertAction: "Go back to App")
        
        
        
        
      /*  let alertController = UIAlertController(title: "Background Notification", message: "Add this to notification center", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let notification = UILocalNotification()
            notification.alertAction = "Go back to App"
            notification.soundName = "Morse.aiff"
            notification.alertBody = self.busAndDestination!
            notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval(self.count! - (self.selectedMin*60))) as Date
            UIApplication.shared.scheduleLocalNotification(notification)
            
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        } */
        
        
        
    }
    
    func disableUnwantedKeys(){
        
        for (index, button) in buttons.enumerated() {
           
            if (index > (count!/60)-1) {
                button.isEnabled = false
                button.layer.backgroundColor = UIColor.gray.cgColor
            }
            
        }
        
        

        
    }

    
    
}
