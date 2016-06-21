## SwiftLibuv

Swiftlibuv is the library for calling Libuv from Swift language, you can call the TCP network functions of Libuv. It also provides a simple framework of Web applications that use these libraries.

## Build exsample application

There is a sample of the echo server and Web server.

To build, run the following command.
```
swift build -Xlinker -L/usr/local/lib
```
(Usually, -Xlinker option, but is not required, if the version of the Swift is "DEVELOPMENT-SNAPSHOT-2016-04-25-a", you get a link error and not with this option.)

## Execution exsample application

### Web Server
```
.build/debug/SwiftLibuvExamples web
```
And access from your browser to http://localhost:4000/


### echo Server
```
.build/debug/SwiftLibuvExamples echo
```

## Using Web Framework

For example.
```
class MyResponder : Responder {
    override func respond() {
        get(uri: URI(byPath:"/index")) {request in
            return Response(body: Data("this is test"))
        }
    }
}

func WebServerStart(){
    let framework = WebFrameWork() { error in
        return Response(body: Data("error page."))
    }
    framework.add(responder: MyResponder())
    framework.run()
}
```

## contribution

Contribution is welcome!

If there is contact, please write to the Issues. Or, please mail.
yoshidaforpublic@gmail.com

## License

 MIT
