//
//  ViewController.swift
//  RESTConnectivityManager
//
//  Created by Luca D'Alberti on 6/10/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        APIURLRequestBuilder.set(baseURL: NSURL(string: "http://www.google.it")!)
        
        let _ = ItemRequest<Object, Error>(
        endpoint: APIEndpoint.Me) { (let response) in
            
            switch response {
                
            case .Success(let item):
                
                print(item.itemId)
                
            case .Failure(let error):
                
                print(error)
            }
        }.perform()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

struct Object : JSONDecodable {
    typealias Element = Object
    
    private let itemId : String
    
    static func fromDictionary(json: [String : AnyObject]) -> Element? {
        
        if let itemId = json["id"] as? String {
            
            return Object(
                itemId: itemId
            )
        }
        
        return nil
    }
}

