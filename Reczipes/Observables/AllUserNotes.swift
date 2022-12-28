//
//  AllUserNotes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/28/22.
//

import Foundation

class AllUserNotes: ObservableObject {
    // MARK: - Local debug
    fileprivate var zBug: Bool = true
    // MARK: - Publisher
    @Published var notes: [Note] = []
    // MARK: - Initializer
    init() {
        self.notes = FileManager.default.constructNotesIfAvailable()
#if DEBUG
        print(msgs.aun.rawValue + "initialized", "count: ", self.notes.count)
#endif
    }
    // MARK: - Properties
    fileprivate enum msgs: String {
        case aun = "AllUserNotes: "
        case appd = "Appended a note"
        case appdnot = "Note already in, did not append"
        case remvd = "Note removed"
        case json = ".json"
        case saved = " saved"
    }
    
    // MARK: - Methods
    func addNote(note: Note) {
        let idx = notes.firstIndex(of: note)
        if idx == nil {
            let myReczipesDirUrl:URL = getDocuDirUrl().appending(path: recipesName)
            let myImagesDirUrl:URL = myReczipesDirUrl.appending(path: recipeImagesFolderName)
            do {
                let encodedJSON = try JSONEncoder().encode(note)
                do {
                    try encodedJSON.write(to: myImagesDirUrl.appendingPathComponent(note.recipeuuid.uuidString + "_" + dateSuffix() + msgs.json.rawValue))
                    if zBug { print(msgs.aun.rawValue + note.recipeuuid.uuidString + msgs.json.rawValue + msgs.saved.rawValue)}
                    notes.append(note)
                } catch  {
                    fatalError("Cannot write to user RecipeNotes folder")
                }
            } catch  {
                fatalError("Cannot encode Note to json")
            }
            
#if DEBUG
            print(msgs.aun.rawValue + msgs.appd.rawValue)
#endif
        } else {
#if DEBUG
            print(msgs.aun.rawValue + msgs.appdnot.rawValue)
#endif
        }
    }
    
    func removeNote(note: Note) {
        // only removes from the observable object
        // does not remove from user files
        guard let idx = notes.firstIndex(of: note) else { return }
        notes.remove(at: idx)
#if DEBUG
        print(msgs.aun.rawValue + msgs.remvd.rawValue)
#endif
    }
}
