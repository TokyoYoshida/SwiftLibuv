import Cuv

public protocol TcpListenable {
    func listen(backLog:Int32, callBack: TcpListenCallBack) throws
    var stream_addr: UVStream { get }
}

public typealias TcpListenCallBack = (result: Result<TcpListenable>) -> Void

public class TcpListener : TcpListenable{
    static let  DEFAULT_BACKLOG: Int32 = 128
    private var handle = uv_tcp_t()
    
    public var stream_addr: UVStream {
        return withUnsafePointer(&handle) {
            UnsafeMutablePointer($0)
        }
    }
    
    init<T:TcpBindable where T.HandleType == UnsafeMutablePointer<uv_tcp_t>>(loop: UVLoop ,socket: T){
        uv_tcp_init(loop, &handle)
        socket.bind(handle: &handle)
    }
}

extension TcpListener {
    public func listen(backLog: Int32 = DEFAULT_BACKLOG, callBack: TcpListenCallBack ) throws {
        let calBackBag = unsafeBitCast(stream_addr, to: UnsafeMutablePointer<uv_stream_t>.self)
        calBackBag.pointee.data = retainedVoidPointer{[unowned self] (status:UVStatus) -> Void in
            callBack(result: self.makeResult(status: status))
        }

        let ret = uv_listen(calBackBag, backLog){
            stream ,status in
            let callback = unsafeFromVoidPointer(x:stream.pointee.data) as ((UVStatus) -> Void)!
            defer {
                releaseRetainedPointer(x: callback)
            }
            callback(status)
        }

        if ret != UVResult.success {
            throw SwiftLibuvError.libuvError(errorNo: ret)
        }
    }
    
    private func makeResult(status:UVStatus) -> Result<TcpListenable> {
        guard status == 0 else {
            let error = SwiftLibuvError.libuvError(errorNo: status)
            return Result(error: error)
        }
        return Result(value: self)
    }
}
