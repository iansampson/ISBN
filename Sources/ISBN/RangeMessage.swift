//
//  RangeMessage.swift
//  
//
//  Created by Ian Sampson on 2021-11-21.
//

import Foundation

extension RangeMessage {
    struct Container: Codable {
        let isbnRangeMessage: RangeMessage
        
        enum CodingKeys: String, CodingKey {
            case isbnRangeMessage = "ISBNRangeMessage"
        }
        
        init() throws {
            let decoder = JSONDecoder()
            guard let url = Bundle.module.url(forResource: "RangeMessage", withExtension: "json") else {
                throw ParseError.missingData
            }
            let data = try Data(contentsOf: url)
            self = try decoder.decode(Container.self, from: data)
        }
    }
    
    enum ParseError: Error {
        case missingData
    }
}

struct RangeMessage: Codable {
    let messageSource: String
    let messageSerialNumber: String
    let messageDate: String
    let eanUccPrefixes: EAN.UCC.Prefixes
    let registrationGroups: RegistrationGroups
    
    enum CodingKeys: String, CodingKey {
        case messageSource = "MessageSource"
        case messageSerialNumber = "MessageSerialNumber"
        case messageDate = "MessageDate"
        case eanUccPrefixes = "EAN.UCCPrefixes"
        case registrationGroups = "RegistrationGroups"
    }
    
    struct RegistrationGroups: Codable {
        let group: [EAN.UCC]
        
        enum CodingKeys: String, CodingKey {
            case group = "Group"
        }
    }
}

enum EAN {
    struct UCC: Codable {
        let prefix: String
        let agency: String
        let rules: Rules
        
        enum CodingKeys: String, CodingKey {
            case prefix = "Prefix"
            case agency = "Agency"
            case rules = "Rules"
        }
        
        struct Rules: Codable {
            let rule: [Rule]
            
            enum CodingKeys: String, CodingKey {
                case rule = "Rule"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                do {
                    rule = try container.decode([Rule].self, forKey: .rule)
                } catch {
                    rule = [try container.decode(Rule.self, forKey: .rule)]
                }
            }
        }
        
        struct Rule: Codable {
            let rangeDescription: String
            let length: String
            
            enum CodingKeys: String, CodingKey {
                case rangeDescription = "Range"
                case length = "Length"
            }
            
            var range: ClosedRange<Int> {
                // TODO: Consider storing ranges in this form during decoding
                let integers = rangeDescription.split(separator: "-")
                    .lazy
                    .map(String.init)
                    .compactMap(Int.init)
                guard integers.count == 2 else {
                    fatalError()
                }
                return integers[0]...integers[1]
            }
        }
        
        struct Prefixes: Codable {
            let eanUcc: [EAN.UCC]
            
            enum CodingKeys: String, CodingKey {
                case eanUcc = "EAN.UCC"
            }
        }
    }
}
