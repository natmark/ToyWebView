import Foundation

public protocol Node {
    var children: [Node] { get }
    var innerText: String { get }
    var innerHTML: String { get }
    mutating func setInnerHTML(html: String) throws
    var description: String { get }
}

extension Node {
    public var innerText: String {
        children.map { node in
            if let text = node as? Text {
                return text.data
            } else {
                return node.innerText
            }
        }.joined()
    }

    public var innerHTML: String {
        fatalError()
    }

    public mutating func setInnerHTML(html: String) throws {
        fatalError()
    }

    public var description: String {
        fatalError()
    }
}


