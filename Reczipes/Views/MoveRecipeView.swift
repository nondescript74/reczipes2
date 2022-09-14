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
        case recz = "Reczipes"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case mrv = "Move Recipe View: "
        case fuar = "Found a user added recipe"
    }
    fileprivate enum imagez: String {
        case snp = "square.and.pencil"
        case pencil = "pencil"
        case gc = "greetingcard"
        case mail = "envelope"
        case add = "plus"
    }
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    private func moveRecipe() {
        var myBs: [BookSection] = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.recz.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                    do {
                        let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                        if aBookSection.name == myMoveFromSection {
                            myBs.append(aBookSection)
                        }
                        if zBug { print(msgs.mrv.rawValue + msgs.fuar.rawValue)}
                        
                    } catch  {
                        // not a json file
                        fatalError("This directory has illegal files")
                    }
            }
        } catch  {
            // no contents
        }
        if myBs.isEmpty {
            // nothing to do
            return
        }
        var existingRecipes = myBs.first!.items
        if existingRecipes.contains(myMovingRecipe) {
            let idx = existingRecipes.firstIndex(of: myMovingRecipe)
            if idx != nil {
                existingRecipes.remove(at: idx!)
            }
        }
        
        var myBSToModify = myBs.first!
        myBSToModify.items = existingRecipes
        
        do {
            let aBookSection = BookSection(id: myBSToModify.id, name: myBSToModify.name, items: existingRecipes)
            let ajsonfile = try encoder.encode(aBookSection)

            try ajsonfile.write(to: myReczipesDirUrl.appendingPathComponent( json))
            if zBug { print(msgs.mrv.rawValue + "Wrote recipe to user folder")}
        } catch {
            if zBug { print(msgs.mrv.rawValue + "Can't encode booksection")}
            fatalError()
        }
        // get the move to booksection and rewrite it with the new recipe
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                    do {
                        let aBookSection = try decoder.decode(BookSection.self, from: ajsonfile)
                        if aBookSection.name == (getBookSectionNames()[xectionTo]) {
                            myBs.append(aBookSection)
                        }
                        if zBug { print(msgs.mrv.rawValue + msgs.fuar.rawValue)}
                        
                    } catch  {
                        // not a json file
                        fatalError("This directory has illegal files")
                    }
            }
        } catch  {
            // no contents
        }
        if myBs.isEmpty {
            let aBookSection = BookSection(id: UUID(), name: getBookSectionNames()[xectionTo], items: [myMovingRecipe])
            do {
                let ajsonfile = try encoder.encode(aBookSection)
                try ajsonfile.write(to: myReczipesDirUrl.appendingPathComponent( json))
                if zBug { print(msgs.mrv.rawValue + "Wrote recipe to a newly created user section")}
            } catch  {
                fatalError()
            }
            
            
        }
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


struct MoveRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MoveRecipeView(movingRecipe: SectionItem.example3, moveFromBookSection: BookSection.example.name)
    }
}

