import Foundation

public struct Text: Node {
    public var children: [Node]

    public var data: String

    public init(_ data: String) {
        self.data = data
        self.children = []
    }
}

extension Text: Equatable {
    public static func == (lhs: Text, rhs: Text) -> Bool {
        let isChildrenEqual = zip(lhs.children, rhs.children).allSatisfy { lhsChild, rhsChild in
            if let lhsChild = lhsChild as? Element, let rhsChild = rhsChild as? Element {
                return lhsChild == rhsChild
            } else if let lhsChild = lhsChild as? Text, let rhsChild = rhsChild as? Text {
                return lhsChild == rhsChild
            } else {
                return false
            }
        }
        return isChildrenEqual && lhs.data == rhs.data
    }
}
