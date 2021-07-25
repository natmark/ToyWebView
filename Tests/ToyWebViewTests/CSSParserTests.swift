import XCTest
@testable import ToyWebView

final class CSSParserTests: XCTestCase {
    func testParseDeclarations() throws {
        XCTAssertEqual(
            try CSSParser.parseDeclarations("foo: bar; piyo: piyopiyo;"),
            [
                .init(name: "foo", value: .keyword("bar")),
                .init(name: "piyo", value: .keyword("piyopiyo"))
            ]
        )
    }

    func testParseSelectors() throws {
        XCTAssertEqual(
            try CSSParser.parseSelectors("test [foo=bar], a"),
            [
                .attributeSelector(tagName: "test", operator: .equal, attribute: "foo", value: "bar"),
                .typeSelector(tagName: "a"),
            ]
        )
    }

    func testParseSimpleSelector() throws {
        typealias TestCase = (input: String, expected: SimpleSelector, line: Int)

        let testCases: [TestCase] = [
            (
                input: "*",
                expected: .universalSelector,
                line: #line
            ),
            (
                input: "test",
                expected: .typeSelector(tagName: "test"),
                line: #line
            ),
            (
                input: "test [foo=bar]",
                expected: .attributeSelector(tagName: "test", operator: .equal, attribute: "foo", value: "bar"),
                line: #line
            ),
            (
                input: ".test",
                expected: .classSelector(className: "test"),
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try CSSParser.parseSimpleSelector(testCase.input), testCase.expected, String(testCase.line))
        }
    }

    func testParseRule() throws {
        typealias TestCase = (input: String, expected: Rule, line: Int)

        let testCases: [TestCase] = [
            (
                input: "test [foo=bar] {}",
                expected: .init(
                    selectors: [
                        .attributeSelector(tagName: "test", operator: .equal, attribute: "foo", value: "bar"),
                    ],
                    declarations: []
                ),
                line: #line
            ),
            (
                input: "test [foo=bar], testtest[piyo~=guoo] {}",
                expected: .init(
                    selectors: [
                        .attributeSelector(tagName: "test", operator: .equal, attribute: "foo", value: "bar"),
                        .attributeSelector(tagName: "testtest", operator: .contain, attribute: "piyo", value: "guoo"),
                    ],
                    declarations: []
                ),
                line: #line
            ),
            (
                input: "test [foo=bar] { aa: bb; cc: dd; }",
                expected: .init(
                    selectors: [
                        .attributeSelector(tagName: "test", operator: .equal, attribute: "foo", value: "bar"),
                    ],
                    declarations: [
                        .init(name: "aa", value: .keyword("bb")),
                        .init(name: "cc", value: .keyword("dd")),
                    ]
                ),
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(try CSSParser.parseRule(testCase.input), testCase.expected, String(testCase.line))
        }
    }
}
