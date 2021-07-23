import Foundation
import SwiftParsec

public struct HTMLParser {
    private static var attributeParser: GenericParser<String, (), Attribute> {
        let attributeName = StringParser.letter.many1.stringValue
        let attributeInnerValue = StringParser.satisfy { c in c != "\""}.many1
        let attributeValue = attributeInnerValue.between(
            StringParser.character("\""),
            StringParser.character("\"")
        ).stringValue  // 引用符の間の、引用符を含まない文字を読む

        let attributeParser = GenericParser.lift5({
            Attribute(key: $0, value: $4)
        },
            parser1: attributeName, // 属性名
            parser2: (StringParser.space <|> StringParser.newLine).many, // 空白と改行を読み飛ばす
            parser3: StringParser.character("="), // = を読む
            parser4: (StringParser.space <|> StringParser.newLine).many, // 空白と改行を読み飛ばす
            parser5: attributeValue // 属性値
        )

        return attributeParser
    }

    private static var attributesParser: GenericParser<String, (), [Attribute]> {
        return attributeParser
            .separatedBy((StringParser.space <|> StringParser.newLine).many)
    }

    private static var openTagParser: GenericParser<String, (), (tag: String, attributes: [Attribute])> {
        let openTagName = StringParser.letter.many1.stringValue

        let openTagContent = GenericParser.lift3({
            (tag: $0, attributes: $2)
        },
            parser1: openTagName,
            parser2: (StringParser.space <|> StringParser.newLine).many, // 空白と改行を読み飛ばす
            parser3: attributesParser
        )
        .between(
            StringParser.character("<"),
            StringParser.character(">")
        )

        return openTagContent
    }

    public static func parseAttribute(_ input: String) throws -> Attribute {
        return try attributeParser.run(sourceName: "", input: input)
    }

    public static func parseAttributes(_ input: String) throws -> [Attribute] {
        return try attributesParser.run(sourceName: "", input: input)
    }

    public static func parseOpenTag(_ input: String) throws -> (tag: String, attributes: [Attribute]) {
        return try openTagParser.run(sourceName: "", input: input)
    }
}
