import Foundation

public struct Text: Node {
    public var children: [Node]

    public var data: String

    public init(_ data: String) {
        self.data = data
        self.children = []
    }
}
