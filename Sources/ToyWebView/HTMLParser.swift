import Foundation
import SwiftParsec

public struct HTMLParser {
    private static var attributeParser: GenericParser<String, (), Attribute> {
        let attributeName = StringParser.letter.many1
        let attributeInnerValue = StringParser.satisfy { c in c != "\""}.many1
        let attributeValue = attributeInnerValue.between(
            StringParser.character("\""),
            StringParser.character("\"")
        )  // 引用符の間の、引用符を含まない文字を読む

        let attributeParser = GenericParser.lift5({
            Attribute(key: $0, value: $4)
        },
            parser1: attributeName.stringValue, // 属性名
            parser2: (StringParser.space <|> StringParser.newLine).many, // 空白と改行を読み飛ばす
            parser3: StringParser.character("="), // = を読む
            parser4: (StringParser.space <|> StringParser.newLine).many, // 空白と改行を読み飛ばす
            parser5: attributeValue.stringValue // 属性値
        )

        return attributeParser
    }

    public static func parseAttribute(_ input: String) throws -> Attribute {
        return try attributeParser.run(sourceName: "", input: input)
    }

    public static func parseAttributes(_ input: String) throws -> [Attribute] {
        return try attributeParser
            .separatedBy((StringParser.space <|> StringParser.newLine).many)
            .run(sourceName: "", input: input)
    }
}
