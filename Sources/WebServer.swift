#if os(Linux)
    import Glibc
#endif

import Cuv
import HTTPParser

class MyResponder : Responder {
    override func respond() {
        get(uri: URI(byPath:"/index")) {request in
            print("stab")
            return Response(body: Data("this is test"))
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
