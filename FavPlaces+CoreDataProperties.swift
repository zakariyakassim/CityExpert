//
//  FavPlaces+CoreDataProperties.swift
//  CityExpert
//
//  Created by Zakariya Kassim on 03/08/2016.
//  Copyright © 2016 Zakariya Kassim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FavPlaces {

    @NSManaged var name: String?
    @NSManaged var vicinity: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var distance: String?
    @NSManaged var image: String?
    @NSManaged var type: String?

}
