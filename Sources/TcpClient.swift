import Cuv
import Foundation
import C7

public typealias TcpReadCallback = (result: Result<UVData>) throws -> Void
public typealias TcpWriteCallback = () -> Void

protocol TcpClientable {
    func close()
}

protocol TcpReadable : TcpClientable {
    func read(callBack: TcpReadCallback) throws
}
protocol TcpWritable : TcpClientable {
    func write(data:   Data,   callBack: TcpWriteCallback)
    func write(string: String, callBack: TcpWriteCallback)
}

let _alloc_buffer: @convention(c) (UnsafeMutablePointer<uv_handle_t>!, ssize_t, UnsafeMutablePointer<uv_buf_t>!) -> Void = { (handle, requireSize, buf) in
    buf.pointee = uv_buf_init(UnsafeMutablePointer(allocatingCapacity: requireSize), UInt32(requireSize))
}

public class TcpClient : TcpReadable, TcpWritable{
    var listener: TcpListenable
    var handle =  uv_tcp_t()
    
    init(loop: UVLoop, listener: TcpListenable){
        self.listener = listener
        uv_tcp_init(loop, &handle)
    }
}

extension TcpClient {
    internal var stream_addr: UVStream {
        return withUnsafePointer(&handle) {
            UnsafeMutablePointer($0)
        }
    }

    internal var tcp_addr: UnsafeMutablePointer<uv_tcp_t> {
        return withUnsafePointer(&handle) {
            UnsafeMutablePointer($0)
        }
    }

    internal var handle_addr: UnsafeMutablePointer<uv_handle_t> {
        return withUnsafePointer(&handle) {
            UnsafeMutablePointer($0)
        }
    }
}

extension TcpClient {
    public func close(){
        uv_close(handle_addr, nil)
    }

    public func read(callBack: TcpReadCallback) throws {
        let ret = uv_accept(listener.stream_addr, stream_addr)
        if ret != UVResult.success {
            throw SwiftLibuvError.libuvError(errorNo: ret)
        }

        let calBackBag = unsafeBitCast(handle_addr, to: UnsafeMutablePointer<uv_stream_t>.self)
        calBackBag.pointee.data = retainedVoidPointer { [unowned self] (bytesRead:Int ,buffer:UVBuffer)->Void in
            let result = self.makeResult(bytesRead: bytesRead ,buffer: buffer)
            try callBack(result: result)
        }

        uv_read_start(calBackBag, _alloc_buffer){ stream, bytesRead, buffer in
            let callback = unsafeFromVoidPointer(x: stream.pointee.data) as ((Int,UVBuffer) -> Void)!
 
            defer {
                releaseRetainedPointer(x: callback)
                buffer.pointee.base.deallocateCapacity(bytesRead)
            }

            callback(bytesRead, UVBuffer(buffer))
        }
    }

    public func write(data: Data, callBack: TcpWriteCallback = {}){
        self._write(data: UnsafeMutablePointer<Int8>(data.bytes), count: UInt32(data.bytes.count) ,callBack: callBack)
    }

    public func write(string: String, callBack: TcpWriteCallback = {}){
        string.withCString {
            let cString = $0
            self._write(data: UnsafeMutablePointer<Int8>(cString), count: UInt32(strlen(cString)), callBack: callBack)
        }
    }

    private func _write(data: UnsafeMutablePointer<Int8> ,count: UInt32 ,callBack: TcpWriteCallback ){
        let request = UnsafeMutablePointer<uv_write_t>(allocatingCapacity:sizeof(uv_write_t))
        var wbuf    = uv_buf_init( data, count) // TODO: Throw Error if uv_buf_init is failed
        let wptr    = withUnsafePointer(&wbuf){ $0 }

        request.pointee.data = retainedVoidPointer(x:callBack)

        uv_write(request, stream_addr, wptr, 1){ request, _ in
            let callback: () -> Void = unsafeFromVoidPointer(x:request.pointee.data)!
            defer {
                releaseRetainedPointer(x: callback)
            }
            callback()
        }
    }
    
    private func makeResult(bytesRead:Int ,buffer:UVBuffer) -> Result<UVData>{
        guard bytesRead >= 0 else {
            let error = SwiftLibuvError.libuvError(errorNo: Int32(bytesRead))
            return Result(error: error)
        }
        
        let uvData = UVData(lenBytes:bytesRead ,buffer: buffer)
        return Result(value: uvData)
    }

}

