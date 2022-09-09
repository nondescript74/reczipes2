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
    // MARK: - Debug local\
    private var zBug: Bool = true
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
//        case json = ".json"
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
    var isDirectory: ObjCBool = true
    private var decoder: JSONDecoder = JSONDecoder()
    private var encoder: JSONEncoder = JSONEncoder()
    // MARK: - Methods
    private func getDocuDirUrl() -> URL {
        var myReturn:URL
        do {
            let myDocuDirUrl = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            myReturn = myDocuDirUrl
        } catch {
            fatalError()
        }
        return myReturn
    }
    
    fileprivate func constructNotesIfAvailable() -> Array<Note> {
        var myNotesConstructed:Array<Note> = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.mv.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl.appending(component: msgs.rnotes.rawValue),
                                                                   includingPropertiesForKeys: []).filter({$0.absoluteString.contains(sectItem.id.uuidString)})
            // now shipped recipes
            
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                do {
                    let aNote = try decoder.decode(Note.self, from: ajsonfile)
                    myNotesConstructed.append(aNote)
                    if zBug { print(msgs.mv.rawValue + msgs.fan.rawValue)}
                    
                } catch  {
                    // not a json file
                    fatalError("Cannot decode This directory has illegal files")
                }
            }
        } catch {
            
        }
        
        let shippedNotes:[Note] = Bundle.main.decode([Note].self, from: msgs.rnotes.rawValue + json).sorted(by: {$0.recipeuuid.description < $1.recipeuuid.description}).filter({$0.recipeuuid.description == sectItem.id.uuidString})
        if shippedNotes.isEmpty  {
            
        } else {
            myNotesConstructed.append(contentsOf: shippedNotes)
        }
        return myNotesConstructed
    }
    
    fileprivate func constructImagesIfAvailable() -> Array<ImageSaved> {
        var myImagesConstructed:Array<ImageSaved> = []
        let myDocuDirUrl = getDocuDirUrl()
        let myReczipesDirUrl:URL = myDocuDirUrl.appending(path: msgs.mv.rawValue)
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: myReczipesDirUrl.appending(component: msgs.rimages.rawValue),
                                                                   includingPropertiesForKeys: []).filter({$0.absoluteString.contains(sectItem.id.uuidString)})
            // now shipped recipes
            
            let myReczipesDirUrlStr = myReczipesDirUrl.absoluteString
            for aurl in urls {
                let ajsonfile = FileManager.default.contents(atPath: myReczipesDirUrlStr.appending(aurl.absoluteString))!
                do {
                    let anImageSaved = try decoder.decode(ImageSaved.self, from: ajsonfile)
                    myImagesConstructed.append(anImageSaved)
                    if zBug { print(msgs.mv.rawValue + msgs.fani.rawValue)}
                    
                } catch  {
                    // not a json file
                    fatalError("Cannot decode This directory has illegal files")
                }
            }
        } catch {
            
        }
        
        let shippedImages:[ImageSaved] = Bundle.main.decode([ImageSaved].self, from: msgs.rimages.rawValue + json).sorted(by: {$0.recipeuuid.uuidString < $1.recipeuuid.uuidString}).filter({$0.recipeuuid.uuidString == sectItem.id.uuidString})
        if shippedImages.isEmpty  {
            
        } else {
            myImagesConstructed.append(contentsOf: shippedImages)
        }
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
