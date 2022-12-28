//
//  Extensions.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/27/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine

fileprivate enum msgs: String {
    
    case returningpresetrecipes = "Returning Preset Recipes "
    case returningbooksectionssf = "Returning BookSections in single file"
    case rshipd = "recipesShipped"
    case rnotes = "RecipeNotes"
    case rimages = "RecipeImages"
    case fuar = "Found user added recipe"
    case combined = "Combined booksections into one booksection"
    case ext = "Extensions: "
    case success = "Successfull remove of a recipe"
    case fail = "Failed to remove a recipe "
    case counted = "User added recipes Contents count "
    case nobs = "No booksection files found"
}

private var decoder: JSONDecoder = JSONDecoder()
private var encoder: JSONEncoder = JSONEncoder()

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
//        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return decoded
    }
}

extension UIImage {
    func scaledDown(into size:CGSize, centered:Bool = false) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleW, scaleH) = (1 as CGFloat, 1 as CGFloat)
        if targetWidth > size.width {
            scaleW = size.width/targetWidth
        }
        if targetHeight > size.height {
            scaleH = size.height/targetHeight
        }
        let scale = min(scaleW,scaleH)
        targetWidth *= scale; targetHeight *= scale
        let sz = CGSize(width:targetWidth, height:targetHeight)
        if !centered {
            return UIGraphicsImageRenderer(size:sz).image { _ in
                self.draw(in:CGRect(origin:.zero, size:sz))
            }
        }
        let x = (size.width - targetWidth)/2
        let y = (size.height - targetHeight)/2
        let origin = CGPoint(x:x,y:y)
        return UIGraphicsImageRenderer(size:size).image { _ in
            self.draw(in:CGRect(origin:origin, size:sz))
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

struct Symbol {
    enum Kind { case mention, hashtag }
    
    let kind: Kind
    var string: String
}

extension Symbol {
    static func mention(_ string: String) -> Symbol {
        return Symbol(kind: .mention, string: string)
    }
    
    static func hashtag(_ string: String) -> Symbol {
        return Symbol(kind: .hashtag, string: string)
    }
}

extension String {
    var mentionedUsernames: [String] {
        let parts = split(separator: ",")
        
        // Character sets may be inverted to identify all
        // characters that are *not* a member of the set.
        let delimiterSet = CharacterSet.letters.inverted
        
        return parts.compactMap { part in
            // Here we grab the first sequence of letters right
            let name = part.components(separatedBy: delimiterSet)[0]
            return name.isEmpty ? nil : name
        }
    }
}

extension FileManager {
    func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}

extension FileManager {
    func constructAllSections() -> [BookSection] {

        var myReturn: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + json).sorted(by: {$0.name < $1.name})
        myReturn = bookSections
        let test = FileManager.default.directoryExists(atUrl: myReczipesDirUrl)
        if !test {
            do {
                try FileManager.default.createDirectory(at: myReczipesDirUrl, withIntermediateDirectories: true)

                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: msgs.rnotes.rawValue), withIntermediateDirectories: true)

                try FileManager.default.createDirectory(at: myReczipesDirUrl.appending(path: msgs.rimages.rawValue), withIntermediateDirectories: true)

#if DEBUG
                print("FileManager: " + " Created Reczipes directory")
                print("FileManager: " + " Created RecipeNotes directory")
                print("FileManager: " + " Created RecipeImages directory")
#endif

            } catch {
                fatalError("Cannot create directories")
            }
        }
        do {

            var urls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(recipesName), includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            // skip these folders
            urls = urls.filter({!$0.pathComponents.contains(msgs.rnotes.rawValue)})
            urls = urls.filter({!$0.pathComponents.contains(msgs.rimages.rawValue)})


            for aurl in urls {
                do {
                    let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(aurl.lastPathComponent))
                    let aBookSection = try decoder.decode(BookSection.self, from: data)
                    // may need to merge recipes if multiple booksections with same name, different id exist
#if DEBUG
                    print(msgs.ext.rawValue + msgs.fuar.rawValue)
#endif
                    if myReturn.contains(where: {$0.name == aBookSection.name}) {
                        var existing = myReturn.first(where: {$0.name == aBookSection.name})
                        existing?.items.append(contentsOf: aBookSection.items)
                        // let idx = myReturn.firstIndex(where: {$0.name == aBookSection.name})
                        myReturn = myReturn.filter({$0.name != aBookSection.name})
                        if (existing != nil) {
                            myReturn.append(existing!)
#if DEBUG
                    print(msgs.ext.rawValue + msgs.combined.rawValue)

#endif
                        }
                    } else {
                        myReturn.append(aBookSection)
                    }

                } catch  {
                    // not a json file
                    fatalError("This directory has illegal files")
                }
            }
        } catch  {
            // no contents or does not exist
        }

        return myReturn
    }
