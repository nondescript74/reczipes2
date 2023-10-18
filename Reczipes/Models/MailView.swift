//
//  MailView.swift
//  MailView
//
//  Created by Zahirudeen Premji on 8/21/21.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {
    // MARK: - Debug local
    fileprivate var zBug: Bool = false
    // MARK: - Environment
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var auu: AllUserRecipes
    @EnvironmentObject var aui: AllUserImages
    @EnvironmentObject var aun: AllUserNotes
    // MARK: - State
    @Binding var result: Result<MFMailComposeResult, Error>?
    // MARK: - Properties
    var sectItem: SectionItem
    fileprivate enum msgs: String {
        case mv = "MailView: "
        case messSubj = "Hi, thought you might like this recipe I cook"
        case failedData = "Failed encoding SectionItem to Data"
        case noAddress = "User mail sending not available"
        case success = "mailComposeController finished with success"
        case failedMC = "mailComposeController finished with failure"
        case recipehasnotes = "This recipe has notes to send"
        case recipehasimages = "This recipe has images to send"
        case separator = " : "
        case mailwithattachmentscreated = "A recipe with note and/or images if availabe attached as data to mail"
        case rnotes = "RecipeNotes"
        case rimages = "RecipeImages"
        case fan = "Found a Note"
        case fani = "Found an ImageSaved"
    }
    fileprivate var decoder: JSONDecoder = JSONDecoder()
    fileprivate var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    
    fileprivate func constructNotesIfAvailable() -> Array<Note> {
        let myNotesConstructed:Array<Note> = aun.notes
        return myNotesConstructed
    }
    
    fileprivate func constructImagesIfAvailable() -> Array<ImageSaved> {
        let myImagesConstructed:Array<ImageSaved> = aui.images
        return myImagesConstructed
    }
    
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                
                print(msgs.mv.rawValue + msgs.failedMC.rawValue)
                
                return
            }
            self.result = .success(result)
            
            print(msgs.mv.rawValue + msgs.success.rawValue)
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        if MFMailComposeViewController.canSendMail() {
            do {
                let jSONEncode = JSONEncoder()
                var myNotesConstructed:Array<Note> = []
                myNotesConstructed = constructNotesIfAvailable()
                
                print(msgs.mv.rawValue + msgs.recipehasnotes.rawValue + msgs.separator.rawValue + "\(myNotesConstructed.count)")
                
                var myImagesConstructed:Array<ImageSaved> = []
                myImagesConstructed = constructImagesIfAvailable()
                
                print(msgs.mv.rawValue + msgs.recipehasimages.rawValue + msgs.separator.rawValue + "\(myImagesConstructed.count)")
                
                
                let encodedSectItem = try jSONEncode.encode(sectItem)
                let encodedSectItemData = Data(encodedSectItem)
                
                let encodedSetOfNotes = try jSONEncode.encode(myNotesConstructed)
                let encodedSetOfNotesData = Data(encodedSetOfNotes)
                
                let encodedSetOfImages = try jSONEncode.encode(myImagesConstructed)
                let encodedSetOfImagesData = Data(encodedSetOfImages)
                
                let dateString = Date().description
                let resultName = sectItem.name + delimiterFileNames + delimiterFileNames + dateString + json
                
                let sectionItemNotesImages: SectionItemNotesImages = SectionItemNotesImages(id: UUID(), name: resultName, recipeData: encodedSectItemData, recipeImages: encodedSetOfImagesData, recipeNotes: encodedSetOfNotesData)
                let encodedSectionItemNotesImages = try jSONEncode.encode(sectionItemNotesImages)
                let encodedSectionItemNotesImagesData = Data(encodedSectionItemNotesImages)
                
                let vc = MFMailComposeViewController()
                vc.mailComposeDelegate = context.coordinator
                vc.setSubject(msgs.messSubj.rawValue)
                vc.setMessageBody(sectItem.url, isHTML: false)
                vc.addAttachmentData(encodedSectionItemNotesImagesData, mimeType: json, fileName: resultName)
                
                print(msgs.mv.rawValue + msgs.mailwithattachmentscreated.rawValue)
                return vc
                
            } catch {
                print(msgs.mv.rawValue + msgs.failedData.rawValue)
                fatalError()
            }
            
        } else {
            fatalError(msgs.mv.rawValue + msgs.noAddress.rawValue)
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}

//struct MailView_Previews: PreviewProvider {
//    static let sectItem = SectionItem.example2
//    static var previews: some View {
//        MailView(result: nil, sectItem: sectItem)
//    }
//}
