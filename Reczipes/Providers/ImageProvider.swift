//
//  ImageProvider.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 5/29/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

public class ImageProvider {
    // MARK: - Debug local
    private var zBug: Bool = false
    // MARK: - Properties
    fileprivate let operationQueue = OperationQueue()
    var imageUrl: URL
    // MARK: Required Initializer
    init(imageUrl: URL, completion: @escaping (Image?) -> ()) {
        self.imageUrl = imageUrl
    
        // Create the operations
        let dataLoadImage = DataLoadOperation(url: self.imageUrl)
        let imageCreate = ImageCreateOperation(data: nil)
        let imageOut = ImageOutputOperation(image: nil, completion: completion)

        let operations = [dataLoadImage, imageCreate, imageOut]
        
        // Add dependencies
        imageCreate.addDependency(dataLoadImage)
        imageOut.addDependency(imageCreate)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
#if DEBUG
        if zBug { print("OperationQueue for ImageProvider is launched")}
        if zBug {print ("imageUrl is: " + imageUrl.absoluteString)}
#endif
        
    }
    
    func cancel() {
        operationQueue.cancelAllOperations()
    }
}

extension ImageProvider: Equatable {
    public static func == (lhs: ImageProvider, rhs: ImageProvider) -> Bool {
        lhs.imageUrl == rhs.imageUrl
    }
}

extension ImageProvider: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(imageUrl)
    }
}
