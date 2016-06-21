public enum Result<A> {
    case success(value: A)
    case error(error: ErrorProtocol)
    
    init(value: A){
        self = .success(value: value)
    }

    init(error: ErrorProtocol){
        self = .error(error: error)
    }
}

