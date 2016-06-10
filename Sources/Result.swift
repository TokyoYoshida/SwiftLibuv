public enum Result<A> {
    case success(value: A)
    case error(error: SwiftLibuvError)
    
    init(value: A){
        self = .success(value: value)
    }

    init(error: SwiftLibuvError){
        self = .error(error: error)
    }
}

