//
//  DataModel.swift
//  TestApp
//
//  Created by Molly Waggett on 12/8/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import Foundation

class DataModel {
  
  var people = [Person]()
  
  func nextPersonID() -> Int {
    return people.count + 1
  }
  
  func createFakeData() -> [Person] {
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
  
  func fetchData(completion: () -> ()) {
    if let url = NSURL(string: "https://www.dropbox.com/s/0qe641r5ouao65h/people.json?dl=1") {
      let session = NSURLSession.sharedSession()
      let dataTask = session.dataTaskWithURL(url, completionHandler: { data, response, error in
        if let error = error {
          print("Error: \(error)")
        } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200, let data = data, peopleDict = self.parseJSON(data) {
          self.people = self.parsePeople(peopleDict)
        }
        dispatch_async(dispatch_get_main_queue()) {
          completion()
        }
      })
      dataTask.resume()
    } else {
      people = createFakeData() // backup if fetch doesn't work
    }
    for person in people {
      print(person.firstName)
    }
  }
  
  func parseJSON(data: NSData) -> [String: AnyObject]? {
    do {
      return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
    } catch {
      print("JSON Error: \(error)")
      return nil
    }
  }
  
  func parsePeople(peopleDict: [String: AnyObject]) -> [Person] {
    guard let peopleArray = peopleDict["people"] as? [AnyObject] else {
      print("Expected 'people' array")
      return []
    }
    var people = [Person]()
    for personDict in peopleArray {
      if let personDict = personDict as? [String: AnyObject] {
        let person = Person()
        if let firstName = personDict["firstName"] as? String {
          person.firstName = firstName
        }
        if let lastName = personDict["lastName"] as? String {
          person.lastName = lastName
        }
        if let phoneNumber = personDict["phoneNumber"] as? String {
          person.phoneNumber = phoneNumber
        }
        if let email = personDict["email"] as? String {
          person.email = email
        }
        if let address = personDict["address"] as? String {
          person.address = address
        }
        if let photo = personDict["photo"] as? String {
          //try to download photo
        }
        people.append(person)
      }
    }
    return people
  }
  
}