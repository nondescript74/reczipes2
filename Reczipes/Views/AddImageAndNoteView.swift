//
//  AddImageAndNoteView.swift
//  AddImageAndNoteView
//
//  Created by Zahirudeen Premji on 8/17/21.
//

import SwiftUI

struct AddImageAndNoteView: View {
    var body: some View {
        VStack {
            AddImageToRecipeView2()
            AddNotesToRecipeView2()
        }.padding(.all)
    }
}

struct AddImageAndNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddImageAndNoteView()
    }
}
