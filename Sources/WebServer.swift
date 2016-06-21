#if os(Linux)
    import Glibc
#endif

import Cuv
import HTTPParser

class MyResponder : Responder {
    override func respond() {
        get(uri: URI(byPath:"/index")) {request in
            return Response(body: Data("this is test"))
        }

        get(uri: URI(byPath:"/cookie")) {request in
            print(request.headers["Cookie"].values)
//            let cookieValue = request.headers["Cookie"].values ?? ""
            var response = Response(body: Data("cookie value"))
            response.headers["Set-Cookie"] = "test=ok"//Header(response.cookies.map { "\($0)=\($1)" }.joined(separator: ";"))
            return response
        }
}
}

func exampleOfWebServer(){
    print("Now web starting.")
    
    let framework = WebFrameWork() { error in
        return Response(body: Data("error page."))
    }
    framework.add(responder: StaticWebPage(uri: URI(byPath:"/"), filePath: "public_html/test.html"))
    framework.add(responder: MyResponder())
    framework.run()
}
