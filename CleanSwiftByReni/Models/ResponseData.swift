//
//  ResponseData.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 09/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
struct ResponseData: Decodable {
    var tracks: ResponseDataSong
    
    init(tracks: ResponseDataSong) {
        self.tracks = tracks
    }
}
