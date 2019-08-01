//
//  EtyArtist.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 14/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//
import Foundation
import CoreData
@objc(EtyArtist)
class EtyArtist: NSManagedObject {
    @NSManaged var name:String
    @NSManaged var url:String
    @NSManaged var position:Int
    @NSManaged var country:String
    
    func addProperty(name:String = "", url:String = "", position:Int = 0, country:String = "") throws {
        if name.count > 0 {
            self.name = name
            self.url = url
            self.position = position
            self.country = country
        } else {
            throw NSError(domain: "", code: 100, userInfo: nil)
        }
    }
}
