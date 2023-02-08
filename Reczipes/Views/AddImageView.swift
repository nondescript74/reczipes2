//
//  AddImageView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/8/23.
//

import SwiftUI

struct AddImageView: View {
    // MARK: - Debug local
    private let zBug = true
    // MARK: - Initializer
    // MARK: EnvironmentObject
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    // MARK: - Focus for textfield
    @FocusState private var textFieldIsFocused:Bool
    // MARK: - State
    @State fileprivate var recipeSelected: Int = 0
    @State fileprivate var showSheet: Bool = false
    @State fileprivate var showImagePicker: Bool = false
    @State fileprivate var recipeImageSaved:Bool = false
    @State fileprivate var image:UIImage?
    @State fileprivate var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State fileprivate var sourceTypes: [UIImagePickerController.SourceType] = [.photoLibrary, .savedPhotosAlbum]
    // MARK: - Properties
    fileprivate enum msgs: String {
        case aiv = "Add Image"
        case recipePickRequestString = "Pick a recipe below ..."
        case buttonTitleImage = "✚ Image"
        case picker = "Recipes"
        case noimageset = "No Image selected yet"
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
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    fileprivate func constructAllSections() -> [BookSection] {
        return aur.sections
    }
    
    fileprivate func constructAllRecipes() -> [SectionItem] {
        var myReturn: [SectionItem] = []
        let myBs: [BookSection] = self.constructAllSections()
        if myBs.isEmpty {
            // nothing to do, no available booksections
        } else {
            for abs in myBs {
                myReturn.append(contentsOf: abs.items) // all the recipes in the section
            }
        }
        return myReturn
    }
    
    fileprivate func addRecipeImage() {
        if image == nil {
            if zBug {print(msgs.aiv.rawValue + msgs.noimageset.rawValue)}
            return
        }
        
        let combinedRecipes = self.constructAllRecipes()
        
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id
        let sizedImage = resizeImage(image: image!, targetSize: targetsize)
        //        let rotatedImage = rotateImageIfNecessary(uiimage: image!)
        
        let myImageToAdd = ImageSaved(recipeuuid: sectionItemId, imageSaved: (sizedImage.pngData()!))
        aui.addImage(imageSaved: myImageToAdd)
        recipeImageSaved = true
    }
    
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
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
        
        return newImage!
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
                    Text(msgs.recipePickRequestString.rawValue)
                        .foregroundColor(.red)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                    Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                        ForEach(0..<self.constructAllRecipes().count, id: \.self) { index in
                            Text(self.constructAllRecipes()[index].name)
                                .foregroundColor(.blue)
                            //                            .font(Font.system(size: 10, weight: .medium, design: .serif))
                        }
                    }
                    
                    
                    Image(uiImage: (image ?? UIImage(named: msgs.defImg.rawValue))!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    //                        .frame(width: proxy.size.width / 2, height: proxy.size.height / 5)
                    
                    Button(action: {
                        // What to perform
                        self.showSheet = true
                    }) {
                        // How the button looks like
                        Text(msgs.bigmsg.rawValue)
                            .foregroundColor(.blue)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                    }.padding(.bottom)
                    
                    
                    Button(action: {
                        //what to perform
                        self.addRecipeImage()
                    }) {
                        // how the button looks
                        Text(msgs.buttonTitleImage.rawValue)
                    }
                }
            }
            .actionSheet(isPresented: $showSheet) {
                self.actionSheet
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
            .alert(isPresented: $recipeImageSaved)   {
                return Alert(title: Text(msgs.alsav.rawValue), message: Text(msgs.saved.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
            }
        }
    }
}

struct AddImageView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageView()
            .environmentObject(AllUserRecipes())
            .environmentObject(AllUserImages())
    }
}
