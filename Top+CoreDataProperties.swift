//
//  Top+CoreDataProperties.swift
//  RedditTops
//
//  Created by Juan Salazar on 31/10/16.
//  Copyright © 2016 Juan Salazar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Top {

    @NSManaged var title: String?
    @NSManaged var thumbnail: String?
    @NSManaged var author: String?
    @NSManaged var date: String?
    @NSManaged var comments: NSNumber?
    @NSManaged var subReddit: String?

}
