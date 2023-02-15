//
//  ShareRecipeView.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 2/13/23.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

struct ShareRecipeView: View {
    @State private var showShareSheet = false
    init(showShareSheet: Bool = false, sectionItem: SectionItem) {
        self.showShareSheet = showShareSheet
        self.myItem = sectionItem
    }
    fileprivate var myItem: SectionItem?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello Z")
            Button(action: {
                self.showShareSheet = true
            }) {
                Text("Share Me").bold()
            }
        }
        .sheet(isPresented: $showShareSheet) {
            let data = URL(string: "https://www.zoho.com")
            ShareSheet(activityItems: [data as Any])
        }
    }
}

struct ShareRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        ShareRecipeView(sectionItem: SectionItem.example2)
    }
}
