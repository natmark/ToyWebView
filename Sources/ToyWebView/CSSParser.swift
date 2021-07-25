import Foundation
import SwiftParsec

public struct CSSParser {
    private static var cssValueParser: GenericParser<String, (), CSSValue> {
        return StringParser.letter.many1.map {
            .keyword(String($0))
        }
    }

    private static var declarationsParser: GenericParser<String, (), [Declaration]> {
        return declarationParser.skipWhitespaces()
            .dividedBy(StringParser.character(";").skipWhitespaces())
    }

    private static var declarationParser: GenericParser<String, (), Declaration> {
        return GenericParser.lift3({ keyword, _, value in
            Declaration(name: String(keyword), value: value)
        },
            parser1: StringParser.letter.many.skipWhitespaces(),
            parser2: StringParser.character(":").skipWhitespaces(),
            parser3: cssValueParser
        )
    }

    public static func parseDeclarations(_ input: String) throws -> [Declaration] {
        return try declarationsParser.run(sourceName: "", input: input)
    }
}
