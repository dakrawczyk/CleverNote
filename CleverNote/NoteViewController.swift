//
//  NoteViewController.swift
//  CleverNote
//
//  Created by Dave Krawczyk on 3/23/16.
//  Copyright © 2016 Dave Krawczyk. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

  var note: Note!
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.note.openWithCompletionHandler { (success) in
      if success == true {
        self.title = self.note.title
        self.textView.text = self.note.documentText
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.textView.becomeFirstResponder()
  }
  
  @IBAction func saveButtonTapped(sender: AnyObject) {
    self.note.documentText = self.textView.text
    self.note.saveToURL(self.note.fileURL, forSaveOperation: .ForOverwriting) { (success) in
      
      let resultAlertController = UIAlertController(title: "Note Saved", message: "Note Saved Successfully", preferredStyle: .Alert)
      
      if success == false {
        resultAlertController.title = "Note Not Saved"
        resultAlertController.message = "Error Saving Note"
      }
      
      let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
      resultAlertController.addAction(okayAction)
      self.presentViewController(resultAlertController, animated: true, completion: nil)
      
    }

  }

}
