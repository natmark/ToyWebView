import Foundation

public struct Rule: Equatable {
    public var selectors: [Selector]
    public var declarations: [Declaration]

    public func matches(node: Node) -> Bool {
        selectors.contains { selector in
            selector.matches(node: node)
        }
    }
}
