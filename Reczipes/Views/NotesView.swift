//
//  NotesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct NotesView: View {
    // MARK: - Environment
    @EnvironmentObject var fileMgr: FileMgr
    // MARK: - Initializer
    init(recipeuuid: String) {
        self.myRecipeUUID = UUID(uuidString: recipeuuid)!
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID
    fileprivate var myNotes:[Note] = []
//    fileprivate let fileIO = FileIO()
    fileprivate enum msgs: String {
        case notesview = "NotesView: "
        case cantdecodenote = "Can't decode note from data"
        case numberofnotes = "Number of notes for recipe "
    }
    // MARK: - Methods
    fileprivate func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
//        fileMgr.getUserNotes()
//        fileMgr.getShippedNotes()
        myNotesConstructed = fileMgr.userRecipesNotesFolderContents.filter({$0.recipeuuid.description == myRecipeUUID.description})
        myNotesConstructed.append(contentsOf: fileMgr.shippedRecipesNotesFolderContents.filter({$0.recipeuuid.description == myRecipeUUID.description}))
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


