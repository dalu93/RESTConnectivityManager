//
//  ResponseErrorHandler.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  Generic requirements for an object responsible for the error handling
 */
protocol ResponseErrorHandler {
    
    func handle(error error: NSError, additionalData: NSData?, completionHandler: (error: NSError?) -> ())
}