//
//  ViewController.swift
//  TestApp
//
//  Created by Molly Waggett on 12/7/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import UIKit
import CoreData

class PersonViewController: UITableViewController {
  
  var managedObjectContext: NSManagedObjectContext!
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetchRequest = NSFetchRequest()
    let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.managedObjectContext)
    fetchRequest.entity = entity
    fetchRequest.sortDescriptors = []
    fetchRequest.fetchBatchSize = 20
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "People")
    return fetchedResultsController
  }()
  
  var people = [Person]()

  override func viewDidLoad() {
    super.viewDidLoad()
    performFetch()
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
    configureCell(cell, atIndexPath: indexPath, withPerson: person)
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    let personToDelete = people[indexPath.row]
    people.removeAtIndex(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    managedObjectContext.deleteObject(personToDelete)
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Error: \(error)")
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddPerson" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! PersonDetailViewController
      controller.delegate = self
      controller.managedObjectContext = managedObjectContext
    } else if segue.identifier == "EditPerson" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! PersonDetailViewController
      controller.delegate = self
      controller.managedObjectContext = managedObjectContext
      if let sender = sender {
        let index = sender.tag - 2000
        controller.personToEdit = people[index]
      }
    } else if segue.identifier == "ShowOptions" {
      let controller = segue.destinationViewController as! OptionsViewController
      controller.delegate = self
      controller.popoverPresentationController?.delegate = self
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
    //if let image = person.photo {
      //imageView.image = image
    if let photoURLString = person.photoURL {
      if let photoURL = NSURL(string: photoURLString) {
        loadImageWithURL(photoURL, intoView: imageView)
      }
    }
    if imageView.image == nil {
      imageView.image = UIImage(named: "No Photo")
    }
  }
  
  func loadImageWithURL(url: NSURL, intoView imageView: UIImageView) {
    let session = NSURLSession.sharedSession()
    let downloadTask = session.downloadTaskWithURL(url, completionHandler: { url, response, error in
      if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data) {
        dispatch_async(dispatch_get_main_queue()) {
          imageView.image = image
        }
      }
    })
    downloadTask.resume()
  }
  
  func performFetch() {
    do {
      try fetchedResultsController.performFetch()
      people = fetchedResultsController.fetchedObjects as! [Person]
    } catch {
      fatalError("Error fetching objects from Core Data")
    }
  }

}

extension PersonViewController: PersonDetailViewControllerDelegate {
  
  func personDetailViewControllerDidCancel(controller: PersonDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func personDetailViewController(controller: PersonDetailViewController, didFinishAddingPerson person: Person) {
    performFetch()
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func personDetailViewController(controller: PersonDetailViewController, didFinishEditingPerson person: Person) {
    performFetch()
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension PersonViewController: OptionsViewControllerDelegate {
  
  func optionsViewControllerSortByAddress(controller: OptionsViewController) {
    people.sortInPlace({ person1, person2 in return
      person1.address.localizedStandardCompare(person2.address) == .OrderedAscending })
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
  func optionsViewControllerSortByName(controller: OptionsViewController) {
    people.sortInPlace({ person1, person2 in return
      person1.lastName.localizedStandardCompare(person2.lastName) == .OrderedAscending })
    tableView.reloadData()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func optionsViewControllerFixPhoneNumberFormatting(controller: OptionsViewController) {
    do {
      let regex: NSRegularExpression = try NSRegularExpression(pattern: "[^0-9]", options: NSRegularExpressionOptions())
      for person in people {
        let strippedNumber = NSMutableString(string: person.phoneNumber)
        regex.replaceMatchesInString(strippedNumber, options: NSMatchingOptions(), range: NSMakeRange(0, strippedNumber.length), withTemplate: "")
        if strippedNumber.length == 10 {
          let areaCode = strippedNumber.substringWithRange(NSRange(location: 0, length: 3))
          let middleThree = strippedNumber.substringWithRange(NSRange(location: 3, length: 3))
          let lastFour = strippedNumber.substringWithRange(NSRange(location: 6, length: 4))
          person.phoneNumber = String("("+areaCode+") "+middleThree+" - "+lastFour)
        } else {
          person.phoneNumber = String(strippedNumber)
        }
      }
      do { // save formatted numbers
        try managedObjectContext.save()
      } catch {
        fatalError("Error: \(error)")
      }
      tableView.reloadData()
      dismissViewControllerAnimated(true, completion: nil)
    } catch {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}

extension PersonViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
}

