import XCTest
@testable import ToyWebView

final class CSSParserTests: XCTestCase {
    func testDeclarations() throws {
        XCTAssertEqual(
            try CSSParser.parseDeclarations("foo: bar; piyo: piyopiyo;"),
            [
                .init(name: "foo", value: .keyword("bar")),
                .init(name: "piyo", value: .keyword("piyopiyo"))
            ]
        )
    }
}
