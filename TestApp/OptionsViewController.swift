//
//  OptionsViewController.swift
//  TestApp
//
//  Created by Molly Waggett on 12/8/15.
//  Copyright © 2015 Molly Waggett. All rights reserved.
//

import UIKit

protocol OptionsViewControllerDelegate: class {
  func optionsViewControllerSortByAddress(controller: OptionsViewController)
  func optionsViewControllerSortByName(controller: OptionsViewController)
  func optionsViewControllerFixPhoneNumberFormatting(controller: OptionsViewController)
}

class OptionsViewController: UITableViewController {
  
  weak var delegate: OptionsViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.preferredContentSize = CGSizeMake(280, 44*5)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    if indexPath.row == 0 {
      delegate?.optionsViewControllerSortByAddress(self)
    } else if indexPath.row == 1 {
      delegate?.optionsViewControllerSortByName(self)
    } else if indexPath.row == 2 {
      delegate?.optionsViewControllerFixPhoneNumberFormatting(self)
    }
  }

}
