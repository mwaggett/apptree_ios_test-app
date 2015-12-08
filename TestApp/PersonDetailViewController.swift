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
  var image: UIImage?
  weak var delegate: PersonDetailViewControllerDelegate?
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var addPhotoLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
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
      if let photo = person.photo {
        showImage(photo)
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    firstNameField.becomeFirstResponder()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 1 {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      pickPhoto()
    }
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
      if let photo = imageView.image {
        person.photo = photo
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
      if let photo = imageView.image {
        newPerson.photo = photo
      }
      delegate?.personDetailViewController(self, didFinishAddingPerson: newPerson)
    }
  }
  
  func showImage(image: UIImage) {
    imageView.image = image
    imageView.hidden = false
    addPhotoLabel.hidden = true
  }
  
}

extension PersonDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : AnyObject]) {
      image = info[UIImagePickerControllerEditedImage] as? UIImage
      if let image = image {
        showImage(image)
      }
      tableView.reloadData()
      dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func pickPhoto() {
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      showPhotoMenu()
    } else {
      choosePhotoFromLibrary()
    }
  }
  
  func showPhotoMenu() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { _ in self.takePhotoWithCamera() })
    alertController.addAction(takePhotoAction)
    
    let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: { _ in self.choosePhotoFromLibrary() })
    alertController.addAction(chooseFromLibraryAction)
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.view.tintColor = view.tintColor
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.view.tintColor = view.tintColor
    imagePicker.sourceType = .Camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
}