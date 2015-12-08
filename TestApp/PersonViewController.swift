//
//  ViewController.swift
//  TestApp
//
//  Created by Molly Waggett on 12/7/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import UIKit

class PersonViewController: UITableViewController {
  
  var dataModel = DataModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.people.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)
    let person = dataModel.people[indexPath.row]
    configureCell(cell, atIndexPath: indexPath, withPerson: person)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    dataModel.people.removeAtIndex(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddPerson" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! PersonDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditPerson" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! PersonDetailViewController
      controller.delegate = self
      if let sender = sender {
        let index = sender.tag - 2000
        controller.personToEdit = dataModel.people[index]
      }
    }
  }
  
  func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath, withPerson person: Person) {
    let nameLabel = cell.viewWithTag(1000) as! UILabel
    let phoneLabel = cell.viewWithTag(1001) as! UILabel
    let emailLabel = cell.viewWithTag(1002) as! UILabel
    let addressLabel = cell.viewWithTag(1003) as! UILabel
    let imageView = cell.viewWithTag(1004) as! UIImageView
    if let editButton = cell.viewWithTag(1005) as? UIButton {
      editButton.tag = 2000 + indexPath.row // change tag to correspond to indexPath if it hasn't been changed already
    }                                       // I'm sure this is a bad idea, but it's what I've got for now.
    
    nameLabel.text = person.firstName + " " + person.lastName
    nameLabel.sizeToFit()
    phoneLabel.text = person.phoneNumber
    phoneLabel.sizeToFit()
    emailLabel.text = person.email
    emailLabel.sizeToFit()
    addressLabel.text = person.address
    addressLabel.sizeToFit()
    if let image = person.photo {
      imageView.image = image
    } else {
      imageView.image = UIImage(named: "No Photo")
    }
  }

}

extension PersonViewController: PersonDetailViewControllerDelegate {
  
  func personDetailViewControllerDidCancel(controller: PersonDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func personDetailViewController(controller: PersonDetailViewController, didFinishAddingPerson person: Person) {
    dataModel.people.append(person)
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func personDetailViewController(controller: PersonDetailViewController, didFinishEditingPerson person: Person) {
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
}

