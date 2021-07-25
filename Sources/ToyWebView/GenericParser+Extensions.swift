import Foundation
import SwiftParsec

extension GenericParser where StreamType == String, UserState == Void {
    func skip(_ skipParser: GenericParser<String, Void, Void>) -> GenericParser {
        return skipParser *> self <* skipParser
    }
}
