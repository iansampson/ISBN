//
//  CountryCode.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

enum CountryCode: Int {
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
