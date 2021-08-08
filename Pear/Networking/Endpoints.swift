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
        let baseURL = Keys.pearServerURL

        #if LOCAL
            Endpoint.config.scheme = "http"
            Endpoint.config.port = 5000
            Endpoint.config.host = "localhost"
        #else
            Endpoint.config.scheme = "https"
            Endpoint.config.host = baseURL
        #endif
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

    // MARK: - Photo Upload
    static func uploadPhoto(base64: String) -> Endpoint {
        let body = PhotoUploadBody(bucket: "pear", image: "data:image/png;base64,\(base64)")
        return Endpoint(
            path: "/upload/",
            body: body,
            useCommonPath: false,
            customHost: Keys.appdevServerURL,
            customScheme: "https"
        )
    }

    /// [GET] Get major of the user
    static func getUserMajor() -> Endpoint {
        Endpoint(path: "/user/majors/")
    }

    /// [GET] Get interests of the user.
    static func getUserInterests() -> Endpoint {
        Endpoint(path: "/user/interests/")
    }

    /// [GET] Get availabilities of user by netID.
    static func getUserAvailabilities(netId: String) -> Endpoint {
        Endpoint(path: "/user/availabilities/", queryItems: [URLQueryItem(name: "netID", value: netId)], headers: standardHeaders)
    }
    
    /// [GET] Gets another user's matches, given their netID. If none provided, gets current user's matches.
    static func getUserMatches(netId: String) -> Endpoint {
        Endpoint(path: "/match/", queryItems: [URLQueryItem(name: "netID", value: netId)], headers: standardHeaders)
    }

    /// [GET] Get preferred locations of user by netID.
    static func getUserPreferredLocations(netId: String) -> Endpoint {
        Endpoint(path: "/user/preferredLocations/", queryItems: [URLQueryItem(name: "netID", value: netId)], headers: standardHeaders)
    }

    // MARK: - Get users
    
    /// [GET] Get all users.
    static func getUsers() -> Endpoint {
        Endpoint(path: "/user/all/", headers: standardHeaders)
    }
    
    // MARK: - Update user.
    
    /// [POST] Update goals information about the user.
    static func updateUserGoals(goals: [String]) -> Endpoint {
        let body = UpdateUserGoalsBody(goals: goals)
        return Endpoint(path: "/user/goals/", headers: standardHeaders, body: body)
    }

    /// [POST] Update time availabilities of the user.
    static func updateTimeAvailabilities(savedAvailabilities: [DaySchedule]) -> Endpoint {
        let body = UpdateTimeAvailabilitiesBody(schedule: savedAvailabilities)
        return Endpoint(path: "/user/availabilities/", headers: standardHeaders, body: body)
    }
    
    /// [POST] Updates the preferred location of current user.
    static func updatePreferredLocations(locations: [Location]) -> Endpoint {
        let body = UpdatePreferredLocationsBody(preferences: locations)
        return Endpoint(path: "/user/preferredLocations/", headers: standardHeaders, body: body)
    }
    
    // MARK: - Matches
    
    /// [GET] Gets another user's matches, given their netID.
    static func getMatch(netId: String) -> Endpoint {
        Endpoint(path: "/match/", queryItems: [URLQueryItem(name: "netID", value: netId)], headers: standardHeaders)
    }

    /// [POST] Update the availabilities for the given match.
    static func updateMatchAvailabilities(match: Match) -> Endpoint {
        let body = UpdateMatchBody(matchID: match.matchID, schedule: match.availabilities)
        return Endpoint(path: "/match/availabilities/", headers: standardHeaders, body: body)
    }

    /// [POST] Cancels match provided the matchID.
    static func cancelMatch(matchID: String) -> Endpoint {
        return Endpoint(path: "/match/cancel", queryItems: [URLQueryItem(name: "matchID", value: matchID)], headers: standardHeaders, method: .post)
    }

    /// [GET] Gets match history for provided netID. If none provided, gets current user's history.
    static func getMatchHistory(netID: String) -> Endpoint {
        Endpoint(path: "/match/history/", queryItems: [URLQueryItem(name: "netID", value: netID)], headers: standardHeaders)
    }

}
