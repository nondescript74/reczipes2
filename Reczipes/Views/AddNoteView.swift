//
//  AddNoteView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/8/23.
//

import SwiftUI

struct AddNoteView: View {
    // MARK: - Debug local
    fileprivate let zBug = false
    // MARK: - Initializer
    // MARK: EnvironmentObject
    @Environment(AllUserRecipes.self) private var aur
    @Environment(AllUserNotes.self) private var aun
    // MARK: - Focus for textfield
    @FocusState private var textFieldIsFocused:Bool
    // MARK: - State
    @State fileprivate var recipeSelected: Int = 0
    @State fileprivate var recipeNote: String = ""
    @State fileprivate var recipeNoteSaved:Bool = false
    // MARK: - Properties
    fileprivate enum msgs: String {
        case anv = "Add Note"
        case recipePickRequestString = "Pick a recipe..."
        case buttonTitleNote = "✚ Note"
        case selected = " Selected"
        case picker = "Recipes"
        case failed = "Note save failed"
        case saving = "Saving"
        case success = "Note save succeeded"
        case noteWithoutText = "Note has no text entered"
        case ok = "Okay"
    }
    
    fileprivate enum labelz: String {
        case save = "save"
        case plus = "+"
        
    }
    
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    fileprivate func constructAllSections() -> [BookSection] {
        return aur.sections
    }
    
    fileprivate func constructAllRecipes() -> [SectionItem3] {
        var myReturn: [SectionItem3] = []
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
                    HStack {
                        Text(msgs.recipePickRequestString.rawValue)
                            .foregroundColor(.red)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                        Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                            ForEach(0..<self.constructAllRecipes().count, id: \.self) { index in
                                Text(self.constructAllRecipes()[index].name)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    
                    TextEditor(text: $recipeNote)
                        .frame(height: proxy.size.height / 2, alignment: .center)
                        .border(Color.black, width: 2)
                        .focused($textFieldIsFocused)
                        .padding([.leading, .trailing])
                    Spacer()
                    
                    Button(action: {
                        //what to perform
                        self.addRecipeNote()
                        textFieldIsFocused = false
                    }) {
                        // how the button looks
                        Label("Save", systemImage: "plus.circle")
                            .clipShape(Capsule())
                    }
                }
            }
            .alert(isPresented: $recipeNoteSaved)   {
                recipeNote = ""
                return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.success.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
            }
        }
        .environment(aur)
        .environment(aun)
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
            .environment(AllUserRecipes())
            .environment(AllUserNotes())
    }
}
