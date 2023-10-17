//
//  NotesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct NotesView: View {
    // MARK: - Debug local
    fileprivate var zBug: Bool = false
    // MARK: - Environment
    @EnvironmentObject var aun: AllUserNotes
    // MARK: - Initializer
    init(recipeuuid: UUID) {
        self.myRecipeUUID = recipeuuid
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID
    fileprivate var myNotes:[Note] = []
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    fileprivate enum msgs: String {
        case nv = "NotesView: "
        case cantdecodenote = "Can't decode note from data"
        case numberofnotes = "Number of notes for recipe "
        case recz = "Reczipes"
    }
    // MARK: - Methods
    // MARK: - View Process
    var body: some View {
        List {
            ForEach(aun.notes.filter({$0.recipeuuid == myRecipeUUID}), id: \.self) { anote in
                Text(anote.note)
            }
        }
    }
}



struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(recipeuuid: Note.example1.recipeuuid)
            .environmentObject(AllUserNotes())
    }
}


