//
//  Person.swift
//  TestApp
//
//  Created by Molly Waggett on 12/8/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import Foundation
import UIKit

class Person: NSObject {
  
  var id = 0
  var firstName = ""
  var lastName = ""
  var fullName: String {
    get {
      return firstName + " " + lastName
    }
  }
  var email = ""
  var phoneNumber = ""
  var address = ""
  var photo: UIImage?
  
  class func createFakeData() -> [Person] {
    var people = [Person]()
    
    var person = Person();
    person.id = 1;
    person.firstName = "Matthew";
    person.lastName = "Smith";
    person.address = "1234 Main St. Portland, Or 97209";
    person.email = "matthew.smith@apptreesoftware.com";
    person.phoneNumber = "123456-7894";
    people.append(person);
    
    person = Person();
    person.id = 2;
    person.firstName = "Alexis";
    person.lastName = "Andreason";
    person.address = "4444 Hoyt St. Portland, Or 97209";
    person.email = "alexis.andreason@apptreesoftware.com";
    person.phoneNumber = "123-456.7894";
    people.append(person);
    
    person = Person();
    person.id = 3;
    person.firstName = "Robert";
    person.lastName = "Guinn";
    person.address = "444 Naito Blvd. Portland, Or 97209";
    person.email = "robert.guinn@apptreesoftware.com";
    person.phoneNumber = "123.456.7849";
    people.append(person);
    
    return people
  }
  
}
