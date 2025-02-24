//
//  AllUserNotes.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/28/22.
//

import Foundation
import os

class AllUserNotes: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.Reczipes", category: "AllUserNotes")
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
            logger.info( "AllUserNotes: \(notesUrls.count) added notes found")
            for anoteurl in notesUrls {
                let data = try Data(contentsOf: myNotesDirUrl.appendingPathComponent(anoteurl.lastPathComponent))
                let decodedJSON = try JSONDecoder().decode(Note.self, from: data)
                myNotesConstructed.append(decodedJSON)
            }
        } catch  {
            logger.error( "AllUserNotes: \(error.localizedDescription)")
            fatalError("Cannot read or decode from notes")
        }
        
        let shippedNotes:[Note] = Bundle.main.decode([Note].self, from: "Notes.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
        if shippedNotes.isEmpty  {
            logger.info("AllUserNotes: shipped notes requested, is empty")
        } else {
            myNotesConstructed.append(contentsOf: shippedNotes)
            logger.info("AllUserNotes: shipped notes requested, added \(shippedNotes.count)")
        }
        
        notes = myNotesConstructed
        
        if myNotesConstructed.count == 0 {
            logger.info("AllUserNotes: no user notes exist)")
        } else {
            logger.info("AllUserNotes: User recipe notes exist: \(myNotesConstructed.count)")
        }
        logger.info("AllUserNotes initialized, count: \(self.notes.count)")
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
                    let temp = note.recipeuuid.uuidString + "_" + dateSuffix() + ".json"
                    try encodedJSON.write(to: myNotesDirUrl.appendingPathComponent(temp))
                    notes.append(note)
                    logger.info("AllUserNotes: addNote: Note added successfully")
                } catch  {
                    logger.error( "AllUserNotes: addNote: Error writing Note to user RecipeNotes folder: \(error.localizedDescription)")
                    fatalError("Cannot write to user RecipeNotes folder")
                }
            } catch  {
                logger.error("AllUserNotes: addNote: Error encoding Note to json: \(error.localizedDescription)")
                fatalError("Cannot encode Note to json")
            }
            logger.info("AllUserNotes: addNote: Note added")
        } else {
            logger.info("AllUserNotes: addNote: Note already exists")
        }
    }
    
    func removeNote(note: Note) {
        // only removes from the observable object
        // does not remove from user files
        guard let idx = notes.firstIndex(of: note) else { return }
        notes.remove(at: idx)
        logger.info("AllUserNotes: removeNote: removed a note")
    }
}
