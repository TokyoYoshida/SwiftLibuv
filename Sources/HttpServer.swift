import Cuv
import C7
import HTTPParser

protocol HttpServable {
    func serve(callBack: HttpListenCallBack) throws
}

public enum HttpListenResult {
    case success(response: Response)
    case error(error: SwiftLibuvError)
    
    init(response: Response){
        self = .success(response: response)
    }

    init(error: SwiftLibuvError){
        self = .error(error: error)
    }
}

typealias ErrorCallBack = (error: ErrorProtocol) -> Response?

typealias HttpListenCallBack = (request: Request) -> Response?

class HttpServer : HttpServable {
    private let loop:          UVLoop
    private let tcpListener:   TcpListenable
    private let parser:        HttpRequestParsable
    private let serializer:    HTTPResponseSerializable
    private let errorCallBack: ErrorCallBack

    init(loop:          UVLoop,
         tcpListener:   TcpListenable,
         parser:        HttpRequestParsable = HttpRequestParser(),
         serializer:    HTTPResponseSerializable = HTTPResponseSerializer(),
         errorCallBack: ErrorCallBack) {

        self.loop          = loop
        self.tcpListener   = tcpListener
        self.parser        = parser
        self.serializer    = serializer
        self.errorCallBack = errorCallBack
    }

    func serve(callBack: HttpListenCallBack) throws {
        try tcpListener.listen(backLog:128) {[unowned self] result in
            let processor = HttpProcessor(httpServer: self, callBack: callBack)

            processor.doStartPhase(result: result)
        }
    }
    
    class HttpProcessor {
        let httpServer: HttpServer
        let callBack:   HttpListenCallBack
        let client:     TcpClient
        let stream:     TcpStream

        init(httpServer: HttpServer, callBack: HttpListenCallBack) {
            self.httpServer = httpServer
            self.callBack   = callBack
            self.client     = TcpClient(loop: self.httpServer.loop,
                                        listener: self.httpServer.tcpListener)
            self.stream     = TcpStream(client: client)
        }
        
        deinit {
            print("deinit")
        }
        
        func doStartPhase(result: Result<TcpListenable>){
            self.doListenResultPhase(result: result)
        }
        
        private func doListenResultPhase(result: Result<TcpListenable>){
            switch result {
            case .success(_):
                self.doReadPhase()
            case .error(let error):
                self.errorRespond(error: error)
            }
        }
        
        private func doReadPhase(){
            // uv_read_start keep a TCP session, but control will return soon
            // because of the non-blocking. For this reason,
            // _selfKeeper is private to hold until the session is close.
            var _selfKeeper:HttpProcessor? = self
            do {
                try client.read { [unowned self] result in
                    switch result {
                    case .success(let data):
                        self.doParsePhase(data: data)
                    case let .error(error) where error is Closed:
                        self.client.close()
                        defer {
                            _selfKeeper = nil
                        }
                    case .error(let error):
                        self.errorRespond(error: error)
                    }
                }
            } catch (let error) {
                self.errorRespond(error: error)
            }
        }
        
        private func doParsePhase(data: UVData){
            self.httpServer.parser.parse(readData: data) { [unowned self] request in
                if let response = self.callBack(request: request) {
                    self.serialize(response: response)
                }
            }
        }

        private func errorRespond(error: ErrorProtocol){
            if let response = self.httpServer.errorCallBack(error: error) {
                self.serialize(response: response)
            }
        }

        private func serialize(response: Response){
            do {
                try self.httpServer.serializer.serialize(response: response, stream: self.stream)
            } catch {
                assert(false, "This code path is expected to be not called.")
            }
        }
    }

}
