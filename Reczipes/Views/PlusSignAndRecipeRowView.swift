//
//  PlusSignAndRecipeRowView.swift
//  PlusSignAndRecipeRowView
//
//  Created by Zahirudeen Premji on 8/17/21.
//

import SwiftUI

struct PlusSignAndRecipeRowView: View {
    
    // MARK: - Environment
    @EnvironmentObject var addedRecipes: AddedRecipes
    // MARK: - ObservedObject
    @ObservedObject var anImage = WebQueryRecipes()
    // MARK: - Properties
    fileprivate var srecipe: SRecipe
    fileprivate var sectionName: String
    fileprivate var urlstring: String
    fileprivate var item: SectionItem
    private enum msgs: String {
        case psnrrv = "PlusSignAndRecipeRowView"
        case plus = "+"
        case writingRecipe = "Adding Recipe"
        case notitle = "No Title"
        case nophotocredit = "No Photocredit"
        case json = "json"
        case wroteFile = "wrote file for BookSection successfully"
        case cantEncode = "Can't encode SectionItem"
        case addedbooksection = "Added to Added Recipes "
        case success = " success: "
        case cantWriteEncode = "Can't write encoded BookSection "
    }
    // MARK: - State
    @State private var recipeSaved: Bool = false
    // MARK: - Initializer
    init(srecipe: SRecipe, sectionName: String, urlstring: String) {
        self.srecipe = srecipe
        self.sectionName = sectionName
        self.urlstring = urlstring
        
        self.item = SectionItem(id: UUID(),
                                name: srecipe.title ?? SectionItem.example.name,
                                url: srecipe.sourceUrl ?? SectionItem.example.url,
                                imageUrl: srecipe.image,
                                photocredit: srecipe.creditsText ?? SectionItem.example.photocredit,
                                restrictions: constructRestrictions(srecipe: srecipe))
        
    }
    // MARK: - Methods
    
    fileprivate func getSectionUUID(sectionname: String) -> UUID {
        let bookSections = myBookSectionsIdNames
        var uuid: UUID = UUID(uuidString: defaultUUID)!  // and example for initialization
        for asection in bookSections {
            if asection.name == sectionname {
                uuid = asection.id
            }
        }
        return uuid
    }
    
    fileprivate func getTitle() -> String {
        var title = ""
        title = self.srecipe.title ?? msgs.notitle.rawValue
        return title
    }
    
    fileprivate func getPhotoCredit() -> String {
        var credit = ""
        credit = self.srecipe.creditsText ?? msgs.nophotocredit.rawValue
        return credit
    }
    
    fileprivate func getImageUrl() -> String {
        let imagetoreturnurl = self.srecipe.image ?? defaultImageUrl
        return imagetoreturnurl
    }
    private func performAddRecipeToAddedRecipes() {
        
#if DEBUG
        print(msgs.psnrrv.rawValue + msgs.writingRecipe.rawValue)
#endif
        
    
        
        let secuuid = getSectionUUID(sectionname: sectionName)
        let recrestrictions = constructRestrictions(srecipe: self.srecipe)  // uses the urlString
        let rectitle = getTitle()
        let reccredit = getPhotoCredit()
        let recimageurl = getImageUrl()
        let sectionItem = SectionItem(id: UUID(), name: rectitle, url: urlstring, imageUrl: recimageurl.description, photocredit: reccredit, restrictions: recrestrictions)  // this is a recipe
        
        let bookSection = BookSection(id: secuuid, name: self.sectionName, items: [sectionItem])
        
        // encode the sectionItem and then save to documents
        do {
            let encodedBookSection = try JSONEncoder().encode(bookSection)
            let date = Date().description
            let result = FileIO().writeFileInRecipeNotesOrImagesFolderInDocuments(folderName:
                                                                                    recipeFolderName + delimiterDirs + recipesName + delimiterDirs + self.sectionName + delimiterDirs,
                                                                                  fileNameToSave:
                                                                                    self.sectionName + delimiterFileNames +
                                                                                  date,
                                                                                  fileType: msgs.json.rawValue,
                                                                                  data: Data(encodedBookSection))
            if result {
                
#if DEBUG
                print(msgs.psnrrv.rawValue + msgs.wroteFile.rawValue)
#endif
                
                addedRecipes.addBookSection(bookSection: bookSection)
                
#if DEBUG
                print(msgs.psnrrv.rawValue + msgs.addedbooksection.rawValue)
#endif
                recipeSaved = true
                
            } else {
#if DEBUG
                print(msgs.psnrrv.rawValue + msgs.cantWriteEncode.rawValue)
#endif
                recipeSaved = false
            }
            
        } catch {
#if DEBUG
            print(msgs.psnrrv.rawValue + msgs.cantEncode.rawValue)
#endif
        }
        
        recipeSaved.toggle()
        //nc.post(name: Notification.Name(msgs.addedRecipe.rawValue), object: nil)
        
    }
    // MARK: - Body
    
    var body: some View {
        HStack {
            Button(action: {
                // What to perform
                performAddRecipeToAddedRecipes()
            }) {
                // How the button looks like
                Text(msgs.plus.rawValue)
                    .foregroundColor(.blue)
                    .font(Font.system(size: 50, weight: .medium, design: .serif))
                
            }.padding(.trailing, 20)
            RecipeRowView(sectionItem: self.item)
        }
        .alert(isPresented: $recipeSaved)   {
            return Alert(title: Text("Saved Recipe"), message: Text("Saved"), dismissButton: .default(Text("OK")))
        }
    }
}

struct PlusSignAndRecipeRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlusSignAndRecipeRowView(srecipe: SRecipe.example, sectionName: "Fake Section", urlstring: "Something")
    }
}
