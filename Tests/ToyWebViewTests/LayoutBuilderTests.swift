import XCTest
@testable import ToyWebView

final class LayoutBuilderTests: XCTestCase {
    func testBuild() {
        let html = """
            <body>
                <p>hello</p>
                <p class="inline">world</p>
                <p class="inline">:)</p>
                <div class="none"><p>this should not be shown</p></div>
                <style>
                    .none {
                        display: none;
                    }
                    .inline {
                        display: inline;
                    }
                </style>
            </body>
            """
        let css = """
            script, style {
                display: none;
            }
            p, div {
                display: block;
            }
            """
        let layoutBuilder = LayoutBuilder()
        layoutBuilder.build(html: html, css: css)
        XCTAssertNotNil(layoutBuilder.layout)
    }
}
