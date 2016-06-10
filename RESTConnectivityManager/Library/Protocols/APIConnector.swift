//
//  APIConnector.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation
import Alamofire

class APIConnector {
    
    static let sharedConnector = APIConnector()
    static let middleware = APIMiddleware<Error>()
    
    
    class func requestJSON<T: APIRequest, U: NetworkMiddleware where U.Result == Response<AnyObject, NSError>>(request request: T, middleware: U, completionHandler: (dict: [String : AnyObject]?, error: NSError?) -> ()) -> Request? {
        
        guard let method : Alamofire.Method = Alamofire.Method(rawValue: request.HTTPRequest.method) else {
            
            completionHandler(
                dict: nil,
                error: .NoMethodError
            )
            
            return nil
        }
        
        return Alamofire.request(
            method,
            request.HTTPRequest.URL,
            parameters: request.HTTPRequest.parameters,
            encoding: .URL,
            headers: request.HTTPRequest.headers
        ).validate()
        .responseJSON { (response) in
            
            middleware.handleResult(
                response,
                completionHandler: completionHandler
            )
//            APIConnector.middleware.handleResult(
//                response,
//                completionHandler: completionHandler
//            )
        }
    }
}

private extension NSError {
    
    static var NoMethodError : NSError {
        
        return NSError(
            domain: "APIConnector",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey : "Cannot use the HTTP method you provided"
            ]
        )
    }
}