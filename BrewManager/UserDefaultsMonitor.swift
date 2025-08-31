//
//  UserDefaultsObserver.swift
//  BrewManager
//
//  Created by David Rosenberg on 8/28/25.
//

import DotEnvEncoding
import Foundation

class UserDefaultsMonitor {
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }

    @objc func userDefaultsDidChange(_ notification: Notification) {
        let decoder = UserDefaultsDecoder()
        guard let prefs = try? decoder.decode(BrewPrefs.self) else {
            fatalError("Failed to load BrewPrefs from UserDefaults")
        }

        let encoder = DotEnvEncoder(arraySeparators: [
            "HOMEBREW_NO_CLEANUP_FORMULAE": ",",
            "no_proxy": ",",
        ])

        guard let encodedPrefs = try? encoder.encode(prefs) else {
            fatalError("Failed to encode BrewPrefs to DotEnv")
        }
        print(prefs)
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }
}
