import XCTest
@testable import ToyWebView

final class SelectorTests: XCTestCase {
    func testUniversalSelectorMatches() {
        let element = Element(
            tagName: "p",
            attributes: [
                .init(key: "id", value: "test"),
                .init(key: "class", value: "testclass")
            ],
            children: []
        )
        XCTAssertTrue(SimpleSelector.universalSelector.matches(node: element))
    }

    func testTypeSelectorMatches() {
        let element = Element(
            tagName: "p",
            attributes: [
                .init(key: "id", value: "test"),
                .init(key: "class", value: "testclass")
            ],
            children: []
        )
        XCTAssertTrue(SimpleSelector.typeSelector(tagName: "p").matches(node: element))
        XCTAssertFalse(SimpleSelector.typeSelector(tagName: "invalid").matches(node: element))
    }

    func testAttributeSelectorMatches() {
        let element = Element(
            tagName: "p",
            attributes: [
                .init(key: "id", value: "test"),
                .init(key: "class", value: "testclass")
            ],
            children: []
        )
        XCTAssertTrue(SimpleSelector.attributeSelector(tagName: "p", operator: .equal, attribute: "id", value: "test").matches(node: element))
        XCTAssertFalse(SimpleSelector.attributeSelector(tagName: "p", operator: .equal, attribute: "id", value: "invalid").matches(node: element))
        XCTAssertFalse(SimpleSelector.attributeSelector(tagName: "p", operator: .equal, attribute: "invalid", value: "test").matches(node: element))
        XCTAssertFalse(SimpleSelector.attributeSelector(tagName: "invalid", operator: .equal, attribute: "id", value: "test").matches(node: element))
    }

    func testClassSelectorMatches() {
        let element = Element(
            tagName: "p",
            attributes: [
                .init(key: "id", value: "test"),
                .init(key: "class", value: "testclass")
            ],
            children: []
        )
        XCTAssertTrue(SimpleSelector.classSelector(className: "testclass").matches(node: element))
        XCTAssertFalse(SimpleSelector.classSelector(className: "invalid").matches(node: element))
    }
}
