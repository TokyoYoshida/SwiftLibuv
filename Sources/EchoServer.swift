
#if os(Linux)
    import Glibc
#endif

import Cuv
import Foundation
import HTTPParser


func exampleOfEchoServer() {
    let socket = TcpSocket()
    let loop = uv_default_loop()

    print("Now echo starting.")
    let listener = TcpListener(loop: loop, socket: socket)
    do {
        try listener.listen { result in
            switch result {
            case .success(let listener):
                let client = TcpClient(loop: loop, listener: listener)
                do {
                    try client.read { result in
                        switch result {
                        case .success(let data):
                            client.write(string: data.description)
                        case .error(let errorNumber):
                            print("error. number = \(errorNumber)")
                        }
                    }
                } catch {
                    print("client error errorno = \(errno)")
                    client.close()
                }
            case .error(_):
                print("error")
            }
        }
        uv_run(loop, UV_RUN_DEFAULT)
    } catch {
        print("unknown error")
    }
}