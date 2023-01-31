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
        var myNotesConstructed:Array<Note> = []
        
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: recipesName)
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        
        do {
            let notesUrls: [URL] = try FileManager.default.contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
#if DEBUG
            if zBug {print(msgs.aun.rawValue + msgs.uanc.rawValue + "\(notesUrls.count)")}
#endif
            for anoteurl in notesUrls {
                let data = try Data(contentsOf: myNotesDirUrl.appendingPathComponent(anoteurl.lastPathComponent))
                let decodedJSON = try JSONDecoder().decode(Note.self, from: data)
                myNotesConstructed.append(decodedJSON)
            }
        } catch  {
            fatalError("Cannot read or decode from notes")
        }
        
        let shippedNotes:[Note] = Bundle.main.decode([Note].self, from: "Notes.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        if shippedNotes.isEmpty  {
#if DEBUG
            if zBug {print(msgs.aun.rawValue + msgs.snc.rawValue + "\(shippedNotes.count)")}
#endif
        } else {
            myNotesConstructed.append(contentsOf: shippedNotes)
        }
        
        notes = myNotesConstructed
        
        if myNotesConstructed.count == 0 {
#if DEBUG
            if zBug {print(msgs.aun.rawValue + " No User recipe notes")}
#endif
        } else {
#if DEBUG
            if zBug {print(msgs.aun.rawValue + " User recipe notes exist: " + " \(myNotesConstructed.count)")}
#endif
        }
#if DEBUG
        if zBug {print(msgs.aun.rawValue + "initialized", "count: ", self.notes.count)}
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
        case uanc = " User added Notes Contents count "
        case snc = " Shipped Notes Contents count "
    }
    
    // MARK: - Methods
    func addNote(note: Note) {
        let idx = notes.firstIndex(of: note)
        if idx == nil {
            let myReczipesDirUrl:URL = getDocuDirUrl().appending(path: recipesName)
            let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
            do {
                let encodedJSON = try JSONEncoder().encode(note)
                do {
                    let temp = note.recipeuuid.uuidString + "_" + dateSuffix() + msgs.json.rawValue
                    try encodedJSON.write(to: myNotesDirUrl.appendingPathComponent(temp))
                    if zBug { print(msgs.aun.rawValue + temp)}
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
