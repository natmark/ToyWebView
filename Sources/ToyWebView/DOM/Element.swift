import Foundation

public struct Element: Node {
    public var children: [Node]

    public var tagName: String
    public var attributes: [Attribute]

    public init(tagName: String, attributes: [Attribute], children: [Node]) {
        self.tagName = tagName
        self.attributes = attributes
        self.children = children
    }
}

extension Element: Equatable {
    public static func == (lhs: Element, rhs: Element) -> Bool {
        let isChildrenEqual = zip(lhs.children, rhs.children).allSatisfy { lhsChild, rhsChild in
            if let lhsChild = lhsChild as? Element, let rhsChild = rhsChild as? Element {
                return lhsChild == rhsChild
            } else if let lhsChild = lhsChild as? Text, let rhsChild = rhsChild as? Text {
                return lhsChild == rhsChild
            } else {
                return false
            }
        }

        return isChildrenEqual &&
            lhs.tagName == rhs.tagName &&
            lhs.attributes == rhs.attributes
    }
}
