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

class DocumentPickerViewController: UIDocumentPickerExtensionViewController {
  
  var fileCoordinator: NSFileCoordinator {
    let fileCoordinator = NSFileCoordinator()
    fileCoordinator.purposeIdentifier = providerIdentifier
    return fileCoordinator
  }
  var notes = [Note]()
  
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
        confirmButton.hidden = true
        extensionWarningLabel.hidden = false
      }
    }
    
    
    switch mode {
    case .ExportToService:
      //Show confirmation button
      confirmButton.setTitle("Export to CleverNote", forState: .Normal)
      
    case .MoveToService:
      //Show confirmation button
      confirmButton.setTitle("Move to CleverNote", forState: .Normal)
      
    case .Open:
      //Show file list
      confirmView.hidden = true
      
    case .Import:
      //Show file list
      confirmView.hidden = true
      
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
        dismissViewControllerAnimated(true, completion: nil)
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
    dismissGrantingAccessToURL(noteDocument.fileURL)
    
  }
}