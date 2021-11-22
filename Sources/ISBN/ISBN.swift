//
//  ISBN.swift
//  
//
//  Created by Ian Sampson on 2020-05-22.
//

public struct ISBN: Hashable {
    public let countryCode: CountryCode
    public let registrationGroup: RegistrationGroup
    public let registrant: Registrant
    public let publication: Publication
    
    public enum Format {
        case isbn10
        case isbn13
    }
}

extension ISBN {
    public init<S>(_ string: S) throws where S: StringProtocol, S.SubSequence == Substring {
        let input = State(stream: string[...], value: ())
        do {
            self = try ISBN13.parse(input).value
        } catch {
            self = try ISBN10.parse(input).value
        }
        // TODO: Consider what to do with remaining input.
        // TODO: Use specific error.
        // TODO: Clean up nested do-catch pattern.
        
        // TODO: Try parsing country code and *then*
        // choose between ISBN10 or ISBN13.
    }
}

// TODO: Encapsulate boilerplate between ISBN10 and ISBN13 in a common function

struct ISBN10: Parsable {
    typealias Input = ()
    typealias Output = ISBN
    
    static func parse(_ input: State<Input>) throws -> State<Output> {
        // Assume ISBN10 belongs to the bookland country code
        // CountryCode
        let resultA = State(
            stream: input.stream,
            value: CountryCode.bookland
        )
        let resultB = try OptionalHyphen.parse(resultA)
        let resultC = try Registration.parse(resultB)
        let resultD = try OptionalHyphen.parse(resultC)
        let resultE = try Checksum.parse(
            State(
                stream: resultD.stream,
                value: (
                    input.stream
                        .split { $0.isHyphen }
                        .joined()
                        .prefix(9)
                        .map { $0.wholeNumberValue! },
                    .isbn10
                )
            )
        )
        
        guard resultE.stream.isEmpty else {
            throw ISBN.Error.expectedEmptyStringAfterISBN
        }
        
        let isbn = ISBN(
            countryCode: resultA.value,
            registrationGroup: resultC.value.registrationGroup,
            registrant: resultC.value.registrant,
            publication: resultC.value.publication
        )
        
        return State(
            stream: resultE.stream,
            value: isbn
        )
    }
}

struct ISBN13: Parsable {
    typealias Input = ()
    typealias Output = ISBN
    
    static func parse(_ input: State<Input>) throws -> State<Output> {
        let resultA = try CountryCode.parse(input)
        let resultB = try OptionalHyphen.parse(resultA)
        let resultC = try Registration.parse(resultB)
        let resultD = try OptionalHyphen.parse(resultC)
        let resultE = try Checksum.parse(
            State(
                stream: resultD.stream,
                value: (
                    input.stream
                        .split { $0.isHyphen }
                        .joined()
                        .prefix(12)
                        .map { $0.wholeNumberValue! },
                    // TODO: Make this an extension somewhere else.
                    // TODO: Make this more efficient.
                    .isbn13
                )
            )
        )
        
        guard resultE.stream.isEmpty else {
            throw ISBN.Error.expectedEmptyStringAfterISBN
        }
        
        let isbn = ISBN(
            countryCode: resultA.value,
            registrationGroup: resultC.value.registrationGroup,
            registrant: resultC.value.registrant,
            publication: resultC.value.publication
        )
        
        return State(
            stream: resultE.stream,
            value: isbn
        )
    }
}

extension ISBN {
    public var string: String {
        guard let string = string(format: .isbn13, hyphenated: true) else {
            fatalError()
        }
        return string
    }
    
    public func string(format: Format, hyphenated: Bool = true) -> String? {
        switch format {
        case .isbn13:
            if hyphenated {
                return isbn13Components.joined(separator: "-")
            } else {
                return isbn13Components.joined()
            }
        case .isbn10:
            guard let components = isbn10Components else {
                return nil
            }
            
            if hyphenated {
                return components.joined(separator: "-")
            } else {
                return components.joined()
            }
        }
    }
    
    var isbn13Checksum: Checksum {
        let digits = countryCode.rawValue.integers
            + registrationGroup.value.integers
            + registrant.value.integers
            + publication.value.integers
        return try! Checksum(digits, format: .isbn13)
        // TODO: Unwrap more safely.
    }
    
    var isbn10checksum: Checksum {
        let digits = registrationGroup.value.integers
            + registrant.value.integers
            + publication.value.integers
        return try! Checksum(digits, format: .isbn10)
        // TODO: Unwrap more safely.
    }
    
    var isbn10Components: [String]? {
        guard countryCode == .bookland else {
            return nil
        }
        
        return [String(registrationGroup.value),
                String(registrant.value),
                String(publication.value),
                isbn10checksum.digit.description]
    }
    
    var isbn13Components: [String] {
        [countryCode.string,
        String(registrationGroup.value),
        String(registrant.value),
        String(publication.value),
        isbn13Checksum.digit.description]
    }
}
