//
//  AddNotesToRecipeView2.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct AddNotesToRecipeView2: View {
    // MARK: - EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - State
    @State var recipeSelected: Int = 0
    @State var recipeNote: String = ""
    @State fileprivate var recipeNoteSaved:Bool = false
    // MARK: - Properties
    fileprivate enum msgs: String {
        case AddNotesToRecipeView2 = "AddNotesToRecipeView2: "
        case initialRequestString = "Pick a recipe below ..."
        case initialNoteString = "Enter a recipe note below ..."
        case navigationTitle = "Add Recipe Note"
        case saving = "Saving Recipe Now ..."
        case buttonTitle = "✚ Note"
        case selected = " Selected"
        case picker = "Recipes"
        case failed = "Note save failed"
        case success = "Note save succeeded"
        case noteWithoutText = "Note has no text entered"
        case json = "json"
        case ok = "Okay"
    }
    fileprivate let fileIO = FileIO()
    fileprivate let encoder = JSONEncoder()
    // MARK: - Methods
    
    fileprivate func constructAllRecipes() -> [SectionItem]  {
        let newlyAddedRecipes = addedRecipes.getAllRecipes() // if any added
        let myPresetRecipes = getAllPresetRecipes()
        var combinedRecipes = myPresetRecipes
        combinedRecipes.append(contentsOf: newlyAddedRecipes)
        combinedRecipes = combinedRecipes.sorted(by: ({$0.name < $1.name}))
        return combinedRecipes
    }
    
    fileprivate func addRecipeNote() {
        if recipeNote == ""  {
#if DEBUG
            print(msgs.AddNotesToRecipeView2.rawValue + msgs.noteWithoutText.rawValue)
#endif
            return
        }
        
        let combinedRecipes = constructAllRecipes()
        let sectionItem = combinedRecipes[recipeSelected]
        let sectionItemId = sectionItem.id.description
        let sectionItemName = sectionItem.name
        
        let myNoteToAdd = Note(recipeuuid: sectionItemId, note: recipeNote)
        do {
            let encodedNote = try JSONEncoder().encode(myNoteToAdd)
            let encodedNoteData = Data(encodedNote)
            let dateString = Date().description
            let resultz = fileIO.writeFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeNotesFolderName, fileNameToSave: sectionItemName + delimiterFileNames + sectionItemId + delimiterFileNames + dateString, fileType: msgs.json.rawValue, data: encodedNoteData)
            
            if !resultz {
                recipeNoteSaved = false
                
#if DEBUG
                print(msgs.AddNotesToRecipeView2.rawValue + msgs.failed.rawValue)
#endif
                
            } else {
                recipeNote = ""
                recipeNoteSaved = true
#if DEBUG
                print(msgs.AddNotesToRecipeView2.rawValue + msgs.success.rawValue)
#endif
            }
        } catch {
            recipeNoteSaved = false
            
#if DEBUG
            print(msgs.AddNotesToRecipeView2.rawValue + msgs.failed.rawValue)
#endif
        }
        return
    }
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack {
                        HStack {
                            Text(msgs.navigationTitle.rawValue)
                                .font(Font.system(size: 30, weight: .bold, design: .rounded))
                                .padding()
                            
                            Button(action: {
                                //what to perform
                                self.addRecipeNote()
                            }) {
                                // how the button looks
                                Text(msgs.buttonTitle.rawValue)
                                    .fontWeight(.bold)
                                    .font(Font.system(size: 20, weight: .medium, design: .serif))
                            }
                        }
                        
                        Text(msgs.initialRequestString.rawValue)
                            .foregroundColor(.red)
                            .font(Font.system(size: 15, weight: .medium, design: .serif))
                        
                        Picker(msgs.picker.rawValue, selection: $recipeSelected) {
                            ForEach(0..<constructAllRecipes().count) { index in
                                Text(constructAllRecipes()[index].name)
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                            }
                        }
                        .labelsHidden()
                        .clipped()
                        
                        //                    Text("\(constructAllRecipes()[recipeSelected].name)" + msgs.selected.rawValue)
                        //                        .foregroundColor(.black)
                        //                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                        //                        .padding()
                        //
                        //                    Text(msgs.initialNoteString.rawValue)
                        //                        .foregroundColor(.red)
                        //                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                        //
                        TextEditor(text: $recipeNote)
                            .foregroundColor(Color.blue)
                            .padding(10)
                        //.font(Font.system(size: 15, weight: .medium, design: .serif))
                        //.multilineTextAlignment(.leading)
                            .frame(height: proxy.size.height, alignment: .center)
                            .border(Color.black, width: 2)
                        //.background(Color.gray)
                    }
                    
                    .alert(isPresented: $recipeNoteSaved)   {
                        return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.success.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
                    }
                }
            }
            .padding()
            
//            .navigationBarItems(
//                trailing: Button(action: addRecipeNote) {
//                    Text(msgs.buttonTitle.rawValue).fontWeight(.bold).font(Font.system(size: 20, weight: .medium, design: .rounded))
//                }
//            )
        }
        
    }
}


#if DEBUG
struct AddNotesToRecipeView2_Previews: PreviewProvider {
    static var previews: some View {
        AddNotesToRecipeView2(recipeSelected: 0)
    }
}
#endif


