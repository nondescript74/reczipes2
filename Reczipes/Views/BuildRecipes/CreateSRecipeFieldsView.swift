//
//  CreateSRecipeFieldsView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/1/22.
//

import SwiftUI

struct CreateSRecipeFieldsView: View {
    // MARK: - Local debug
    fileprivate var zBug: Bool = false
    // MARK: - Environment Variables
    @EnvironmentObject var rbb: RecipeBeingBuilt
    @EnvironmentObject var aur: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    // MARK: - Initializer
    // MARK: - Properties
    fileprivate enum msgs: String {
        case csrfv = "CSRFView: "
        case en = "Enter recipe name"
        case al = "Aggregate likes"
        case chp = "Cheap?"
        case cm = "Cooking minutes"
        case cred = "Credits"
        case cuis = "Pick a cuisine"
        case cuisine = "Cuisine"
        case df = "Dairy Free?"
        case diet = "Diet"
        case gf = "Gluten Free?"
        case hs = "Healthscore"
        case selectPhoto = "Select Photo"
        case choose = "Choose"
        case photolib = "Photo Library"
        case camera = "Camera"
        case bigmsg = "Choose a picture from ..."
        case save = "Save Recipe"
    }
    
    @State fileprivate var recName: String = ""
    @State fileprivate var aggLikes: Int64 = 0
    @State fileprivate var selectionValues: [Int64] = Array(0...500)
    @State fileprivate var cheap: Bool = true
    @State fileprivate var cookmin: Int64 = 0
    @State fileprivate var creds: String = ""
    @State fileprivate var xdiet: Diet = Diet.dietExampleKG
    @State fileprivate var dairyF: Bool = false
    @State fileprivate var cuisine: String = "American"
    @State fileprivate var diets: [String] = []
    @State fileprivate var gf: Bool = false
    @State fileprivate var hscore: Double = 0.0
    @State fileprivate var urlString: String = SectionItem.example.url
    @State fileprivate var showSheet: Bool = false
    @State fileprivate var showImagePicker: Bool = false
    @State fileprivate var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State fileprivate var sourceTypes: [UIImagePickerController.SourceType] = [.photoLibrary, .savedPhotosAlbum]
    @State fileprivate var image:UIImage?
    
    
    // MARK: - Methods
    fileprivate func saveIt() -> Bool {
        rbb.srecipe?.aggregateLikes = self.aggLikes
        rbb.srecipe?.cheap = self.cheap
        rbb.srecipe?.cookingMinutes = self.cookmin
        rbb.srecipe?.creditsText = self.creds
        rbb.srecipe?.dairyFree = self.dairyF
        rbb.srecipe?.cuisines = [cuisine]  //[aur.getBookSectionNames()[xection]]
        rbb.srecipe?.diets = self.diets
        rbb.srecipe?.dishTypes = []
        rbb.srecipe?.extendedIngredients = []
        rbb.srecipe?.gaps = ""
        rbb.srecipe?.glutenFree = self.gf
        rbb.srecipe?.healthScore = self.hscore
        rbb.srecipe?.id = Int.random(in: 100001..<myMax)
        rbb.srecipe?.image = ""
        rbb.srecipe?.imageType = ""
        rbb.srecipe?.instructions = ""
        rbb.srecipe?.license = ""
        rbb.srecipe?.lowFodmap = false
        rbb.srecipe?.occasions = []
        rbb.srecipe?.originalId = ""
        rbb.srecipe?.preparationMinutes = 0
        rbb.srecipe?.pricePerServing = 0.0
        rbb.srecipe?.readyInMinutes = 0
        rbb.srecipe?.servings = 0
        rbb.srecipe?.sourceName = "Z"
        rbb.srecipe?.sourceUrl = urlString
        rbb.srecipe?.spoonacularScore = 0
        rbb.srecipe?.spoonacularSourceUrl = ""
        rbb.srecipe?.summary = ""
        rbb.srecipe?.sustainable = false
        rbb.srecipe?.title = self.recName
        rbb.srecipe?.vegan = false
        rbb.srecipe?.vegetarian = false
        rbb.srecipe?.veryHealthy = false
        rbb.srecipe?.veryPopular = false
        rbb.srecipe?.weightWatcherSmartPoints = 0
        rbb.srecipe?.winePairing = WinePairing()
        
        if rbb.srecipe != nil && rbb.srecipe?.title != "" && aur.getBookSectionNames().contains(where: {$0 == cuisine}) && image != nil  {
            
            let newImg = image!.scaledDown(into: CGSize(width: 384, height: 300))
            let recuuid = UUID()
            let imageSaved = ImageSaved(recipeuuid: recuuid, imageSaved: (newImg.pngData())!)
            aui.addImage(imageSaved: imageSaved)
            
            let imagesDirUrl: URL = getDocuDirUrl().appendingPathComponent(recipesName).appendingPathComponent(recipeImagesFolderName)
            let pathImage = imagesDirUrl.appendingPathComponent(recuuid.uuidString + ".json").absoluteString
            let pathRecipe = getDocuDirUrl().appendingPathComponent(recipesName).appendingPathComponent(recuuid.uuidString + ".json").absoluteString
            
            var sectionItem = convertSRecipeToSectionItem(srecipe: rbb.srecipe!)
            sectionItem.imageUrl = pathImage
            sectionItem.url = pathRecipe
            _ = aur.addRecipe(bsectionid: aur.getBookSectionIDForName(name: cuisine), recipe: sectionItem)
            
#if DEBUG
            if zBug {print(msgs.csrfv.rawValue + "saved SectionItem")}
#endif
        } else {
            
#if DEBUG
            if zBug {print(msgs.csrfv.rawValue + "Could not save, may be missing items")}
#endif
            return false
        }

        return true
    }
    
