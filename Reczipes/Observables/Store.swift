//
//  Store.swift
//  PlayReczipes
//
//  Created by Zahirudeen Premji on 3/18/25.
//

import Foundation
import OSLog

@MainActor @Observable final class Store {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.playrecipes", category: "Store")
    private(set) var messages: [String] = []
    
    private func fetch(_ url: URL) async -> String {
        return "Fetched \(url)"
    }
    
    func fetch(urls: [URL]) async {
        messages = await withTaskGroup(
            of: String.self,
            returning: [String].self
        ) { group in
            let maxConcurrentFetches = min(urls.count, 5)
            var index = -1
            
            for _ in 0..<maxConcurrentFetches {
                group.addTask {
                    index += 1
                    self.logger.info("added task for index: \(index)")
                    return await self.fetch(urls[index])
                }
            }
            var messages: [String] = []
            
            for await message in group where !message.isEmpty {
                messages.append(message)
                logger.info("added message: \(message)")
                
                if index < urls.count {
                    _ = group.addTaskUnlessCancelled {
                        index += 1
                        self.logger.info("added task for index: \(index)")
                        return await self.fetch(urls[index])
                    }
                }
            }
            logger.info(". . . all tasks completed . . .")
            return messages
        }
    }
}
