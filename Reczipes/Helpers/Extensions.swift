//
//  Extensions.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 12/27/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine

fileprivate var zBug: Bool = false

fileprivate enum msgs: String {
    case returningpresetrecipes = "Returning Preset Recipes "
    case returningbooksectionssf = "Returning BookSections in single file"
    case success = "Successfull remove of a recipe"
    case fail = "Failed to remove a recipe "
    case counted = "User added recipes Contents count "
    case nobs = "No booksection files found"
}

private var decoder: JSONDecoder = JSONDecoder()
private var encoder: JSONEncoder = JSONEncoder()

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return decoded
    }
}

extension UIImage {
    func scaledDown(into size:CGSize, centered:Bool = false) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleW, scaleH) = (1 as CGFloat, 1 as CGFloat)
        if targetWidth > size.width {
            scaleW = size.width/targetWidth
        }
        if targetHeight > size.height {
            scaleH = size.height/targetHeight
        }
        let scale = min(scaleW,scaleH)
        targetWidth *= scale; targetHeight *= scale
        let sz = CGSize(width:targetWidth, height:targetHeight)
        if !centered {
            return UIGraphicsImageRenderer(size:sz).image { _ in
                self.draw(in:CGRect(origin:.zero, size:sz))
            }
        }
        let x = (size.width - targetWidth)/2
        let y = (size.height - targetHeight)/2
        let origin = CGPoint(x:x,y:y)
        return UIGraphicsImageRenderer(size:size).image { _ in
            self.draw(in:CGRect(origin:origin, size:sz))
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

struct Symbol {
    enum Kind { case mention, hashtag }
    
    let kind: Kind
    var string: String
}

extension Symbol {
    static func mention(_ string: String) -> Symbol {
        return Symbol(kind: .mention, string: string)
    }
    
    static func hashtag(_ string: String) -> Symbol {
        return Symbol(kind: .hashtag, string: string)
    }
}

extension String {
    var mentionedUsernames: [String] {
        let parts = split(separator: ",")
        
        // Character sets may be inverted to identify all
        // characters that are *not* a member of the set.
        let delimiterSet = CharacterSet.letters.inverted
        
        return parts.compactMap { part in
            // Here we grab the first sequence of letters right
            let name = part.components(separatedBy: delimiterSet)[0]
            return name.isEmpty ? nil : name
        }
    }
}

extension FileManager {
    func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}

extension Publisher {
  
  /// Executes an asyncronous call and returns its result to the downstream subscriber.
  ///
  /// - Parameter transform: A closure that takes an element as a parameter and returns a publisher that produces elements of that type.
  /// - Returns: A publisher that transforms elements from an upstream  publisher into a publisher of that element’s type.
  func `await`<T>(_ transform: @escaping (Output) async -> T) -> AnyPublisher<T, Failure> {
    flatMap { value -> Future<T, Failure> in
      Future { promise in
        Task {
          let result = await transform(value)
          promise(.success(result))
        }
      }
    }
    .eraseToAnyPublisher()
  }
  
  /// Performs the specified closures when publisher events occur.
  ///
  /// This is an overloaded version of ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` that only
  /// accepts a closure for the `receiveOutput` events. Use it to inspect events as they pass through the pipeline.
  ///
  /// - Parameters:
  ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
  /// - Returns: A publisher that performs the specified closures when publisher events occur.
  func handleEvents(_ receiveOutput: (@escaping (Self.Output) -> Void)) -> Publishers.HandleEvents<Self> {
    self.handleEvents(receiveOutput: receiveOutput)
  }
  
  /// Performs the specified closures when publisher events occur.
  ///
  /// This is an overloaded version of ``Publisher/handleEvents(receiveSubscription:receiveOutput:receiveCompletion:receiveCancel:receiveRequest:)`` that only
  /// accepts a closure for the `receiveOutput` events. Use it to execute side effects while events pass down the pipeline.
  ///
  /// - Parameters:
  ///   - receiveOutput: A closure that executes when the publisher receives a value from the upstream publisher.
  /// - Returns: A publisher that performs the specified closures when publisher events occur.
  func handleEvents(_ receiveOutput: (@escaping () -> Void)) -> Publishers.HandleEvents<Self> {
    self.handleEvents { output in
      receiveOutput()
    }
  }
}
