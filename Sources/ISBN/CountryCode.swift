//
//  CountryCode.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

public enum CountryCode: Int {
    case bookland = 978
    case musicland = 979
}

extension CountryCode {
    init(_ code: Int) throws {
        guard let code = CountryCode(rawValue: code) else {
            throw ISBN.Error.invalidCountryCode
        }
        self = code
    }
}

extension CountryCode {
    var string: String {
        String(rawValue)
    }
}

extension CountryCode: Parsable, Hashable {
    typealias Input = ()
    typealias Output = Self
    
    static func parse(_ input: State<Input>) throws -> State<Output> {
        guard let value = Int(
            String(input.stream.prefix(3))
            // TODO: Consider making Substring conform
            // to binary integer.
            )
        else {
            throw ISBN.Error.invalidCharacter
            // TODO: Make error more specific
        }

        
        let countryCode = try CountryCode(value)
        
        return State(
            stream: input.stream.dropFirst(3),
            value: countryCode
        )
    }
}
