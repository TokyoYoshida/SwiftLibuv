import HTTPParser

typealias Actioner = (request:Request) -> Response?

protocol Respondable: class  {
    func respond()
    var actioners: [URI:Actioner] { get set }
    var cookies:   Cookies        { get }
}

extension Respondable {
    func get(uri: URI, actioner: Actioner){
        addActioner(uri: uri, actioner: actioner)
    }

    func post(uri: URI, actioner: Actioner){
        addActioner(uri: uri, actioner: actioner)
    }

    func addActioner(uri:URI, actioner: Actioner){
        actioners[uri] = actioner
    }
    
    func execute(uri: URI, request: Request) -> Response?{
        guard let actioner = self.actioners[uri] else {
            return nil
        }

        var response = actioner (request: request)
        response?.setCookies(cookies: cookies)

        return response
    }
}

class Responder : Respondable {
    var actioners = [URI:Actioner]()
    let cookies   = Cookies()

    init (){
        respond()
    }
    
    func respond() {
        assert(false, "This method is expected to be not called.")
    }
}
