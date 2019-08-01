//
//  Conectivity.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 14/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
import Alamofire

struct Conectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
