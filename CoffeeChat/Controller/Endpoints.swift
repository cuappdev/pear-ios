//
//  Endpoints.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 3/8/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {

    static func setupEndpointConfig() {

//        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "SERVER_URL") as? String else {
//            fatalError("Could not find SERVER_URL in Info.plist!")
//        }

        let baseURL = "pear-backend.cornellappdev.com"

        #if LOCAL
            Endpoint.config.scheme = " "
            Endpoint.config.port = 5000
        #else
            Endpoint.config.scheme = "http"
        #endif
        Endpoint.config.host = baseURL
        Endpoint.config.commonPath = "/api/v1"
    }

    // TODO: Revisit (copied from CourseGrab)
//    static var standardHeaders: [String: String] {
//        if let token = User.current?.sessionAuthorization?.sessionToken {
//            return ["Authorization": token]
//        } else {
//            return [:]
//        }
//    }
//
//    // TODO: Revisit (copied from CourseGrab)
//    static var updateHeaders: [String: String] {
//        if let token = User.current?.sessionAuthorization?.updateToken {
//            return ["Authorization": token]
//        } else {
//            return [:]
//        }
//    }

    /// Check if server application is running
    static func pingServer() -> Endpoint {
        return Endpoint(path: "/auth/hello/")
    }

    /// Create a new user and initialize a Google Auth session
    static func createUser(clubs: [String],
                           idToken: String,
                           graduationYear: String,
                           hometown: String,
                           interests: [String],
                           major: String,
                           pronouns: String) -> Endpoint {
        let body = UserSessionBody(clubs: clubs,
                            idToken: idToken,
                            graduationYear: graduationYear,
                            hometown: hometown,
                            interests: interests,
                            major: major,
                            pronouns: pronouns)
        return Endpoint(path: "/user/login", body: body)
    }

}
