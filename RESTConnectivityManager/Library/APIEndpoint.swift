//
//  APIEndpoint.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

struct APIEndpoint {
    
    let path : String
    let method : String
    let headers: [String : String]?
    let parameters: [String : AnyObject]?
}

extension APIEndpoint {
    
    static var Me : APIEndpoint {
        
        return APIEndpoint(
            path: "/me",
            method: "GET",
            headers: nil,
            parameters: nil
        )
    }
}