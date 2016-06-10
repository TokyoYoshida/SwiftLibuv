import Cuv
import Foundation
import C7

public protocol DataType : CustomStringConvertible{
    var data:Data {get}
    var lenBytes:Int {get}
    var description : String {get}
}

public struct UVData : DataType {
    var _data:Data!
    var _lenBytes:Int

    public var data:Data { get {return _data} }
    public var lenBytes:Int { get {return _lenBytes} }
    
    init(lenBytes:Int ,buffer:UVBuffer){
        self._lenBytes = lenBytes
        self._data = Data()
        var array = [Byte]()
        var i = 0
        while i < lenBytes {
            array.append( UnsafeMutablePointer<UInt8>(buffer.pointee.base).advanced(by:i).pointee )
            i += 1
        }
        _data.bytes = array
    }
    
    public var description : String {
        return NSString(bytes: data.bytes, length:lenBytes ,encoding: NSUTF8StringEncoding) as! String
    }
}


