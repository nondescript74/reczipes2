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
    // MARK: Debug local
    private var zBug: Bool = false
    // MARK: - Initializer
    init(data: Data?, completion: ((Image?) -> ())? = nil) {
        inputData = data
        self.completion = completion
        super.init()
    }
    // MARK: - Properties
    fileprivate var inputData: Data?
    fileprivate var completion: ((Image?) -> ())?
    fileprivate var myImage: Image?
    fileprivate enum msgs: String {
        case ico = "ImgCrtOp: "
        case isib = "Image size in bytes "
        case ifd = "Image from data "
        case ciwd = "Created Image with data, myImage is "
        case cci = " Can't create image"
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
        
        if let image = UIImage(data: data) {
            myImage = Image.init(uiImage: image)
#if DEBUG
            if zBug {print(msgs.ico.rawValue + msgs.isib.rawValue + "\(data.count)")}
            if zBug {print(msgs.ico.rawValue + msgs.ifd.rawValue, image.debugDescription)}
            if zBug {print(msgs.ico.rawValue +  msgs.ciwd.rawValue, myImage.debugDescription)}
#endif
            
        } else {
#if DEBUG
            if zBug {print(msgs.ico.rawValue + msgs.cci.rawValue)}
#endif
        }
        if self.isCancelled { return }
        completion?(myImage)
    }
}

extension ImageCreateOperation: @unchecked Sendable {
     
}

extension ImageCreateOperation:  ImageOutputOperationDataProvider, ImageXOperationDataProvider {
    var image: Image? { return myImage }
}
