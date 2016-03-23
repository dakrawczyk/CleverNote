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
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "noteSelectedSegue" {
      let noteViewController = segue.destinationViewController as! NoteViewController
      let noteIndexPath = self.tableView.indexPathForSelectedRow!
      noteViewController.note = self.notes[noteIndexPath.row]
    }
  }
  
  @IBAction func addButtonTapped(sender: AnyObject) {
    let addNoteAlertController = UIAlertController(title: "Add Note", message: "Please enter a title for your new note", preferredStyle: .Alert)
    
    addNoteAlertController.addTextFieldWithConfigurationHandler { (textField) in
      textField.placeholder = "Note Title"
    }
    
    let okayAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
      if let noteTitle = addNoteAlertController.textFields?.first?.text {
      
      }
      
    }
    addNoteAlertController.addAction(okayAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
    addNoteAlertController.addAction(cancelAction)

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
    return cell
  }
  
}