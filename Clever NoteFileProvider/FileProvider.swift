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

class FileProvider: NSFileProviderExtension {

    var fileCoordinator: NSFileCoordinator {
        let fileCoordinator = NSFileCoordinator()
        fileCoordinator.purposeIdentifier = self.providerIdentifier()
        return fileCoordinator
    }

    override init() {
        super.init()
        
        self.fileCoordinator.coordinateWritingItemAtURL(self.documentStorageURL(), options: NSFileCoordinatorWritingOptions(), error: nil, byAccessor: { newURL in
            // ensure the documentStorageURL actually exists
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(newURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // Handle error
            }
        })
    }

    override func providePlaceholderAtURL(url: NSURL, completionHandler: ((error: NSError?) -> Void)?) {
        // Should call writePlaceholderAtURL(_:withMetadata:error:) with the placeholder URL, then call the completion handler with the error if applicable.
        let fileName = url.lastPathComponent!
    
        let placeholderURL = NSFileProviderExtension.placeholderURLForURL(self.documentStorageURL().URLByAppendingPathComponent(fileName))
    
        // TODO: get file size for file at <url> from model
        let fileSize = 0
        let metadata = [NSURLFileSizeKey: fileSize]
        do {
            try NSFileProviderExtension.writePlaceholderAtURL(placeholderURL, withMetadata: metadata)
        } catch {
            // Handle error
        }

        completionHandler?(error: nil)
    }

    override func startProvidingItemAtURL(url: NSURL, completionHandler: ((error: NSError?) -> Void)?) {
        // Should ensure that the actual file is in the position returned by URLForItemWithIdentifier, then call the completion handler

        // TODO: get the contents of file at <url> from model
        let fileData = NSData(contentsOfURL: url)

        do {
            _ = try fileData!.writeToURL(url, options: NSDataWritingOptions())
          completionHandler?(error: nil);

        } catch {
          completionHandler?(error: nil);
        }

    }


    override func itemChangedAtURL(url: NSURL) {
        NSLog("Item changed at URL %@", url)
      
    }

    override func stopProvidingItemAtURL(url: NSURL) {
        // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
        // Care should be taken that the corresponding placeholder file stays behind after the content file has been deleted.

        do {
            _ = try NSFileManager.defaultManager().removeItemAtURL(url)
        } catch {
            // Handle error
        }
        self.providePlaceholderAtURL(url, completionHandler: { error in
            // TODO: handle any error, do any necessary cleanup
        })
    }

}
