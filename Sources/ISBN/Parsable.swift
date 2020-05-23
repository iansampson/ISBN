//
//  Parsable.swift
//  
//
//  Created by Ian Sampson on 2020-05-22.
//

protocol Parsable {
    associatedtype Input
    associatedtype Output
    static func parse(_ input: State<Input>) throws -> State<Output>
}

struct State<Value> {
    let stream: Substring
    let value: Value
}
