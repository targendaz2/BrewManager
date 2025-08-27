//
//  main.swift
//  BrewManager
//
//  Created by David Rosenberg on 8/18/25.
//

import ArgumentParser
import DotEnvEncoder

@main
struct BrewManager: ParsableCommand {
    mutating func run() throws {
        guard let prefs = try? BrewPrefs.fromUserDefaults() else {
            fatalError("Failed to load BrewPrefs from UserDefaults")
        }
        
        let encoder = DotEnvEncoder()
        guard let encodedPrefs = try? encoder.encode(prefs) else {
            fatalError("Failed to encode BrewPrefs to DotEnv")
        }
        print(encodedPrefs)
    }
}
