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

    func createUser(idToken: String) -> Future<Response<UserSession>> {
        networking(Endpoint.createUser(idToken: idToken)).decode()
    }

    func updateUser(clubs: [String],
                    graduationYear: String,
                    hometown: String,
                    interests: [String],
                    major: String,
                    pronouns: String) -> Future<Response<UserSession>> {
        networking(Endpoint.updateUser(clubs: clubs,
                                       graduationYear: graduationYear,
                                       hometown: hometown,
                                       interests: interests,
                                       major: major,
                                       pronouns: pronouns)).decode()
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

    // TODO: Update response body
//    func updateUser(firstName: String, lastName: String, netID: String) -> Future<Response<User>> {
//        return networking(Endpoint.updateUser(firstName: firstName, lastName: lastName, netID: netID)).decode()
//    }

    // TODO: replace with an actual networking calls
    // ASSUMING about matching...
    //
    // - Matching.active = true if it has been sheduled and ready to go
    // - Matching.active = false if it still needs to be scheduled
    //
    // An unscheduled matching
    // - has 0 entries in schedule starting out
    // - 1 person puts up their array of DaySchedule, making it have size > 0
    // - Other person chooses one time, making the matching now ACTIVE and size == 1

    // Get all matchings that involve this user
    func getMatching(user: SubUser) -> Future<Response<Matching?>> {
        let request = networking(Endpoint.pingServer())

        //let dummySchedule = [
        //    DaySchedule(day: "Sunday", times: [10, 11, 12, 13, 14]),
        //    DaySchedule(day: "Monday", times: [15, 16.5, 17]),
        //    DaySchedule(day: "Wednesday", times: [19, 20.5]),
        //    DaySchedule(day: "Friday", times: [10, 20.5])
        //]
        let dummySchedule: [DaySchedule] = []
        let dummyMatch = Matching(active: false, schedule: dummySchedule, users: [user, user])

        return request.transformed { _ in
            Response(data: dummyMatch, success: true)
        }
    }

    // Update a matching with available times and place
    func updateMatching(matching: Matching, schedule: [DaySchedule]) -> Future<Response<Matching>> {
        let request = networking(Endpoint.pingServer())
        return request.transformed { _ in
            let newMatching = Matching(active: false, schedule: schedule, users: matching.users)
            return Response(data: newMatching, success: true)
        }
    }

    // Update a matching with chosen time and place
    func updateMatching(matching: Matching, for time: DaySchedule) -> Future<Response<Matching>> {
        let request = networking(Endpoint.pingServer())
        return request.transformed { _ in
            let newMatching = Matching(active: false, schedule: [time], users: matching.users)
            return Response(data: newMatching, success: true)
        }
    }
}
