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

    // MARK: - Photo Upload
    func uploadPhoto(base64: String) -> Future<Response<String>> {
        networking(Endpoint.uploadPhoto(base64: base64)).decode()
    }

    // MARK: - General
    
    /// [GET] Checks if server application is running.
    func pingServer() -> Future<Response<String>> {
        networking(Endpoint.pingServer()).decode()
    }
    
    // MARK: - Authentication
    
    /// [POST] Authenticate ID token from Google and creates a user if account does not exist. Returns a session for the user.
    func createUser(idToken: String) -> Future<Response<UserSession>> {
        networking(Endpoint.createUser(idToken: idToken)).decode()
    }

    /// [GET] Authenticates the refresh token and returns a new user session.
    func refreshUserToken(token: String) -> Future<Response<UserSession>> {
        networking(Endpoint.refreshUserToken(token: token)).decode()
    }
    
    // MARK: - Get User

    /// [GET] Get information about the user after login.
    func getLoginUser(netId: String) -> Future<Response<LoginUser>> {
        networking(Endpoint.getLoginUser(netId: netId)).decode()
    }

    /// [GET] Get information about the user.
    func getUser(netId: String) -> Future<Response<User>> {
        networking(Endpoint.getUser(netId: netId)).decode()
    }

    /// [GET] Get clubs of the user.
    func getUserClubs() -> Future<Response<[String]>> {
        networking(Endpoint.getUserClubs()).decode()
    }
    
    /// [GET] Get goals of the user.
    func getUserGoals(netId: String) -> Future<Response<[String]>> {
        networking(Endpoint.getUserGoals(netId: netId)).decode()
    }

    /// [GET] Get major of the user.
    func getUserMajor() -> Future<Response<String>> {
        networking(Endpoint.getUserMajor()).decode()
    }

    /// [GET] Get interests of the user.
    func getUserInterests() -> Future<Response<[String]>> {
        networking(Endpoint.getUserInterests()).decode()
    }
    
    /// [GET] Get talking points of the user.
    func getUserTalkingPoints(netId: String) -> Future<Response<[String]>> {
        networking(Endpoint.getUserTalkingPoints(netId: netId)).decode()
    }
    
    /// [GET] Get preferred locations of user by netID.
    func getUserPreferredLocations(netId: String) -> Future<Response<[Location]>> {
        networking(Endpoint.getUserAvailabilities(netId: netId)).decode()
    }
    
    /// [GET] Get availabilities of user by netID.
    func getUserAvailabilities(netId: String) -> Future<Response<[DaySchedule]>> {
        networking(Endpoint.getUserAvailabilities(netId: netId)).decode()
    }
    
    /// [GET] Get social media of the user.
    func getUserSocialMedia(netId: String) -> Future<Response<UserSocialMedia>> {
        networking(Endpoint.getUserSocialMedia(netId: netId)).decode()
    }
    
    /// [GET] Gets another user's matches, given their netID. If none provided, gets current user's matches.
    func getUserMatches(netId: String) -> Future<Response<[Match]>> {
        networking(Endpoint.getUserMatches(netId: netId)).decode()
    }
    
    // MARK: - Get users.
    
    // MARK: - Update users.
    
    /// [POST] Update demographics information about the user.
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

    /// [POST] Update interests information about the user.
    func updateUserInterests(interests: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserInterests(interests: interests)).decode()
    }

    /// [POST] Update groups information about the user.
    func updateUserGroups(groups: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserGroups(groups: groups)).decode()
    }

    /// [POST] Update goals information about the user.
    func updateUserGoals(goals: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserGoals(goals: goals)).decode()
    }

    /// [POST] Update talking points information about the user.
    func updateUserTalkingPoints(talkingPoints: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserTalkingPoints(talkingPoints: talkingPoints)).decode()
    }

    /// [POST] Update social media information about the user.
    func updateUserSocialMedia(facebook: String, instagram: String, didOnboard: Bool) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserSocialMedia(facebook: facebook, instagram: instagram, didOnboard: didOnboard)).decode()
    }
    
    /// [POST] Update time availabilities of the user.
    func updateTimeAvailabilities(savedAvailabilities: [DaySchedule]) -> Future<SuccessResponse> {
        networking(Endpoint.updateTimeAvailabilities(savedAvailabilities: savedAvailabilities)).decode()
    }

    /// [POST] Updates the preferred location of current user.
    func updatePreferredLocations(locations: [Location]) -> Future<SuccessResponse> {
        networking(Endpoint.updatePreferredLocations(locations: locations)).decode()
    }
    
    
    // MARK: - Matches
    
    /// [GET] Gets another user's matches, given their netID.
    func getMatch(netId: String) -> Future<Response<Match>> {
        networking(Endpoint.getMatch(netId: netId)).decode()
    }

    /// [POST] Update the availabilities for the given match.
    func updateMatchAvailabilities(match: Match) -> Future<SuccessResponse> {
        networking(Endpoint.updateMatchAvailabilities(match: match)).decode()
    }

    /// [POST] Cancels match provided the matchID.
    func cancelMatch(matchID: String) -> Future<SuccessResponse> {
        networking(Endpoint.cancelMatch(matchID: matchID)).decode()
    }

    /// [GET] Gets match history for provided netID. If none provided, gets current user's history.
    func getMatchHistory(netID: String) -> Future<Response<[Match]>> {
        networking(Endpoint.getMatchHistory(netID: netID)).decode()
    }
    
    // MARK: - Stored
    
    /// [GET] Get all student groups.
    func getAllGroups() -> Future<Response<[String]>> {
        networking(Endpoint.getAllGroups()).decode()
    }

    /// [GET] Get all interests.
    func getAllInterests() -> Future<Response<[String]>> {
        networking(Endpoint.getAllInterests()).decode()
    }

    /// [GET] Get all majors.
    func getAllMajors() -> Future<Response<[String]>> {
        networking(Endpoint.getAllMajors()).decode()
    }
    
}
