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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.title = note.title
    
  }

}
