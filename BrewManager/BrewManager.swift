//
//  main.swift
//  BrewManager
//
//  Created by David Rosenberg on 8/18/25.
//

import ArgumentParser
import DotEnvEncoding

@main
struct Start: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Starts Brew Manager")
    
    mutating func run() throws {
        guard let prefs = try? BrewPrefs.fromUserDefaults() else {
            fatalError("Failed to load BrewPrefs from UserDefaults")
        }
        
        let encoder = DotEnvEncoder(arraySeparators: [
            "HOMEBREW_NO_CLEANUP_FORMULAE": ",",
            "no_proxy": ",",
        ])
        
        guard let encodedPrefs = try? encoder.encode(prefs) else {
            fatalError("Failed to encode BrewPrefs to DotEnv")
        }
        print(encodedPrefs)
    }
}
