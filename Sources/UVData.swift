import Cuv
import C7

public protocol DataType : CustomStringConvertible {
    var data:Data {get}
    var lenBytes:Int {get}
    var description : String {get}
}

public struct UVData : DataType {
    var _data:Data!
    var _lenBytes:Int

    public var data:Data {
        get {
            return _data
        }
    }

    public var lenBytes:Int {
        get{
            return _lenBytes
        }
    }
    
    public var description : String {
        return _data.description
    }

    init(lenBytes:Int ,buffer:UVBuffer){
        self._lenBytes = lenBytes
        self._data = Data(lenBytes:lenBytes, buffer: buffer)
    }
}

