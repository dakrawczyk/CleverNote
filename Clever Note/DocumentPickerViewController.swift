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
  
  @IBOutlet weak var tableView: UITableView!
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    notes = Note.getAllNotesInFileSystem()
    print("got notes: \(notes)")
    tableView.reloadData()
  }
  @IBAction func openDocument(sender: AnyObject?) {
    let documentURL = self.documentStorageURL!.URLByAppendingPathComponent("Untitled.txt")
    
    // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
    self.dismissGrantingAccessToURL(documentURL)
  }
  
  
  
  override func prepareForPresentationInMode(mode: UIDocumentPickerMode) {
    // TODO: present a view controller appropriate for picker mode here
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