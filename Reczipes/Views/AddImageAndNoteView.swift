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
//    @EnvironmentObject var fileMgr: FileMgr
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
    fileprivate func constructAllRecipes() -> [SectionItem] {
        var myReturn: [SectionItem] = []
        var myBs: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                if aurl.pathComponents.contains(msgs.rnotes.rawValue) || aurl.pathComponents.contains(msgs.rimages.rawValue)  {
                    // skip these folders
                } else {
                    let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                    do {
                        let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                        myBs.append(aBookSection)
                        if zBug { print(msgs.aianv.rawValue + msgs.fuar.rawValue)}
                        
                    } catch  {
                        // not a json file
                        fatalError("This directory has illegal files")
                    }
                    for abs in myBs {
                        myReturn.append(contentsOf: abs.items)
                    }
                }
            }
        } catch  {
            // no contents
        }

        let bookSections:[BookSection] = Bundle.main.decode([BookSection].self, from: msgs.rshipd.rawValue + json).sorted(by: {$0.name < $1.name})
        if bookSections.isEmpty  {
            
        } else {
            for abs in bookSections {
                myReturn.append(contentsOf: abs.items)
            }
        }
        return myReturn
    }
    
    fileprivate func addRecipeImage() {
        if image == nil {
            if zBug {print(msgs.aianv.rawValue + msgs.noimageset.rawValue)}
            return
        }
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        let combinedRecipes = self.constructAllRecipes()
        
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id
        let rotatedImage = rotateImageIfNecessary(uiimage: image!)
        
        let myImageToAdd = ImageSaved(recipeuuid: sectionItemId, imageSaved: (rotatedImage.pngData()!))

        
            
            
            let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
            do {
                let encodedJSON = try encoder.encode(myImageToAdd)
                // now write out
                do {
                    try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(myImageToAdd.recipeuuid.uuidString + json))
                    if zBug { print(msgs.aianv.rawValue + msgs.imgjson.rawValue)}
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
    }
    
    fileprivate func addRecipeNote() {
        if recipeNote == ""  {
            if zBug {print(msgs.aianv.rawValue + msgs.noteWithoutText.rawValue)}
            return
        }
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        let combinedRecipes = self.constructAllRecipes()
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id
        
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        
        let myNoteToAdd = Note(recipeuuid: sectionItemId, note: recipeNote)
        do {
            let encodedJSON = try encoder.encode(myNoteToAdd)
            // now write out
            do {
                try encodedJSON.write(to: myNotesDirUrl.appendingPathComponent(myNoteToAdd.recipeuuid.uuidString + json))
                if zBug { print(msgs.aianv.rawValue + msgs.notejson.rawValue)}
                let result = try FileManager.default.contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [])
                if zBug { print(msgs.aianv.rawValue + "Contents count " + "\(result.count)")}
            } catch  {
                fatalError("Cannot write to user RecipeNotes folder")
            }
        } catch  {
            fatalError("Cannot encode booksection to json")
        }
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
