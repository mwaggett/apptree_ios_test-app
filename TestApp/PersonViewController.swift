//
//  ViewController.swift
//  TestApp
//
//  Created by Molly Waggett on 12/7/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import UIKit

class PersonViewController: UITableViewController {
  
  var people = Person.createFakeData()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)
    let person = people[indexPath.row]
    configureCell(cell, withPerson: person)
    return cell
  }
  
  func configureCell(cell: UITableViewCell, withPerson person: Person) {
    let nameLabel = cell.viewWithTag(1000) as! UILabel
    let phoneLabel = cell.viewWithTag(1001) as! UILabel
    let emailLabel = cell.viewWithTag(1002) as! UILabel
    let addressLabel = cell.viewWithTag(1003) as! UILabel
    let imageView = cell.viewWithTag(1004) as! UIImageView
    
    nameLabel.text = person.firstName + " " + person.lastName
    nameLabel.sizeToFit()
    phoneLabel.text = person.phoneNumber
    phoneLabel.sizeToFit()
    emailLabel.text = person.email
    emailLabel.sizeToFit()
    addressLabel.text = person.address
    addressLabel.sizeToFit()
    imageView.image = UIImage(named: "No Photo")
  }

}

