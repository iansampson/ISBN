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
        
        // TODO: Parse optional hyphen.
        
        let resultB = try Registrant.parse(resultA)
    
        // TODO: Parse optional hyphen.
        
        let resultC = try Publication.parse(resultB)

        return resultC
    }
}

struct RegistrationGroup: Parsable {
    let value: Int
    
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
            input.stream.prefix(7)
                .split { $0.isHyphen }
                .joined())
        else {
            throw ISBN.Error.invalidCharacter
            // TODO: Make error more specific
        }
        
        guard let length = Length
            .countryCodes[countryCode]?
            .length(for: sevenDigitsAfterCountryCode)
        else {
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

struct Registrant: Parsable {
    let value: Int
    
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
        guard let length = Length
            .registrationGroups[prefix]?
            .length(for: input.value.sevenDigitsAfterCountryCode)
        else {
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

struct Publication: Parsable {
    let value: Int
    
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
