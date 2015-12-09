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
  var photoURL: String?
  
}
