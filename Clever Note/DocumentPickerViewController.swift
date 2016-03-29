//
//  DocumentPickerViewController.swift
//  Clever Note
//
//  Created by Dave Krawczyk on 3/23/16.
//  Copyright © 2016 Dave Krawczyk. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerExtensionViewController {
  
  var fileCoordinator: NSFileCoordinator {
    let fileCoordinator = NSFileCoordinator()
    fileCoordinator.purposeIdentifier = self.providerIdentifier
    return fileCoordinator
  }
  var notes: [Note] = []
  
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var confirmView: UIVisualEffectView!
  @IBOutlet weak var extensionWarningLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    notes = Note.getAllNotesInDocumentStorage(documentStorageURL!)
    
    tableView.reloadData()
    
  }
  
  override func prepareForPresentationInMode(mode: UIDocumentPickerMode) {
    
    if let sourceURL = originalURL {
      // If the source URL does not have a path extension supported
      // show the extension warning label.
      
      // ** This should only apply in Export to and Move to services. **
      if sourceURL.pathExtension != fileExtension {
        self.confirmButton.hidden = true
        self.extensionWarningLabel.hidden = false
      }
    }
    
    
    switch mode {
    case .ExportToService:
      //Show confirmation button
      self.confirmButton.setTitle("Export to CleverNote", forState: .Normal)
      
    case .MoveToService:
      //Show confirmation button
      self.confirmButton.setTitle("Move to CleverNote", forState: .Normal)
      
    case .Open:
      //Show file list
      self.confirmView.hidden = true
      
    case .Import:
      //Show file list
      self.confirmView.hidden = true
      
    }
  }
  
  @IBAction func confirmButtonTapped(sender: AnyObject) {
    
    if let sourceURL = originalURL {
      
      switch documentPickerMode {
      case .ExportToService:
        
        if let fileName = sourceURL.URLByDeletingPathExtension?.lastPathComponent {
          let destURL = Note.fileUrlForDocumentNamed(fileName)
          
          fileCoordinator.coordinateReadingItemAtURL(sourceURL, options: .WithoutChanges, error: nil, byAccessor: { (newURL) in
            do {
              try NSFileManager.defaultManager().copyItemAtURL(sourceURL, toURL: destURL)
              self.dismissGrantingAccessToURL(destURL)
            } catch _ {
              print("error copying")
            }
          })
        }
        
      case .MoveToService:
        
        if let fileName = sourceURL.URLByDeletingPathExtension?.lastPathComponent {
          let destURL = Note.fileUrlForDocumentNamed(fileName)
          
          fileCoordinator.coordinateReadingItemAtURL(sourceURL, options: .WithoutChanges, error: nil, byAccessor: { (newURL) in
            do {
              try NSFileManager.defaultManager().copyItemAtURL(sourceURL, toURL: destURL)
              self.dismissGrantingAccessToURL(destURL)
            } catch _ {
              print("error copying")
            }
          })
        }
        
      default:
        self.dismissViewControllerAnimated(true, completion: nil)
      }
      
    }
  }
  
}


//MARK: UITableViewDelegate & UITableViewDataSource
extension DocumentPickerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath)
    let noteDocument = notes[indexPath.row]
    cell.textLabel?.text = noteDocument.title
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let noteDocument = notes[indexPath.row]
    self.dismissGrantingAccessToURL(noteDocument.fileURL)
    
  }
}