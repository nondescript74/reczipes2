//
//  ImageXOperatIon.swift
//  CRecipes
//
//  Created by Zahirudeen Premji on 5/31/20.
//  Copyright © 2020 Zahirudeen Premji. All rights reserved.
//


import Foundation
import SwiftUI

protocol ImageXOperationDataProvider {
    var image: Image? { get }
}

class ImageXOperation: Operation {
    var filterOutput: Image?
    fileprivate let _filterInput: Image?
    
    init(image: Image?) {
        _filterInput = image
        super.init()
    }
    
    var filterInput: Image? {
        var image: Image?
        if let inputImage = _filterInput {
            image = inputImage
        } else if let dataProvider = dependencies
            .filter({ $0 is ImageXOperationDataProvider })
            .first as? ImageXOperationDataProvider {
            image = dataProvider.image
        }
        #if DEBUG
        print(image.debugDescription)
        #endif
        
        filterOutput = image
        return filterOutput
    }
}

extension ImageXOperation: ImageXOperationDataProvider {
    var image: Image? {
        return filterOutput
    }
}
