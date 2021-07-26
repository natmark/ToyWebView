import Foundation

public struct StyledNode<T: Node> {
    public var children: [StyledNode<T>]
    public var properties: [String: CSSValue]
}

extension StyledNode: Equatable {}
