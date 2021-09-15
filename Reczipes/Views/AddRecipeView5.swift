//
//  AddRecipeView5.swift
//  AddRecipeView5
//
//  Created by Zahirudeen Premji on 8/11/21.
//

import SwiftUI

struct AddRecipeView5: View {
    
    // MARK: - EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var order: OrderingList
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    @ObservedObject var sRecipeGroup = WebQueryRecipes()
    // MARK: - Properties
    fileprivate var fileIO = FileIO()
    fileprivate enum msgs: String {
        case AddRecipeView5 = "AddRecipeView5: "
        case addRecipe = "Add Recipe"
        case addedbooksection = "Added to Added Recipes "
        case success = " success: "
        case notitle = "No Title"
        case nophotocredit = "No Photocredit"
        case notificationsOk = "All Set"
        case urlNotOk = "Need a Valid URL"
        case urlOk = "Valid Url"
        case addedRecipe = "Added Recipe"
        case invalidUrl = "Invalid URl"
        case enterValidUrl = "Enter valid Recipe URL"
        case gotIt = "Got It!"
        case available = " Available"
        case wroteFile = "wrote file for BookSection successfully"
        case cantWriteEncode = "Can't write encoded BookSection "
        case cantEncode = "Can't encode SectionItem"
        case json = "json"
        case z = "Z"
        case imageInfo = "_imageinfo"
        case creating = "Creating"
        case notComplete = "Not Complete"
        case constructedRestrict = "constructed restrictions"
        case pickSection = "Pick a Recipe Section"
        case pickbook = "Pick a Recipe Book"
        case sectionz = "Sections"
        case books = "Recipe Books"
        case selected = "Selected"
        case ok = "OK"
        case notYet = "Not yet"
        case obtaining = " Being obtained"
        case saving = "Saving Recipe"
        case saved = "Saved Recipe"
        case plussign = "✚"
        case find = "?"
        case makeFindSelection = "Enter text, click ?"
        
    }
    // MARK: - State
    @State private var hasRecipeBook: Bool = false
    @State private var restrictions: String = ""
    @State private var urlString: String = ""
    @State private var xection: Int = 0
    @State private var bookselected: Int = 0
    @State private var recipeSaved: Bool = false
    @State private var recipeRequested: Bool = false
    @State fileprivate var searchTerm: String = ""
    @State var show: Selectors = .notyet
    // MARK: - Properties
    enum Selectors {
        case notyet
        case names
        case random
        case search
    }
    // MARK: - Methods
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
                  return false
              }
        extractedSRecipe.findExtracted(urlString: urlString)
        recipeRequested = true
        return UIApplication.shared.canOpenURL(url)
    }
    
    func getSRecipeGroup() {
        show = Selectors.names
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        sRecipeGroup.getSearched(searchString: searchTerm, numberSent: numberNeeded)
        endEditing()
    }
    
    func findRandom() {
        show = Selectors.random
        let numberNeeded = userData.profile.numberOfRecipes.rawValue
        sRecipeGroup.findByRandom(searchString: searchTerm, numberSent: numberNeeded)
        endEditing()
    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    func convertSRecipeToSectionItem(srecipe: SRecipe) -> SectionItem {
        let returningSecItem = SectionItem(id: UUID(),
                                           name: srecipe.title ?? SectionItem.example.name,
                                           url: srecipe.sourceUrl ?? SectionItem.example.url,
                                           imageUrl: srecipe.image,
                                           photocredit: srecipe.creditsText ?? SectionItem.example.photocredit,
                                           restrictions: constructRestrictions(srecipe: srecipe))
        return returningSecItem
    }
    
    func createRecipeInRecipeBook() {
        if !verifyUrl(urlString: self.urlString)     {
#if DEBUG
            print(msgs.notComplete.rawValue)
#endif
            return
        }
    }
    
    private func createRecipeInRecipeBookWithSRecipe(srecipe: SRecipe) {
        self.urlString = srecipe.sourceUrl!
        if !verifyUrl(urlString: self.urlString) {
#if DEBUG
            print(msgs.urlNotOk.rawValue)
#endif
            return
        } else {
#if DEBUG
            print(msgs.urlOk.rawValue)
#endif
            _ = convertSRecipeToSectionItem(srecipe: srecipe)
            _ = createRecipeInRecipeBook2()
        }
    }
    
    func createRecipeInRecipeBook2() -> SectionItem {
        
        let existingBookSectionNames = getBookSectionNames()   //(filename: recipeBooks[recipeBook] + "." + msgs.json.rawValue)
        let filtered = existingBookSectionNames.filter {$0 == existingBookSectionNames[xection]}  // should be only one
        
        // extract the recipe and create the necessary SectionItem to contain it
        // save the image set for the recipe in a separate struct, use the recipeID
        
        let secname = (filtered.first)!
        let secuuid = getSectionUUID(sectionname: secname)
        let recrestrictions = constructRestrictions(srecipe: extractedSRecipe.extractedSRecipe!)  // uses the urlString
        let rectitle = getTitle()
        let reccredit = getPhotoCredit()
        let recimageurl = getImageUrl()
        let sectionItem = SectionItem(id: UUID(), name: rectitle, url: urlString, imageUrl: recimageurl.description, photocredit: reccredit, restrictions: recrestrictions)  // this is a recipe
        
        let bookSection = BookSection(id: secuuid, name: secname, items: [sectionItem])
        
        // encode the sectionItem and then save to documents
        do {
            let encodedBookSection = try JSONEncoder().encode(bookSection)
            let date = Date().description
            let result = fileIO.writeFileInRecipeNotesOrImagesFolderInDocuments(folderName:
                                                                                    recipeFolderName + delimiterDirs + recipesName + delimiterDirs + secname + delimiterDirs,
                                                                                fileNameToSave:
                                                                                    secname + delimiterFileNames +
                                                                                date,
                                                                                fileType: msgs.json.rawValue,
                                                                                data: Data(encodedBookSection))
            if result {
                
#if DEBUG
                print(msgs.AddRecipeView5.rawValue + msgs.wroteFile.rawValue)
#endif
                
                addedRecipes.addBookSection(bookSection: bookSection)
                
#if DEBUG
                print(msgs.AddRecipeView5.rawValue + msgs.addedbooksection.rawValue)
#endif
                recipeSaved = true
                
            } else {
#if DEBUG
                print(msgs.AddRecipeView5.rawValue + msgs.cantWriteEncode.rawValue)
#endif
                recipeSaved = false
            }
            
        } catch {
#if DEBUG
            print(msgs.AddRecipeView5.rawValue + msgs.cantEncode.rawValue)
#endif
        }
        
        recipeRequested.toggle()
        recipeSaved.toggle()
        //nc.post(name: Notification.Name(msgs.addedRecipe.rawValue), object: nil)
        
        return sectionItem
    }
    
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
        title = extractedSRecipe.extractedSRecipe?.title ?? msgs.notitle.rawValue
        return title
    }
    
    fileprivate func getPhotoCredit() -> String {
        var credit = ""
        credit = extractedSRecipe.extractedSRecipe?.creditsText ?? msgs.nophotocredit.rawValue
        return credit
    }
    
    fileprivate func getImageUrl() -> String {
        let imagetoreturnurl = extractedSRecipe.extractedSRecipe?.image ?? defaultImageUrl
        return imagetoreturnurl
    }
    
    // MARK: - View Process
    var body: some View {
        NavigationView {
            GeometryReader(content: { geometry in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 1) {
                        SearchBar(text: $searchTerm)
                            //.padding()
                        Button(action: getSRecipeGroup) {
                            Text(msgs.find.rawValue).fontWeight(.bold)
                        }
                    }
                    
                    TextField(msgs.enterValidUrl.rawValue, text: $urlString)
                        .padding(.bottom, 10)
                    
                    Picker(msgs.books.rawValue, selection: $xection) { let zx = getBookSectionNames().count
                        ForEach(0..<zx) { index in
                            Text("\(getBookSectionNames()[index])")
                        }
                    }
                    
//                    Text("\(getBookSectionNames()[xection])" + " " + msgs.selected.rawValue)
//                        .padding(5)
                    
                    List   {
                        if show == Selectors.names {
                            ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                                PlusSignAndRecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: srecipe))
                            }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                        }
                        if show == Selectors.random {
                            ForEach(sRecipeGroup.sRecipeGroup) { srecipe in
                                PlusSignAndRecipeRowView(sectionItem: convertSRecipeToSectionItem(srecipe: srecipe))
                            }.disabled(sRecipeGroup.sRecipeGroup.isEmpty)
                        }
                    }
                }
                .alert(isPresented: $recipeRequested)   {
                    if extractedSRecipe.extractedSRecipe?.title != nil {
                        let item = createRecipeInRecipeBook2()
                        return Alert(title: Text( item.name + msgs.available.rawValue), message: Text(item.name + msgs.creating.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
                    } else {
                        return Alert(title: Text(msgs.notYet.rawValue), message: Text(msgs.obtaining.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
                    }
                }
                .alert(isPresented: $recipeSaved)   {
                    return Alert(title: Text(msgs.saving.rawValue), message: Text(msgs.saved.rawValue), dismissButton: .default(Text(msgs.ok.rawValue)))
                }
                
            })
                .padding()
                .navigationBarTitle(msgs.addRecipe.rawValue)
        }
    }
}

#if DEBUG
struct AddRecipeView5_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView5(show: .notyet)
            .previewDevice("iPhone Xr")
    }
}
#endif




