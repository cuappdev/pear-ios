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
    
    func updateUserOrganizations(organizations: [String]) -> Future<SuccessResponse> {
        networking(Endpoint.updateUserOrganizations(organizations: organizations)).decode()
    }

    func getUser() -> Future<Response<User>> {
        networking(Endpoint.getUser()).decode()
    }

    func getUserClubs() -> Future<Response<[String]>> {
        networking(Endpoint.getUserClubs()).decode()
    }

    func getUserMatchings(netIDs: [String], schedule: [DaySchedule]) -> Future<Response<Matching>> {
        networking(Endpoint.getUserMatchings(netIDs: netIDs, schedule: schedule)).decode()
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

    // TODO: Update response body
//    func updateUser(firstName: String, lastName: String, netID: String) -> Future<Response<User>> {
//        return networking(Endpoint.updateUser(firstName: firstName, lastName: lastName, netID: netID)).decode()
//    }

}
