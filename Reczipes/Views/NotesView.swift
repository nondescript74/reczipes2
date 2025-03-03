//
//  NotesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct NotesView: View {
    // MARK: - Environment
    @Environment(AllUserNotes.self) private var aun
    
    // MARK: - Initializer
    init(recipeuuid: UUID) {
        self.myRecipeUUID = recipeuuid
    }
    // MARK: - Properties
    fileprivate var myRecipeUUID: UUID

    // MARK: - View Process
    var body: some View {
        List {
            ForEach(aun.notes.filter({$0.recipeuuid == myRecipeUUID}), id: \.self) { anote in
                Text(anote.note)
            }
        }
        .environment(aun)
    }
}



struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(recipeuuid: Note.example1.recipeuuid)
            .environment(AllUserNotes())
    }
}


