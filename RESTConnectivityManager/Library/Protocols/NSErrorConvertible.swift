//
//  NSErrorConvertible.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  Describes an object that can be converted to an NSError instance
 */
protocol NSErrorConvertible {
    
    func toNSError() -> NSError
}