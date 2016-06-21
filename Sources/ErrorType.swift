public enum SwiftLibuvError: ErrorProtocol {
    case libuvError(errorNo: Int32)
}

public struct Closed: ErrorProtocol {
}
