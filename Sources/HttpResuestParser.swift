import HTTPParser

typealias ParsedCallBack = (request: Request) -> Void

protocol HttpRequestParsable {
    func parse(readData: UVData ,callBack: ParsedCallBack)
}

class HttpRequestParser : HttpRequestParsable {
    private var readBuffer = ReadBuffer()
    
    init() {
        readBuffer.initialize()
    }
    
    func parse(readData: UVData ,callBack: ParsedCallBack) {
        readBuffer.append(newData: readData)
        
        let parser = RequestParser()
        if let request = try! parser.parse(readBuffer.toData()) {
            readBuffer.initialize()
            callBack(request: request)
        }
    }

    private class ReadBuffer {
        var bufferData = Data()

        var data:Data {
            get {
                return bufferData
            }
        }
        
        func initialize(){
            bufferData = Data()
        }
        
        func append(newData: UVData){
            bufferData.append(buffer: newData.data)
        }
        
        func toData() -> Data {
            return bufferData
        }
    }
}
