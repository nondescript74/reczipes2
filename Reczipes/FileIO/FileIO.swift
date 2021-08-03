//
//  FileIO.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class FileIO: NSObject {
    // MARK: - Properties
    var fileManager: FileManager = FileManager.default
    fileprivate enum msgs:String {
        case fileIO = "FileIO: "
        case read = "Read "
        case docudir = "Documents Debug Descrip, qty"
        case write = "Write "
        case success = "Succeeded "
        case fail = "Failed "
        case empty = " or Empty Folder"
        case wtf = "WTF????? "
        case fileUrls = "URL found in Documents "
        case note = "a note "
        case tempz = "Temp URL "
        case count = "Count "
        case commonCreate = "CommonCreate "
        case commonCreateReturn = "Returned Success from Commoncreate"
        case recNoteFldrExists = "RecipeFolder exists, contents: "
        case cannotCreateRNotesFolder = "Cannot create Folder"
        case cannotCreateRecipeFolder = "Cannot create Recipe Folder"
        case cannotFindFolder = "Cannot find requested folder"
        case createdRNotesFolder = "Created RecipeNotesFolder or already exists"
        case createdRecipeFolder = "Created the RecipeFolder or already exists"
        case recipeNotesFolderExists = "Recipe Notes Folder already exists "
        case recipeFolderExists = "The folder requested already exists"
        case checkContentsRecipeFolder = "checkContentsRecFolder"
        case foldercontents = "Contents of Folder "
        case xcassets = "Contents of Assets.xcassets"
    }
    
    // MARK: - CoreData
    // MARK: Methods
    func checkDocuDirContents() -> [URL] {
        do {
            let myDocuDirUrl = try fileManager.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
            
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: myDocuDirUrl, includingPropertiesForKeys: nil)
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.docudir.rawValue + fileURLs.debugDescription, fileURLs.count.description)
                #endif
                
                return fileURLs
            } catch {
                fatalError(msgs.fileIO.rawValue + msgs.fail.rawValue)
            }
        } catch {
            fatalError(msgs.fileIO.rawValue + msgs.wtf.rawValue)
        }
    }
    
    func checkContentsOfDir(dirname: String) -> [URL] {
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(dirname, isDirectory: true)
            let contents = try fileManager.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.foldercontents.rawValue + msgs.xcassets.rawValue + contents.count.description)
            #endif
            
            return contents
            
        } catch {
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.foldercontents.rawValue + msgs.cannotFindFolder.rawValue)
            #endif
            return []
        }
    }
    
    func getFileDataAtUrl(url: URL) -> Data {
        do {
            let data = try Data(contentsOf: url)
            return data
            
        } catch {
            fatalError(msgs.fileIO.rawValue + msgs.fail.rawValue)
        }
    }
    
    func getContentsOfXCAssetsDir() -> [URL] {
        do {
            var myxcassetsUrl = try fileManager.url(for: .applicationDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: true)
            myxcassetsUrl.appendPathComponent("Assets.xcassets", isDirectory: true)
            let contents = try fileManager.contentsOfDirectory(at: myxcassetsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.foldercontents.rawValue + msgs.xcassets.rawValue + contents.count.description)
            #endif
            
            return contents
            
        } catch {
            fatalError(msgs.fileIO.rawValue + msgs.foldercontents.rawValue + msgs.wtf.rawValue)
        }
    }
    
    func writeFileInFolderInDocuments(folderName: String, fileNameToSave: String, fileType: String, data: Data) -> Bool {
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(folderName)
            
            try data.write(to: myDocumentsUrl.appendingPathComponent(fileNameToSave + delimiterFiletype + fileType))
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.success.rawValue, myDocumentsUrl.debugDescription)
            #endif
            
            let contents = try fileManager.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            if contents.count >= 0  {
                return true
            } else {
                return false
            }
        } catch {
            fatalError(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.wtf.rawValue)
        }
    }
    
    func readFileInRecipeNotesOrImagesFolderInDocuments(folderName: String) -> [URL] {
        var myReturnFilesUrls:[URL] = []
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(folderName)
            
            let contents = try fileManager.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            myReturnFilesUrls = contents
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.read.rawValue + msgs.foldercontents.rawValue + " " + myReturnFilesUrls.count.description)
            #endif
            
        } catch {
            switch myReturnFilesUrls.count {
//            case 0:
//                #if DEBUG
//                print(msgs.fileIO.rawValue + msgs.read.rawValue + msgs.foldercontents.rawValue + msgs.empty.rawValue)
//                #endif
            default:
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.read.rawValue + msgs.cannotFindFolder.rawValue)
                #endif
                break
            }
            
        }
        
        #if DEBUG
        print(msgs.fileIO.rawValue + msgs.read.rawValue + msgs.foldercontents.rawValue + msgs.count.rawValue + myReturnFilesUrls.count.description)
        #endif
        return myReturnFilesUrls  // can be empty
    }
    
    
    func writeFileInRecipeNotesOrImagesFolderInDocuments(folderName: String, fileNameToSave: String, fileType: String, data: Data) -> Bool {
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(folderName)
            let tempz = myDocumentsUrl.appendingPathComponent(fileNameToSave + delimiterFiletype + fileType)
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.tempz.rawValue + tempz.absoluteString)
            #endif
            
            let resultz = createRecipeFolders(folderName: folderName)
            
            switch resultz {
            case true:
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.createdRecipeFolder.rawValue)
                #endif
                
            case false:
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.cannotCreateRecipeFolder.rawValue + msgs.fail.rawValue)
                #endif
                
                return resultz
            }
            
            try data.write(to: tempz)
            let contents = try fileManager.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            if contents.count > 0  {
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.createdRecipeFolder.rawValue + msgs.write.rawValue + msgs.success.rawValue)
                #endif
                
                return true
            } else {
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.cannotCreateRecipeFolder.rawValue + msgs.write.rawValue + msgs.note.rawValue + msgs.fail.rawValue)
                #endif
                
                return false
            }
        } catch {
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.write.rawValue + msgs.cannotCreateRecipeFolder.rawValue + msgs.wtf.rawValue)
            #endif
            return false
        }
    }
    
    func checkContentsRecipeFolder(recipeFolder: String) -> [URL] {
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(recipeFolder)
            let contentsRFD = try FileManager.default.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.recipeFolderExists.rawValue, contentsRFD.count)
            #endif
            
            return contentsRFD
        } catch {
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.checkContentsRecipeFolder.rawValue + recipeFolder + " " + msgs.cannotFindFolder.rawValue)
            #endif
            return []
        }
    }
    
    func doesFileNameExistInRecipeFolder(recipeFolder: String, fileName: String) -> Bool   {
        var myReturn = false
        let contentsRF = checkContentsRecipeFolder(recipeFolder: recipeFolder)
        for aUrl in contentsRF {
            if aUrl.description.contains(fileName) {
                myReturn = true
            }
        }
        return myReturn
    }
    
    func createRecipeFolders(folderName: String)  -> Bool  {
        
        do {
            var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            myDocumentsUrl.appendPathComponent(folderName)
            try FileManager.default.createDirectory(at: myDocumentsUrl, withIntermediateDirectories: true)
            
            #if DEBUG
            print(msgs.fileIO.rawValue + msgs.recipeFolderExists.rawValue + msgs.success.rawValue)  // continue without save
            #endif
            
            return true
        } catch {
            // could not create the folder or folder exists
            do {
                var myDocumentsUrl = try fileManager.url(for: .documentDirectory,
                                                         in: .userDomainMask,
                                                         appropriateFor: nil,
                                                         create: true)
                myDocumentsUrl.appendPathComponent(folderName)
                
                _ = try FileManager.default.contentsOfDirectory(at: myDocumentsUrl, includingPropertiesForKeys: nil)
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.recipeFolderExists.rawValue + msgs.success.rawValue)
                #endif
                
                return true
            } catch {
                
                #if DEBUG
                print(msgs.fileIO.rawValue + msgs.createdRecipeFolder.rawValue + msgs.fail.rawValue)
                #endif
                
                return false
            }
        }
    }
    
    func removeFileInRecipeFolder(recipeFolder: String, fileName: String) {
        let contentsRF = checkContentsRecipeFolder(recipeFolder: recipeFolder)
        for aUrl in contentsRF {
            if aUrl.description.contains(fileName) {
                do {
                    try fileManager.removeItem(at: aUrl)
                } catch {
                    #if DEBUG
                    print(msgs.fileIO.rawValue + " Failed remove of aUrl in recipeFolder")
                    #endif
                }
            }
        }
    }
}

