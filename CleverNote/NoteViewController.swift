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

class NoteViewController: UIViewController {

  var note: Note!
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.note.openWithCompletionHandler { (success) in
      if success == true {
        self.title = self.note.title
        self.textView.text = self.note.documentText
      } else {
        
        let resultAlertController = UIAlertController(title: "Error", message: "Error opening note", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        resultAlertController.addAction(okayAction)
        self.presentViewController(resultAlertController, animated: true, completion: nil)

      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textView.becomeFirstResponder()
  }
  
  @IBAction func saveButtonTapped(sender: AnyObject) {
    note.documentText = self.textView.text
    note.saveToURL(self.note.fileURL, forSaveOperation: .ForOverwriting) { (success) in
      
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
