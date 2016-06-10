//
//  NetworkMiddleware.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  General mandatory requirements for a NetworkMiddleware
 */
protocol NetworkMiddleware {
    
    associatedtype Result
    
    /**
     Describes how to handle a network Result
     
     - parameter result:            Result got from a netowrk request
     - parameter completionHandler: Should return a correct JSON instance or a NSError
     */
    func handleResult(result: Result, completionHandler: (json: [String : AnyObject]?, error: NSError?) -> Void)
}