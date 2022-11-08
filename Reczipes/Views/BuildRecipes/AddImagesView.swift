//
//  AddImagesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/26/22.
//

import SwiftUI

struct AddImagesView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Initializer
    init(id: UUID) {
        self.id = id
    }
    // MARK: - State
    @State fileprivate var showSheet: Bool = false
    @State fileprivate var showImagePicker: Bool = false
    @State fileprivate var recipeImageSaved:Bool = false
    @State fileprivate var image:UIImage?
    @State fileprivate var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State fileprivate var sourceTypes: [UIImagePickerController.SourceType] = [.photoLibrary, .savedPhotosAlbum]
    
    // MARK: - Properties
    fileprivate enum msgs: String {
        case aiv = "AddImagesView: "
        case selectPhoto = "Select Photo"
        case noimageset = "No Image selected yet"
        case recz = "Reczipes"
        case choose = "Choose"
        case photolib = "Photo Library"
        case camera = "Camera"
        case bigmsg = "Choose a picture from ..."
        case saving = "Saving Recipe Image"
        case cancel = "Cancel"
        case up = "Image is Up, rotate by pi / 2"
        case left = "Image is left, rotating by pi"
        case right = "Image is right, no rotation needed"
        case down = "Image is down, rotate 3 pi / 2"
        case other = "Not LRUDown"
        case buttonTitleImage = "✚ Image"
        case saved = "Saved"
        case ok = "Ok"
        case defImg = "Default Image"
        case na = "Nothing available"
        case imgjson = "Successfully wrote image"
        case fail = "Failed"
        case succes = "Success"
    }
    
    fileprivate var id: UUID
    
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    
    fileprivate func addRecipeImage() {
        if image == nil {
            if zBug {print(msgs.aiv.rawValue + msgs.noimageset.rawValue)}
            return
        }
        let myReczipesDirUrl:URL = getDocuDirUrl().appending(path: msgs.recz.rawValue)
        let combinedRecipes = FileManager.default.constructAllRecipes()
        
        let rotatedImage = rotateImageIfNecessary(uiimage: image!)
        
        let myImageToAdd = ImageSaved(recipeuuid: id, imageSaved: (rotatedImage.pngData()!))
            let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
            do {
                let encodedJSON = try encoder.encode(myImageToAdd)
                do {
                    try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(myImageToAdd.recipeuuid.uuidString + "_" + dateSuffix() + json))
                    if zBug { print(msgs.aiv.rawValue + msgs.imgjson.rawValue)}
                } catch  {
                    fatalError("Cannot write to user RecipeImages folder")
                }
            } catch  {
                fatalError("Cannot encode booksection to json")
            }
    }
    
    fileprivate func rotateImageIfNecessary(uiimage: UIImage) -> UIImage {
        let zImg = uiimage
        switch zImg.imageOrientation {
        case UIImage.Orientation.up:
            
            if zBug {print(msgs.aiv.rawValue + msgs.up.rawValue)}
            let zCopy = zImg.rotate(radians:  .pi / 2)
            return zCopy!
        case UIImage.Orientation.down:
            if zBug {print(msgs.aiv.rawValue + msgs.down.rawValue)}
            
            let zCopy = zImg.rotate(radians:  3 * .pi / 2)
            return zCopy!
        case UIImage.Orientation.left:
            
            if zBug {print(msgs.aiv.rawValue + msgs.left.rawValue)}
            
            let zCopy = zImg.rotate(radians: .pi)
            return zCopy!
        case UIImage.Orientation.right:
            
            if zBug {print(msgs.aiv.rawValue + msgs.right.rawValue)}
            
            let zCopy = zImg.rotate(radians: 0)
            return zCopy!
        default:
            
            print(msgs.aiv.rawValue + msgs.other.rawValue)
            
            return zImg
        }
    }
    var body: some View {
//        GeometryReader { proxy in
            VStack {
                Image(uiImage: (image ?? UIImage(named: msgs.defImg.rawValue))!)
//                    .resizable()
//                    .frame(width: proxy.size.width / 2, height: proxy.size.height / 4)
                    
                Button(action: {
                    // What to perform
                    self.showSheet = true
                }) {
                    // How the button looks like
                    Text(msgs.bigmsg.rawValue)
                        .foregroundColor(.blue)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                }.padding(.bottom)
                
                HStack {
                    Button(action: {
                        //what to perform
                        self.addRecipeImage()
                    }) {
                        // how the button looks
                        Text(msgs.buttonTitleImage.rawValue)
                            .fontWeight(.bold)
                            .font(Font.system(size: 20, weight: .medium, design: .serif))
                    }
                    
                }.padding(.bottom)
            }.padding()
        
            .actionSheet(isPresented: $showSheet) {
                self.actionSheet
            }
            .alert(isPresented: $recipeImageSaved)   {
                return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.saved.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
            
//        }

    }
    
    var actionSheet: ActionSheet {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            // camera is available
            sourceTypes = [.camera, .photoLibrary, .savedPhotosAlbum]
            return ActionSheet(title: Text(msgs.selectPhoto.rawValue),
                               message: Text(msgs.choose.rawValue),
                               buttons: [
                                .default(Text(msgs.photolib.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .default(Text(msgs.camera.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .camera
                                },
                                .cancel()
                               ])
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
//            sourceTypes = [.photoLibrary, .savedPhotosAlbum]
            return ActionSheet(title: Text(msgs.selectPhoto.rawValue),
                               message: Text(msgs.choose.rawValue),
                               buttons: [
                                .default(Text(msgs.photolib.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .cancel()
                               ])
        } else {
            return ActionSheet(title: Text(msgs.na.rawValue),
                               message: Text(msgs.cancel.rawValue),
                               buttons: [
                                .default(Text(msgs.ok.rawValue)) {
                                    self.showImagePicker = false
                                    self.sourceType = .savedPhotosAlbum
                                },
                                .cancel()
                               ])
        }
    }
}

struct AddImagesView_Previews: PreviewProvider {
    static var previews: some View {
        AddImagesView(id: UUID())
    }
}
