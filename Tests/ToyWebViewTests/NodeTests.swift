import XCTest
@testable import ToyWebView

final class NodeTests: XCTestCase {
    func testInnerText() {
        typealias TestCase = (node: Node, expected: String, line: Int)

        let testCases: [TestCase] = [
            (
                node: Element(tagName: "p", attributes: [:], children: [Text("Hello World")]),
                expected: "Hello World",
                line: #line
            ),
            (
                node:
                Element(tagName: "div", attributes: [:], children: [
                    Text("Hello World"),
                    Element(tagName: "p", attributes: [:], children: [
                        Text("1")
                    ]),
                    Element(tagName: "p", attributes: [:], children: []),
                    Element(tagName: "p", attributes: [:], children: [
                        Text("3")
                    ]),
                ]),
                expected: "Hello World13",
                line: #line
            ),
        ]

        for testCase in testCases {
            XCTAssertEqual(testCase.node.innerText, testCase.expected, String(testCase.line))
        }
    }
}
