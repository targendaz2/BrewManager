//
//  main.swift
//  BrewManager
//
//  Created by David Rosenberg on 8/18/25.
//

import ArgumentParser
import Foundation
import Monitoring

@main
struct BrewManager: ParsableCommand {
    mutating func run() throws {
        let _ = UserDefaultsMonitor { notification in
            let prefs = BrewPrefs.load()
            prefs.write()
        }

        do {
            let _ = try FileMonitor(path: brewEnvFile) { event in
                let prefs = BrewPrefs.load()
                prefs.write()
            }
        } catch {
            fatalError("Could not monitor brew env file at \(brewEnvFile): \(error)")
        }

        RunLoop.main.run()
    }
}
