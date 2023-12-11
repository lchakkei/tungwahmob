import UIKit
// MARK: - Update

public struct KeychainHelper {
    
    public static func verify(values: [String]) {
        if UserDefaults.standard.string(forKey: "firstTimeInstall") == nil {
            print("Delete All Key")
            UserDefaults.standard.set("false", forKey: "firstTimeInstall")
            UserDefaults.standard.synchronize()
            KeychainHelper.clearAll(values)
        }
    }
    
    private static func clearAll(_ values: [String]) {
        for key in values {
            delete(forKey: key)
        }
    }
    
    // add update save
    public static func save<T: Encodable>(_ object: T, forKey key: String) -> Void? {
        let data = try? JSONEncoder().encode(object)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data ?? Data()
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else {
            return nil
        }
        return ()
    }

    public static func getData<T: Decodable>(forKey key: String) -> T? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        guard status == errSecSuccess else {
            return nil
        }

        guard let data = dataTypeRef as? Data else {
            return nil
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            return nil
        }
    }

    public static func delete(forKey key: String) -> Void? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return nil
        }
        return ()
    }
    
}
