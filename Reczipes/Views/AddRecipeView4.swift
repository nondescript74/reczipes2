//
//  AddRecipeView4.swift
//  RecipeBookCreator
//
//  Created by Zahirudeen Premji on 1/10/21.
//

import SwiftUI
import UserNotifications

struct AddRecipeView4: View {
    // MARK: - EnvironmentObject
    @EnvironmentObject var addedRecipes: AddedRecipes
    @EnvironmentObject var newFormRecipes: NewFormRecipes
    // MARK: - ObservedObject
    @ObservedObject var extractedSRecipe = WebQueryRecipes()
    // MARK: - Properties
    fileprivate let nc = NotificationCenter.default
    fileprivate var fileIO = FileIO()
    fileprivate enum msgs: String {
        case AddRecipeView4 = "AddRecipeView4: "
        case addRecipe = "Add Recipe"
        case addedbooksection = "Added to Added Recipes "
        case success = " success: "
        case notitle = "No Title"
        case notificationsOk = "All Set"
        case urlNotOk = "Need a Valid URL"
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
        
        
    }
    let content = UNMutableNotificationContent()
    
    // MARK: - State
    @State private var hasRecipeBook:Bool = false
    @State private var restrictions:String = ""
    @State private var urlString:String = ""
    @State private var xection:Int = 0
    @State private var bookselected:Int = 0
    @State private var recipeSaved:Bool = false
    @State private var recipeRequested:Bool = false
    // MARK: - Methods
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return false
        }
        //        invalidUrl = false
        extractedSRecipe.findExtracted(urlString: urlString)
        recipeRequested = true
        return UIApplication.shared.canOpenURL(url)
    }
    
    
    fileprivate func buildNotificationContent(title: String, subTitle: String, sound: UNNotificationSound) {
        content.title = title
        content.subtitle = subTitle
        content.sound = UNNotificationSound.default
    }
    
    func createRecipeInRecipeBook() {
        
        if !verifyUrl(urlString: self.urlString)     {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    nc.post(name: Notification.Name(msgs.urlNotOk.rawValue), object: nil)
                    
                } else if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            
            #if DEBUG
            print(msgs.notComplete.rawValue)
            #endif
            return
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
                print(msgs.AddRecipeView4.rawValue + msgs.wroteFile.rawValue)
                #endif
                
                addedRecipes.addBookSection(bookSection: bookSection)
                
                #if DEBUG
                print(msgs.AddRecipeView4.rawValue + msgs.addedbooksection.rawValue)
                #endif
                recipeSaved = true
                
            } else {
                #if DEBUG
                print(msgs.AddRecipeView4.rawValue + msgs.cantWriteEncode.rawValue)
                #endif
                recipeSaved = false
            }
            
        } catch {
            #if DEBUG
            print(msgs.AddRecipeView4.rawValue + msgs.cantEncode.rawValue)
            #endif
        }
        
        recipeRequested.toggle()
        recipeSaved.toggle()
        nc.post(name: Notification.Name(msgs.addedRecipe.rawValue), object: nil)
        
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
        title = extractedSRecipe.extractedSRecipe?.title ?? "No_Title"
        return title
    }
    
    fileprivate func getPhotoCredit() -> String {
        var credit = ""
        credit = extractedSRecipe.extractedSRecipe?.creditsText ?? "No_photocredit"
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
                    Text(msgs.enterValidUrl.rawValue)
                        .foregroundColor(.black)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                        .padding(.bottom, 5)
                    
                    TextField(msgs.enterValidUrl.rawValue, text: $urlString)
                        .foregroundColor(Color.blue)
                        .padding(.bottom, 10)
                        .font(Font.system(size: 13, weight: .medium, design: .serif))
                    
                    //HStack(alignment: .top) {
//                        VStack(alignment: .leading) {
//                            Text(msgs.pickbook.rawValue)
//                                .foregroundColor(.black)
//                                .font(Font.system(size: 15, weight: .medium, design: .serif))
//                            
//                            Picker(msgs.books.rawValue, selection: $bookselected) {
//                                ForEach(0..<getBookNames().count) { index in
//                                    Text("\(getBookNames()[index])")
//                                        .foregroundColor(.blue)
//                                        .font(Font.system(size: 13, weight: .medium, design: .serif))
//                                }
//                                
//                            }.frame(width: geometry.size.width / 2)
//                            .clipped()
//                            
//                            Text("\(getBookNames()[bookselected])" + " " + msgs.selected.rawValue)
//                                .foregroundColor(.black)
//                                .font(Font.system(size: 15, weight: .medium, design: .serif))
//                        }
//                        .padding(5)
                        
                        VStack(alignment: .leading) {
                            Text(msgs.pickSection.rawValue)
                                .foregroundColor(.black)
                                .font(Font.system(size: 15, weight: .medium, design: .serif))
                            
                            Picker(msgs.books.rawValue, selection: $xection) {
                                ForEach(0..<getBookSectionNames().count) { index in
                                    Text("\(getBookSectionNames()[index])")
                                        .foregroundColor(.blue)
                                        .font(Font.system(size: 13, weight: .medium, design: .serif))
                                }
                            }.frame(width: geometry.size.width / 2)
                            .clipped()
                            
                            Text("\(getBookSectionNames()[xection])" + " " + msgs.selected.rawValue)
                                .foregroundColor(.black)
                                .font(Font.system(size: 15, weight: .medium, design: .serif))
                        }
                        .padding(5)
                        
                    //}.padding(5)
                    
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
            .navigationBarItems(
                trailing: Button(action: createRecipeInRecipeBook) {
                    Text(msgs.plussign.rawValue + "Recipe").fontWeight(.bold).font(Font.system(size: 20, weight: .medium, design: .serif))
                }
            )
            .navigationBarTitle(msgs.addRecipe.rawValue)
        }
    }
}
#if DEBUG
struct AddRecipeView4_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView4()
    }
}
#endif
