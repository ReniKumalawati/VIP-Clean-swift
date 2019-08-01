//
//  UrlContainer.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 16/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
class URLContainer {
    private(set) var urls: [URL] = []
    
    func add(_ url: URL) {
        urls.append(url)
        
        NotificationCenter.default.post(name: .URLContainerDidAddURL, object: self, userInfo: [URLContainer.urlKey: url ] )
    }
    
    static let urlKey = "URL"
}
