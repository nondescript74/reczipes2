//
//  ImageOutputOperation.swift
//  ZTester4
//
//  Created by Zahirudeen Premji on 11/26/20.
//

import Foundation
import SwiftUI

protocol ImageOutputOperationDataProvider {
    var image:Image? { get }
}

class ImageOutputOperation: ImageXOperation {
    // MARK: - Debug local
    private var zBug:Bool = false
    // MARK: -  Properties
    fileprivate var inputImage: Image?
    fileprivate var completion: (Image?) -> ()
    // MARK: - Initializer
    init(image: Image?, completion: @escaping (Image?) -> ()) {
        self.completion = completion
        self.inputImage = image
        super.init(image: image)
    }
    
    override func main() {
        
        let imagez: Image?
        if self.isCancelled { return }
        
        if let inputImage = inputImage {
            imagez = inputImage
        } else {
            let dataProvider = dependencies
                .filter { $0 is ImageOutputOperationDataProvider }
                .first as? ImageOutputOperationDataProvider
            imagez = dataProvider?.image
        }
        
        guard imagez != nil else { return }
        
        if self.isCancelled { return }
        
        #if DEBUG
        if zBug { print("ImageOutputOperation Image debug description ", imagez.debugDescription)}
        #endif
        
        if isCancelled { return }
        completion(imagez)
    }
}

