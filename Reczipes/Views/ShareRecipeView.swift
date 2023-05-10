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
            
            Button(action: {
                self.showShareSheet = true
            }) {
                Text("Share https://www.zoho.com").bold()
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

struct Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }

    public var image: Image
    public var caption: String
}

struct PhotoView: View {
    let photo: Photo

    var body: some View {
        
        photo.image
            .toolbar {
                ShareLink(
                    item: photo,
                    subject: Text("Cool Photo"),
                    message: Text("Check it out!"),
                    preview: SharePreview(
                        photo.caption,
                        image: photo.image))
            }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: Photo(image: Image(uiImage: UIImage(systemName: "flag.2.crossed")!), caption: "flags"))
    }
}
