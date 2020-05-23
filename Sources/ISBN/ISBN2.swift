//
//  ISBN.swift
//  
//
//  Created by Ian Sampson on 2020-05-22.
//

// TODO: Rename to ISBN after removing ISBN.swift.
struct ISBN2 {
    let countryCode: CountryCode
    let registrationGroup: RegistrationGroup
    let registrant: Registrant
    let publication: Publication
    
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
    
    enum Format {
        case isbn10
        case isbn13
    }
}

extension ISBN2 {
    init?(_ string: String) {
        let input = State(stream: string[...], value: ())
        do {
            self = try ISBN13.parse(input).value
        } catch {
            do {
                self = try ISBN10.parse(input).value
            } catch {
                return nil
            }
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
    typealias Output = ISBN2
    
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
        
        let isbn = ISBN2(
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
    typealias Output = ISBN2
    
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
        
        let isbn = ISBN2(
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

extension ISBN2 {
    var hyphenated: String {
        let a = countryCode.string
        let b = String(registrationGroup.value)
        let c = String(registrant.value)
        let d = String(publication.value)
        let e = isbn13Checksum.digit.description
        
        return a + "-" + b + "-" + c + "-" + d + "-" + e
    }
}
