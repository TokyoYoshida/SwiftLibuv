import C7

class TcpStream : Stream {
    let client:TcpClient

    init(client: TcpClient) {
         self.client = client
    }
    var closed: Bool { get {return false} }

    func send(_ data: Data, timingOut deadline: Double) throws {
        client.write(data: data){ // Todo
        }
    }
    
    func receive(upTo byteCount: Int, timingOut deadline: Double) throws -> Data {return Data()} // Todo
    
    func flush(timingOut deadline: Double) throws {} // Todo

    func close() throws {
        client.close()
    }
}
