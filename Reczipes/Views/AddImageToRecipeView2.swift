//
//  AddImageToRecipeView2.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

import SwiftUI
import AVFoundation

struct AddImageToRecipeView2: View {
    // MARK: EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - State
    @State fileprivate var recipeSelected: Int = 0
    @State fileprivate var recipeNote: String = ""
    @State fileprivate var showSheet: Bool = false
    @State fileprivate var showImagePicker: Bool = false
    @State fileprivate var recipeImageSaved:Bool = false
    @State fileprivate var image:UIImage?
    @State fileprivate var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State fileprivate var sourceTypes: [UIImagePickerController.SourceType] = [.photoLibrary, .savedPhotosAlbum]
    // MARK: - Properties
    fileprivate enum msgs: String {
        case AddImageToRecipeView2, AIRV = "AddImageToRecipeView2: "
        case recipePickRequestString = "Pick a recipe below ..."
        case navigationTitle = "Add Recipe Image"
        case buttonTitle = "✚ Image"
        case selected = " Selected"
        case picker = "Recipes"
        case failed = "Image save failed"
        case noimageset = "No Image selected yet"
        case success = "Image save succeeded"
        case json = "json"
        case selectPhoto = "Select Photo"
        case choose = "Choose"
        case photolib = "Photo Library"
        case camera = "Camera"
        case bigmsg = "Choose a picture from ..."
        case saving = "Saving Recipe Image"
        case up = "Image is Up, rotate by pi / 2"
        case left = "Image is left, rotating by pi"
        case right = "Image is right, no rotation needed"
        case down = "Image is down, rotate 3 pi / 2"
        case other = "Not LRUDown"
    }
    
    
    fileprivate let fileIO = FileIO()
    fileprivate let encoder = JSONEncoder()
    // MARK: - Methods
    fileprivate func constructAllRecipes() -> [SectionItem] {
        return addedRecipes.getAllRecipes()
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
    
    fileprivate func rotateImageIfNecessary(uiimage: UIImage) -> UIImage {
        let zImg = uiimage
        switch zImg.imageOrientation {
        case UIImage.Orientation.up:

            print(msgs.AddImageToRecipeView2.rawValue + msgs.up.rawValue)

            let zCopy = zImg.rotate(radians:  .pi / 2)
            return zCopy!
        case UIImage.Orientation.down:

            print(msgs.AddImageToRecipeView2.rawValue + msgs.down.rawValue)

            let zCopy = zImg.rotate(radians:  3 * .pi / 2)
            return zCopy!
        case UIImage.Orientation.left:

            print(msgs.AddImageToRecipeView2.rawValue + msgs.left.rawValue)

            let zCopy = zImg.rotate(radians: .pi)
            return zCopy!
        case UIImage.Orientation.right:

            print(msgs.AddImageToRecipeView2.rawValue + msgs.right.rawValue)

            let zCopy = zImg.rotate(radians: 0)
            return zCopy!
        default:

            print(msgs.AddImageToRecipeView2.rawValue + msgs.other.rawValue)

            return zImg
        }
        //        if zImg.imageOrientation == UIImage.Orientation.up {
        //            
        //            print(msgs.imagesview.rawValue + msgs.up.rawValue)
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
    
    fileprivate func addRecipeImage() {
        
        if image == nil {

            print(msgs.AddImageToRecipeView2.rawValue + msgs.noimageset.rawValue)

            return
        }
        let combinedRecipes = constructAllRecipes()
        
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id.description
        let sectionItemName = sectionItem.name
        
        let rotatedImage = rotateImageIfNecessary(uiimage: image!)
        
        let myImageToAdd = ImageSaved(recipeuuid: sectionItemId, imageSaved: (rotatedImage.pngData()!))
        do {
            let encodedImage = try JSONEncoder().encode(myImageToAdd)
            let encodedImageData = Data(encodedImage)
            let dateString = Date().description
            let resultz = fileIO.writeFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeImagesFolderName, fileNameToSave: sectionItemName + delimiterFileNames + sectionItemId.description + delimiterFileNames + dateString, fileType: msgs.json.rawValue, data: encodedImageData)
            if !resultz {

                print(msgs.AddImageToRecipeView2.rawValue + msgs.failed.rawValue)

                
                recipeImageSaved = false
                
            } else {
                recipeNote = ""
                recipeImageSaved = true
                

                print(msgs.AddImageToRecipeView2.rawValue + msgs.success.rawValue)

            }
        } catch {
            
            recipeImageSaved = false
            

            print(msgs.AddImageToRecipeView2.rawValue + msgs.failed.rawValue)

        }
        return
    }
//    
//    fileprivate func constructAllRecipes() -> [SectionItem]  {
//        let newlyAddedRecipes = addedRecipes.getAllRecipes() // if any added
//        let myPresetRecipes = getAllPresetRecipes()
//        var combinedRecipes = myPresetRecipes
//        combinedRecipes.append(contentsOf: newlyAddedRecipes)
//        combinedRecipes = combinedRecipes.sorted(by: ({$0.name < $1.name}))
//        return combinedRecipes
//    }
//
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                //ScrollView {
                VStack {
                    HStack {
                        Text(msgs.navigationTitle.rawValue)
                            .font(Font.system(size: 30, weight: .bold, design: .rounded))
                            .padding()
                        Button(action: {
                            //what to perform
                            self.addRecipeImage()
                        }) {
                            // how the button looks
                            Text(msgs.buttonTitle.rawValue)
                                .fontWeight(.bold)
                                .font(Font.system(size: 20, weight: .medium, design: .serif))
                        }
                        
                    }
                    
                    Text(msgs.recipePickRequestString.rawValue)
                        .foregroundColor(.red)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                    Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                        ForEach(0..<constructAllRecipes().count, id: \.self) { index in
                            Text(constructAllRecipes()[index].name)
                                .foregroundColor(.blue)
                                .font(Font.system(size: 15, weight: .medium, design: .serif))
                        }
                    }
                    .labelsHidden()
                    .clipped()
                    
                    //                Text("\(constructAllRecipes()[recipeSelected].name)" + msgs.selected.rawValue)
                    //                    .foregroundColor(.black)
                    //                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                    //                    .padding()
                    //                Text(msgs.selectPhoto.rawValue)
                    //                    .foregroundColor(.red)
                    //                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                    Image(uiImage: (image ?? UIImage(named: "Default Image"))!)
                        .resizable()
                        .frame(width: proxy.size.width / 4, height: proxy.size.height / 4)
                    Button(action: {
                        // What to perform
                        self.showSheet = true
                    }) {
                        // How the button looks like
                        Text(msgs.bigmsg.rawValue)
                            .foregroundColor(.blue)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                    }
                    .padding()
                    
                    // }  //.frame(minWidth: proxy.size.width, idealWidth: proxy.size.width, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: proxy.size.height, idealHeight: proxy.size.height, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
                    
                    .actionSheet(isPresented: $showSheet) {
                        self.actionSheet
                    }
                    .alert(isPresented: $recipeImageSaved)   {
                        return Alert(title: Text("Saving Recipe Image"), message: Text("Saved"), dismissButton: .default(Text("OK")))
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                    }
                    .padding()
                    //                    .navigationBarItems(
                    //                        trailing: Button(action: addRecipeImage) {
                    //                            Text(msgs.buttonTitle.rawValue).fontWeight(.bold).font(Font.system(size: 20, weight: .medium, design: .serif))
                    //                        }
                    //                    )
                    // }
                }
            }
        }
    }
}


struct AddImageToRecipeView2_Previews: PreviewProvider {
    static var previews: some View {
        AddImageToRecipeView2()
    }
}


