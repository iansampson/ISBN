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

struct OptionalHyphen<Value>: Parsable {
    static func parse(_ input: State<Value>) throws -> State<Value> {
        var remainingStream = input.stream
        if
            let character = remainingStream.popFirst(),
            character.isHyphen
        {
            return State(stream: remainingStream, value: input.value)
        }
        return input
    }
}
