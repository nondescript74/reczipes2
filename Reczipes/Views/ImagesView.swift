//
//  ImagesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct ImagesView: View {
    // MARK: - Initializer
    init(recipeuuid: String) {
        self.myRecipeUUID = UUID(uuidString: recipeuuid)!
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID
    fileprivate var myImages:[ImageSaved] = []
    fileprivate let fileIO = FileIO()
    fileprivate enum msgs: String {
        case imagesview = "ImagesView: "
        case cantdecodeimage = "Can't decode image from data"
        case numberofimages = "Number of images for recipe "
        case up = "No rotation needed"
        case left = "Image is left"
        case right = "Image is right"
        case down = "Image is down"
        case other = "Not LRUDown"
    }
    // MARK: - Methods
    fileprivate func constructImagesIfAvailable() -> Array<ImageSaved> {
        var myImagesConstructed:Array<ImageSaved> = []
        let myImagesUrls = fileIO.readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeImagesFolderName)
        let zmyImagesUrls = myImagesUrls.filter {$0.description.contains(myRecipeUUID.description)}
        for aUrl in zmyImagesUrls {
            let imageData = fileIO.getFileDataAtUrl(url: aUrl)
            do {
                let imagez = try JSONDecoder().decode(ImageSaved.self, from: imageData)
                // now get the image
                myImagesConstructed.append(imagez)
            } catch {
                
                #if DEBUG
                print(msgs.imagesview.rawValue + msgs.cantdecodeimage.rawValue)
                #endif
            }
        }
        
        #if DEBUG
        print(msgs.imagesview.rawValue + msgs.numberofimages.rawValue + "\(myImagesConstructed.count)")
        #endif
        
        return myImagesConstructed
    }
    
    fileprivate func rotateImageIfNecessary(data: Data) -> UIImage {
        let zImg = UIImage(data: data)!
        switch zImg.imageOrientation {
        case UIImage.Orientation.up:
            #if DEBUG
            print(msgs.imagesview.rawValue + msgs.up.rawValue)
            #endif
            return zImg
        case UIImage.Orientation.down:
            #if DEBUG
            print(msgs.imagesview.rawValue + msgs.down.rawValue)
            #endif
            return zImg
        case UIImage.Orientation.left:
            #if DEBUG
            print(msgs.imagesview.rawValue + msgs.left.rawValue)
            #endif
            return zImg
        case UIImage.Orientation.right:
            #if DEBUG
            print(msgs.imagesview.rawValue + msgs.right.rawValue)
            #endif
            return zImg
        default:
            #if DEBUG
            print(msgs.imagesview.rawValue + msgs.other.rawValue)
            #endif
            return zImg
        }
//        if zImg.imageOrientation == UIImage.Orientation.up {
//            #if DEBUG
//            print(msgs.imagesview.rawValue + msgs.up.rawValue)
//            #endif
//            return zImg
//        } else {
//            UIGraphicsBeginImageContext(zImg.size)
//            zImg.draw(in: CGRect(origin: .zero, size: zImg.size))
//            let zCopy = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            return zCopy
//        }
    }
    // MARK: - View Process
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(constructImagesIfAvailable(), id: \.self) { savedImage in
                        Image(uiImage: rotateImageIfNecessary(data: savedImage.imageSaved).scaledDown(into: CGSize(width: proxy.size.width / 2, height: proxy.size.height / 2)))
                        // UIImage(data: savedImage.imageSaved)!.scaledDown(into: CGSize(width: proxy.size.width / 2, height: proxy.size.height / 2))
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(recipeuuid: "9926BA12-55C3-4B26-800B-B68AA8D80474")
    }
}
#endif
