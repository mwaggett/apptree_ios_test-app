//
//  DataModel.swift
//  TestApp
//
//  Created by Molly Waggett on 12/8/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import Foundation

class DataModel {
  
  var people = Person.createFakeData()
  
  func nextPersonID() -> Int {
    return people.count + 1
  }
  
}