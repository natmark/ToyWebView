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
