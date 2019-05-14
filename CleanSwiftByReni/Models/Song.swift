//
//  Song.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 08/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation

struct Song: Decodable {
    var name: String
    var url: String
    
    init(name:String, url: String) {
        self.name = name
        self.url = url
    }
}
