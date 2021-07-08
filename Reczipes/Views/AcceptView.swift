//
//  AcceptView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/8/21.
//

import SwiftUI

struct AcceptView: View {
    
    // MARK: - Environment Variables
    @StateObject private var contactsVM = ContactsViewModel()
    
    // MARK: - Messages
    private enum msgs: String {
        case register_m = "Add Me"
        case send_m = "Send Me"
        case title_m = "Please Register"
        case permErr_m = "Permissions Error"
        case ok_m = "OK"
        case nodesc_m = "No Description of error"
    }
    
    var body: some View {
        NavigationView {
            ForEach(contactsVM.contacts) { contact in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Label(contact.firstName, systemImage: "person.crop.circle")
                        Text(contact.lastName).bold()
                    }
                    Divider()
                    Label(contact.email, systemImage: "apps.iphone")
                }
                .padding()
                .background(Color.secondary.opacity(0.30))
                .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
            }
            .navigationTitle(msgs.title_m.rawValue)
        }
        .alert(item: $contactsVM.permissionsError) { _ in
            Alert(title: Text(msgs.permErr_m.rawValue),
                  message: Text(contactsVM.permissionsError?.description ?? msgs.nodesc_m.rawValue),
                  dismissButton: .default(Text(msgs.ok_m.rawValue), action: { contactsVM.openSettings()}))
            
        }
    }
}

struct AcceptView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptView()
    }
}
