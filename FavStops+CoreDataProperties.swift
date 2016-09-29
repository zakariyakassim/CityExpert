//
//  FavStops+CoreDataProperties.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 01/08/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavStops {

    @NSManaged var longitude: String?
    @NSManaged var latitude: String?
    @NSManaged var name: String?
    @NSManaged var atcocode: String?
    @NSManaged var distance: String?

}
