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
        Endpoint(path: "/refresh/", headers: updateHeaders)
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
        profilePictureURL: String
    ) -> Endpoint {
        let body = UpdateUserDemographicsBody(
            graduationYear: graduationYear,
            hometown: hometown,
            major: major,
            pronouns: pronouns,
            profilePictureURL: profilePictureURL
        )
        return Endpoint(path: "/user/demographics/", headers: standardHeaders, body: body)
    }

    /// [POST] Update interests information about the user
    static func updateUserInterests(interests: [String]) -> Endpoint {
        let body = UpdateUserInterestsBody(interests: interests)
        return Endpoint(path: "/user/interests/", headers: standardHeaders, body: body)
    }

    /// [POST] Update groups information about the user
    static func updateUserGroups(groups: [String]) -> Endpoint {
        let body = UpdateUserGroupsBody(groups: groups)
        return Endpoint(path: "/user/groups/", headers: standardHeaders, body: body)
    }

    /// [POST] Update goals information about the user
    static func updateUserGoals(goals: [String]) -> Endpoint {
        let body = UpdateUserGoalsBody(goals: goals)
        return Endpoint(path: "/user/goals/", headers: standardHeaders, body: body)
    }

    /// [POST] Update goals information about the user
    static func updateUserSocialMedia(facebook: String, instagram: String) -> Endpoint {
        let body = UpdateUserSocialMediaBody(facebook: facebook, instagram: instagram)
        return Endpoint(path: "/user/socialMedia/", headers: standardHeaders, body: body)
    }

    /// [POST] Update oganizations information about the user
    static func updateUserOrganizations(organizations: [String]) -> Endpoint {
        let body = UpdateUserGroupsBody(groups: organizations)
        return Endpoint(path: "/user/organizations/", headers: standardHeaders, body: body)
    }

    /// [POST] Update talking points information about the user
    static func updateUserTalkingPoints(talkingPoints: [String]) -> Endpoint {
        let body = UpdateUserTalkingPointsBody(talkingPoints: talkingPoints)
        return Endpoint(path: "/user/talkingPoints/", headers: standardHeaders, body: body)
    }

    /// [GET] Get information about the user
    static func getUser(netId: String) -> Endpoint {
        Endpoint(path: "/user/", queryItems: [URLQueryItem(name: "netID", value: netId)], headers: standardHeaders)
    }

    /// [GET] Get clubs of the user
    static func getUserClubs() -> Endpoint {
        Endpoint(path: "/user/clubs/")
    }

    /// [GET] Get major of the user
    static func getUserMajor() -> Endpoint {
        Endpoint(path: "/user/majors/")
    }

    /// [GET] Get interests of the user
    static func getUserInterests() -> Endpoint {
        Endpoint(path: "/user/interests/")
    }

    /// [GET] Get all users
    static func getUsers() -> Endpoint {
        Endpoint(path: "/user/all/", headers: standardHeaders)
    }

    /// [GET] Get searched users
    static func searchUsers(query: String) -> Endpoint {
        Endpoint(path: "/user/search/", queryItems: [URLQueryItem(name: "query", value: query)], headers: standardHeaders)
    }

    /// [GET] Get all student groups
    static func getAllGroups() -> Endpoint {
        Endpoint(path: "/group/all/", headers: standardHeaders)
    }

    /// [GET] Get all interests
    static func getAllInterests() -> Endpoint {
        Endpoint(path: "/interest/all/", headers: standardHeaders)
    }

    /// [GET] Get all majors
    static func getAllMajors() -> Endpoint {
        Endpoint(path: "/major/all/", headers: standardHeaders)
    }

    /// [GET] Get user time availabilities
    static func getTimeAvailabilities() -> Endpoint {
        Endpoint(path: "/user/", headers: standardHeaders)
    }

    /// [POST] Update user time availabilities
    static func updateTimeAvailabilities(savedAvailabilities: [DaySchedule]) -> Endpoint {
        let body = UpdateTimeAvailabilitiesBody(schedule: savedAvailabilities)
        return Endpoint(path: "/user/availabilities/", headers: standardHeaders, body: body)
    }

    /// [GET] Gets current user's matches
    static func getMatch(netId: String) -> Endpoint {
        Endpoint(path: "/match/", queryItems: [URLQueryItem(name: "netID", value: netId)], headers: standardHeaders)

    }
    /// [GET] Gets another user's matches, given their netID
    static func getMatch() -> Endpoint {
        Endpoint(path: "/match/", headers: standardHeaders)
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
