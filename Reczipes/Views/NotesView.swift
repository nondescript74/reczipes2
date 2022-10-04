//
//  NotesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct NotesView: View {
    // MARK: - Debug local
    private var zBug:Bool = false
    // MARK: - Environment
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
    
//    fileprivate func constructNotesIfAvailable() -> Array<Note> {
//        var myNotesConstructed:Array<Note> = []
//
//            do {
//                let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue).appendingPathComponent("RecipeNotes"), includingPropertiesForKeys: [])
//                if zBug { print(msgs.nv.rawValue + "Contents count " + "\(contUrls.count)")}
//                for aUrl in contUrls {
//                    let data = FileManager.default.contents(atPath: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue).appendingPathComponent("RecipeNotes").absoluteString.appending(aUrl.lastPathComponent))!
//                    let decodedJSON = try decoder.decode(Note.self, from: data)
//                    myNotesConstructed.append(decodedJSON)
//                }
//            } catch  {
//                fatalError("Cannot read or decode from notes")
//            }
//        // 34FB9E0B-7DE9-4E79-B3FE-F9577468A296
//
//        var shippedNotes:[Note] = Bundle.main.decode([Note].self, from: "Notes.json").sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString})
//        shippedNotes = shippedNotes.filter({$0.recipeuuid == self.myRecipeUUID})
//        if shippedNotes.isEmpty  {
//
//        } else {
//            myNotesConstructed.append(contentsOf: shippedNotes)
//        }
//
//        myNotesConstructed = myNotesConstructed.filter({$0.recipeuuid == self.myRecipeUUID})
//        if myNotesConstructed.count == 0 {
//            if zBug {print(msgs.nv.rawValue + " No Recipe Notes")}
//        } else {
//            if zBug { print(msgs.nv.rawValue + msgs.numberofnotes.rawValue + "  \(myNotesConstructed.count)")}
//        }
//        return myNotesConstructed
//    }
    // MARK: - View Process
    var body: some View {
        List {
            ForEach(FileManager.default.constructNotesIfAvailable().filter({$0.recipeuuid == myRecipeUUID}), id: \.self) { anote in
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


