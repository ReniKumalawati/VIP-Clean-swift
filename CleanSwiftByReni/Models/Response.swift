//
//  Response.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 08/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
struct ResponseDataSong: Decodable {
    var track: [Song]
    
    init(track: [Song]) {
        self.track = track
    }
    init() {
        self.track = [Song]()
    }
}
