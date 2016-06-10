import HTTPParser

protocol Routable {
        func doRouting(byRequest: Request) -> Response?
}

class Router : Routable {
    private var routes = [UriMatchingKeyType:Respondable]()

    func doRouting(byRequest request: Request) -> Response?{
        return doRouting(byUri: request.uri, request:request)
    }

    func doRouting(byUri uri: URI, request:Request)-> Response?{
        print("matching \(uri) , \(uri.matchingKey) , \(routes)")
        return routes[uri.matchingKey]?.execute(uri: uri, request: request)
    }

    func isMatch(uri: URI) -> Bool{
        return routes[uri.matchingKey] != nil
    }

    func add(responder: Respondable){
        responder.actioners.keys.forEach {
            routes[$0.matchingKey] = responder
        }
    }
}
