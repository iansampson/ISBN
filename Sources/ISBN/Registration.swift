//
//  Registration.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

/*struct ParsableISBN {
    let countryCode: CountryCode?
    let registrationGroup: Int?
    let registrant: Int?
    let publication: Int?
    let checksum: Checksum?
    let remainingCharacters: Digits
    // TODO: Use Subsequence inside/as Digits.
}*/

/*struct ISBNParser {
    func parse(_ isbn: ParsableISBN) throws -> ParsableISBN {
        
    }
}*/

struct Parser<Result, PreviousResult> {
    let parse: (PreviousResult, Digits) -> (Result, Digits)
}

struct RegistrationGroup {
    static func parse(countryCode: CountryCode, digits: Digits) ->
        ((RegistrationGroup, CountryCode), Digits) {
            
    }
}



// Digits throws -> (CountryCode, Digits)
// (CountryCode, Digits) -> (CountryCode, RegistrationGroup, Digits)
// (CountryCode, RegistrationGroup, Digits)  -> ISBN

// Curry?



/*struct Registration {
    let registrationGroup: Int
    let registrant: Int
    let publication: Int
    
    init(countryCode: CountryCode, firstSevenDigits: Int) throws {
        registrationGroup = try RegistrationGroup(
            countryCode: countryCode,
            firstSevenDigits: firstSevenDigits
        )
        
    }
}

struct RegistrationGroup {
    let length: Int
    
    // TODO: Consider making these inits functions
    // (and getting rid of these structs).
    init(countryCode: CountryCode, firstSevenDigits: Int) throws {
        // TODO: Consider passing LengthMap in as a parameter.
        guard let length = Length
            .countryCodes[countryCode]?
            .length(for: firstSevenDigits)
        else {
            throw ISBN.Error.invalidRange
            // TODO: Make this error more specific.
        }
        self.length = length
    }
}

struct Registrant {
    let length: Int
    init(countryCode: CountryCode, registrationGroup: RegistrationGroup, firstSevenDigits: Int) throws {
        let prefix = countryCode.string + "-" + registrationGroup.string
        guard let length = Length
            .registrationGroups[prefix]?
            .length(for: firstSevenDigits)
        else {
            throw ISBN.Error.invalidRange
        }
        self.length = length
    }
}

func parseRegistrationGroup(countryCode: CountryCode, remainingDigits: [Int]) throws ->
    (registrationGroup: Int, remainingDigits: Int) {
    let prefix = remainingDigits.prefix(through: 7)
    guard let length = Length
        .countryCodes[countryCode]?
        .length(for: prefix)
    else {
        throw ISBN.Error.invalidRange
        // TODO: Make this error more specific.
    }
    let registrationGroup = remainingDigits.prefix(length)
        guard registrationGroup.count == length else {
            throw ISBN.Error.invalidRange
        }
        
}
// TODO: Create helper function to convert integer arrays, strings, and ints.
*/

// parse -> (result, remainingDigits)
// (i.e. reduce)

/*
// TODO: Not safe. Pull this value out of the full string.
let string = String(firstSevenDigits)
// TODO: Consider using .digits instead
// and making [Int] conform to BinaryInteger.
let prefix = String(string.prefix(length))
// TODO: Consider renaming prefix to avoid ambiguity
// (countryCode is also a prefix).
guard
    prefix.count == length,
    let value = Int(prefix)
else {
    throw ISBN.Error.invalidRange
    // TODO: Consider using .invalidLength instead.
}
self.value = value
range = 0..<length
*/



extension CountryCode {
    var string: String {
        String(rawValue)
    }
}
