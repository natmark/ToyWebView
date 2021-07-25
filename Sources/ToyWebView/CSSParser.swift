import Foundation
import SwiftParsec

public struct CSSParser {
    private static var cssValueParser: GenericParser<String, (), CSSValue> {
        return StringParser.letter.many1.stringValue.map { .keyword($0) }
    }

    private static var declarationsParser: GenericParser<String, (), [Declaration]> {
        return declarationParser.skip(StringParser.spaces)
            .dividedBy(StringParser.character(";").skip(StringParser.spaces))
    }

    private static var declarationParser: GenericParser<String, (), Declaration> {
        return GenericParser.lift3({ keyword, _, value in
            Declaration(name: keyword, value: value)
        },
            parser1: StringParser.letter.many.stringValue.skip(StringParser.spaces),
            parser2: StringParser.character(":").skip(StringParser.spaces),
            parser3: cssValueParser
        )
    }

    private static var attributeParser: GenericParser<String, (), (attribute: String, operator: String, value: String)> {
        StringParser.character("[").skip(StringParser.spaces) *>
            GenericParser.lift3({
                return ($0, $1, $2)
            },
            parser1: StringParser.letter.many1.stringValue,
            parser2: GenericParser.choice([StringParser.string("="), StringParser.string("~=")]).stringValue,
            parser3: StringParser.letter.many1.stringValue
            ) <* StringParser.character("]")
    }

    private static var simpleSelectorParser: GenericParser<String, (), SimpleSelector> {
        let universalSelector = StringParser.character("*")
            .map { _ in SimpleSelector.universalSelector }

        let classSelector = (StringParser.character(".") *> StringParser.letter.many1.stringValue).map { className in
            SimpleSelector.classSelector(className: className)
        }

        let typeOrAttributeSelector = GenericParser.lift2( { tagName, attribute -> Result<SimpleSelector, ParseError> in
            if let attribute = attribute {
                let attributeOperator: AttributeSelectorOperator
                switch attribute.operator {
                case "=":
                    attributeOperator = .equal
                case "~=":
                    attributeOperator = .contain
                default:
                    return .failure(ParseError(description: "invalid attribute selector operator"))
                }
                return .success(
                    SimpleSelector.attributeSelector(
                        tagName: tagName,
                        operator: attributeOperator,
                        attribute: attribute.attribute,
                        value: attribute.value
                    )
                )
            } else {
                return .success(SimpleSelector.typeSelector(tagName: tagName))
            }
        },
            parser1: StringParser.letter.many1.stringValue.skip(StringParser.spaces),
            parser2: attributeParser.optional
        )
            .flatMap { result -> GenericParser<String, (), SimpleSelector> in
                switch result {
                case let .success(selector):
                    return .init(result: selector)
                case let .failure(error):
                    return .fail(error.description)
                }
            }

        return GenericParser.choice([
            universalSelector,
            classSelector,
            typeOrAttributeSelector
        ])
    }

    private static var selectorsParser: GenericParser<String, (), [Selector]> {
        simpleSelectorParser.skip(StringParser.spaces)
            .separatedBy(StringParser.character(",").skip(StringParser.spaces))
    }

    private static var ruleParser: GenericParser<String, (), Rule> {
        GenericParser.lift4({ selectors, _, declarations, _ in
            .init(selectors: selectors, declarations: declarations)
        },
            parser1: selectorsParser.skip(StringParser.spaces),
            parser2: StringParser.character("{").skip(StringParser.spaces),
            parser3: declarationsParser.skip(StringParser.spaces),
            parser4: StringParser.character("}")
        )
    }

    public static func parseDeclarations(_ input: String) throws -> [Declaration] {
        return try declarationsParser.run(sourceName: "", input: input)
    }

    public static func parseSelectors(_ input: String) throws -> [Selector] {
        return try selectorsParser.run(sourceName: "", input: input)
    }

    public static func parseSimpleSelector(_ input: String) throws -> SimpleSelector {
        return try simpleSelectorParser.run(sourceName: "", input: input)
    }

    public static func parseRule(_ input: String) throws -> Rule {
        return try ruleParser.run(sourceName: "", input: input)
    }
}
