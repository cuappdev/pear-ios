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

    func createUser(clubs: [String],
                    idToken: String,
                    graduationYear: String,
                    hometown: String,
                    interests: [String],
                    major: String,
                    pronouns: String) -> Future<Response<UserSessionBody>> {
        return networking(Endpoint.createUser(clubs: clubs,
                                              idToken: idToken,
                                              graduationYear: graduationYear,
                                              hometown: hometown,
                                              interests: interests,
                                              major: major,
                                              pronouns: pronouns)).decode()
    }

}
