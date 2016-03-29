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

let fileExtension = "txt"
let appGroupIdentifier = "group.com.WindyCityLab.CleverNote"

class Note: UIDocument {
  
  var documentText: String?
  var title: String!
  
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
    
    if let docData = self.documentText?.dataUsingEncoding(NSUTF8StringEncoding) {
      print(docData)
      return docData
    } else {
      throw DocumentError.RuntimeError("Unable to convert String to data")
    }
  }

  // Creates a note with a title/filename
  class func createNoteWithTitle(noteTitle: String) -> Note {
    let fileURL = Note.fileUrlForDocumentNamed(noteTitle)
    let noteDocument = Note(fileURL: fileURL)
    noteDocument.title = noteTitle
    
    return noteDocument
  }
  
  // Given an array of filenames, return an array of notes from the file system
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
  
  // Returns all notes in file system
  class func getAllNotesInFileSystem() -> [Note] {
    let localDocuments: [AnyObject]?
    do {
      localDocuments = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(localDocumentsDirectoryURL().path!)
    } catch _ {
      localDocuments = nil
    }
    if let fileNames = localDocuments as? [String] {
      return Note.arrayOfNotesFromArrayOfFileNames(fileNames)
    }
    
    return []
  }
  
  // Returns all notes at specified URL
  class func getAllNotesInDocumentStorage(documentStorageURL: NSURL!) -> [Note] {
    
    
    let localDocuments: [AnyObject]?
    do {
      localDocuments = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentStorageURL!.path!)
    } catch _ {
      localDocuments = nil
    }
    if let fileNames = localDocuments as? [String] {
      return Note.arrayOfNotesFromArrayOfFileNames(fileNames)
    }
    
    return []
  }
  
  // Returns the file URL for the file to be saved at
  class func fileUrlForDocumentNamed(name: String) -> NSURL {
    var protectedName = name
    if protectedName.characters.count == 0 {
      protectedName = "Untitled"
    }
    
    let localDoc = localDocumentsDirectoryURL()
    let urlWithName = localDoc.URLByAppendingPathComponent(protectedName)
    
    return urlWithName.URLByAppendingPathExtension(fileExtension)
  }
}


func appGroupContainerURL() -> NSURL {
  
  let groupPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupIdentifier)!
  let storagePath = groupPath.URLByAppendingPathComponent("File Provider Storage")
  
  let fileManager = NSFileManager.defaultManager()
  if fileManager.fileExistsAtPath(storagePath.path!) == false {
    do {
      try fileManager.createDirectoryAtPath(storagePath.path!, withIntermediateDirectories: false, attributes: nil)
    } catch _ {
      print("error creating filepath")
    }
  }
    print("\(storagePath)")

  return storagePath
}

func localDocumentsDirectoryURL() -> NSURL! {
  
  var localDocumentsDirectoryURL: NSURL?
  if let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
    localDocumentsDirectoryURL = NSURL(fileURLWithPath: docPath)
  }

//  print("\(localDocumentsDirectoryURL!)")
  return localDocumentsDirectoryURL!
}