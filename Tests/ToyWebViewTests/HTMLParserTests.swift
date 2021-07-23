import XCTest
@testable import ToyWebView

final class HTMLParserTests: XCTestCase {
    func testParseAttribute() {
        typealias TestCase = (token: String, expected: Attribute, line: Int)

        let testCases: [TestCase] = [
            (
                token: "test=\"foobar\"",
                expected: .init(key: "test", value: "foobar"),
                line: #line
            ),
            (
                token: "test = \"foobar\"",
                expected: .init(key: "test", value: "foobar"),
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try? HTMLParser.parseAttribute(testCase.token), testCase.expected, String(testCase.line))
        }
    }

    func testParseAttributes() {
        typealias TestCase = (token: String, expected: [Attribute], line: Int)

        let testCases: [TestCase] = [
            (
                token: "test=\"foobar\" abc=\"def\"",
                expected: [
                    .init(key: "test", value: "foobar"),
                    .init(key: "abc", value: "def"),
                ],
                line: #line
            ),
            (
                token: "",
                expected: [],
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try? HTMLParser.parseAttributes(testCase.token), testCase.expected, String(testCase.line))
        }
    }
}
