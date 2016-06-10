import C7

typealias UriMatchingKeyType = String

extension URI {
    init(byPath path: String){
        self.init()
        self.path = path
    }

    var matchingKey:UriMatchingKeyType {
        get {
            return path ?? "/"
        }
    }

}
