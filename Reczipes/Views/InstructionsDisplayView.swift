//
//  InstructionsDisplayView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 4/17/23.
//

import SwiftUI

struct InstructionsDisplayView: View {
    // MARK: - Initializer
    init(sectionItem: SectionItem) {
        self.myItem = sectionItem
    }
    // MARK: - Properties
    fileprivate var myItem: SectionItem?

    var body: some View {
        List {
//            ForEach(analyInstrSet.steps!, id: \.self) { aStep in
//                Text(aStep?.number?.description ?? "0" + (aStep?.step ?? "no step"))
            }
        }
}

struct InstructionsDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsDisplayView(sectionItem: SectionItem.example)}
}
