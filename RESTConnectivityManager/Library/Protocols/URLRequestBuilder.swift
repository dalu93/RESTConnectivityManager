//
//  URLRequestBuilder.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  Generic requirements for an URLRequestBuilder object
 */
protocol URLRequestBuilder {
    
    associatedtype HTTPEndpoint
    
    /**
     It creates an URLRequest struct
     
     - parameter endpoint:             The endpoint to use to build the complete URL
     - parameter authorizationHeaders: Use or not the authorization headers for this
     http request
     
     - returns: Return an URLRequest struct
     */
    static func HTTPRequestWith(endpoint endpoint: HTTPEndpoint) throws -> URLRequest
}

/**
 *  Basic struct containing the minimal info to create a new network connection
 */
struct URLRequest {
    
    let URL : NSURL
    let headers : [String : String]?
    let method : String
    let parameters: [String : AnyObject]?
}