//
//  NotesListViewController.swift
//  CleverNote
//
//  Created by Dave Krawczyk on 3/23/16.
//  Copyright © 2016 Dave Krawczyk. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
  
  var notes: [Note] = []
  let noteSegueIdentifier = "noteSegue"
  let dateFormatter = NSDateFormatter()

  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .ShortStyle
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.notes = Note.getAllNotesInFileSystem()

  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == noteSegueIdentifier {
      let noteViewController = segue.destinationViewController as! NoteViewController
      let noteDocument = sender as! Note
      noteViewController.note = noteDocument
    }
  }
  
  @IBAction func addButtonTapped(sender: AnyObject) {
    let addNoteAlertController = UIAlertController(title: "Add Note", message: "Please enter a title for your new note", preferredStyle: .Alert)
    
    addNoteAlertController.addTextFieldWithConfigurationHandler { (textField) in
      textField.placeholder = "Note Title"
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
    addNoteAlertController.addAction(cancelAction)
    
    let okayAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
      if let noteTitle = addNoteAlertController.textFields?.first?.text {
        
        let noteDocument = Note.createNoteWithTitle(noteTitle)
        
        noteDocument.saveToURL(noteDocument.fileURL, forSaveOperation: .ForCreating) { (success) -> Void in
          if success == true {
            self.notes.insert(noteDocument, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.performSegueWithIdentifier(self.noteSegueIdentifier, sender: noteDocument)
          } else {
            print("Save unsuccessful")
          }
        }
      }
    }
    addNoteAlertController.addAction(okayAction)

    presentViewController(addNoteAlertController, animated: true, completion: nil)
  }
  
  
}

//MARK: UITableViewDelegate & UITableViewDataSource
extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath)
    let noteDocument = notes[indexPath.row]
    cell.textLabel?.text = noteDocument.title
    if let modificationDate = noteDocument.fileModificationDate {
      cell.detailTextLabel?.hidden = false
      cell.detailTextLabel?.text = dateFormatter.stringFromDate(modificationDate)
    } else {
      cell.detailTextLabel?.hidden = true
    }
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let noteDocument = notes[indexPath.row]
    performSegueWithIdentifier(noteSegueIdentifier, sender: noteDocument)
  }
}
