import Foundation

struct ParseError: Error, CustomStringConvertible {
    var description: String
    init(description: String) {
        self.description = description
    }
}
