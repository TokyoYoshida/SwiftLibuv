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

