import XCTest

@testable import SwiftUvTestSuite

XCTMain([
    testCase(RouterTests.allTests),
    testCase(HttpServerTests.allTests)
])