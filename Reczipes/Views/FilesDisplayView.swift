//
//  FilesDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/25/22.
//

import SwiftUI

struct FilesDisplayView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Environment Objects
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    @EnvironmentObject var aun: AllUserNotes
    
    // MARK: - Initializer
    // MARK: - Properties
    private enum msgs:String {
        case recz = "Reczipes"
        case recznotes = "RecipeNotes"
        case reczimages = "RecipeImages"
        case ddir = "Contents of Documents: "
        case rdir = "Contents of Reczipes: "
        case rndir = "Contents of Notes:"
        case ridir = "Contents of Images:"
        case fdisp = "Files Display: "
    }
    // MARK: - State
    @State var searchTerm: String = ""
    @State var urlString: String = ""
    @State private var showRemove = false
    // MARK: - Methods
    private func getDocuDirContents(lpc:Bool) -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl(), includingPropertiesForKeys: [])
            if lpc {
                myReturn = contUrls.map({$0.lastPathComponent})
            } else {
                myReturn = contUrls.map({$0.absoluteString})
            }

        } catch  {

        }
        return myReturn
    }
    
//    private func getReczDirContents(lpc:Bool) -> [String] {
//        var myReturn:[String] = []
////        do {
////            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue), includingPropertiesForKeys: [])
////            if lpc {
////                myReturn = contUrls.map({$0.lastPathComponent})
////            } else {
////                myReturn = contUrls.map({$0.absoluteString})
////            }
////        } catch  {
////
////        }
//        let myObsvBookSections = aur.sections
//        for abs in myObsvBookSections {
//            let sectItems = abs.items
//            for aSectionItem in sectItems {
//                if !myReturn.contains(aSectionItem.name) {
//                    myReturn.append(aSectionItem.name)
//                }
//            }
//        }
//        myReturn = myReturn.sorted()
//        return myReturn
//    }
    
    
    private func getReczNotesDirContents(lpc:Bool) -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue).appendingPathComponent(msgs.recznotes.rawValue), includingPropertiesForKeys: [])
            if lpc {
                myReturn = contUrls.map({$0.lastPathComponent})
            } else {
                myReturn = contUrls.map({$0.absoluteString})
            }
        } catch  {
            
        }
        let myObsvNotes = aun.notes
        for anote in myObsvNotes {
            if !myReturn.contains(anote.note) {
                myReturn.append(anote.note)
            }
        }
        myReturn = myReturn.sorted()
        return myReturn
    }
    
    private func getReczImagesDirContents(lpc:Bool) -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue).appendingPathComponent(msgs.reczimages.rawValue), includingPropertiesForKeys: [])
            if lpc {
                myReturn = contUrls.map({$0.lastPathComponent})
            } else {
                myReturn = contUrls.map({$0.absoluteString})
            }
            for animg in aui.images {
                if contUrls.contains(where: {$0.absoluteString.contains(animg.recipeuuid.uuidString)}) {
                    // already in nothing to do
                } else {
                    myReturn.append(animg.recipeuuid.uuidString)
                }
            }
        } catch  {
            
        }
        myReturn = myReturn.sorted()
        return myReturn
    }
    
    fileprivate func removeMyAddedRecipes() {
        for abs in aur.sections {
            aur.remove(bsection: abs)
        }
#if DEBUG
        if zBug {print("FilesDisplayView: removed all user recipe files")}
#endif
        showRemove = false
    }

    var body: some View {
        NavigationView {
            VStack {
                Text(msgs.ddir.rawValue).bold()
                List {
                    ForEach(getDocuDirContents(lpc: true), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                Text(msgs.rdir.rawValue).bold()
                List {
                    ForEach(aur.getRecipeNames(), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                Text(msgs.ridir.rawValue).bold()
                List {
                    ForEach(getReczImagesDirContents(lpc: true), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                Text(msgs.rndir.rawValue).bold()
                List {
                    ForEach(getReczNotesDirContents(lpc: true), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                VStack {
                    Button("Tap to remove user recipes") {
                        showRemove = true
                    }.buttonStyle(.borderedProminent)
                }

            }
            .actionSheet(isPresented: $showRemove) {
                ActionSheet(title: Text("Remove All User Recipes"),
                            message: Text("Choose"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("Remove Recipes"),
                                    action: removeMyAddedRecipes
                                )
                            ]
                )
            }
        }.navigationTitle(Text(msgs.fdisp.rawValue))
             
    }
}

struct FilesDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        FilesDisplayView()
            .environmentObject(AllUserRecipes())
            .environmentObject((AllUserNotes()))
            .environmentObject(AllUserImages())
    }
}
