import Foundation
import SwiftParsec

extension GenericParser where StreamType == String, UserState == Void {
    func skipWhitespaces() -> GenericParser {
        return StringParser.spaces *> self <* StringParser.spaces
    }
}

