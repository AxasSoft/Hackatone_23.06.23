//
//  Constants.swift
//  hackathon
//
//  Created by Денис Чупров on 23.06.2023.
//

import Foundation
import KeychainAccess

final class NetworkManager {
    private static let keychain = Keychain(service: "ru.axas.FamilyVibe")
 
    static var accessToken: String? {
        get {
            return keychain["accessToken"]
        } set {
            do {
                try keychain.set(newValue ?? "", key: "accessToken")
            } catch {
                print("something wrong with the token installation")
            }
        }
    }
    
    static let baseURLString = "http://87.249.49.97:84"
}
