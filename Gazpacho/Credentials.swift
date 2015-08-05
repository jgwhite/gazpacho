//
//  Credentials.swift
//  Gazpacho
//
//  Created by Jamie White on 23/06/2015.
//  Copyright © 2015 Jamie White. All rights reserved.
//

import Foundation

struct Credentials {
    let username: String
    let password: String

    static let server = "rubytapas.dpdcart.com"

    static func fetch() -> Credentials? {
        let query = [
            (kSecReturnAttributes as String) : kCFBooleanTrue,
            (kSecClass as String)            : kSecClassInternetPassword,
            (kSecAttrServer as String)       : Credentials.server
        ]

        var itemRef: Unmanaged<AnyObject>?

        withUnsafeMutablePointer(&itemRef) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }

        if let ref = itemRef?.takeRetainedValue() as? [String: AnyObject],
            let username = ref["acct"] as? String {
            let usernameLength = username.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

            let serverName = Credentials.server
            let serverNameLength = serverName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

            var passwordLength: UInt32 = 0
            var passwordData: UnsafeMutablePointer<Void> = nil

            SecKeychainFindInternetPassword(
                nil, // keychain
                UInt32(serverNameLength),
                serverName,
                0, // securityDomainLength
                nil, // securityDomain
                UInt32(usernameLength),
                username,
                0, // pathLength
                nil, // path
                0, // port
                .HTTPS,
                .Default,
                &passwordLength,
                &passwordData,
                nil // itemRef
            )

            if let password = NSString(bytes: passwordData, length: Int(passwordLength), encoding: NSUTF8StringEncoding) as? String {
                return Credentials(username: username, password: password)
            }
        }
        
        return nil
    }

    static func store(credentials: Credentials) {
        Credentials.deleteAll()

        let serverName = Credentials.server
        let serverNameLength = serverName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

        let username = credentials.username
        let usernameLength = username.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

        let password = credentials.password
        let passwordLength = password.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)

        SecKeychainAddInternetPassword(
            nil, // keychain
            UInt32(serverNameLength),
            serverName,
            0, // securityDomainLength
            nil, // securityDomain
            UInt32(usernameLength),
            username,
            0, // pathLength
            nil, // path
            0, // port
            .HTTPS,
            .Default,
            UInt32(passwordLength),
            password,
            nil
        )
    }

    static func deleteAll() {
        let query = [
            (kSecClass as String): kSecClassInternetPassword,
            (kSecAttrServer as String): Credentials.server
        ]

        SecItemDelete(query)
    }
}