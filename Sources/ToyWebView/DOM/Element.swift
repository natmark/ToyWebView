import Foundation

public struct Element: Node {
    public var tagName: String
    public var attributes: [Attribute]
    public var children: [Node]
}

extension Element: Equatable {
    public static func == (lhs: Element, rhs: Element) -> Bool {
        let isChildrenEqual = zip(lhs.children, rhs.children).allSatisfy { $0.0 == $0.1 }

        return isChildrenEqual &&
            lhs.tagName == rhs.tagName &&
            lhs.attributes == rhs.attributes
    }
}
