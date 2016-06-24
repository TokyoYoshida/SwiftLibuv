//Test area. TODO: Delete the bottom line than this later.
//var x = Cookie(name: "test", value: "ok")
//var y = Cookies()
//y["test"] = "ok"


//examples entry point
var args = Process.arguments
args[1..<args.count].forEach {
    switch $0 {
    case "echo":
        exampleOfEchoServer()
    case "web":
        exampleOfWebServer()
    default:
        print("error: Unknown command.\nusage: SwiftUvExamples [echo|web]")
    }
}

