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

        let baseURL = Keys.serverURL

        #if LOCAL
            Endpoint.config.scheme = "http"
            Endpoint.config.port = 5000
        #else
            Endpoint.config.scheme = "http"
        #endif
        Endpoint.config.host = baseURL
        Endpoint.config.commonPath = "/api/v1"
    }

    /// [GET] Check if server application is running
    static func pingServer() -> Endpoint {
        return Endpoint(path: "/general/hello/")
    }

    /// [POST] Authenticate ID token from Google and creates a user if account does not exist
    static func createUser(idToken: String) -> Endpoint {
        let body = UserSessionBody(idToken: idToken)
        return Endpoint(path: "/auth/login/", body: body)
    }

    /// [POST] Update information about the user
    static func updateUser(
        clubs: [String],
        graduationYear: String,
        hometown: String,
        interests: [String],
        major: String,
        pronouns: String
    ) -> Endpoint {
        let body = UserUpdateBody(
            clubs: clubs,
            graduationYear: graduationYear,
            hometown: hometown,
            interests: interests,
            major: major,
            pronouns: pronouns
        )
        return Endpoint(path: "/user/update/", body: body)
    }

    /// [GET] Get information about the user
    static func getUser() -> Endpoint {
        return Endpoint(path: "/user/")
    }

    /// [GET] Get clubs of the user
    static func getUserClubs() -> Endpoint {
        return Endpoint(path: "/user/clubs/")
    }

    /// [POST] Get matchings of the user
    static func getUserMatchings(netIDs: [String], schedule: [DaySchedule]) -> Endpoint {
        let body = MatchingBody(netIDs: netIDs, schedule: schedule)
        return Endpoint(path: "/user/matchings/", body: body)
    }

    /// [GET] Get major of the user
    static func getUserMajor() -> Endpoint {
        return Endpoint(path: "/user/majors/")
    }

    /// [GET] Get interests of the user
    static func getUserInterests() -> Endpoint {
        return Endpoint(path: "/user/interests/")
    }

}
