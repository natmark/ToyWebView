import Foundation

public struct Stylesheet: Equatable {
    public var rules: [Rule]
}

public struct Rule: Equatable {
    public var selectors: [Selector]
    public var declarations: [Declaration]
}

public typealias Selector = SimpleSelector

public enum SimpleSelector: Equatable {
    case universalSelector
    case typeSelector(tagName: String)
    case attributeSelector(tagName: String, operator: AttributeSelectorOperator, attribute: String, value: String)
    case classSelector(className: String)
}

public enum AttributeSelectorOperator {
    case equal
    case contain
}

public struct Declaration: Equatable {
    public var name: String
    public var value: CSSValue
}

public enum CSSValue: Equatable {
    case keyword(String)
}
