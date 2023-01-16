//
//  AllUserImages.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/28/22.
//

import Foundation
import UIKit

class AllUserImages: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
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
#if DEBUG
            if zBug {print(msgs.aui.rawValue + msgs.uai.rawValue + "\(imagesUrls.count)")}
#endif
            for anImageUrl in imagesUrls {
                let data = try Data(contentsOf: myImagesDirUrl.appendingPathComponent(anImageUrl.lastPathComponent))
                let decodedJSON = try JSONDecoder().decode(ImageSaved.self, from: data)
                myImagesConstructed.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from images")
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: "Images.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        
#if DEBUG
        if zBug {print(msgs.aui.rawValue + msgs.sic.rawValue + "\(shippedImages.count)")}
#endif
        
        if shippedImages.isEmpty  {
            
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
        }
        
        images = myImagesConstructed
        
        if myImagesConstructed.count == 0 {
#if DEBUG
            if zBug {print(msgs.aui.rawValue + msgs.nui.rawValue)}
#endif
        } else {
#if DEBUG
            if zBug {print(msgs.aui.rawValue + msgs.uie.rawValue + " \(myImagesConstructed.count)")}
#endif
        }
        
#if DEBUG
        if zBug {print(msgs.aui.rawValue + msgs.initz.rawValue, msgs.count.rawValue, self.images.count)}
#endif
    }
    // MARK: - Properties
    fileprivate enum msgs: String {
        case initz = " Initialized"
        case count = " Count: "
        case aui = "AllUserImages: "
        case appd = "Appended an image"
        case appdnot = "image already in, did not append"
        case remvd = "image removed"
        case json = ".json"
        case saved = " saved"
        case uie = " User images exist: "
        case nui = " No user images"
        case sic = " Shipped Images Contents count "
        case uai = " User added Images Contents count "
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
                    try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(imageSaved.recipeuuid.uuidString + "_" + dateSuffix() + msgs.json.rawValue))
                    if zBug { print(msgs.aui.rawValue + imageSaved.recipeuuid.uuidString + msgs.json.rawValue + msgs.saved.rawValue)}
                    images.append(imageSaved)
                } catch  {
                    fatalError("Cannot write to user RecipeImages folder")
                }
            } catch  {
                fatalError("Cannot encode ImageSaved to json")
            }
            
            images.append(imageSaved)
#if DEBUG
            if zBug {print(msgs.aui.rawValue + msgs.appd.rawValue)}
#endif
        } else {
#if DEBUG
            if zBug {print(msgs.aui.rawValue + msgs.appdnot.rawValue)}
#endif
        }
    }
    
    func removeImage(imageSaved: ImageSaved) {
        // only removes from the observable object
        // does not remove from user files
        guard let idx = images.firstIndex(of: imageSaved) else { return }
        images.remove(at: idx)
#if DEBUG
        if zBug {print(msgs.aui.rawValue + msgs.remvd.rawValue)}
#endif
    }
}
