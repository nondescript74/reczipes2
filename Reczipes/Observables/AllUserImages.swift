//
//  AllUserImages.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/28/22.
//

import Foundation
import SwiftUI
import OSLog

class AllUserImages: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "AllUserImages")

    // MARK: - Publisher
    @Published var images: [ImageSaved] = []
    // MARK: - Initializer
    init() {
        var myImagesConstructed:Array<ImageSaved> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
        do {
            let imagesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myImagesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            logger.info("User images count: \(imagesUrls.count)")
            for anImageUrl in imagesUrls {
                let data = try Data(contentsOf: myImagesDirUrl.appendingPathComponent(anImageUrl.lastPathComponent))
                let decodedJSON = try JSONDecoder().decode(ImageSaved.self, from: data)
                myImagesConstructed.append(decodedJSON)
                logger.info("Decoded and appended user image: \(anImageUrl.lastPathComponent)")
            }
        } catch  {
            logger.error("Error in getting user images: \(error.localizedDescription)")
            fatalError("Cannot read or decode from images")
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: "Images.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        logger.info("Shipped images count: \(shippedImages.count)")
        if shippedImages.isEmpty  {
            logger.info("Shiped images array is empty")
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
        }
        
        images = myImagesConstructed
        
        if myImagesConstructed.count == 0 {
            logger.info("myImagesConstructed array is empty")
        } else {
            logger.info("myImagesConstructed array count: \(myImagesConstructed.count)")
        }
        logger.info("Initialization complete")
    }
    
    // MARK: - Methods

    func addImage(imageSaved: ImageSaved) {
        let idx = images.firstIndex(of: imageSaved)
        if idx == nil {
            let myReczipesDirUrl:URL = getDocuDirUrl().appending(path: recipesName)
            let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
            do {
                let encodedJSON = try JSONEncoder().encode(imageSaved)
                do {
                    let filename = imageSaved.recipeuuid.uuidString + ".json"
                    try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(filename))
                    images.append(imageSaved)
                    logger.info("Saved imageSaved to user RecipeImages folder")
                } catch  {
                    logger.error("Cannot write imageSaved to user RecipeImages folder")
                    fatalError()
                }
            } catch  {
                logger.error( "Cannot encode ImageSaved to json")
                fatalError()
            }
            logger.info( "ImageSaved added")
        } else {
            logger.info( "ImageSaved already exists, did not add")
        }
    }
    
    func removeImage(imageSaved: ImageSaved) {
        // only removes from the observable object
        // does not remove from user files
        guard let idx = images.firstIndex(of: imageSaved) else { return }
        images.remove(at: idx)
        logger.trace(#function)
        logger.info("Removed image \(imageSaved.recipeuuid) from AllUserImages")
    }
    
    func removeImageAndStored(imageSaved: ImageSaved) {
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
        
        do {
            let imagesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myImagesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            for anImageUrl in imagesUrls {
                let data = try Data(contentsOf: myImagesDirUrl.appendingPathComponent(anImageUrl.lastPathComponent))
                let decodedJSON = try JSONDecoder().decode(ImageSaved.self, from: data)
                if decodedJSON == imageSaved {
                    try FileManager.default.removeItem(atPath: anImageUrl.absoluteString)
                    logger.info( "Removed image \(imageSaved.recipeuuid) from AllUserImages and from disk")
                }
            }
        } catch  {
            logger.error("Cannot read or decode from images")
        }
    }
}
