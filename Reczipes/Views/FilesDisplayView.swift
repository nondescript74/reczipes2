//
//  FilesDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/25/22.
//

import SwiftUI

struct FilesDisplayView: View {
    // MARK: - Properties
    private enum msgs:String {
        case ddir = "Contents of Documents"
        case rdir = "Contents of Reczipes"
        case rndir = "Contents of Notes"
        case ridir = "Contents of Images"
        case fdisp = "Files Display"
    }
    var fileUrls:[URL] = []
    private var fileNames:[URL] = []
    private let fileIO = FileIO()
    // MARK: - State
    @State var searchTerm: String = ""
    @State var urlString: String = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text(msgs.ddir.rawValue).bold()
                ForEach(fileIO.checkDocuDirContents(), id: \.self) { fname in
                    Text(fname.absoluteString).font(.body)
                }
                Text(msgs.rdir.rawValue).bold()
                ForEach(fileIO.checkContentsRecipeFolder(recipeFolder: recipesName), id: \.self) { fname in
                    Text(fname.absoluteString).font(.body)
                }
            
                Divider()
                
                Text(msgs.ridir.rawValue).bold()
                ForEach(fileIO.checkContentsRecipeFolder(recipeFolder: recipeImagesFolderName), id: \.self) { fname in
                    Text(fname.absoluteString).font(.body)
                }
                
                
                Text(msgs.rndir.rawValue).bold()
                ForEach(fileIO.checkContentsRecipeFolder(recipeFolder: recipeNotesFolderName), id: \.self) { fname in
                    Text(fname.absoluteString).font(.body)
                }
            }
        }.navigationTitle(Text(msgs.fdisp.rawValue))
    }
}

struct FilesDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        FilesDisplayView()
    }
}
