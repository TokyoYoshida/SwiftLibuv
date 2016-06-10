// Now don't avairable.

//@testable import SwiftLibuvExamples
//import XCTest
//import HTTPParser
//
//class RightResponder : SwiftLibuvExamples.Responder {
//    override func respond() {
//        get(uri: URI(byPath:"/index")) {request in
//            print("stab")
//            return Response(body: Data("this is test"))
//        }
//    }
//}
//
//class WrongResponder : SwiftLibuvExamples.Responder {
//    override func respond() {
//        get(uri: URI(byPath:"/wrong")) {request in
//            print("stab")
//            return Response(body: Data("this is test"))
//        }
//    }
//}
//
//class RouterTests: XCTestCase {
//    static var allTests: [(String, RouterTests -> () throws -> Void)] {
//        return [
//                   ("testAppend_And_isMatch", testAppend_And_isMatch)
//        ]
//    }
//}
//
//extension RouterTests {
//    func testAppend_And_isMatch() {
//        let rightRoute = RightResponder()
//        let wrongRoute = WrongResponder()
//        let router = Router()
//
//        router.add(responder: rightRoute)
//
//        XCTAssertEqual(router.isMatch(uri: URI(byPath: "/index")), true)
//        XCTAssertEqual(router.isMatch(uri: URI(byPath: "/wrong")), false)
//    }
//
//}
