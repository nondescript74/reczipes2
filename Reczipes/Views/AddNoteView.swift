//
//  AddNoteView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/8/23.
//

import SwiftUI

struct AddNoteView: View {
    // MARK: - Debug local
    private let zBug = true
    // MARK: - Initializer
    // MARK: EnvironmentObject
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aun: AllUserNotes
    // MARK: - Focus for textfield
    @FocusState private var textFieldIsFocused:Bool
    // MARK: - State
    @State fileprivate var recipeSelected: Int = 0
    @State fileprivate var recipeNote: String = ""
    @State fileprivate var recipeNoteSaved:Bool = false
    // MARK: - Properties
    fileprivate enum msgs: String {
        case anv = "Add Note"
//        case rshipd = "recipesShipped"
        case recipePickRequestString = "Pick a recipe below ..."
//        case buttonTitleImage = "✚ Image"
        case buttonTitleNote = "✚ Note"
        case selected = " Selected"
        case picker = "Recipes"
        case failed = "Note save failed"
//        case noimageset = "No Image selected yet"
        case saving = "Saving"
        case success = "Note save succeeded"
//        case json = ".json"
//        case selectPhoto = "Select Photo"
//        case choose = "Choose"
//        case photolib = "Photo Library"
//        case camera = "Camera"
//        case bigmsg = "Choose a picture from ..."
//        case saving = "Saving Recipe Image or Note"
//        case up = "Image is Up, rotate by pi / 2"
//        case left = "Image is left, rotating by pi"
//        case right = "Image is right, no rotation needed"
//        case down = "Image is down, rotate 3 pi / 2"
//        case other = "Not LRUDown"
//        case initialNoteString = "Enter a recipe note below ..."
        case noteWithoutText = "Note has no text entered"
        case ok = "Okay"
//        case recz = "Reczipes"
//        case rnotes = "RecipeNotes"
//        case rimages = "RecipeImages"
//        case gbss = "Got shipped booksections"
//        case fuar = "Found user added recipe"
//        case nur = "No user recipes"
//        case nunotes = "No user notes"
//        case nuimages = "No user images"
//        case fanote = "Found a note"
//        case faimage = "Found an image"
//        case wrjson = "Successfully wrote booksection"
//        case notejson = "Successfully wrote note"
//        case imgjson = "Successfully wrote image"
//        case fail = "Failed"
//        case succes = "Success"
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
    
    fileprivate func addRecipeNote() {
        if recipeNote == ""  {
            if zBug {print(msgs.anv.rawValue + msgs.noteWithoutText.rawValue)}
            return
        }
        
        let combinedRecipes = self.constructAllRecipes()
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id
        
        let myNoteToAdd = Note(recipeuuid: sectionItemId, note: recipeNote)
        aun.addNote(note: myNoteToAdd)
        recipeNoteSaved = true
    }
        
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(msgs.anv.rawValue).font(.largeTitle).bold().padding(.bottom)
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
            .alert(isPresented: $recipeNoteSaved)   {
                recipeNote = ""
                return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.success.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
            }
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
            .environmentObject(AllUserRecipes())
            .environmentObject(AllUserNotes())
    }
}
