//
//  AddImageAndNoteView.swift
//  AddImageAndNoteView
//
//  Created by Zahirudeen Premji on 8/17/21.
//

import SwiftUI

struct AddImageAndNoteView: View {
    // MARK: - Debug local
    private let zBug = true
    // MARK: - Initializer
    // MARK: EnvironmentObject
    @EnvironmentObject var fileMgr: FileMgr
    // MARK: - Focus for textfield
    @FocusState private var textFieldIsFocused:Bool
    // MARK: - State
    @State fileprivate var recipeSelected: Int = 0
    @State fileprivate var recipeNote: String = ""
    @State fileprivate var recipeNoteSaved:Bool = false
    @State fileprivate var showSheet: Bool = false
    @State fileprivate var showImagePicker: Bool = false
    @State fileprivate var recipeImageSaved:Bool = false
    @State fileprivate var image:UIImage?
    @State fileprivate var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State fileprivate var sourceTypes: [UIImagePickerController.SourceType] = [.photoLibrary, .savedPhotosAlbum]
    // MARK: - Properties
    fileprivate enum msgs: String {
        case aianv = "Add Image/Note"
        case recipePickRequestString = "Pick a recipe below ..."
        case buttonTitleImage = "✚ Image"
        case buttonTitleNote = "✚ Note"
        case selected = " Selected"
        case picker = "Recipes"
        case failed = "Image/Note save failed"
        case noimageset = "No Image selected yet"
        case success = "Image/Note save succeeded"
        case json = "json"
        case selectPhoto = "Select Photo"
        case choose = "Choose"
        case photolib = "Photo Library"
        case camera = "Camera"
        case bigmsg = "Choose a picture from ..."
        case saving = "Saving Recipe Image or Note"
        case up = "Image is Up, rotate by pi / 2"
        case left = "Image is left, rotating by pi"
        case right = "Image is right, no rotation needed"
        case down = "Image is down, rotate 3 pi / 2"
        case other = "Not LRUDown"
        case initialNoteString = "Enter a recipe note below ..."
        case noteWithoutText = "Note has no text entered"
        case ok = "Okay"
    }
    //    fileprivate let fileIO = FileIO()
    fileprivate let encoder = JSONEncoder()
    // MARK: - Methods
    fileprivate func constructAllRecipes() -> [SectionItem] {
        //        let shippedBookSections = Bundle.main.decode([BookSection].self, from: "recipesShipped.json")
        //        var recipesShipped:[SectionItem] = []
        //        for aBS in shippedBookSections {
        //            recipesShipped += aBS.items
        //        }
        //        return addedRecipes.getAllRecipes() + recipesShipped
        let bsUser = fileMgr.getUserBookSections()
        let bsShipped = fileMgr.getShippedBookSections()
        var recipesCombined: [SectionItem] = []
        
        for abs in bsShipped {
            recipesCombined.append(contentsOf: abs.items)
        }
        
        for abs in bsUser {
            recipesCombined.append(contentsOf: abs.items)
        }
        return recipesCombined
    }
    
    fileprivate func addRecipeImage() {
        if image == nil {
            if zBug {print(msgs.aianv.rawValue + msgs.noimageset.rawValue)}
            return
        }
        let combinedRecipes = self.constructAllRecipes()
        
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id.description
//        let sectionItemName = sectionItem.name
        
        let rotatedImage = rotateImageIfNecessary(uiimage: image!)
        
        let myImageToAdd = ImageSaved(recipeuuid: sectionItemId, imageSaved: (rotatedImage.pngData()!))
        let result = fileMgr.addRecipeImage(image: myImageToAdd)
        if result {
            recipeImageSaved = true
            if zBug {print(msgs.aianv.rawValue + msgs.success.rawValue)}
        } else {
            recipeImageSaved = false
            print(msgs.aianv.rawValue + msgs.failed.rawValue)
        }
        //        do {
        //            let encodedImage = try JSONEncoder().encode(myImageToAdd)
        //            let encodedImageData = Data(encodedImage)
        ////            let dateString = Date().description
        ////            let resultz = fileIO.writeFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeImagesFolderName, fileNameToSave: sectionItemName + delimiterFileNames + sectionItemId.description + delimiterFileNames, fileType: msgs.json.rawValue, data: encodedImageData)
        //
        //            if !resultz {
        //                print(msgs.aianv.rawValue + msgs.failed.rawValue)
        //                recipeImageSaved = false
        //            } else {
        //                recipeImageSaved = true
        //                if zBug {print(msgs.aianv.rawValue + msgs.success.rawValue)}
        //            }
        //        } catch {
        //            recipeImageSaved = false
        //            print(msgs.aianv.rawValue + msgs.failed.rawValue)
        //        }
        return
    }
    
