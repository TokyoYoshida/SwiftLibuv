import Cuv

protocol TcpBindable {
    associatedtype HandleType
    func bind(handle: HandleType)
}

public class TcpSocket {
    typealias SockAddr = UnsafePointer<sockaddr>

    static let DEFAULT_HOST = "0.0.0.0"
    static let DEFAULT_PORT = 4000

    private var sock_addr_in = sockaddr_in()
    private let host: String
    private let port: Int
    
    internal var sock_addr: SockAddr {
        return withUnsafePointer(&sock_addr_in) {
            UnsafePointer($0)
        }
    }
    
    init(_ host: String = DEFAULT_HOST, port: Int = DEFAULT_PORT) {
        self.host = host
        self.port = port
 
        if uv_ip4_addr(host, Int32(port), &sock_addr_in) != UVResult.success {
            print("TcpSocket address init failed!")
        }
    }
}
extension TcpSocket: TcpBindable {
    func bind(handle: UnsafeMutablePointer<uv_tcp_t>){
        uv_tcp_bind( handle, self.sock_addr, 0)
    }
}