    fileprivate func addDietToList() {
        let str = xdiet.name
        if !self.diets.contains(str) {
            self.diets.append(str)
        }
        if zBug {print(msgs.csrfv.rawValue + diets.description)}
    }
    
    fileprivate var actionSheet: ActionSheet {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            // camera is available
            sourceTypes = [.camera, .photoLibrary, .savedPhotosAlbum]
            return ActionSheet(title: Text(msgs.selectPhoto.rawValue),
                               message: Text(msgs.choose.rawValue),
                               buttons: [
                                .default(Text(msgs.photolib.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .default(Text(msgs.camera.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .camera
                                },
                                .cancel()
                               ])
        } else {
            sourceTypes = [.photoLibrary, .savedPhotosAlbum]
            return ActionSheet(title: Text(msgs.selectPhoto.rawValue),
                               message: Text(msgs.choose.rawValue),
                               buttons: [
                                .default(Text(msgs.photolib.rawValue)) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .cancel()
                               ])
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Form {
                        TextField(msgs.en.rawValue, text: $recName)
                        TextField(msgs.cred.rawValue, text: $creds)
                        Picker(msgs.cuis.rawValue, selection: $cuisine) {
                            ForEach(aur.getBookSectionNames(), id: \.self) { name in
                                Text(name)
                            }
                        }
                        Section {
                            Image(uiImage: (image ?? UIImage(named: "Default Image"))!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width, height: proxy.size.height / 4)
                            Button(action: {
                                // What to perform
                                self.showImagePicker = true
                            }) {
                                // How the button looks like
                                Text(msgs.bigmsg.rawValue)
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                                    .frame(width: proxy.size.width, height: proxy.size.height / 30)
                            }
                        }
                        
                        BuildRestrictionsView()
                        
                        Section {
                            Button(action: {
                                // What to perform
                                _ = saveIt()
                            }) {
                                // How the button looks like
                                Text(msgs.save.rawValue)
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                                    .frame(width: proxy.size.width, height: proxy.size.height / 30)
                            }
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
                    }
                }
            }
        }
    }
}

struct CreateSRecipeFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSRecipeFieldsView()
            .environmentObject(RecipeBeingBuilt())
            .environmentObject(AllUserRecipes())
            .environmentObject(AllUserImages())
    }
}

