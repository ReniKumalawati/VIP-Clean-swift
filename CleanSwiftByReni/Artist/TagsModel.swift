//
//  TagsModel.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 17/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import UIKit
enum Tags
{
    // MARK: Use cases
    
    enum TagsData
    {
        struct Request
        {
            var method: String
        }
        struct Response
        {
        }
        
        struct ResponseTags: Decodable {
            var tags: ResponseDataTag
        }
        struct ViewModel
        {
        }
        
        struct SingleTags: Decodable {
            var name: String
            var url: String
            var reach: String
            var position: Int? = 0
            
            init(name: String, url: String, reach: String, position: Int?) {
                self.name = name
                self.url = url
                self.reach = reach
                self.position = position
            }
        }
        
        struct ResponseDataTag: Decodable {
            var tag: [SingleTags]
            
            init(tag: [SingleTags]) {
                self.tag = tag
            }
            init() {
                self.tag = [SingleTags]()
            }
        }
        
        
    }
}
