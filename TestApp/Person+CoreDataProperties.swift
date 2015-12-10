//
//  Person+CoreDataProperties.swift
//  TestApp
//
//  Created by Molly Waggett on 12/9/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var phoneNumber: String
    @NSManaged var email: String
    @NSManaged var address: String
    @NSManaged var photoURL: String?

}
