import Foundation

struct LayoutBox {
    var boxType: BoxType
    var children: [LayoutBox]

    init(boxType: BoxType, children: [LayoutBox]) {
        self.boxType = boxType
        self.children = children
    }

    init(styledNode: StyledNode) {
        switch styledNode.display {
        case .block:
            boxType = .blockBox(.init(node: styledNode.node, properties: styledNode.properties))
        case .inline:
            boxType = .inlineBox(.init(node: styledNode.node, properties: styledNode.properties))
        case .none:
            fatalError()
        }

        children = styledNode.children.reduce([], { base, child in
            var base = base
            switch child.display {
            case .block:
                base.append(LayoutBox(styledNode: child))
                return base
            case .inline:
                if case .anonymousBox = base.last?.boxType {}
                else {
                    base.append(LayoutBox(boxType: .anonymousBox, children: []))
                }
            case .none:
                fatalError()
            }

            if let last = base.last {
                base.removeLast()
                base.append(LayoutBox(boxType: last.boxType, children: last.children + [LayoutBox(styledNode: child)]))
            }

            return base
        })

        children = styledNode.children.map { child in
            switch child.display {
            case .block:
                return LayoutBox(styledNode: child)
            case .inline:
                return LayoutBox(styledNode: child)
            case .none:
                fatalError()
            }
        }
    }
}

enum BoxType {
    case blockBox(BoxProps)
    case inlineBox(BoxProps)
    case anonymousBox
}

struct BoxProps {
    var node: Node
    var properties: [String: CSSValue]
}
