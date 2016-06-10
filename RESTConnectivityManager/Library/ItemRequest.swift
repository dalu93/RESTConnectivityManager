//
//  ItemRequest.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

class ItemRequest<Item, RequestError where Item : JSONDecodable, RequestError: ResponseError> {
    
    let endoint : APIEndpoint
    
    typealias Element = Item
    var completionHandler: (ItemResponse<Element, NSError>) -> ()
    
    init(endpoint: APIEndpoint, completionHandler: (ItemResponse<Element, NSError>) -> ()) {
        
        self.endoint = endpoint
        self.completionHandler = completionHandler
    }
}

extension ItemRequest : APIRequest {
    
    var HTTPRequest: URLRequest {
        
        do {
            
            return try APIURLRequestBuilder.HTTPRequestWith(
                endpoint: self.endoint
            )
            
        } catch (_) {
            
            preconditionFailure("Please, set the apiBaseURL before using the library")
        }
    }
    
    func serialize(dictionary: [String : AnyObject]?, error: NSError?) {
        
        if let error = error {
            
            completionHandler(.Failure(error))
            
        } else if
            let dictionary = dictionary,
            let item = Element.fromDictionary(dictionary) as? Element {
            
            completionHandler(.Success(item))
            
        } else {
            
            completionHandler(.Failure(.SerializationError))
        }
    }
}

private extension NSError {
    
    static var SerializationError : NSError {
        
        return NSError(
            domain: "Serialization",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey : "An error occured while serializing the object"
            ]
        )
    }
}

enum ItemResponse<Value, Error> {
    
    case Success(Value)
    case Failure(Error)
}