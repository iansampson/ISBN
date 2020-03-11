//
//  LengthMaps.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

protocol LengthMap {
    var rules: [Rule] { get }
}

extension LengthMap {
    func length(for firstSevenDigitsAfterCountryCode: Digits) -> Int? {
        guard firstSevenDigitsAfterCountryCode.count == 7 else {
            fatalError()
        }
        // TODO: Consider parsing the digits yourself.
        return rules.first {
            $0.range.contains(firstSevenDigitsAfterCountryCode.singleInteger)
        }?.length
    }
}

struct CountryCodeMap: LengthMap {
    let prefix: CountryCode
    let agency: String
    let rules: [Rule]
}

struct RegistrationGroupMap: LengthMap {
    let prefix: String // TODO: Will Int work?
    let agency: String
    let rules: [Rule]
}

struct Rule {
    let range: ClosedRange<Int>
    let length: Int
}

enum Length {
    static let countryCodes: [CountryCode : CountryCodeMap] = [
        .bookland: CountryCodeMap(
            prefix: .bookland,
            agency: "International ISBN Agency",
            rules: [
                Rule(range: 0000000...5999999, length: 1),
                Rule(range: 6000000...6499999, length: 3),
                Rule(range: 6500000...6599999, length: 2),
                Rule(range: 6600000...6999999, length: 0),
                Rule(range: 7000000...7999999, length: 1),
                Rule(range: 8000000...9499999, length: 2),
                Rule(range: 9500000...9899999, length: 3),
                Rule(range: 9900000...9989999, length: 4),
                Rule(range: 9990000...9999999, length: 5)
            ]
        )
    ]

    static let registrationGroups: [String : RegistrationGroupMap] = [
        "978-3": RegistrationGroupMap(
            prefix: "978-3",
            agency: "German language",
            rules: [
                Rule(range: 2000000...6999999, length: 3)
            ]
        )
    ]
}

// CountryCode -> RegistrationGroup -> Registrant
