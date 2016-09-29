//
//  CoreData.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 27/07/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//

import UIKit
import CoreData

let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext


func addStop(_ name : String, atcocode : String, latitude : String, longitude : String, distance : String) {
    
    let entity = NSEntityDescription.insertNewObject(forEntityName: "FavStops", into: managedObjectContext) as! FavStops
    
 
    entity.setValue(name, forKey: "name")
    entity.setValue(atcocode, forKey: "atcocode")
    entity.setValue(latitude, forKey: "latitude")
    entity.setValue(longitude, forKey: "longitude")
    entity.setValue(distance, forKey: "distance")

    
    print("Addeeeeeeeeed")
    
    do {
        try managedObjectContext.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}


func deleteEachStop(_ indexPath : IndexPath, tableView : UITableView){
    do {
        
   
           // let fetch = NSFetchRequest(entityName: "FavStops")
        
  

        let fetch: NSFetchRequest<FavStops>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetch = FavStops.fetchRequest() as! NSFetchRequest<FavStops>
        } else {
            fetch = NSFetchRequest(entityName: "FavStops")
        }
        
         var fetchedExercises = try managedObjectContext.fetch(fetch)
        
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        context.delete(fetchedExercises[(indexPath as NSIndexPath).row])
        fetchedExercises.remove(at: (indexPath as NSIndexPath).row)
        
        try context.save()
    } catch _ {
    }
    
    
   // tableView.deleteItemsAtIndexPaths([indexPath])
    tableView.deleteRows(at: [indexPath], with: .fade)

    
}


func deleteEachStop(_ atcocode: String) {
    do {
        
        
      //  let fetch = NSFetchRequest(entityName: "FavStops")
      
        
        
        let fetch: NSFetchRequest<FavStops>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetch = FavStops.fetchRequest() as! NSFetchRequest<FavStops>
        } else {
            fetch = NSFetchRequest(entityName: "FavStops")
        }

        let fetchedExercises = try managedObjectContext.fetch(fetch) 
        
        for x in fetchedExercises {
            
            if (x.atcocode == atcocode) {
                managedObjectContext.delete(x)
                print("deleted")
            }
        }
        
    } catch _ {
    }

    
  
    
}


func ifStopExist(_ atcocode: String) -> Bool{
    do {
        
        
       // let fetch = NSFetchRequest(entityName: "FavStops")
        
        
        let fetch: NSFetchRequest<FavStops>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetch = FavStops.fetchRequest() as! NSFetchRequest<FavStops>
        } else {
            fetch = NSFetchRequest(entityName: "FavStops")
        }
        
        
        let fetchedExercises = try managedObjectContext.fetch(fetch)
        
        
        for x in fetchedExercises {
            
            if (x.atcocode == atcocode) {
                return true
            }
        }

    } catch _ {
    }
    
    
 return false
    
    
}




func addPlace(_ name : String, vicinity : String, latitude : String, longitude : String, distance : String, image : String, type : String) {
    
    let entity = NSEntityDescription.insertNewObject(forEntityName: "FavPlaces", into: managedObjectContext) as! FavPlaces
    
    
    entity.setValue(name, forKey: "name")
    entity.setValue(vicinity, forKey: "vicinity")
    entity.setValue(latitude, forKey: "latitude")
    entity.setValue(longitude, forKey: "longitude")
    entity.setValue(distance, forKey: "distance")
    entity.setValue(image, forKey: "image")
    entity.setValue(type, forKey: "type")
    
    print("Addeeeeeeeeed")
    
    do {
        try managedObjectContext.save()
    } catch {
        fatalError("Failure to save context: \(error)")
    }
}


func ifPlaceExist(_ vicinity: String) -> Bool{
    do {
        
        
      //  let fetch = NSFetchRequest(entityName: "FavPlaces")
        
       // let fetch = NSFetchRequest<NSFetchRequestResult> = FavPlaces.fetchRequest()
        
        
        let fetch: NSFetchRequest<FavPlaces>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetch = FavPlaces.fetchRequest() as! NSFetchRequest<FavPlaces>
        } else {
            fetch = NSFetchRequest(entityName: "FavPlaces")
        }
        
      //  let fetch: NSFetchRequest<FavPlaces> = FavPlaces.fetchRequest() as! NSFetchRequest<FavPlaces>
        
        let fetchedExercises = try managedObjectContext.fetch(fetch)
        
        
        
        for x in fetchedExercises {
            
            if (x.vicinity == vicinity) {
                return true
            }
        }
        
    } catch _ {
    }
    
    
    return false
    
    
}


func deleteEachPlace(_ vicinity: String){
    do {
        
        
      //  let fetch = NSFetchRequest(entityName: "FavPlaces")
       
        
        
        let fetch: NSFetchRequest<FavPlaces>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetch = FavPlaces.fetchRequest() as! NSFetchRequest<FavPlaces>
        } else {
            fetch = NSFetchRequest(entityName: "FavPlaces")
        }
        
        let fetchedExercises = try managedObjectContext.fetch(fetch)
        
        for x in fetchedExercises {
            
            if (x.vicinity == vicinity) {
                managedObjectContext.delete(x)
                print("deleted")
            }
        }
        
    } catch _ {
    }
    

    
    
}
