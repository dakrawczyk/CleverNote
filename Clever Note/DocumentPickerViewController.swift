//
//  DocumentPickerViewController.swift
//  Clever Note
//
//  Created by Dave Krawczyk on 3/23/16.
//  Copyright © 2016 Dave Krawczyk. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerExtensionViewController {
  var notes: [Note] = []
  
  var fileCoordinator: NSFileCoordinator {
    let fileCoordinator = NSFileCoordinator()
    fileCoordinator.purposeIdentifier = self.providerIdentifier
    return fileCoordinator
  }
  
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var confirmView: UIView!
  
  @IBOutlet weak var tableView: UITableView!
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    notes = Note.getAllNotesInDocumentStorage(documentStorageURL!)
    print("got notes: \(notes)")
    tableView.reloadData()
    
  }
  
  @IBAction func confirmButtonTapped(sender: AnyObject) {
    switch documentPickerMode {
    case .ExportToService:
      //Export
      
      if let sourceURL = originalURL {
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
      }
      
    case .MoveToService:
      //Move
      if let sourceURL = originalURL {
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
      }
      
    default:
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
  }
  
  override func prepareForPresentationInMode(mode: UIDocumentPickerMode) {
    switch mode {
    case .ExportToService:
      //confirmation Button
      self.confirmButton.setTitle("Export to CleverNote", forState: .Normal)
      
    case .MoveToService:
      //confirmation Button
      self.confirmButton.setTitle("Move to CleverNote", forState: .Normal)
      
    case .Open:
      //file list
      self.confirmView.hidden = true
      
    case .Import:
      //file list
      self.confirmView.hidden = true
      
    default:
      self.confirmView.hidden = true
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
    let documentURL = self.documentStorageURL!.URLByAppendingPathComponent("\(noteDocument.title).txt")
    self.dismissGrantingAccessToURL(documentURL)
    
  }
}