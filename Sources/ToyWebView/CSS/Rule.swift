import Foundation

struct Rule: Equatable {
    var selectors: [Selector]
    var declarations: [Declaration]

    func matches(node: Node) -> Bool {
        selectors.contains { selector in
            selector.matches(node: node)
        }
    }
}
