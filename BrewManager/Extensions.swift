//
//  Extensions.swift
//  BrewManager
//
//  Created by David Rosenberg on 8/28/25.
//

import Foundation

extension UserDefaults {
    static func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let dict = UserDefaults.standard.dictionaryRepresentation()
        let data = try PropertyListSerialization.data(
            fromPropertyList: dict,
            format: .binary,
            options: 0,
        )
        
        let decoder = PropertyListDecoder()
        let prefs = try decoder.decode(T.self, from: data)
        return prefs
    }
}
