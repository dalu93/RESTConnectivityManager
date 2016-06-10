//
//  JSONDecodable.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  Describes an object that can be instantiate from JSON
 */
protocol JSONDecodable {
    
    associatedtype Element
    static func fromDictionary(json: [String : AnyObject]) -> Element?
}