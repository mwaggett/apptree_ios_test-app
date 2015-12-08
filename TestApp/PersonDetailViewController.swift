//
//  PersonDetailViewController.swift
//  TestApp
//
//  Created by Molly Waggett on 12/8/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import UIKit

protocol PersonDetailViewControllerDelegate: class {
  func personDetailViewControllerDidCancel(controller: PersonDetailViewController)
  func personDetailViewController(controller: PersonDetailViewController, didFinishAddingPerson person: Person)
  func personDetailViewController(controller: PersonDetailViewController, didFinishEditingPerson person: Person)
}

class PersonDetailViewController: UITableViewController {
  
  var personToEdit: Person?
  weak var delegate: PersonDetailViewControllerDelegate?
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let person = personToEdit {
      title = "Edit Person"
      firstNameField.text = person.firstName
      lastNameField.text = person.lastName
      phoneField.text = person.phoneNumber
      emailField.text = person.email
      addressField.text = person.address
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    firstNameField.becomeFirstResponder()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func cancel() {
    delegate?.personDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let person = personToEdit {
      if let firstName = firstNameField.text {
        person.firstName = firstName
      }
      if let lastName = lastNameField.text {
        person.lastName = lastName
      }
      if let phoneNumber = phoneField.text {
        person.phoneNumber = phoneNumber
      }
      if let email = emailField.text {
        person.email = email
      }
      if let address = addressField.text {
        person.address = address
      }
      delegate?.personDetailViewController(self, didFinishEditingPerson: person)
    } else {
      let newPerson = Person()
      if let firstName = firstNameField.text {
        newPerson.firstName = firstName
      }
      if let lastName = lastNameField.text {
        newPerson.lastName = lastName
      }
      if let phoneNumber = phoneField.text {
        newPerson.phoneNumber = phoneNumber
      }
      if let email = emailField.text {
        newPerson.email = email
      }
      if let address = addressField.text {
        newPerson.address = address
      }
      delegate?.personDetailViewController(self, didFinishAddingPerson: newPerson)
    }
  }
  
}