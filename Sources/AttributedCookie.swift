import HTTP

extension AttributedCookie: StringLiteralConvertible {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: "_dummy", value: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: "_dummy", value: value)
    }
    
    public init(unicodeScalarLiteral value:String) {
        self.init(name: "_dummy", value: value)
    }
}
