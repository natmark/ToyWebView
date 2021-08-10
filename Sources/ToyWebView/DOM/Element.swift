import Foundation

struct Element: Node {
    var tagName: String
    var attributes: [Attribute]
    var children: [Node]
}

extension Element: Equatable {
    static func == (lhs: Element, rhs: Element) -> Bool {
        let isChildrenEqual = zip(lhs.children, rhs.children).allSatisfy { $0.0 == $0.1 }

        return isChildrenEqual &&
            lhs.tagName == rhs.tagName &&
            lhs.attributes == rhs.attributes
    }
}
