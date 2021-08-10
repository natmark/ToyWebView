import Foundation

struct Text: Node {
    var data: String
    var children: [Node] = []
    init(_ data: String) {
        self.data = data
    }
}

extension Text: Equatable {
    static func == (lhs: Text, rhs: Text) -> Bool {
        let isChildrenEqual = zip(lhs.children, rhs.children).allSatisfy { $0.0 == $0.1 }
        return isChildrenEqual && lhs.data == rhs.data
    }
}
