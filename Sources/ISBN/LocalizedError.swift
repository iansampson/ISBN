//
//  File.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

import Foundation

extension ISBN.Error: LocalizedError {
    var errorDescription: String? {
        "\(self)"
    }
}
// TODO: Make errors more specific.
// TODO: Remove dependence on Foundation if possible.
