//
//  ImagesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct ImagesView: View {
    // MARK: Debug local
    private var zBug:Bool = false
    // MARK: - Environment
    @EnvironmentObject var aui: AllUserImages
    // MARK: - Initializer
    init(recipeuuid: UUID) {
        self.myRecipeUUID = recipeuuid
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID
    fileprivate var myImages:[ImageSaved] = []
    fileprivate enum msgs: String {
        case iv = "ImagesView: "
        case cantdecodeimage = "Can't decode image from data"
        case numberofimages = "Number of images for recipe "
        case up = "No rotation needed"
        case left = "Image is left"
        case right = "Image is right"
        case down = "Image is down"
        case other = "Not LRUDown"
        case rimages = "RecipeImages"
        case recz = "Reczipes"
        case fau = "Found an Image"
        case rshippd = "recipesShipped"
//        case json = ".json"
    }
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    fileprivate func rotateImageIfNecessary(data: Data) -> UIImage {
        let zImg = UIImage(data: data)!
        switch zImg.imageOrientation {
        case UIImage.Orientation.up:
            
            print(msgs.iv.rawValue + msgs.up.rawValue)
            
            return zImg
        case UIImage.Orientation.down:
            
            print(msgs.iv.rawValue + msgs.down.rawValue)
            
            return zImg
        case UIImage.Orientation.left:
            
            print(msgs.iv.rawValue + msgs.left.rawValue)
            
            return zImg
        case UIImage.Orientation.right:
            
            print(msgs.iv.rawValue + msgs.right.rawValue)
            
            return zImg
        default:
            
            print(msgs.iv.rawValue + msgs.other.rawValue)
            
            return zImg
        }
        //        if zImg.imageOrientation == UIImage.Orientation.up {
        //
        //            print(msgs.iv.rawValue + msgs.up.rawValue)
        //
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
                    ForEach(aui.images.filter({$0.recipeuuid == myRecipeUUID}), id: \.self) { savedImage in
                        Image(uiImage: rotateImageIfNecessary(data: savedImage.imageSaved).scaledDown(into: CGSize(width: proxy.size.width / 2, height: proxy.size.height / 2)))
                    }
                }
            }
        }
    }
}


struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(recipeuuid: UUID(uuidString: "9926BA12-55C3-4B26-800B-B68AA8D80474")!)
    }
}

