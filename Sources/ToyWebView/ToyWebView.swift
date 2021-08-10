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
            render(layout: layout)
        }
    }

    @ViewBuilder
    func render(layout: LayoutBox) -> some View {
        // SwiftUIで再帰のコードを描けなさそうなので困った
    }
}
//
//enum ElementContainer {
//    case vstack(containers: [ElementContainer])
//    case hstack(containers: [ElementContainer])
//    case text(String)
//
//    init(layoutBox: LayoutBox) {
//        switch layoutBox.boxType {
//        case .blockBox(let props), .inlineBox(let props):
//            if let element = props.node as? Element {
//                self = .vstack(containers: [.text(element.tagName)] + layoutBox.children.map { ElementContainer(layoutBox: $0) })
//            } else if let text = props.node as? Text {
//                let trimmedText = text.data.trimmingCharacters(in: .whitespacesAndNewlines)
//                self = .text(trimmedText)
//            } else {
//                fatalError()
//            }
//        case .anonymousBox:
//            self = .hstack(containers: layoutBox.children.map { ElementContainer(layoutBox: $0) })
//        }
//    }
//}

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
