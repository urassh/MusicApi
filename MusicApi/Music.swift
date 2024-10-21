//
//  Music.swift
//  MusicApi
//
//  Created by 浦山秀斗 on 2024/10/21.
//

import UIKit

struct Music {
    var trackName: String
    var artistImage: UIImage
    
    init(trackName: String, artistImage: UIImage) {
        self.trackName = trackName
        self.artistImage = artistImage
    }
    
    init(_ result: MusicResult) async {
        self.trackName = result.trackName
        self.artistImage = await result.artworkUrl100.urlEncoded()?.image() ?? UIImage(imageLiteralResourceName: "placeholder")
    }
}
