//
//  NotesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct NotesView: View {
    // MARK: - Initializer
    init(recipeuuid: String) {
        self.myRecipeUUID = UUID(uuidString: recipeuuid)!
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID
    fileprivate var myNotes:[Note] = []
    fileprivate let fileIO = FileIO()
    fileprivate enum msgs: String {
        case notesview = "NotesView: "
        case cantdecodenote = "Can't decode note from data"
        case numberofnotes = "Number of notes for recipe "
    }
    // MARK: - Methods
    fileprivate func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
        let myNotesUrls = fileIO.readFileInRecipeNotesOrImagesFolderInDocuments(folderName:recipeNotesFolderName)
        let zmyNotesUrls = myNotesUrls.filter {$0.description.contains(myRecipeUUID.description)}
        for aUrl in zmyNotesUrls {
            let noteData = fileIO.getFileDataAtUrl(url: aUrl)
            do {
                let note = try JSONDecoder().decode(Note.self, from: noteData)
                myNotesConstructed.append(note)
            } catch {
                
                
                print(msgs.notesview.rawValue + msgs.cantdecodenote.rawValue)
                
            }
        }
        
        let nmyNotes = Bundle.main.decode([Note].self, from: "Notes.json")  // array of Note
        let savedNotes = nmyNotes.filter { $0.recipeuuid.description == myRecipeUUID.description}
        myNotesConstructed.append(contentsOf: savedNotes)
        
        
        print(msgs.notesview.rawValue + msgs.numberofnotes.rawValue + "\(myNotesConstructed.count)")
        
        
        return myNotesConstructed
    }
    // MARK: - View Process
    var body: some View {
        List {
            ForEach(constructNotesIfAvailable(), id: \.self) { anote in
                Text(anote.note)
            }
        }
    }
}



struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(recipeuuid: Note.example1.recipeuuid)
    }
}


