//
//  ATestView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/1/22.
//

import SwiftUI



struct ATestView: View {
    
    @State var searchTerm: String = ""
    @State var urlString: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .center ) {
                SearchBar(text: $searchTerm)
                Text("?").padding()
            }
        }
    }
}

struct ATestView_Previews: PreviewProvider {
    static var previews: some View {
        ATestView()
    }
}
