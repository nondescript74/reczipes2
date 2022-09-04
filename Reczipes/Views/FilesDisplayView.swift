//
//  FilesDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/25/22.
//

import SwiftUI

struct FilesDisplayView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var fileMgr: FileMgr
    // MARK: - Properties
    private enum msgs:String {
        case ddir = "Contents of Documents"
        case rdir = "Contents of Reczipes"
        case rndir = "Contents of Notes"
        case ridir = "Contents of Images"
        case fdisp = "Files Display"
    }
    var fileUrls:[URL] = []
//    private var fileNames:[URL] = []
//    private let fileIO = FileIO()
    // MARK: - State
    @State var searchTerm: String = ""
    @State var urlString: String = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text(msgs.ddir.rawValue).bold()
                ForEach(fileMgr.docsDirContents, id: \.self) { fname in
                    Text(fname.absoluteString).font(.body)
                }.refreshable {
                     
                }
                Text(msgs.rdir.rawValue).bold()
//                ForEach(fileMgr.shippedBookSectionsDirContents, id: \.self) { fname in
//                    Text(fname.absoluteString).font(.body)
//                }.refreshable {
//
//                }
            
                Divider()
                
                Text(msgs.ridir.rawValue).bold()
//                ForEach(fileMgr.checkContentsRecipeFolder(recipeFolder: recipeImagesFolderName), id: \.self) { fname in
//                    Text(fname.absoluteString).font(.body)
//                }.refreshable {
//
//                }
                
                
                Text(msgs.rndir.rawValue).bold()
//                ForEach(fileMgr.checkContentsRecipeFolder(recipeFolder: recipeNotesFolderName), id: \.self) { fname in
//                    Text(fname.absoluteString).font(.body)
//                }.refreshable {
//
//                }
            }
        }.navigationTitle(Text(msgs.fdisp.rawValue))
    }
}

struct FilesDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        FilesDisplayView()
    }
}
