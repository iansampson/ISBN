//
//  ISBN+Codable.swift
//  
//
//  Created by Ian Sampson on 2021-11-22.
//

extension ISBN: Codable {
    public init(from decoder: Decoder) throws {
        let string = try String(from: decoder)
        try self.init(string)
    }
    
    public func encode(to encoder: Encoder) throws {
        try string.encode(to: encoder)
    }
}
