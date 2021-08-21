//
//  SendMailView.swift
//  SendMailView
//
//  Created by Zahirudeen Premji on 8/21/21.
//

import SwiftUI
import MessageUI


struct SendMailView: View {

   @State var result: Result<MFMailComposeResult, Error>? = nil
   @State var isShowingMailView = false

    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        }) {
            Text("📤")
        }
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result)
        }
    }
}

struct SendMailView_Previews: PreviewProvider {
    static var previews: some View {
        SendMailView()
    }
}
