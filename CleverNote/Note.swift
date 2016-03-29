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
        documentText = String(data: contentData, encoding: NSUTF8StringEncoding)
      }
    }
  }
  
  override func contentsForType(typeName: String) throws -> AnyObject {
    
    if documentText == nil {
      documentText = ""
    }
    
    if let docData = documentText?.dataUsingEncoding(NSUTF8StringEncoding) {
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
      
      let note = Note.createNoteWithTitle(fileNameLessExtension)
      notes.append(note)
    }
    return notes
  }
  
  // Returns all notes in file system
  class func getAllNotesInFileSystem() -> [Note] {
    let localDocuments: [AnyObject]?
    do {
      localDocuments = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(appGroupContainerURL().path!)
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
    
    let contentsOfDirectoryArray: [AnyObject]?
    do {
      contentsOfDirectoryArray = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentStorageURL!.path!)
    } catch _ {
      contentsOfDirectoryArray = nil
    }
    
    if let fileNames = contentsOfDirectoryArray as? [String] {
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
    
    let baseURL = appGroupContainerURL()
    let urlWithName = baseURL.URLByAppendingPathComponent(protectedName)
    
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
  //    print("\(storagePath)")
  
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