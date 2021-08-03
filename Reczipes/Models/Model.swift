//
//  Model.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/7/21.
//

import Contacts
import ContactsUI

struct Contact: Identifiable {
    
    var id: String {contact.identifier}
    var firstName: String {contact.givenName}
    var lastName: String {contact.familyName}
    var email: String {(contact.emailAddresses.map(\.value).first ?? "no_one@gmail.com") as String}
    let contact: CNContact
    
    static func fetchAll(_ completion: @escaping(Result<[Contact], Error>) -> Void) {
        let containerID = CNContactStore().defaultContainerIdentifier()
        let predicated = CNContact.predicateForContactsInContainer(withIdentifier: containerID)
        let descriptor = [CNContactIdentifierKey,
                          CNContactGivenNameKey,
                          CNContactFamilyNameKey,
                          CNContactEmailAddressesKey] as [CNKeyDescriptor]
        
        do {
            let rawContacts = try CNContactStore().unifiedContacts(matching: predicated, keysToFetch: descriptor)
            completion(.success(rawContacts.map {.init(contact: $0)}))
        } catch {
            completion(.failure(error))
        }
    }
}

enum PermissionsError: Identifiable {
    var id: String {UUID().uuidString}
    case userCancelledError
    case fetchError(_: Error)
    var description: String {
        switch self {
        case .userCancelledError:
            return "Please do something else"
        case .fetchError(let error):
            return error.localizedDescription
        }
    }
}
