//
//  ImagesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct ImagesView: View {
    // MARK: Debug local
    private var zBug: Bool = true
    // MARK: - Environment
    // MARK: - Initializer
    init(recipeuuid: String) {
        self.myRecipeUUID = UUID(uuidString: recipeuuid)!
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
        case json = ".json"
    }
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    private func getDocuDirUrl() -> URL {
        var myReturn:URL
        do {
            let myDocuDirUrl = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            myReturn = myDocuDirUrl
        } catch {
            fatalError()
        }
        return myReturn
    }
    // MARK: - Methods
    fileprivate func constructImagesIfAvailable() -> Array<ImageSaved> {
        var myImagesConstructed:Array<ImageSaved> = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl.appending(component: msgs.rimages.rawValue), includingPropertiesForKeys: []).filter({$0.absoluteString.contains(myRecipeUUID.uuidString)})
            // now shipped recipes
            
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                do {
                    let anImageSaved = try decoder.decode(ImageSaved.self, from: ajsonfile)
                    myImagesConstructed.append(anImageSaved)
                    if zBug { print(msgs.iv.rawValue + msgs.fau.rawValue)}
                    
                } catch  {
                    // not a json file
                    fatalError("Cannot decode This directory has illegal files")
                }
            }
        } catch {
            
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: msgs.rshippd.rawValue + msgs.json.rawValue).sorted(by: {$0.recipeuuid < $1.recipeuuid})
        if shippedImages.isEmpty  {
            // nothin
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
            
        }
        
        print(msgs.iv.rawValue + msgs.numberofimages.rawValue + "\(myImagesConstructed.count)")
        
        return myImagesConstructed
    }
    
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
                    ForEach(constructImagesIfAvailable(), id: \.self) { savedImage in
                        Image(uiImage: rotateImageIfNecessary(data: savedImage.imageSaved).scaledDown(into: CGSize(width: proxy.size.width / 2, height: proxy.size.height / 2)))
                    }
                }
            }
        }
    }
}


struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesView(recipeuuid: "9926BA12-55C3-4B26-800B-B68AA8D80474")
    }
}

