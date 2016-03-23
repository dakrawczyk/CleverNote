//
//  Note.swift
//  CleverNote
//
//  Created by Dave Krawczyk on 3/23/16.
//  Copyright © 2016 Dave Krawczyk. All rights reserved.
//

import UIKit

enum DocumentError : ErrorType {
  case RuntimeError(String)
}

let FILE_EXTENSION = "txt"

class Note: UIDocument {
  
  var documentText: String?
  var title: String!
  
  
  class func createNoteWithTitle(noteTitle: String) -> Note {
    let fileURL = Note.fileUrlForDocumentNamed(noteTitle)
    let noteDocument = Note(fileURL: fileURL)
    noteDocument.title = noteTitle
    
    return noteDocument
  }
  
  class func arrayOfNotesFromArrayOfFileNames(fileNames: [String]) -> [Note] {
    var notes: [Note] = []
    
    for fileName in fileNames {
      let fileNameLessExtension = fileName.stringByReplacingOccurrencesOfString(".txt", withString: "")

      let note = Note(fileURL: Note.fileUrlForDocumentNamed(fileNameLessExtension))
      note.title = fileNameLessExtension

      notes.append(note)
    }
    return notes
  }
  
  class func getAllNotesInFileSystem() -> [Note] {
    let localDocuments: [AnyObject]?
    do {
      localDocuments = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(localDocumentsDirectoryURL()!.path!)
    } catch _ {
      localDocuments = nil
    }
    if let fileNames = localDocuments as? [String] {
      return Note.arrayOfNotesFromArrayOfFileNames(fileNames)
    }
    
    return []
  }
  
  override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
    
    if let contentData = contents as? NSData {
      if contents.length > 0 {
        self.documentText = String(data: contentData, encoding: NSUTF8StringEncoding)
      }
    }
  }
  
  override func contentsForType(typeName: String) throws -> AnyObject {
    
    if self.documentText == nil {
      self.documentText = ""
    }
    
    if let docData = self.documentText?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
      return docData
    } else {
      throw DocumentError.RuntimeError("Unable to convert String to data")
    }
    
    
  }
  
  class func fileUrlForDocumentNamed(name: String) -> NSURL {
    var protectedName = name
    if protectedName.characters.count == 0 {
      protectedName = "Untitled"
    }
    
    let localDoc = localDocumentsDirectoryURL()!
    let urlWithName = localDoc.URLByAppendingPathComponent(protectedName)
    
    return urlWithName.URLByAppendingPathExtension(FILE_EXTENSION)
  }
}


func ubiquitousContainerURL() -> NSURL {
  return NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)!
}

func ubiquitousDocumentsDirectoryURL() -> NSURL {
  return ubiquitousContainerURL().URLByAppendingPathComponent("Documents")
}

func localDocumentsDirectoryURL() -> NSURL? {
  
  var localDocumentsDirectoryURL: NSURL?
  if let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
    localDocumentsDirectoryURL = NSURL(fileURLWithPath: docPath)
  }
  print("\(localDocumentsDirectoryURL!)")
  return localDocumentsDirectoryURL
}