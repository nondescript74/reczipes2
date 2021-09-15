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
    
    // MARK: - Environment
    @Environment(\.presentationMode) var presentation
    // MARK: - State
    @Binding var result: Result<MFMailComposeResult, Error>?
    // MARK: - Properties
    var sectItem: SectionItem
    private enum msgs: String {
        case mv = "MailView: "
        case messSubj = "Hi, thought you might like this recipe I cook"
        case failedData = "Failed encoding SectionItem to Data"
        case noAddress = "User mail sending not available"
        case json = ".json"
        case success = "mailComposeController finished with success"
        case failedMC = "mailComposeController finished with failure"
        case recipehasnotes = "This recipe has notes to send"
        case recipehasimages = "This recipe has images to send"
        case separator = " : "
        case mailwithattachmentscreated = "A recipe with note and/or images if availabe attached as data to mail"
    }
    
    private let fileIO = FileIO()
    
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
#if DEBUG
                print(msgs.mv.rawValue + msgs.failedMC.rawValue)
#endif
                return
            }
            self.result = .success(result)
#if DEBUG
                print(msgs.mv.rawValue + msgs.success.rawValue)
#endif
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
//    func createMailComposeViewController() -> MFMailComposeViewController {
//        let mailComposeViewController = MFMailComposeViewController()
//        mailComposeViewController.mailComposeDelegate = self
//        mailComposeViewController.setToRecipients(["example@test.test"])
//        mailComposeViewController.setSubject("subject")
//        mailComposeViewController.setMessageBody("test body", isHTML: false)
//        return mailComposeViewController
//    }
    
//    func createRecipeWithImagesAndNotes() -> SectionItem {
//        
//    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        //let resultz = fileIO.writeFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeNotesFolderName, fileNameToSave: sectionItemName + delimiterFileNames + sectionItemId + delimiterFileNames + dateString, fileType: msgs.json.rawValue, data: encodedNoteData)
        
        
        if MFMailComposeViewController.canSendMail() {
            do {
                let jSONEncode = JSONEncoder()
                
                let getNotes = fileIO.readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeNotesFolderName)  // set of urls to files
                let thisSetOfNotes = getNotes.filter({"\($0)".contains(sectItem.id.uuidString)})
#if DEBUG
                print(msgs.mv.rawValue + msgs.recipehasnotes.rawValue + msgs.separator.rawValue + "\(thisSetOfNotes.count)")
#endif
                
                let getImages = fileIO.readFileInRecipeNotesOrImagesFolderInDocuments(folderName: recipeFolderName + delimiterDirs + recipeImagesFolderName)  // set of urls to files
                let thisSetOfImages = getImages.filter({"\($0)".contains(sectItem.id.uuidString)})
#if DEBUG
                print(msgs.mv.rawValue + msgs.recipehasimages.rawValue + msgs.separator.rawValue + "\(thisSetOfImages.count)")
#endif
                
                let encodedSectItem = try jSONEncode.encode(sectItem)
                let encodedSectItemData = Data(encodedSectItem)
                
                let encodedSetOfNotes = try jSONEncode.encode(thisSetOfNotes)
                let encodedSetOfNotesData = Data(encodedSetOfNotes)
                
                let encodedSetOfImages = try jSONEncode.encode(thisSetOfImages)
                let encodedSetOfImagesData = Data(encodedSetOfImages)
                
                let dateString = Date().description
                let resultName = sectItem.name + delimiterFileNames + delimiterFileNames + dateString + msgs.json.rawValue
                
                let sectionItemNotesImages: SectionItemNotesImages = SectionItemNotesImages(id: UUID(), name: resultName, recipeData: encodedSectItemData, recipeImages: encodedSetOfImagesData, recipeNotes: encodedSetOfNotesData)
                let encodedSectionItemNotesImages = try jSONEncode.encode(sectionItemNotesImages)
                let encodedSectionItemNotesImagesData = Data(encodedSectionItemNotesImages)
                
                let vc = MFMailComposeViewController()
                vc.mailComposeDelegate = context.coordinator
                vc.setSubject(msgs.messSubj.rawValue)
                vc.setMessageBody(sectItem.url, isHTML: false)
                vc.addAttachmentData(encodedSectionItemNotesImagesData, mimeType: msgs.json.rawValue, fileName: resultName)
                
#if DEBUG
                print(msgs.mv.rawValue + msgs.mailwithattachmentscreated.rawValue)
#endif
                return vc
                
            } catch {
#if DEBUG
                print(msgs.mv.rawValue + msgs.failedData.rawValue)
#endif
                fatalError()
            }
            
        } else {
            
#if DEBUG
            print(msgs.mv.rawValue + msgs.noAddress.rawValue)
#endif
            fatalError()
        }
        
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
