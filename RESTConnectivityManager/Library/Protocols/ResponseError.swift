//
//  ResponseError.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  Generic requirements for a ResponseError candidate object
 */
protocol ResponseError : JSONDecodable, NSErrorConvertible {}

class Error : ResponseError {
    
    typealias Element = Error
    static func fromDictionary(json: [String : AnyObject]) -> Element? {
        
        return Error()
    }
    
    func toNSError() -> NSError {
        
        return NSError(
            domain: "Error",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey : "This is a default error. Please, provide a new ResponseError conforming struct or class"
            ]
        )
    }
}