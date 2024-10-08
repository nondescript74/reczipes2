/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SwiftUI

protocol ImageFilterDataProvider {
    var image: Image? { get }
}

public class ImageFilterOperation: Operation {
    
    // MARK: - Environment Variables
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // MARK: - Publisher
    @Published var filterOutput: Image?
    
    // MARK: - Debug
    fileprivate var zBug: Bool = false
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
            .filter({ $0 is ImageFilterDataProvider })
            .first as? ImageFilterDataProvider {
            image = dataProvider.image
        }
        return image
    }
}

extension ImageFilterOperation: @unchecked Sendable {
     
}


extension ImageFilterOperation: ImageFilterDataProvider {
    var image: Image? {
        return filterOutput
    }
}
