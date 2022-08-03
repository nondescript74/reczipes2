//
//  NetworkAccessor.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/30/17.
//  Copyright © 2017 Zahirudeen Premji. All rights reserved.
//

import Foundation

struct NetworkAccessor {
    static func asyncLoadDataAtURL(_ url: URL, completion: @escaping ((_ data: Data?) -> ())) {
        DispatchQueue.global(qos: .default).async {
            let data = syncLoadDataAtURL(url)
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    static func syncLoadDataAtURL(_ url: URL) -> Data? {
        return (try? Data(contentsOf: url))
    }
}