//}
//
//extension FileManager {
//    func constructAllRecipes() -> [SectionItem] {
//        var myReturn: [SectionItem] = []
//        let myBs: [BookSection] = self.constructAllSections()
//        if myBs.isEmpty {
//
//        } else {
//            for abs in myBs {
//                myReturn.append(contentsOf: abs.items)
//            }
//        }
//        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + json).sorted(by: {$0.name < $1.name})
//        if bookSections.isEmpty  {
//
//        } else {
//            for abs in bookSections {
//                myReturn.append(contentsOf: abs.items)
//            }
//        }
//
//        let bs = constructAllSections()
//        for abs in bs {
//            myReturn.append(contentsOf: abs.items)
//        }
//        return myReturn
//    }
//}
//
//extension FileManager {
//    func saveBookSection(bsection: BookSection) -> Bool {
//        var myReturn: Bool = false
//
//        let myDocuDirUrl = getDocuDirUrl()
//        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
//        do {
//            let encodedJSON = try encoder.encode(bsection)
//            // now write out
//            try encodedJSON.write(to: myReczipesDirUrl.appendingPathComponent(bsection.name + "_" + dateSuffix() + json))
//            #if DEBUG
//            print("Successfully wrote booksection to reczipes directory")
//            #endif
//            myReturn = true
//
//        } catch {
//            // can't save
//        }
//        return myReturn
//    }
//}
//
//extension FileManager {
//    func constructUserSavedRecipesIfAvailable() -> [SectionItem] {
//        var mySavedRecipes:Array<SectionItem> = []
//
//        let myDocuDirUrl = getDocuDirUrl()
//        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
//
//        do {
//            var recipesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
//            recipesUrls = recipesUrls.filter({$0.lastPathComponent != recipeNotesFolderName})
//            recipesUrls = recipesUrls.filter({$0.lastPathComponent != recipeImagesFolderName})
//
//#if DEBUG
//            print(msgs.ext.rawValue + msgs.counted.rawValue + "\(recipesUrls.count)")
//#endif
//            for arecipeurl in recipesUrls {
//                let data = try Data(contentsOf: myReczipesDirUrl.appendingPathComponent(arecipeurl.lastPathComponent))
//                let decodedJSON = try decoder.decode(SectionItem.self, from: data)
//                mySavedRecipes.append(decodedJSON)
//            }
//        } catch  {
//            fatalError("Cannot read or decode from notes")
//        }
//        return mySavedRecipes
//    }
}

extension FileManager {
    func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        
        do {
            let notesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
#if DEBUG
            print(msgs.ext.rawValue + " User added Notes Contents count " + "\(notesUrls.count)")
#endif
            for anoteurl in notesUrls {
                let data = try Data(contentsOf: myNotesDirUrl.appendingPathComponent(anoteurl.lastPathComponent))
                let decodedJSON = try decoder.decode(Note.self, from: data)
                myNotesConstructed.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from notes")
        }
        
        let shippedNotes:[Note] = Bundle.main.decode([Note].self, from: "Notes.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        if shippedNotes.isEmpty  {
#if DEBUG
            print(msgs.ext.rawValue + " shipped Notes Contents count " + "\(shippedNotes.count)")
#endif
        } else {
            myNotesConstructed.append(contentsOf: shippedNotes)
        }
        
        if myNotesConstructed.count == 0 {
#if DEBUG
            print(msgs.ext.rawValue + " No User recipe notes")
#endif
        } else {
#if DEBUG
            print(msgs.ext.rawValue + " User recipe notes exist: " + " \(myNotesConstructed.count)")
#endif
        }
        return myNotesConstructed
    }
}

