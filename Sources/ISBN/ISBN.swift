//
//  ISBN.swift
//  
//
//  Created by Ian Sampson on 2020-05-22.
//

// TODO: Rename to ISBN after removing ISBN.swift.
struct ISBN {
    let countryCode: CountryCode
    let registrationGroup: RegistrationGroup
    let registrant: Registrant
    let publication: Publication
    
    enum Format {
        case isbn10
        case isbn13
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
}

extension ISBN {
    init(_ string: String) throws {
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
    func hyphenated(format: Format) -> String {
        switch format {
        case .isbn13:
            return hyphenatedISBN13
        case .isbn10:
            return hyphenatedISBN10
        }
    }
    
    var hyphenatedISBN10: String {
        let b = String(registrationGroup.value)
        let c = String(registrant.value)
        let d = String(publication.value)
        let e = isbn10checksum.digit.description
        
        return b + "-" + c + "-" + d + "-" + e
    }
    
    var hyphenatedISBN13: String {
        let a = countryCode.string
        let b = String(registrationGroup.value)
        let c = String(registrant.value)
        let d = String(publication.value)
        let e = isbn13Checksum.digit.description
        
        return a + "-" + b + "-" + c + "-" + d + "-" + e
    }
}
