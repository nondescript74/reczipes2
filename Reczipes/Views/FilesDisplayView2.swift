//
//  FilesDisplayView2.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/1/23.
//

import SwiftUI

struct FilesDisplayView2: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Environment Objects
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    @EnvironmentObject var aun: AllUserNotes
    
    // MARK: - Initializer
    // MARK: - State
    @State private var zection: Int = 1
    // MARK: - Properties
    private enum msgs:String {
//        case recz = "Reczipes"
        case recznotes = "RecipeNotes"
        case reczimages = "RecipeImages"
        case ddir = "Contents of Documents: "
        case rdir = "Contents of Reczipes: "
        case rndir = "Contents of Notes:"
        case ridir = "Contents of Images:"
        case fdisp = "Files Display: "
        case fdv2 = "FilesDisplayV2: "
    }
    fileprivate enum labels: String {
        case docs = "Documents"
        case recz = "Reczipes"
        case reczn = "ReczipeNotes"
        case reczi = "ReczipeImages"
    }
    // MARK: - State
    @State var searchTerm: String = ""
    @State var urlString: String = ""
    // MARK: - Methods
    @MainActor
    fileprivate func getNames() -> [String] {
        let myReturn: [String] = [labels.docs.rawValue, labels.recz.rawValue, labels.reczn.rawValue, labels.reczi.rawValue]
        return myReturn
    }
    fileprivate func getDocuDirContents(lpc:Bool) -> [String] {
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
    
    
    fileprivate func getReczNotesDirContents(lpc:Bool) -> [String] {
        var myReturn:[String] = []
        let myObsvNotes = aun.notes
        for anote in myObsvNotes {
            if !myReturn.contains(anote.note) {
                myReturn.append(anote.note)
            }
        }
        myReturn = myReturn.sorted()
        return myReturn
    }
    
    fileprivate func getReczImagesDirContents(lpc:Bool) -> [String] {
        var myReturn:[String] = []
        let myObsvImgs = aui.images
        for anImg in myObsvImgs {
            if !myReturn.contains(anImg.recipeuuid.uuidString) {
                myReturn.append(anImg.recipeuuid.uuidString)
            }
        }
        myReturn = myReturn.sorted()
        return myReturn
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Pick a directory")
                    Picker("Pick a directory", selection: $zection) {
                        let zx = getNames().count
                        ForEach(0..<zx, id: \.self) { index in
                            Text("\(getNames()[index])")
                        }
                    }
                }
                List {
                    switch zection {
                    case 0:
                        ForEach(getDocuDirContents(lpc: true), id: \.self) { fname in
                            Text(fname).font(.body)
                        }
                    case 1:
                        ForEach(aur.getRecipeNames(), id: \.self) { fname in
                            Text(fname).font(.body)
                        }
                    case 2:
                        ForEach(getReczNotesDirContents(lpc: true), id: \.self) { fname in
                            Text(fname).font(.body)
                        }
                    case 3:
                        ForEach(getReczImagesDirContents(lpc: true), id: \.self) { fname in
                            Text(fname).font(.body)
                        }
                        
                    default:
                        ForEach(getDocuDirContents(lpc: true), id: \.self) { fname in
                            Text(fname).font(.body)
                        }
                    }
                }
                
            }
//            .navigationTitle(Text(msgs.fdisp.rawValue))
        }
    }
}

struct FilesDisplayView2_Previews: PreviewProvider {
    static var previews: some View {
        FilesDisplayView2()
            .environmentObject(AllUserRecipes())
            .environmentObject((AllUserNotes()))
            .environmentObject(AllUserImages())
    }
}
