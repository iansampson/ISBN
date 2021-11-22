//
//  Registration.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

struct Registration: Parsable {
    let registrationGroup: RegistrationGroup
    let registrant: Registrant
    let publication: Publication
    
    typealias Input = CountryCode
    
    static func parse(_ input: State<Input>) throws -> State<Self> {
        let resultA = try RegistrationGroup.parse(input)
        let resultB = try OptionalHyphen.parse(resultA)
        let resultC = try Registrant.parse(resultB)
        let resultD = try OptionalHyphen.parse(resultC)
        let resultE = try Publication.parse(resultD)
        return resultE
    }
}

public struct RegistrationGroup: Parsable, Hashable {
    public let value: Int
    
    typealias Input = CountryCode
    typealias Output = (
        countryCode: CountryCode,
        registrationGroup: RegistrationGroup,
        sevenDigitsAfterCountryCode: Int,
        lengthAfterCountryCode: Int
        // TODO: Consider using Digits.SubSequence.Base instead
        // and removing this parameter.
    )
    
    static func parse(_ input: State<Input>) throws -> State<Output> {
        let countryCode = input.value
        // TODO: Calculate this more efficiently.
        guard let sevenDigitsAfterCountryCode = Int(
            input.stream
                .split { $0.isHyphen }
                .joined()
                .prefix(7))
        else {
            throw ISBN.Error.invalidCharacter
            // TODO: Make error more specific
        }
        
        // TODO: Abstract into method on Prefixes
        let length = try RangeMessage.Container().isbnRangeMessage.eanUccPrefixes.eanUcc.first {
            $0.prefix == countryCode.string
        }?.length(for: sevenDigitsAfterCountryCode)
        
        guard let length = length else {
            throw ISBN.Error.invalidRange
        }
        
        guard let value = Int(input.stream.prefix(length)) else {
            throw ISBN.Error.invalidCharacter
            // TODO: Make error more specific
        }
        
        let registrationGroup = RegistrationGroup(value: value)
        return State(
            stream: input.stream.dropFirst(length),
            value: (countryCode, registrationGroup, sevenDigitsAfterCountryCode, length)
        )
    }
}

public struct Registrant: Parsable, Hashable {
    public let value: Int
    
    typealias Input = RegistrationGroup.Output
    
    typealias Output = (
        countryCode: CountryCode,
        registrationGroup: RegistrationGroup,
        registrant: Registrant,
        lengthAfterCountryCode: Int
    )
    
    static func parse(_ input: State<Input>) throws -> State<Output> {
        // TODO: Avoid reallocating String if possible. Perhaps passing Substring
        // through State.
        let prefix = input.value.countryCode.string + "-" + String(input.value.registrationGroup.value)
        
        let length = try RangeMessage.Container()
            .isbnRangeMessage
            .registrationGroups.group.first {
                $0.prefix == prefix
            }?.length(for: input.value.sevenDigitsAfterCountryCode)
        
        guard let length = length else {
            throw ISBN.Error.invalidRange
        }
        let stream = input.stream.dropFirst(length)
        
        guard let value = Int(input.stream.prefix(length)) else {
             throw ISBN.Error.invalidCharacter
             // TODO: Make error more specific
         }
        
        let registrant = Registrant(value: value)
        return State(
            stream: stream,
            value: (
                input.value.countryCode,
                input.value.registrationGroup,
                registrant, input.value.lengthAfterCountryCode + length
            )
        )
    }
}

public struct Publication: Parsable, Hashable {
    public let value: Int
    
    typealias Input = Registrant.Output
    typealias Output = Registration
    
    static func parse(_ input: State<Input>) throws -> State<Output> {
        let length = 9 - input.value.lengthAfterCountryCode
        let substring = input.stream.prefix(length)
        // TODO: Consider the possibility that the prefix is less than the given length.
        // I.e. that the ISBN is truncated.
        
        guard let value = Int(substring) else {
            throw ISBN.Error.invalidCharacter
            // TODO: Make error more specific.
        }
        
        let publication = Publication(value: value)
        let registration = Registration(
            registrationGroup: input.value.registrationGroup,
            registrant: input.value.registrant,
            publication: publication
        )
        return State(
            stream: input.stream.dropFirst(length),
            value: registration
        )
    }
}