    fileprivate func rotateImageIfNecessary(uiimage: UIImage) -> UIImage {
        let zImg = uiimage
        switch zImg.imageOrientation {
        case UIImage.Orientation.up:
            
            if zBug {print(msgs.aianv.rawValue + msgs.up.rawValue)}
            let zCopy = zImg.rotate(radians:  .pi / 2)
            return zCopy!
        case UIImage.Orientation.down:
            if zBug {print(msgs.aianv.rawValue + msgs.down.rawValue)}
            
            let zCopy = zImg.rotate(radians:  3 * .pi / 2)
            return zCopy!
        case UIImage.Orientation.left:
            
            if zBug {print(msgs.aianv.rawValue + msgs.left.rawValue)}
            
            let zCopy = zImg.rotate(radians: .pi)
            return zCopy!
        case UIImage.Orientation.right:
            
            if zBug {print(msgs.aianv.rawValue + msgs.right.rawValue)}
            
            let zCopy = zImg.rotate(radians: 0)
            return zCopy!
        default:
            
            print(msgs.aianv.rawValue + msgs.other.rawValue)
            
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
    
    fileprivate func addRecipeNote() {
        if recipeNote == ""  {
            if zBug {print(msgs.aianv.rawValue + msgs.noteWithoutText.rawValue)}
            return
        }
        let combinedRecipes = self.constructAllRecipes()
//        let combinedRecipes = addedRecipes.getAllRecipes()
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id.description
//        let sectionItemName = sectionItem.name
        
        let myNoteToAdd = Note(recipeuuid: sectionItemId, note: recipeNote)
        let result = fileMgr.addRecipeNote(note: myNoteToAdd)
        if result {
            recipeNoteSaved = true
            if zBug {print(msgs.aianv.rawValue + msgs.success.rawValue)}
        } else {
            recipeNoteSaved = false
            print(msgs.aianv.rawValue + msgs.failed.rawValue)
        }
//        do {
//            let encodedNote = try JSONEncoder().encode(myNoteToAdd)
//            let encodedNoteData = Data(encodedNote)
//            let dateString = Date().description
//            let resultz = fileIO.writeFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeNotesFolderName, fileNameToSave: sectionItemName + delimiterFileNames + sectionItemId + delimiterFileNames + dateString, fileType: msgs.json.rawValue, data: encodedNoteData)
//
//            if !resultz {
//                recipeNoteSaved = false
//                print(msgs.aianv.rawValue + msgs.failed.rawValue)
//            } else {
//                recipeNote = ""
//                recipeNoteSaved = true
//                if zBug {print(msgs.aianv.rawValue + msgs.success.rawValue)}
//            }
//        } catch {
//            recipeNoteSaved = false
//            print(msgs.aianv.rawValue + msgs.failed.rawValue)
//        }
        return
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
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Text(msgs.aianv.rawValue).font(.largeTitle).bold()
                    VStack {
                        
                        Text(msgs.recipePickRequestString.rawValue)
                            .foregroundColor(.red)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                        Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                            ForEach(0..<constructAllRecipes().count, id: \.self) { index in
                                Text(constructAllRecipes()[index].name)
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                            }
                        }.padding()
                    }
                    Divider()
                    
                    VStack {
                        Image(uiImage: (image ?? UIImage(named: "Default Image"))!)
                            .resizable()
                            .frame(width: proxy.size.width / 2, height: proxy.size.height / 4)
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
                            
                            Button(action: {
                                //what to perform
                                textFieldIsFocused = false
                                self.addRecipeNote()
                            }) {
                                // how the button looks
                                Text(msgs.buttonTitleNote.rawValue)
                                    .fontWeight(.bold)
                                    .font(Font.system(size: 20, weight: .medium, design: .serif))
                            }
                        }.padding(.bottom)
                    }
                    Divider()
                    
                    VStack {
                        TextEditor(text: $recipeNote)
                            .padding(10)
                            .frame(height: proxy.size.height / 4, alignment: .center)
                            .border(Color.black, width: 2)
                            .focused($textFieldIsFocused)
                        
                    }
                }.padding(.bottom)
                    .actionSheet(isPresented: $showSheet) {
                        self.actionSheet
                    }
                    .alert(isPresented: $recipeImageSaved)   {
                        return Alert(title: Text("Saving Recipe Image"), message: Text("Saved"), dismissButton: .default(Text("OK")))
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                    }
                    .alert(isPresented: $recipeNoteSaved)   {
                        return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.success.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
                    }
            }
        }
    }
}

struct AddImageAndNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageAndNoteView()
    }
}
