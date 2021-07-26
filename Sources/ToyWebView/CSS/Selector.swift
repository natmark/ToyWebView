import Foundation

public typealias Selector = SimpleSelector

public enum SimpleSelector: Equatable {
    case universalSelector
    case typeSelector(tagName: String)
    case attributeSelector(tagName: String, operator: AttributeSelectorOperator, attribute: String, value: String)
    case classSelector(className: String)

    public func matches(node: Node) -> Bool {
        switch self {
        case .universalSelector:
            return true
        case let .typeSelector(tagName):
            if let node = node as? Element {
                return node.tagName == tagName
            } else {
                return false
            }
        case let .attributeSelector(tagName, op, attribute, value):
            if let node = node as? Element, node.tagName == tagName {
                switch op {
                case .equal:
                    return node.attributes.first(where: { $0.key == attribute })?.value == value
                case .contain:
                    if let targetAttribute = node.attributes.first(where: { $0.key == attribute }) {
                        return targetAttribute.value.split(separator: " ")
                            .map { String($0) }
                            .contains(value)
                    } else {
                        return false
                    }
                }
            } else {
                return false
            }
        case let .classSelector(className):
            if let node = node as? Element {
                return node.attributes.first(where: { $0.key == "class" })?.value == className
            } else {
                return false
            }
        }
    }
}

public enum AttributeSelectorOperator {
    case equal
    case contain
}
