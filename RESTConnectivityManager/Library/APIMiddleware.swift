//
//  APIMiddleware.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

/// The APIMiddleware handle the first communication result between the client
/// and the server. Create a new instance by passing a custom error object conforming
/// to JSONDecodable and NSErrorConvertible protocols. You can even override
/// the ErrorHandler instance by providing a ResponseErrorHandler conforming object
class APIMiddleware<ErrorObject: ResponseError> {
    
    /// The error handler. Please, override it if you want to handle the error
    /// differently
    var errorHandler = ErrorHandler<ErrorObject>()
}

import Alamofire

// MARK: - NetworkMiddleware
extension APIMiddleware : NetworkMiddleware {
    
    typealias Result = Alamofire.Response<AnyObject, NSError>
    
    func handleResult(result: Result, completionHandler: (json: [String : AnyObject]?, error: NSError?) -> Void) {
        
        switch result.result {
            
        case .Success(let jsonObject):
            
            guard let json = jsonObject as? [String : AnyObject] else {
                
                completionHandler(
                    json: nil,
                    error: .APIMiddlewareGenericError
                )
                
                return
            }
            
            completionHandler(
                json: json,
                error: nil
            )
            
        case .Failure(let error):
            
            errorHandler.handle(
                error: error,
                additionalData: result.data,
                completionHandler: { (handleError) in
                    
                    completionHandler(
                        json: nil,
                        error: handleError
                    )
                }
            )
        }
    }
}

/// The default ResponseErrorHandler object the APIMiddleware will use to handle the error
class ErrorHandler<ErrorObject where ErrorObject : JSONDecodable, ErrorObject : NSErrorConvertible> : ResponseErrorHandler {
    
    func handle(error error: NSError, additionalData: NSData?, completionHandler: (error: NSError?) -> ()) {
        
        if error.isCanceled { return }
        
        if error.isConnectionError() {
            
            completionHandler(
                error: .APIMiddlewareConnectionError
            )
            
        } else if
            let data = additionalData,
            let jsonError = data.toDictionary(),
            let error = ErrorObject.fromDictionary(jsonError) as? ErrorObject {
            
            completionHandler(
                error: error.toNSError()
            )
            
        } else {
            
            completionHandler(
                error: .APIMiddlewareGenericError
            )
        }
    }
}

// MARK: - Added some shortcuts for NSError
private extension NSError {
    
    static let APIMiddlewareErrorDomain = "APIMiddleware"
    
    private static let GenericErrorCode     = -1
    private static let ConnectionErrorCode  = -2
    
    static var APIMiddlewareGenericError : NSError {
        
        return NSError(
            domain: NSError.APIMiddlewareErrorDomain,
            code: NSError.GenericErrorCode,
            userInfo: [
                NSLocalizedDescriptionKey : "Generic error while fetching the response"
            ]
        )
    }
    
    static var APIMiddlewareConnectionError : NSError {
        
        return NSError(
            domain: NSError.APIMiddlewareErrorDomain,
            code: NSError.ConnectionErrorCode,
            userInfo: [
                NSLocalizedDescriptionKey : "There were connection issues"
            ]
        )
    }
}

// MARK: - Generic shortcuts for NSError
extension NSError {
    
    func isConnectionError() -> Bool {
        
        switch code {
        case NSURLErrorTimedOut,
             NSURLErrorCannotConnectToHost,
             NSURLErrorNetworkConnectionLost,
             NSURLErrorResourceUnavailable,
             NSURLErrorNotConnectedToInternet:
            return true
            
        default:
            return false
        }
    }
    
    var isCanceled : Bool { return code == NSURLErrorCancelled }
}

// MARK: - Dictionary transformation
private extension NSData {
    
    func toDictionary() -> [String : AnyObject]? {
        
        var dictionary : [String : AnyObject]?
        
        do {
            
            dictionary = try NSJSONSerialization.JSONObjectWithData(
                self,
                options: .AllowFragments
                ) as? [String : AnyObject]
            
        } catch (_) {  }
        
        return dictionary
    }
}