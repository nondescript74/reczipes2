//
//  FoundRecipeStore.swift
//  Reczipes
//
//  Created by Zahirudeen Premji on 10/6/22.
//

import Foundation

class FoundRecipeStore: ObservableObject {
    @Published var foundRecipes: [BookSection] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent(recipesName)
            .appendingPathComponent("recipesShipped.json")
    }
    
    static func load() async throws -> [BookSection] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let booksections):
                    continuation.resume(returning: booksections)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[BookSection], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let bsections = try JSONDecoder().decode([BookSection].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(bsections))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(booksections: [BookSection]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(booksections: booksections) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let booksectionsSaved):
                    continuation.resume(returning: booksectionsSaved)
                }
            }
        }
    }
    
    static func save(booksections: [BookSection], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(booksections)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(booksections.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
