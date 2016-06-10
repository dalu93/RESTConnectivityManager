//
//  APIRequest.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/**
 *  Generic requirements for an APIRequest object
 */
protocol APIRequest {
    
    associatedtype Element
    associatedtype SomeKindOfRequest
    
    var HTTPRequest : URLRequest { get }
    var completionHandler : (ItemResponse<Element, NSError>) -> () { get set }
    
    func perform() -> SomeKindOfRequest?
    func serialize(dictionary: [String : AnyObject]?, error: NSError?)
}

import Alamofire

extension ItemRequest {
    
    func perform() -> Alamofire.Request? {
        
        let middleware = APIMiddleware<RequestError>()
        return APIConnector.sharedConnector.perform(
            request: self,
            middleware: middleware
        )
    }
}

// MARK: - Private APIConnector default behavior
private extension APIConnector {
    
    func perform<T: APIRequest, U: NetworkMiddleware where U.Result == Response<AnyObject, NSError>>(request request: T, middleware: U) -> Request? {
        
        return APIConnector.requestJSON(
            request: request,
            middleware: middleware,
            completionHandler: request.serialize
        )
    }
}