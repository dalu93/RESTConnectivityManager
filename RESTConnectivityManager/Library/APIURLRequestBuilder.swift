//
//  APIURLRequestBuilder.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

class APIURLRequestBuilder : URLRequestBuilder {
    
    private static let sharedBuilder = APIURLRequestBuilder()
    
    private var apiBaseURL : NSURL?
    
    static func set(baseURL baseURL: NSURL) {
        
        APIURLRequestBuilder.sharedBuilder.apiBaseURL = baseURL
    }
    
    typealias HTTPEndpoint = APIEndpoint
    static func HTTPRequestWith(endpoint endpoint: HTTPEndpoint) throws -> URLRequest {
        
        guard let apiBaseURL = APIURLRequestBuilder.sharedBuilder.apiBaseURL else {
            
            throw URLRequestBuilderError.NoBaseURLSet
        }
        
        let completeURL = apiBaseURL.URLByAppendingPathComponent(endpoint.path)
        
        return URLRequest(
            URL: completeURL,
            headers: endpoint.headers,
            method: endpoint.method,
            parameters: endpoint.parameters
        )
    }
}

private enum URLRequestBuilderError : ErrorType {
    
    case NoBaseURLSet
}