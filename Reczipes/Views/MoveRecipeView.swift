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
    // MARK: - Environment Objects
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - Initializer
    init(movingRecipe:SectionItem, moveFromBookSection:String) {
        self.myMovingRecipe = movingRecipe
        self.myMoveFromSection = moveFromBookSection
    }
    // MARK: - State
    @State private var xectionTo: Int = getBookSectionNames().count - 1
    // MARK: - Properties
    private var myMovingRecipe: SectionItem
    private var myMoveFromSection: String
    private enum msgs:String {
        case title = "Move Recipe To Different Section"
        case recipez = "Moving: "
        case mvfrom = "From"
        case mvto = "To"
        case doit = "Do It!"
        case doit2 = ""
    }
    fileprivate enum imagez: String {
        case snp = "square.and.pencil"
        case pencil = "pencil"
        case gc = "greetingcard"
        case mail = "envelope"
        case add = "plus"
    }
    // MARK: - Methods
    private func moveRecipe() {
        addedRecipes.moveRecipeFromOneBookSectionToOther(recipe: self.myMovingRecipe,
                                                         originalBookSectionName: getBookSectionNames()[getBookSectionNames().firstIndex(of: myMoveFromSection)!],
                                                         newBookSectionName: getBookSectionNames()[xectionTo])
    }
    var body: some View {
        VStack {
            Text(msgs.title.rawValue)
                .foregroundColor(.red)
            Text(msgs.recipez.rawValue + self.myMovingRecipe.name)
                .fontWeight(.medium)
            HStack {
                Text(msgs.mvfrom.rawValue)
                Text(getBookSectionNames()[getBookSectionNames().firstIndex(of: myMoveFromSection)!])
                    .foregroundColor(.red)
                Text(msgs.mvto.rawValue)
                Picker("", selection: $xectionTo) { let zx = getBookSectionNames().count
                    ForEach(0..<zx, id: \.self) { index in
                        Text("\(getBookSectionNames()[index])")
                    }
                }
                Button(action: {
                    // What to perform
                    self.moveRecipe()
                }) {
                    // How the button looks like
                    RoundButton3View(someTextTop: msgs.doit.rawValue,
                                     someTextBottom: msgs.doit2.rawValue,
                                     someImage: imagez.snp.rawValue,
                                     reversed: true)
                }
            }
        }.padding()
        
    }
}

#if DEBUG
struct MoveRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MoveRecipeView(movingRecipe: SectionItem.example3, moveFromBookSection: BookSection.example.name)
    }
}
#endif
