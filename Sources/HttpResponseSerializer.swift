import HTTPSerializer

typealias SerializedCallBack = (data: Data) -> Void

protocol HTTPResponseSerializable {
    func serialize(response: Response,stream: Stream) throws
}

class HTTPResponseSerializer : HTTPResponseSerializable {
    
    func serialize(response: Response, stream: Stream) throws {
        let serializer = ResponseSerializer()

        try serializer.serialize(response, to: stream)
    }
}
