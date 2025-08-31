//
//  UserDefaultsObserver.swift
//  Monitoring
//
//  Created by David Rosenberg on 8/28/25.
//

import Foundation

public final class UserDefaultsMonitor {
    let onChange: (Notification) -> Void
    
    public init(onChange: @escaping (Notification) -> Void) {
        self.onChange = onChange
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }

    @objc func userDefaultsDidChange(_ notification: Notification) {
        onChange(notification)
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }
}
