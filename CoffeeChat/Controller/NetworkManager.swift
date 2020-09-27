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
        return networking(Endpoint.pingServer()).decode()
    }

    func createUser(idToken: String) -> Future<Response<UserSession>> {
        return networking(Endpoint.createUser(idToken: idToken)).decode()
    }

    func updateUser(clubs: [String],
                    graduationYear: String,
                    hometown: String,
                    interests: [String],
                    major: String,
                    pronouns: String) -> Future<Response<UserSession>> {
        return networking(Endpoint.updateUser(clubs: clubs,
                                              graduationYear: graduationYear,
                                              hometown: hometown,
                                              interests: interests,
                                              major: major,
                                              pronouns: pronouns)).decode()
    }

    func getUser() -> Future<Response<User>> {
        return networking(Endpoint.getUser()).decode()
    }

    func getUserClubs() -> Future<Response<[String]>> {
        return networking(Endpoint.getUserClubs()).decode()
    }

    func getUserMatchings(netIDs: [String], schedule: [DaySchedule]) -> Future<Response<Matching>> {
        return networking(Endpoint.getUserMatchings(netIDs: netIDs, schedule: schedule)).decode()
    }

    func getUserMajor() -> Future<Response<String>> {
        return networking(Endpoint.getUserMajor()).decode()
    }

    func getUserInterests() -> Future<Response<[String]>> {
        return networking(Endpoint.getUserInterests()).decode()
    }

    // TODO: Update response body
//    func updateUser(firstName: String, lastName: String, netID: String) -> Future<Response<User>> {
//        return networking(Endpoint.updateUser(firstName: firstName, lastName: lastName, netID: netID)).decode()
//    }

}
