import Foundation
import SwiftUI

public struct ToyWebView: View {
    @ObservedObject var layoutBuilder = LayoutBuilder()

    public var html: String
    public var css: String
    public init(html: String, css: String) {
        self.html = html
        self.css = css
        layoutBuilder.build(html: html, css: css)
    }

    public var body: some View {
        if let layout = layoutBuilder.layout {
            ForEach(Array(render(layout: layout).enumerated()), id: \.offset) { _, anyView in
                AnyView(anyView)
            }
        }
    }

    func render(layout: LayoutBox) -> [AnyView] {
        switch layout.boxType {
        case .blockBox(let props), .inlineBox(let props):
                    if let element = props.node as? Element {
                        return [AnyView(SwiftUI.Text(element.tagName))] + layout.children.map { render(layout: $0) }.flatMap { $0 }
                    } else if let text = props.node as? Text {
                        return [AnyView(SwiftUI.Text(text.data))]
                    } else {
                        fatalError()
                    }
        case .anonymousBox:
            return layout.children.map { render(layout: $0) }.flatMap { $0 }
        }
    }
}

class LayoutBuilder: ObservableObject {
    @Published var layout: LayoutBox? = nil

    func build(html: String, css: String) {
        guard let styleSheet = try? CSSParser.parse(css),
              let node = try? HTMLParser.parseElement(html),
              let styledNode = StyledNode(node: node, stylesheet: styleSheet) else {
            return
        }
        layout = LayoutBox(styledNode: styledNode)
    }
}
