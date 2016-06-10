public enum SwiftLibuvError: ErrorProtocol {
    case libuvError(errorNo: Int32)
}