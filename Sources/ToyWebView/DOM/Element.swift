import Foundation

public struct Element: Node {
    public var children: [Node]

    public var tagName: String
    public var attributes: [String: String]

    public init(tagName: String, attributes: [String: String], children: [Node]) {
        self.tagName = tagName
        self.attributes = attributes
        self.children = children
    }
}
