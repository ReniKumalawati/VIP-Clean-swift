//
//  Connectivity.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 20/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
