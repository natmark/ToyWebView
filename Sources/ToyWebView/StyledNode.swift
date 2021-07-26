import Foundation

public struct StyledNode {
    public var children: [StyledNode]
    public var properties: [String: CSSValue]
    public var node: Node

    public init(children: [StyledNode], properties: [String: CSSValue], node: Node) {
        self.children = children
        self.properties = properties
        self.node = node
    }

    public init?(node: Node, stylesheet: Stylesheet) {
        var properties: [String: CSSValue] = [:]
        let matchedRules = stylesheet.rules.filter { rule in rule.matches(node: node) }

        for matchedRule in matchedRules {
            for declaration in matchedRule.declarations {
                properties[declaration.name] = declaration.value
            }
        }

        // defaulting は一旦考慮しないことにしていたのでスキップ
        // display: none が指定されているノードはレンダリングツリーに含めない

        if properties["display"] == .keyword("none") {
            return nil
        }

        let children = node.children.map { child in
            StyledNode(node: child, stylesheet: stylesheet)
        }.compactMap { $0 }

        self.properties = properties
        self.children = children
        self.node = node
    }
}

extension StyledNode: Equatable {
    public static func == (lhs: StyledNode, rhs: StyledNode) -> Bool {
        lhs.properties == rhs.properties &&
            lhs.children == rhs.children &&
            lhs.node == rhs.node
    }
}
