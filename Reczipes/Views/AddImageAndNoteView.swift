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
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    @EnvironmentObject var aui: AllUserImages
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
        case rshipd = "recipesShipped"
        case recipePickRequestString = "Pick a recipe below ..."
        case buttonTitleImage = "✚ Image"
        case buttonTitleNote = "✚ Note"
        case selected = " Selected"
        case picker = "Recipes"
        case failed = "Image/Note save failed"
        case noimageset = "No Image selected yet"
        case success = "Image/Note save succeeded"
        case json = ".json"
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
        case recz = "Reczipes"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case gbss = "Got shipped booksections"
        case fuar = "Found user added recipe"
        case nur = "No user recipes"
        case nunotes = "No user notes"
        case nuimages = "No user images"
        case fanote = "Found a note"
        case faimage = "Found an image"
        case wrjson = "Successfully wrote booksection"
        case notejson = "Successfully wrote note"
        case imgjson = "Successfully wrote image"
        case fail = "Failed"
        case succes = "Success"
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
            if zBug {print(msgs.aianv.rawValue + msgs.noimageset.rawValue)}
            return
        }
        
        let combinedRecipes = self.constructAllRecipes()
        
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id
        //        let targetsize = CGSize(width: 90.0, height: 60.0)
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
    
    fileprivate func addRecipeNote() {
        if recipeNote == ""  {
            if zBug {print(msgs.aianv.rawValue + msgs.noteWithoutText.rawValue)}
            return
        }
        
        let combinedRecipes = self.constructAllRecipes()
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id
        
        let myNoteToAdd = Note(recipeuuid: sectionItemId, note: recipeNote)
        aun.addNote(note: myNoteToAdd)
        recipeNoteSaved = true
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
                Text(msgs.aianv.rawValue).font(.largeTitle).bold().padding(.bottom)
                VStack {
                    Text(msgs.recipePickRequestString.rawValue)
                        .foregroundColor(.red)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                    Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                        ForEach(0..<self.constructAllRecipes().count, id: \.self) { index in
                            Text(self.constructAllRecipes()[index].name)
                                .foregroundColor(.blue)
                                .font(Font.system(size: 15, weight: .medium, design: .serif))
                        }
                    }
                }
                VStack {
                    Image(uiImage: (image ?? UIImage(named: "Default Image"))!)
                        .resizable()
                        .frame(width: proxy.size.width / 2, height: proxy.size.height / 5)
                    HStack {
                        Button(action: {
                            // What to perform
                            self.showSheet = true
                        }) {
                            // How the button looks like
                            Text(msgs.bigmsg.rawValue)
                                .foregroundColor(.blue)
                                .font(Font.system(size: 15, weight: .medium, design: .serif))
                        }
                        Spacer()
                        
                        Button(action: {
                            //what to perform
                            self.addRecipeImage()
                        }) {
                            // how the button looks
                            Text(msgs.buttonTitleImage.rawValue)
                        }
                    }.padding()
                }.padding(.bottom)
                
                VStack {
                    HStack {
                        TextEditor(text: $recipeNote)
                            .frame(height: proxy.size.height / 4, alignment: .center)
                            .border(Color.black, width: 2)
                            .focused($textFieldIsFocused)
                            .padding([.leading, .trailing])
                        Button(action: {
                            //what to perform
                            self.addRecipeNote()
                            textFieldIsFocused = false
                        }) {
                            // how the button looks
                            Text(msgs.buttonTitleNote.rawValue)
                        }
                    }.padding(.trailing)
                }
                
            }
            .actionSheet(isPresented: $showSheet) {
                self.actionSheet
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
            .alert(isPresented: $recipeNoteSaved)   {
                recipeNote = ""
                return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.success.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
            }
            .alert(isPresented: $recipeImageSaved)   {
                return Alert(title: Text("Saving Recipe Image"), message: Text("Saved"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddImageAndNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageAndNoteView()
            .environmentObject(AllUserRecipes())
            .environmentObject(AllUserNotes())
            .environmentObject(AllUserImages())
    }
}
