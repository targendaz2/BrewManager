//
//  BrewPrefs.swift
//  BrewManager
//
//  Created by David Rosenberg on 8/18/25.
//

import DotEnvEncoding
import Foundation

struct BrewPrefs: Codable {
    enum Permission: String, Codable {
        case allow = "allow"
        case deny = "deny"
    }

    let HOMEBREW_ALLOWED_TAPS: [String]?  // space separated
    let HOMEBREW_API_AUTO_UPDATE_SECS: Int?
    let HOMEBREW_API_DOMAIN: URL?
    let HOMEBREW_ARTIFACT_DOMAIN: URL?
    let HOMEBREW_ARTIFACT_DOMAIN_NO_FALLBACK: Bool?
    let HOMEBREW_ASK: Bool?
    let HOMEBREW_AUTO_UPDATE_SECS: Int?
    let HOMEBREW_BAT: Bool?
    let HOMEBREW_BAT_CONFIG_PATH: String?
    let HOMEBREW_BAT_THEME: String?
    let HOMEBREW_BOTTLE_DOMAIN: URL?
    let HOMEBREW_BREW_GIT_REMOTE: URL?
    let HOMEBREW_BREW_WRAPPER: String?
    let HOMEBREW_BROWSER: String?
    let HOMEBREW_BUNDLE_USER_CACHE: String?
    let HOMEBREW_CACHE: String?
    let HOMEBREW_CASK_OPTS: String?
    let HOMEBREW_CLEANUP_MAX_AGE_DAYS: Int?
    let HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS: Int?
    let HOMEBREW_COLOR: Bool?
    let HOMEBREW_CORE_GIT_REMOTE: URL?
    let HOMEBREW_CURLRC: String?
    let HOMEBREW_CURL_RETRIES: Int?
    let HOMEBREW_CURL_VERBOSE: Bool?
    let HOMEBREW_DEBUG: Bool?
    let HOMEBREW_DEVELOPER: Bool?
    let HOMEBREW_DISABLE_DEBREW: Bool?
    let HOMEBREW_DISABLE_LOAD_FORMULA: Bool?
    let HOMEBREW_DISPLAY: String?
    let HOMEBREW_DISPLAY_INSTALL_TIMES: Bool?
    let HOMEBREW_DOCKER_REGISTRY_BASIC_AUTH_TOKEN: String?
    let HOMEBREW_DOCKER_REGISTRY_TOKEN: String?
    let HOMEBREW_DOWNLOAD_CONCURRENCY: Int?
    let HOMEBREW_EDITOR: String?
    let HOMEBREW_ENV_SYNC_STRICT: Bool?
    let HOMEBREW_EVAL_ALL: Bool?
    let HOMEBREW_FAIL_LOG_LINES: Int?
    let HOMEBREW_FORBIDDEN_CASKS: [String]?  // space separated
    let HOMEBREW_FORBIDDEN_FORMULAE: [String]?  // space separated
    let HOMEBREW_FORBIDDEN_LICENSES: [String]?  // space separated
    let HOMEBREW_FORBIDDEN_OWNER: String?
    let HOMEBREW_FORBIDDEN_OWNER_CONTACT: String?
    let HOMEBREW_FORBIDDEN_TAPS: [String]?  // space separated
    let HOMEBREW_FORBID_CASKS: Bool?
    let HOMEBREW_FORBID_PACKAGES_FROM_PATHS: Bool?
    let HOMEBREW_FORCE_API_AUTO_UPDATE: Bool?
    let HOMEBREW_FORCE_BREWED_CA_CERTIFICATES: Bool?
    let HOMEBREW_FORCE_BREWED_CURL: Bool?
    let HOMEBREW_FORCE_BREWED_GIT: Bool?
    let HOMEBREW_FORCE_BREW_WRAPPER: String?
    let HOMEBREW_FORCE_VENDOR_RUBY: Bool?
    let HOMEBREW_FORMULA_BUILD_NETWORK: Permission?
    let HOMEBREW_FORMULA_POSTINSTALL_NETWORK: Permission?
    let HOMEBREW_FORMULA_TEST_NETWORK: Permission?
    let HOMEBREW_GITHUB_API_TOKEN: String?
    let HOMEBREW_GITHUB_PACKAGES_TOKEN: String?
    let HOMEBREW_GITHUB_PACKAGES_USER: String?
    let HOMEBREW_GIT_COMMITTER_EMAIL: String?
    let HOMEBREW_GIT_COMMITTER_NAME: String?
    let HOMEBREW_GIT_EMAIL: String?
    let HOMEBREW_GIT_NAME: String?
    let HOMEBREW_INSTALL_BADGE: String?
    let HOMEBREW_LIVECHECK_AUTOBUMP: Bool?
    let HOMEBREW_LIVECHECK_WATCHLIST: String?
    let HOMEBREW_LOCK_CONTEXT: String?
    let HOMEBREW_LOGS: String?
    let HOMEBREW_MAKE_JOBS: Int?
    let HOMEBREW_NO_ANALYTICS: Bool?
    let HOMEBREW_NO_AUTOREMOVE: Bool?
    let HOMEBREW_NO_AUTO_UPDATE: Bool?
    let HOMEBREW_NO_BOOTSNAP: Bool?
    let HOMEBREW_NO_CLEANUP_FORMULAE: [String]?  // comma separated
    let HOMEBREW_NO_COLOR: Bool?
    let HOMEBREW_NO_EMOJI: Bool?
    let HOMEBREW_NO_ENV_HINTS: Bool?
    let HOMEBREW_NO_FORCE_BREW_WRAPPER: Bool?
    let HOMEBREW_NO_GITHUB_API: Bool?
    let HOMEBREW_NO_INSECURE_REDIRECT: Bool?
    let HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK: Bool?
    let HOMEBREW_NO_INSTALL_CLEANUP: Bool?
    let HOMEBREW_NO_INSTALL_FROM_API: Bool?
    let HOMEBREW_NO_INSTALL_UPGRADE: Bool?
    let HOMEBREW_NO_UPDATE_REPORT_NEW: Bool?
    let HOMEBREW_NO_VERIFY_ATTESTATIONS: Bool?
    let HOMEBREW_PIP_INDEX_URL: URL?
    let HOMEBREW_PRY: Bool?
    let HOMEBREW_SKIP_OR_LATER_BOTTLES: Bool?
    let HOMEBREW_SORBET_RUNTIME: Bool?
    let HOMEBREW_SSH_CONFIG_PATH: String?
    let HOMEBREW_SUDO_THROUGH_SUDO_USER: Bool?
    let HOMEBREW_SVN: String?
    let HOMEBREW_SYSTEM_ENV_TAKES_PRIORITY: Bool?
    let HOMEBREW_TEMP: String?
    let HOMEBREW_UPDATE_TO_TAG: Bool?
    let HOMEBREW_UPGRADE_GREEDY: Bool?
    let HOMEBREW_UPGRADE_GREEDY_CASKS: [String]?  // space separated
    let HOMEBREW_VERBOSE: Bool?
    let HOMEBREW_VERBOSE_USING_DOTS: Bool?
    let HOMEBREW_VERIFY_ATTESTATIONS: Bool?
    let SUDO_ASKPASS: Bool?
    let all_proxy: String?
    let ftp_proxy: String?
    let http_proxy: String?
    let https_proxy: String?
    let no_proxy: [String]?  // comma separated
}

extension BrewPrefs {
    static func load() -> Self {
        guard let prefs = try? UserDefaults.decode(BrewPrefs.self) else {
            fatalError("Failed to load BrewPrefs from UserDefaults")
        }
        return prefs
    }

    func write() {
        let encoder = DotEnvEncoder(arraySeparators: [
            "HOMEBREW_NO_CLEANUP_FORMULAE": ",",
            "no_proxy": ",",
        ])

        guard let encodedPrefs = try? encoder.encode(self) else {
            fatalError("Failed to encode BrewPrefs to DotEnv")
        }
        
        do {
            try encodedPrefs.write(to: brewEnvFile, atomically: true, encoding: .utf8)
        } catch {
            fatalError("Failed to write BrewPrefs to file: \(error)")
        }
    }
}
