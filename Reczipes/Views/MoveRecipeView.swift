//
//  MoveRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 8/21/22.
//

import SwiftUI

struct MoveRecipeView: View {
    // MARK: - Debug local
    private var zBug:Bool = false
    // MARK: - Initializer
    init(zBug: Bool, movingRecipe:SectionItem, moveToBookSection:BookSection) {
        self.zBug = zBug
        self.myMovingRecipe = movingRecipe
        self.myMoveToSection = moveToBookSection
        self.xectionto = getBookSectionNames().firstIndex(of: moveToBookSection.name)!
    }
    // MARK: - State
    @State private var xectionfrom: Int = 0
    // MARK: - Properties
    private var myMovingRecipe: SectionItem
    private var myMoveToSection: BookSection
    private enum msgs:String {
        case title = "Move Recipe To Different Section"
        case recipez = "Moving: "
        case mvfrom = "From"
        case mvto = "To"
    }
    private var xectionto: Int = 0
    // MARK: - Methods
    private func moveRecipe() {
        
    }
    var body: some View {
        VStack {
            Text(msgs.title.rawValue)
                .foregroundColor(.red)
                .padding()
            Text(msgs.recipez.rawValue + self.myMovingRecipe.name)
                .fontWeight(.medium)
            HStack {
                Text(msgs.mvfrom.rawValue)
                Text(getBookSectionNames()[xectionto])
                    .foregroundColor(.red)
                Text(msgs.mvto.rawValue)
                Picker("", selection: $xectionfrom) { let zx = getBookSectionNames().count
                    ForEach(0..<zx, id: \.self) { index in
                        Text("\(getBookSectionNames()[index])")
                            .font(.system(size: 8.0))
                    }
                }
            }.padding()
        }
        
    }
}

#if DEBUG
struct MoveRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MoveRecipeView(zBug: true, movingRecipe: SectionItem.example3, moveToBookSection: BookSection.example)
    }
}
#endif
