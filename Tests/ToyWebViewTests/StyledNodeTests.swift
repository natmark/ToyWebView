import XCTest
@testable import ToyWebView

final class StyledNodeTests: XCTestCase {
    func testInit() {
        let element = Element(tagName: "p", attributes: [], children: [])
        let styledElement = StyledNode(node: element, stylesheet: .init(rules: [
            .init(selectors: [.universalSelector], declarations: [
                .init(name: "display", value: .keyword("block"))
            ])
        ]))

        XCTAssertEqual(
            styledElement,
            StyledNode(children: [], properties: [
                "display": .keyword("block"),
            ], node: element)
        )
    }
}
