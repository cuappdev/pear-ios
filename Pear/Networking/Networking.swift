//
//  Networking.swift
//  Pear
//
//  Created by Lucy Xu on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//


import Foundation
import Alamofire

class Networking2 {

    static let shared: Networking2 = Networking2()

    static var headers: HTTPHeaders {
        let accessToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.accessToken) ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Token \(accessToken)",
            "Accept": "application/json"
        ]
        return headers
    }

    private static let hostEndpoint = "http://\(Keys.pearServerURLV2)"

    private static func getUrlWithQuery(baseUrl: String, items: [String: String]) -> String? {
        guard let baseUrl = URL(string: baseUrl) else { return nil }
        var urlComp = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        var queryItems: [URLQueryItem] = []
        items.forEach { (key, value) in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComp?.queryItems = queryItems
        return urlComp?.url?.absoluteString
    }

    static func authenticateUser(idToken: String, completion: @escaping (UserSession) -> Void) {
        let parameters: [String: Any] = [
            "id_token": idToken
        ]

        AF.request(
            "\(hostEndpoint)/api/authenticate/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let authorizationData = try? jsonDecoder.decode(Response<UserSession>.self, from: data) {
                    let userSession = authorizationData.data
                    completion(userSession)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func validateAccessToken(completion: @escaping (Bool) -> Void) {

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }

    }

    static func getMe(completion: @escaping (UserV2) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let userData = try jsonDecoder.decode(Response<UserV2>.self, from: data)
                    let user = userData.data
                    completion(user)
                } catch {
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateDemographics(
        graduationYear: String,
        majors: [Int],
        hometown: String,
        pronouns: String,
        completion: @escaping (Bool) -> Void
    ) {

        let parameters: [String: Any] = [
            "graduation_year": graduationYear,
            "majors": majors,
            "hometown": hometown,
            "pronouns": pronouns
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateProfile(
        graduationYear: String,
        major: String,
        hometown: String,
        pronouns: String,
        profilePicUrl: String,
        completion: @escaping (Bool) -> Void
    ) {

        let parameters: [String: Any] = [
            "graduation_year": graduationYear,
            "major": major,
            "hometown": hometown,
            "pronouns": pronouns,
            "profile_pic_url": profilePicUrl
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateInterests(
        interests: [Int],
        completion: @escaping (Bool) -> Void
    ) {
        let parameters: [String: Any] = [
            "interests": interests,
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateGroups(
        groups: [Int],
        completion: @escaping (Bool) -> Void
    ) {
        let parameters: [String: Any] = [
            "groups": groups,
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateSocialMedia(
        facebookUrl: String?,
        instagramUsername: String?,
        hasOnboarded: Bool,
        completion: @escaping (Bool) -> Void
    ) {

        let parameters: [String: Any] = [
            "facebook_url": facebookUrl as Any,
            "instagram_username": instagramUsername as Any,
            "has_onboarded": hasOnboarded
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateAvailability(
        availabilities: [String],
        completion: @escaping (Bool) -> Void
    ) {

        let parameters: [String: Any] = [
            "availability": availabilities,
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updateGoals(
        goals: [String],
        completion: @escaping (Bool) -> Void
    ) {

        let parameters: [String: Any] = [
            "goals": goals,
        ]

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let successResponse = try? jsonDecoder.decode(SuccessResponse.self, from: data) {
                    completion(successResponse.success)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func getAllMajors(completion: @escaping ([MajorV2]) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/majors/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let majorsData = try? jsonDecoder.decode(Response<[MajorV2]>.self, from: data) {
                    let majors = majorsData.data
                    completion(majors)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func getAllInterests(completion: @escaping ([InterestV2]) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/interests/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let interestData = try? jsonDecoder.decode(Response<[InterestV2]>.self, from: data) {
                    let interests = interestData.data
                    completion(interests)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func getAllGroups(completion: @escaping ([GroupV2]) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/groups/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupsData = try? jsonDecoder.decode(Response<[GroupV2]>.self, from: data) {
                    let groups = groupsData.data
                    completion(groups)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func getAllUsers(completion: @escaping ([ShortenedUser]) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/users/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let usersData = try jsonDecoder.decode(Response<[ShortenedUser]>.self, from: data)
                    let users = usersData.data
                    completion(users)
                } catch {
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func getUser(id: Int, completion: @escaping (UserV2) -> Void) {

        AF.request(
            "\(hostEndpoint)/api/users/\(id)/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let userData = try jsonDecoder.decode(Response<UserV2>.self, from: data)
                    let user = userData.data
                    completion(user)
                } catch {
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
