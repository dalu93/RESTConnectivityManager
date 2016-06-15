# RESTConnectivityManager

**RESTConnectivityManager** is a powerful and simple library that can be used for API communication. It uses Alamofire 3.x and allows you to create a resource request with few lines of code

    // First you need to declare the base URL
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

Where **Object** is a **JSONDecodable** conforming structure:

    struct Object : JSONDecodable {
        typealias Element = Object

        let itemId : String

        static func fromDictionary(json: [String : AnyObject]) -> Element? {

            if let itemId = json["id"] as? String {

                return Object(
                    itemId: itemId
                )
            }

            return nil
        }
    }

It expects a `ResponseError` conforming object as generic parameter too. In our simple case, `Error` is:

    protocol ResponseError : JSONDecodable, NSErrorConvertible {}

    class Error : ResponseError {

        typealias Element = Error
        static func fromDictionary(json: [String : AnyObject]) -> Element? {

            return Error()
        }

        func toNSError() -> NSError {

            return NSError(
                domain: "Error",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey : "This is a default error. Please, provide a new ResponseError conforming struct or class"
                ]
            )
        }
    }