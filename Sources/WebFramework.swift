#if os(Linux)
    import Glibc
#endif

import Cuv
import HTTPParser

class WebFrameWork {
    let loop =         uv_default_loop()
    let router =       Router()
    let httpServer:    HttpServable
    let errorCallBack: ErrorCallBack
    init(errorCallBack: ErrorCallBack) {
        self.errorCallBack = errorCallBack
        let socket =      TcpSocket()
        let tcpListener = TcpListener(loop: loop, socket: socket)

        httpServer = HttpServer(loop:          loop,
                                  tcpListener:   tcpListener,
                                  errorCallBack: errorCallBack )
    }
    
    func run(){
        do {
            try listen()
            uv_run(loop, UV_RUN_DEFAULT)
        } catch {
            print("error")
        }
    }

    func add(responder: Respondable){
        router.add(responder: responder)
    }

    private func listen() throws {
        try httpServer.serve(){ request in
            let response = self.router.doRouting(byRequest: request)

            return response
        }
    }
}
