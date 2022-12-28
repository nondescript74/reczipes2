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
    fileprivate var zBug: Bool = true
    // MARK: - Publisher
    @Published var images: [ImageSaved] = []
    // MARK: - Initializer
    init() {
        self.images = FileManager.default.constructImagesIfAvailable()
#if DEBUG
        print(msgs.aui.rawValue + "initialized", "count: ", self.images.count)
#endif
    }
    // MARK: - Properties
    fileprivate enum msgs: String {
        case aui = "AllUserImages: "
        case appd = "Appended an image"
        case appdnot = "image already in, did not append"
        case remvd = "image removed"
        case json = ".json"
        case saved = " saved"
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
            print(msgs.aui.rawValue + msgs.appd.rawValue)
#endif
        } else {
#if DEBUG
            print(msgs.aui.rawValue + msgs.appdnot.rawValue)
#endif
        }
    }
    
    func removeImage(imageSaved: ImageSaved) {
        // only removes from the observable object
        // does not remove from user files
        guard let idx = images.firstIndex(of: imageSaved) else { return }
        images.remove(at: idx)
#if DEBUG
        print(msgs.aui.rawValue + msgs.remvd.rawValue)
#endif
    }
}
