//
//  AddImageView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/8/23.
//

import SwiftUI
import OSLog

struct AddImageView: View {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.playrecipes", category: "AddImageView")
    
    // MARK: - Initializer
    init(recipeid: UUID) {
        self.recipeId = recipeid
        logger.info("Initializing AddImageView with recipeid: \(recipeid)")
    }
    // MARK: EnvironmentObject
    @Environment(AllUserRecipes.self) private var aur
    @Environment(AllUserImages.self) private var aui
    // MARK: - Focus for textfield
    // MARK: - State
    @State fileprivate var recipeSelected: Int = 0
    @State fileprivate var showSheet: Bool = false
    @State fileprivate var showImagePicker: Bool = false
    @State fileprivate var recipeImageSaved:Bool = false
    @State fileprivate var image:UIImage?
    @State fileprivate var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State fileprivate var sourceTypes: [UIImagePickerController.SourceType] = [.photoLibrary, .savedPhotosAlbum]
    // MARK: - Properties
    fileprivate var recipeId: UUID
    fileprivate enum msgs: String {
        case aiv = "AddImageView: "
        case recipePickRequestString = "Pick a recipe"
        case picker = "Recipes"
        case selectPhoto = "Select Photo"
        case choose = "Choose"
        case photolib = "Photo Library"
        case camera = "Camera"
        case bigmsg = "Choose a picture from ..."
        case alsav = "Saving Recipe Image"
        case saved = "Saved"
        case ok = "Okay"
        case defImg = "Default Image"
    }
    var isDirectory: ObjCBool = true
    
    // MARK: - Methods
    
    fileprivate func convertImageToImageSaved() -> ImageSaved {
        let imageSaved = ImageSaved(recipeuuid: recipeId, imageSaved:  self.image!.pngData()!)
        logger.info("Converted image to ImageSaved, recipeId: \(recipeId.uuidString)")
        return imageSaved
    }
    
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        logger.info("resizeImage, widthRatio: \(widthRatio), heightRatio: \(heightRatio)")
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        logger.info("resizeImage - done with newSize")
        return newImage!
    }
    
    fileprivate func getRecipes() -> [SectionItem3]  {
        var myReturn: [SectionItem3] = []
        for bs in aur.sections {
            myReturn.append(contentsOf: bs.items)
        }
        logger.info("getRecipes: returning \(myReturn.count)")
        return myReturn
    }
    
    fileprivate var actionSheet: ActionSheet {
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
        } else {
            sourceTypes = [.photoLibrary, .savedPhotosAlbum]
            return ActionSheet(title: Text(msgs.selectPhoto.rawValue),
                               message: Text(msgs.choose.rawValue),
                               buttons: [
                                .default(Text(msgs.photolib.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .cancel()
                               ])
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(msgs.aiv.rawValue).font(.largeTitle).bold().padding(.bottom)
                VStack {
                    HStack {
                        Text(msgs.recipePickRequestString.rawValue)
                            .foregroundColor(.red)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                        Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                            ForEach(0..<getRecipes().count, id: \.self) { index in
                                Text(getRecipes()[index].name)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    
                    Image(uiImage: (image ?? UIImage(named: msgs.defImg.rawValue))!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    Button(action: {
                        // What to perform
                        self.showSheet = true
                    }) {
                        // How the button looks like
                        Text(msgs.bigmsg.rawValue)
                            .foregroundColor(.blue)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                    }.padding(.bottom)
                    
                    Spacer()
                    Button(action: {
                        //what to perform
                        let resizedImage = resizeImage(image: image!, targetSize: imageTargetSize)
                        image = resizedImage
                        aui.addImage(imageSaved: convertImageToImageSaved())
                        recipeImageSaved.toggle()
                    }) {
                        // how the button looks
                        Label("Save", systemImage: "plus.circle")
                            .clipShape(Capsule())
                    }
                }
            }
            .environment(aur)
            .environment(aui)
            
            .actionSheet(isPresented: $showSheet) {
                self.actionSheet
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
            .alert(isPresented: $recipeImageSaved)   {
//                self.recipeImageSaved = false
                return Alert(title: Text(msgs.alsav.rawValue), message: Text(msgs.saved.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
            }
        }
    }
}

struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView(recipeid: SectionItem3.example.id)
            .environment(AllUserRecipes())
            .environment(AllUserImages())
    }
}
