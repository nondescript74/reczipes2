//
//  ImageCreateOperation.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 5/29/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//

import Foundation
import SwiftUI

protocol ImageCreateOperationDataProvider {
    var data:Data? { get }
}

class ImageCreateOperation: Operation {
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: ((Image?) -> ())?
    fileprivate var myImage: Image?
    // MARK: - Initializer
    init(data: Data?, completion: ((Image?) -> ())? = nil) {
        inputData = data
        self.completion = completion
        super.init()
    }
    
    override func main() {
        
        let imageData: Data?
        if self.isCancelled { return }
        if let inputData = inputData {
            imageData = inputData
        } else {
            let dataProvider = dependencies
                .filter { $0 is ImageCreateOperationDataProvider }
                .first as? ImageCreateOperationDataProvider
            imageData = dataProvider?.data
        }
        
        guard let data = imageData else { return }
        
        if self.isCancelled { return }
        
        #if DEBUG
        print("ImageCreateOperation Image debug description ", image.debugDescription)
        #endif
        
        
        if let image = UIImage(data: data) {
            
            #if DEBUG
            print("ImageCreateOperation Image from data ", image.debugDescription)
            #endif
            
            myImage = Image.init(uiImage: image)
                        
            #if DEBUG
            print("ImageCreateOperation Created Image with data, myImage is ", myImage.debugDescription)
            #endif
            
        } else {
            #if DEBUG
            print("Can't create image")
            #endif
        }
        
        if self.isCancelled { return }
        completion?(myImage)
    }
}

extension ImageCreateOperation:  ImageOutputOperationDataProvider, ImageXOperationDataProvider {
    var image: Image? { return myImage }
}
