import Foundation

struct LocalizationManager {
    static func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    static func localizedString(forKey key: String, with arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: arguments)
    }
}
