import XCTest
@testable import ToyWebView

final class HTMLParserTests: XCTestCase {
    func testParseAttribute() throws {
        typealias TestCase = (input: String, expected: Attribute, line: Int)

        let testCases: [TestCase] = [
            (
                input: "test=\"foobar\"",
                expected: .init(key: "test", value: "foobar"),
                line: #line
            ),
            (
                input: "test = \"foobar\"",
                expected: .init(key: "test", value: "foobar"),
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try HTMLParser.parseAttribute(testCase.input), testCase.expected, String(testCase.line))
        }
    }

    func testParseAttributes() throws {
        typealias TestCase = (input: String, expected: [Attribute], line: Int)

        let testCases: [TestCase] = [
            (
                input: "test=\"foobar\" abc=\"def\"",
                expected: [
                    .init(key: "test", value: "foobar"),
                    .init(key: "abc", value: "def"),
                ],
                line: #line
            ),
            (
                input: "",
                expected: [],
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try HTMLParser.parseAttributes(testCase.input), testCase.expected, String(testCase.line))
        }
    }

    func testParseOpenTag() throws {
        try XCTContext.runActivity(named: "No attributes") { _ in
            let openTag = try HTMLParser.parseOpenTag("<p>aaaa")
            XCTAssertEqual(openTag.tag, "p")
            XCTAssertEqual(openTag.attributes, [])
        }

        try XCTContext.runActivity(named: "Has an attribute") { _ in
            let openTag = try HTMLParser.parseOpenTag("<p id=\"test\">")
            XCTAssertEqual(openTag.tag, "p")
            XCTAssertEqual(openTag.attributes, [.init(key: "id", value: "test")])
        }

        try XCTContext.runActivity(named: "Has attributes") { _ in
            let openTag = try HTMLParser.parseOpenTag("<p id=\"test\" class=\"sample\">")
            XCTAssertEqual(openTag.tag, "p")
            XCTAssertEqual(openTag.attributes, [.init(key: "id", value: "test"), .init(key: "class", value: "sample")])
        }

        try XCTContext.runActivity(named: "Catch parse error") { _ in
            XCTAssertThrowsError(try HTMLParser.parseOpenTag("<p id>"))
        }
    }

    func testParseCloseTag() throws {
        XCTAssertEqual(try HTMLParser.parseCloseTag("</p>"), "p")
    }
}
