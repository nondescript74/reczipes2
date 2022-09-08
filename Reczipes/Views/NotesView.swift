//
//  NotesView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import SwiftUI

struct NotesView: View {
    // MARK: - Debug local
    private var zBug: Bool = true
    // MARK: - Environment
    // MARK: - Initializer
    init(recipeuuid: String) {
        self.myRecipeUUID = UUID(uuidString: recipeuuid)!
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
    private func getDocuDirUrl() -> URL {
        var myReturn:URL
        do {
            let myDocuDirUrl = try FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false)
            myReturn = myDocuDirUrl
        } catch {
            fatalError()
        }
        return myReturn
    }
    
    fileprivate func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        let myNotesDirUrl:URL = myReczipesDirUrl.appending(path: recipeNotesFolderName)
        let myNotesDirUrlStr = myNotesDirUrl.absoluteString
      
            do {
                let result = try FileManager.default.contentsOfDirectory(at: myNotesDirUrl, includingPropertiesForKeys: [])
                if zBug { print(msgs.nv.rawValue + "Contents count " + "\(result.count)")}
                for aUrl in result {
                    let data = FileManager.default.contents(atPath: myNotesDirUrlStr.appending(aUrl.absoluteString))!
                    let decodedJSON = try decoder.decode(Note.self, from: data)
                    myNotesConstructed.append(decodedJSON)
                }
               
            } catch  {
                fatalError("Cannot read or decode from notes")
            }

        myNotesConstructed = myNotesConstructed.filter({$0.recipeuuid.description == myRecipeUUID.description})
        print(msgs.nv.rawValue + msgs.numberofnotes.rawValue + "\(myNotesConstructed.count)")
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


