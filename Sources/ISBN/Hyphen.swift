//
//  Character.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

extension Character {
    var isHyphen: Bool {
        self == "\u{002D}"
        || self == "\u{2010}"
        || self == "\u{2212}"
    }
}
