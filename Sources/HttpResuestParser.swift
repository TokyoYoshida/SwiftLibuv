import HTTPParser

typealias ParsedCallBack = (request: Request) -> Void

protocol HttpRequestParsable {
    func parse(readData: String ,callBack: ParsedCallBack)
}

class HttpRequestParser : HttpRequestParsable {
    private var readBuffer = ReadBuffer()
    
    init() {
        readBuffer.initialize()
    }
    
    func parse(readData: String ,callBack: ParsedCallBack) {
        readBuffer.append(newData: readData)
        
        let parser = RequestParser()
        if let request = try! parser.parse(readBuffer.toData()) {
            readBuffer.initialize()
            callBack(request: request)
        }
    }

    private class ReadBuffer {
        var readStr = ""

        func initialize(){
            readStr = ""
        }
        
        func append(newData: String){
            readStr += newData
        }
        
        func toData() -> Data {
            return Data(readStr)
        }
    }
}
