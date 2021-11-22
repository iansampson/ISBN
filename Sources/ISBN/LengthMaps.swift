//
//  LengthMaps.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

extension EAN.UCC {
    func length(for firstSevenDigitsAfterCountryCode: Int) -> Int? {
        guard let rule = rules.rule.first(where: {
            $0.range.contains(firstSevenDigitsAfterCountryCode)
        }) else {
            return nil
        }
        return Int(rule.length)
    }
}
