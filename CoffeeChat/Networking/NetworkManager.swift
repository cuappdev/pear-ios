//
//  NetworkManager.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 3/8/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation
import FutureNova

class NetworkManager {

    static let shared: NetworkManager = NetworkManager()

    private let networking: Networking = URLSession.shared.request

    private init() {}

    func pingServer() -> Future<Response<String>> {
        networking(Endpoint.pingServer()).decode()
    }

    func refreshUserSession(token: String) -> Future<Response<UserSession>> {
        networking(Endpoint.refreshUserToken(token: token)).decode()
    }

    func createUser(idToken: String) -> Future<Response<UserSession>> {
        networking(Endpoint.createUser(idToken: idToken)).decode()
    }

    func updateUserDemographics(
        graduationYear: String,
        major: String,
        hometown: String,
        pronouns: String,
        profilePictureURL: String) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserDemographics(
                    graduationYear: graduationYear,
                    hometown: hometown,
                    major: major,
                    pronouns: pronouns,
                    profilePictureURL: profilePictureURL)
        ).decode()
    }

    func updateUserInterests(interests: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserInterests(interests: interests)).decode()
    }

    func updateUserGroups(groups: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserGroups(groups: groups)).decode()
    }

    func updateUserGoals(goals: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserGoals(goals: goals)).decode()
    }

    func updateUserTalkingPoints(talkingPoints: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserTalkingPoints(talkingPoints: talkingPoints)).decode()
    }

    func updateUserSocialMedia(facebook: String, instagram: String) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserSocialMedia(facebook: facebook, instagram: instagram)).decode()
    }

    func getUser(netId: String) -> Future<Response<User>> {
        networking(Endpoint.getUser(netId: netId)).decode()
    }

    func getUserClubs() -> Future<Response<[String]>> {
        networking(Endpoint.getUserClubs()).decode()
    }

    func getUserMajor() -> Future<Response<String>> {
        networking(Endpoint.getUserMajor()).decode()
    }

    func getUserInterests() -> Future<Response<[String]>> {
        networking(Endpoint.getUserInterests()).decode()
    }

    func getUsers() -> Future<Response<[CommunityUser]>> {
        networking(Endpoint.getUsers()).decode()
    }

    func searchUsers(query: String) -> Future<Response<[CommunityUser]>> {
        networking(Endpoint.searchUsers(query: query)).decode()
    }

    func getAllGroups() -> Future<Response<[String]>> {
        networking(Endpoint.getAllGroups()).decode()
    }

    func getAllInterests() -> Future<Response<[String]>> {
        networking(Endpoint.getAllInterests()).decode()
    }

    func getAllMajors() -> Future<Response<[String]>> {
        networking(Endpoint.getAllMajors()).decode()
    }

    func getTimeAvailabilities() -> Future<Response<[DaySchedule]>> {
        networking(Endpoint.getTimeAvailabilities()).decode()
    }

    func updateTimeAvailabilities(savedAvailabilities: [DaySchedule]) -> Future<SuccessResponse> {
        networking(Endpoint.updateTimeAvailabilities(savedAvailabilities: savedAvailabilities)).decode()
    }

    func getMatch() -> Future<Response<Match>> {
        networking(Endpoint.getMatch()).decode()
    }

    func getMatch(netId: String) -> Future<Response<Match>> {
        networking(Endpoint.getMatch(netId: netId)).decode()
    }

    func updateMatchAvailabilities(match: Match) -> Future<SuccessResponse> {
        networking(Endpoint.updateMatchAvailabilities(match: match)).decode()
    }

    func cancelMatch(matchID: String) -> Future<SuccessResponse> {
        networking(Endpoint.cancelMatch(matchID: matchID)).decode()
    }

    func getMatchHistory(netID: String) -> Future<Response<[Match]>> {
        networking(Endpoint.getMatchHistory(netID: netID)).decode()
    }

}
