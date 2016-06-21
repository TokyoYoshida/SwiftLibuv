import C7

extension Data {
    init(lenBytes:Int, buffer: UVBuffer){
        let array = [Byte]()
        self.init(array)
        append(lenBytes: lenBytes, buffer: buffer)
    }
    
    mutating func append(lenBytes:Int, buffer: UVBuffer){
        var i = 0
        while i < lenBytes {
            self.bytes.append( UnsafeMutablePointer<UInt8>(buffer.pointee.base).advanced(by:i).pointee )
            i += 1
        }
    }

    mutating func append(buffer: Data){
        self.bytes += buffer.bytes
    }
}
