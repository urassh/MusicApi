//
//  Music.swift
//  MusicApi
//
//  Created by 浦山秀斗 on 2024/10/21.
//

import Foundation
import UIKit

struct MusicResponse: Codable {
    let results: [MusicResult]
    
    func toMusics() async -> [Music] {
        return await self.results.asyncCompactMap { result in
            await Music(result)
        }
    }
}

struct MusicResult: Codable {
    var trackName: String
    var artworkUrl100: String
}

extension Array {
    func asyncCompactMap<T>(_ transform: (Element) async -> T?) async -> [T] {
        var result = [T]()
        for value in self {
            if let transformed = await transform(value) {
                result.append(transformed)
            }
        }
        return result
    }
}
