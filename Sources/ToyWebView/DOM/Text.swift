import Foundation

public struct Text: Node {
    public var data: String
    public var children: [Node] = []
    public init(_ data: String) {
        self.data = data
    }
}

extension Text: Equatable {
    public static func == (lhs: Text, rhs: Text) -> Bool {
        let isChildrenEqual = zip(lhs.children, rhs.children).allSatisfy { $0.0 == $0.1 }
        return isChildrenEqual && lhs.data == rhs.data
    }
}
