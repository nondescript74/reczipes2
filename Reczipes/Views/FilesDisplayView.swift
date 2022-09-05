//
//  FilesDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/25/22.
//

import SwiftUI

struct FilesDisplayView: View {
    // MARK: - Environment Objects
//    @EnvironmentObject var fileMgr: FileMgr
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
    
    private func getDocuDirContents() -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl(), includingPropertiesForKeys: [])
            myReturn = contUrls.map({$0.absoluteString})
        } catch  {
            
        }
        return myReturn
    }
    
    private func getReczDirContents() -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue), includingPropertiesForKeys: [])
            myReturn = contUrls.map({$0.absoluteString})
        } catch  {
            
        }
        return myReturn
    }
    
    
    private func getReczNotesDirContents() -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue).appendingPathComponent(msgs.recznotes.rawValue), includingPropertiesForKeys: [])
            myReturn = contUrls.map({$0.absoluteString})
        } catch  {
            
        }
        return myReturn
    }
    
    private func getReczImagesDirContents() -> [String] {
        var myReturn:[String] = []
        do {
            let contUrls = try FileManager.default.contentsOfDirectory(at: getDocuDirUrl().appendingPathComponent(msgs.recz.rawValue).appendingPathComponent(msgs.reczimages.rawValue), includingPropertiesForKeys: [])
            myReturn = contUrls.map({$0.absoluteString})
        } catch  {
            
        }
        return myReturn
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text(msgs.ddir.rawValue).bold()
                List {
                    
                    ForEach(getDocuDirContents(), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                Text(msgs.rdir.rawValue).bold()
                List {
                    ForEach(getReczDirContents(), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                Text(msgs.ridir.rawValue).bold()
                List {
                    ForEach(getReczImagesDirContents(), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
                Text(msgs.rndir.rawValue).bold()
                List {
                    ForEach(getReczNotesDirContents(), id: \.self) { fname in
                        Text(fname).font(.body)
                    }
                }.padding()
            }
        }.navigationTitle(Text(msgs.fdisp.rawValue))
    }
}

struct FilesDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        FilesDisplayView()
    }
}
