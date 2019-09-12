//
//  Digit.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

extension Int {
    var digits: [Int] {
        String(self).map {
            guard let integer = $0.wholeNumberValue else {
                fatalError()
            }
            return integer
        }
    }
}
// TODO: Consider returning Digit so that Int
// is guaranteed to be a single digit.
