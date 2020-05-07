//
//  User.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 4/29/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

//struct User {
//
//    static var current: User? {
////        guard let email = Auth.auth().currentUser?.email,
////            let name = Auth.auth().currentUser?.displayName,
////            let id = Auth.auth().currentUser?.uid
////            else { return nil }
//        return User(email: "email", name: "name", id: "id")
//    }
//
//    let email: String
//    let name: String
//    let id: String
//
//    var sessionAuthorization: SessionAuthorization? {
//        get {
//            if let dict = UserDefaults.standard.value(forKey: "sessionAuth") as? [String: Any],
//                let sessionToken = dict["sessionToken"] as? String,
//                let updateToken = dict["updateToken"] as? String,
//                let sessionExpiration = dict["sessionExpiration"] as? Date {
////                return SessionAuthorization(sessionExpiration: Timestamp(sessionExpiration), sessionToken: sessionToken, updateToken: updateToken)
//                return SessionAuthorization(sessionToken: sessionToken, updateToken: updateToken)
//            } else {
//                return nil
//            }
//        }
//        nonmutating set(token) {
//            if let token = token {
//                let dict: [String: Any] = [
//                    "sessionToken": token.sessionToken,
//                    "updateToken": token.updateToken,
////                    "sessionExpiration": token.sessionExpiration.date,
//                ]
//                UserDefaults.standard.set(dict, forKey: "sessionAuth")
//            } else {
//                UserDefaults.standard.set(nil, forKey: "sessionAuth")
//            }
//        }
//    }
//
//    var googleToken: String? {
//        get {
//            return UserDefaults.standard.string(forKey: "googleToken")
//        }
//        nonmutating set(token) {
//            UserDefaults.standard.set(token, forKey: "googleToken")
//        }
//    }
//
//}
