import Foundation
import SwiftParsec

public struct HTMLParser {
    public struct ParseError: Error, CustomStringConvertible {
        public var description: String
        init(description: String) {
            self.description = description
        }
    }

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

    private static var closeTagParser: GenericParser<String, (), String> {
        let closeTagName = StringParser.letter.many1.stringValue
        let closeTagContent = GenericParser.lift2({
            $1
        },
            parser1: StringParser.character("/"),
            parser2: closeTagName
        )
        .between(
            StringParser.character("<"),
            StringParser.character(">")
        )

        return closeTagContent
    }

    private static var textParser: GenericParser<String, (), Node> {
        return StringParser.satisfy { c in c != "<"}.many1.stringValue.map { text in Text(text) }
    }

    private static var elementParser: GenericParser<String, (), Node> {
       return GenericParser<String, (), Node>.recursive { node in
            return GenericParser.lift3({ openTag, children, closeTag -> Result<Node, ParseError> in
                if openTag.tag == closeTag {
                    return .success(Element(tagName: openTag.tag, attributes: openTag.attributes, children: children))
                } else {
                    return .failure(ParseError(description: "tag name of open tag and close tag mismatched"))
                }
            },
                parser1: openTagParser,
                parser2: GenericParser.choice([textParser.attempt, node.attempt]).many.attempt,
                parser3: closeTagParser
            ).flatMap { result -> GenericParser<String, (), Node> in
                switch result {
                case let .success(node):
                    return .init(result: node)
                case let .failure(error):
                    return .fail(error.description)
                }
            }
        }
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

    public static func parseCloseTag(_ input: String) throws -> String {
        return try closeTagParser.run(sourceName: "", input: input)
    }

    public static func parseElement(_ input: String) throws -> Node {
        return try elementParser.run(sourceName: "", input: input)
    }
}
