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

    /// [GET] Get major of the user.
    func getUserMajor() -> Future<Response<String>> {
        networking(Endpoint.getUserMajor()).decode()
    }

    /// [GET] Get interests of the user.
    func getUserInterests() -> Future<Response<[String]>> {
        networking(Endpoint.getUserInterests()).decode()
    }

    /// [GET] Get preferred locations of user by netID.
    func getUserPreferredLocations(netId: String) -> Future<Response<[Location]>> {
        networking(Endpoint.getUserAvailabilities(netId: netId)).decode()
    }
    
    /// [GET] Get availabilities of user by netID.
    func getUserAvailabilities(netId: String) -> Future<Response<[DaySchedule]>> {
        networking(Endpoint.getUserAvailabilities(netId: netId)).decode()
    }
    
    /// [GET] Gets another user's matches, given their netID. If none provided, gets current user's matches.
    func getUserMatches(netId: String) -> Future<Response<[Match]>> {
        networking(Endpoint.getUserMatches(netId: netId)).decode()
    }

    /// [POST] Update goals information about the user.
    func updateUserGoals(goals: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserGoals(goals: goals)).decode()
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
    
}
