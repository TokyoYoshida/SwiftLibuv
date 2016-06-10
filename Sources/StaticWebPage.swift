import Foundation
import C7
import S4

class StaticWebPage : Responder {
    let uri:URI
    let filePath:String
    
    init(uri:URI, filePath: String){
        self.uri = uri
        self.filePath = filePath
        super.init()
    }

    override func respond() {
        get(uri: uri){request in
            print("static page ok")
            if let str = self.fileRead(filePath: self.filePath){
                print(str)
                return Response(body: Data(str))
            }
            return nil
        }
    }

    func fileRead(filePath: String) -> String? {
        do {
            let text = try NSString( contentsOfFile: filePath, encoding: NSUTF8StringEncoding )
            return text as String
        } catch {
            print("error")
        }
        return nil
    }
}
