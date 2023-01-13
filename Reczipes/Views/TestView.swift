//
//  TestView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 1/13/23.
//

import SwiftUI

struct TestView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        Button("Done") {
            self.presentation.wrappedValue.dismiss()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
