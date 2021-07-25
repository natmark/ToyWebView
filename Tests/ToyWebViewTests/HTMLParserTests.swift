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

    func testParseElement() throws {
        try XCTContext.runActivity(named: "No content tag") { _ in
            XCTAssertEqual(
                try HTMLParser.parseElement("<p></p>") as! Element,
                Element(tagName: "p", attributes: [], children: [])
            )
        }

        try XCTContext.runActivity(named: "Tag with content") { _ in
            XCTAssertEqual(
                try HTMLParser.parseElement("<p>Hello World</p>") as! Element,
                Element(tagName: "p", attributes: [], children: [Text("Hello World")])
            )
        }

        try XCTContext.runActivity(named: "Nested tag with content") { _ in
            XCTAssertEqual(
                try HTMLParser.parseElement("<div><p>Hello World</p></div>") as! Element,
                Element(tagName: "div", attributes: [], children: [Element(tagName: "p", attributes: [], children: [Text("Hello World")])])
            )
        }

        try XCTContext.runActivity(named: "Catch parse error") { _ in
            XCTAssertThrowsError(
                try HTMLParser.parseElement("<p>Hello World</div>")
            )
        }
    }

    func testParseText() throws {
        typealias TestCase = (input: String, expected: Text, line: Int)

        let testCases: [TestCase] = [
            (
                input: "Hello World",
                expected: .init("Hello World"),
                line: #line
            ),
            (
                input: "Hello World<",
                expected: .init("Hello World"),
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try HTMLParser.parseText(testCase.input), testCase.expected, String(testCase.line))
        }
    }
}
