/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

class NotesListViewController: UIViewController {
  
  var notes = [Note]()
  let noteSegueIdentifier = "noteSegue"
  let dateFormatter = NSDateFormatter()

  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter.dateStyle = .ShortStyle
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    refreshNoteList()
  }
  
  func refreshNoteList() {
    notes = Note.getAllNotesInFileSystem()
    tableView.reloadData()
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
            self.performSegueWithIdentifier(self.noteSegueIdentifier, sender: noteDocument)
            self.notes.append(noteDocument)
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

    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let noteDocument = notes[indexPath.row]
    performSegueWithIdentifier(noteSegueIdentifier, sender: noteDocument)
  }
}
