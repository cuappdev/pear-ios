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
    
    static var standardHeaders: [String: String] {
        if let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.accessToken) {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return [:]
        }
    }

    static var updateHeaders: [String: String] {
        if let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.refreshToken) {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return [:]
        }
    }

    /// [GET] Check if server application is running
    static func pingServer() -> Endpoint {
        Endpoint(path: "/general/hello/")
    }
    
    static func refreshUserToken(token: String) -> Endpoint {
        return Endpoint(path: "/refresh/", headers: updateHeaders)
    }

    /// [POST] Authenticate ID token from Google and creates a user if account does not exist
    static func createUser(idToken: String) -> Endpoint {
        let body = UserSessionBody(idToken: idToken)
        return Endpoint(path: "/auth/login/", body: body)
    }

    /// [POST] Update demographics information about the user
    static func updateUserDemographics(
        graduationYear: String,
        hometown: String,
        major: String,
        pronouns: String,
        picture: String
    ) -> Endpoint {
        let body = UserUpdateDemographicsBody(
            graduationYear: graduationYear,
            hometown: hometown,
            major: major,
            pronouns: pronouns,
            profilePictureURL: picture
        )
        print(standardHeaders)
        return Endpoint(path: "/user/updateDemographics/", headers: standardHeaders, body: body)
    }
    
    /// [POST] Update interests information about the user
    static func updateUserInterests(
        interests: [String]
    ) -> Endpoint {
        let body = UserUpdateInterestsBody(
            interests: interests
        )
        print(standardHeaders)
        return Endpoint(path: "/user/updateInterests/", headers: standardHeaders, body: body)
    }
    
    /// [POST] Update oganizations information about the user
    static func updateUserOrganizations(organizations: [String]) -> Endpoint {
        let body = UserUpdateOrganizationsBody(clubs: organizations)
        print(standardHeaders)
        return Endpoint(path: "/user/updateOrganizations/", headers: standardHeaders, body: body)
    }

    /// [GET] Get information about the user
    static func getUser() -> Endpoint {
        Endpoint(path: "/user/")
    }

    /// [GET] Get clubs of the user
    static func getUserClubs() -> Endpoint {
        Endpoint(path: "/user/clubs/")
    }

    /// [POST] Get matchings of the user
    static func getUserMatchings(netIDs: [String], schedule: [DaySchedule]) -> Endpoint {
        let body = MatchingBody(netIDs: netIDs, schedule: schedule)
        return Endpoint(path: "/user/matchings/", body: body)
    }

    /// [GET] Get major of the user
    static func getUserMajor() -> Endpoint {
        Endpoint(path: "/user/majors/")
    }

    /// [GET] Get interests of the user
    static func getUserInterests() -> Endpoint {
        Endpoint(path: "/user/interests/")
    }

}
