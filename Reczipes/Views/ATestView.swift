//
//  ATestView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/1/22.
//

import SwiftUI



struct ATestView: View {
    
    init() {
        
    }
    
    @State var searchTerm: String = ""
    @State var urlString: String = ""
    
    var fileUrls:[URL] = []
    
    private var fileNames:[URL] = []
    private let fileIO = FileIO()
    
    var body: some View {
        VStack {
            HStack(alignment: .center ) {
                SearchBar(text: $searchTerm)
                Text("?").padding()
            }
            ForEach(fileIO.checkDocuDirContents(), id: \.self) { fname in
                Text(fname.absoluteString)
            }
        }
    }
}

struct ATestView_Previews: PreviewProvider {
    static var previews: some View {
        ATestView()
    }
}