extension FileManager {
    func constructImagesIfAvailable() -> Array<ImageSaved> {
        var myImagesConstructed:Array<ImageSaved> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
        do {
            let imagesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myImagesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
#if DEBUG
            print(msgs.ext.rawValue + " User added Images Contents count " + "\(imagesUrls.count)")
#endif
            for anImageUrl in imagesUrls {
                let data = try Data(contentsOf: myImagesDirUrl.appendingPathComponent(anImageUrl.lastPathComponent))
                let decodedJSON = try decoder.decode(ImageSaved.self, from: data)
                myImagesConstructed.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from images")
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: "Images.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        if shippedImages.isEmpty  {
#if DEBUG
            print(msgs.ext.rawValue + " shipped Images Contents count " + "\(shippedImages.count)")
#endif
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
        }
        
        if myImagesConstructed.count == 0 {
#if DEBUG
            print(msgs.ext.rawValue + " No user images")
#endif
        } else {
#if DEBUG
            print(msgs.ext.rawValue + " User images exist: " + " \(myImagesConstructed.count)")
#endif
        }
        return myImagesConstructed
    }
}

//extension FileManager {
//    func removeAddedRecipes() {
//        let myDocuDirUrl = getDocuDirUrl()
//        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
//        do {
//            let sectionUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
//            if sectionUrls.isEmpty {
//#if DEBUG
//                print(msgs.ext.rawValue + msgs.nobs.rawValue)
//#endif
//                return
//            }
//
//            for aPath in sectionUrls {
//                do {
//                    try FileManager.default.removeItem(at: aPath)
//#if DEBUG
//                    print(msgs.ext.rawValue + msgs.success.rawValue)
//#endif
//                } catch  {
//#if DEBUG
//                    print(msgs.ext.rawValue + msgs.fail.rawValue)
//#endif
//                }
//            }
//        } catch   {
//             // no files
//#if DEBUG
//            print(msgs.ext.rawValue + msgs.nobs.rawValue)
//#endif
//        }
//    }
//}

extension Publisher {
  
  /// Executes an asyncronous call and returns its result to the downstream subscriber.
  ///
  /// - Parameter transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
  /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
  func `await`<T>(_ transform: @escaping (Output) async -> T) -> AnyPublisher<T, Failure> {
    flatMap { value -> Future<T, Failure> in
      Future { promise in
        Task {
          let result = await transform(value)
          promise(.success(result))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  /// Performs the specified closures when publisher events occur.
  ///
  /// This is an overloaded version of ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` that only
  /// accepts a closure for the `receiveOutput` events. Use it to inspect events as they pass through the pipeline.
  ///
  /// - Parameters:
  ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
  /// - Returns: A publisher that performs the specified closures when publisher events occur.
  func handleEvents(_ receiveOutput: (@escaping (Self.Output) -> Void)) -> Publishers.HandleEvents<Self> {
    self.handleEvents(receiveOutput: receiveOutput)
  }
  
  /// Performs the specified closures when publisher events occur.
  ///
  /// This is an overloaded version of ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` that only
  /// accepts a closure for the `receiveOutput` events. Use it to execute side effects while events pass down the pipeline.
  ///
  /// - Parameters:
  ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
  /// - Returns: A publisher that performs the specified closures when publisher events occur.
  func handleEvents(_ receiveOutput: (@escaping () -> Void)) -> Publishers.HandleEvents<Self> {
    self.handleEvents { output in
      receiveOutput()
    }
  }
}
