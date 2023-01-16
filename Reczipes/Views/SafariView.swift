//
//  SafariView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 7/18/21.
//

import Foundation
import UIKit
import SafariServices
import SwiftUI

struct SafariView: View, UIViewControllerRepresentable {

    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://apple.com")!)
    }
}
