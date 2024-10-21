//
//  MusicRepository.swift
//  MusicApi
//
//  Created by 浦山秀斗 on 2024/10/21.
//

import Foundation

enum MusicError: Error {
    case invalidURL
    case invalidResponse
    case notFound
    case unknown
}

class MusicRepository {
    private let BASE_URL: String = "https://itunes.apple.com"
    
    private func query(keyword: String) -> String {
        BASE_URL + "/search?term=\(keyword)&entity=song&country=JP&lang=ja_jp&limit=20"
    }
    
    func fetchMusics(keyword: String) async throws -> [Music]? {
        guard let url = query(keyword: keyword).urlEncoded() else { throw MusicError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw MusicError.invalidResponse }
        
        if httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            let response = try decoder.decode(MusicResponse.self, from: data)
            return await response.toMusics()
        }
        
        if httpResponse.statusCode == 404 {
            throw MusicError.notFound
        }
        
        throw MusicError.unknown
    }
}

extension String {
    func urlEncoded() -> URL? {
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: encoded)
    }
}


