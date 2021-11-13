//
//  NetworkManager.swift
//  Pear
//
//  Created by Lucy Xu on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//


import Foundation
import Alamofire

class NetworkManager {

    static let shared: NetworkManager = NetworkManager()

    static var headers: HTTPHeaders {
        let accessToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.accessToken) ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Token \(accessToken)",
            "Accept": "application/json"
        ]
        return headers
    }

    private static let hostEndpoint = "http://\(Keys.pearServerURLV2)"

    static func uploadPhoto(base64: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = [
            "bucket": "pear",
            "image": "data:image/png;base64,\(base64)"
        ]

        AF.request(
            "https://\(Keys.appdevServerURL)/upload/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let imageData = try jsonDecoder.decode(Response<String>.self, from: data)
                    let img = imageData.data
                    completion(.success(img))
                    
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

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

    static func authenticateUser(idToken: String, completion: @escaping (Result<UserSession, Error>) -> Void) {
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
                
                do {
                    let authorizationData = try jsonDecoder.decode(Response<UserSession>.self, from: data)
                    let userSession = authorizationData.data
                    completion(.success(userSession))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func validateAccessToken(completion: @escaping (Result<Data, AFError>) -> Void) {

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            completion(response.result)
        }

    }

    static func getCurrentUser(completion: @escaping (Result<UserV2, Error>) -> Void) {
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
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
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
        majors: [Int],
        hometown: String,
        pronouns: String,
        profilePicUrl: String,
        completion: @escaping (Bool) -> Void
    ) {
        print(profilePicUrl)

        let parameters: [String: Any] = [
            "graduation_year": graduationYear,
            "majors": majors,
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
        hasOnboarded: Bool,
        completion: @escaping (Bool) -> Void
    ) {

        let parameters: [String: Any] = [
            "goals": goals,
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

    static func getAllMajors(completion: @escaping (Result<[MajorV2], Error>) -> Void) {
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
                do {
                    let majorsData = try jsonDecoder.decode(Response<[MajorV2]>.self, from: data)
                    let majors = majorsData.data
                    completion(.success(majors))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getAllInterests(completion: @escaping (Result<[Interest], Error>) -> Void) {
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
                do {
                    let interestData = try jsonDecoder.decode(Response<[Interest]>.self, from: data)
                    let interests = interestData.data
                    completion(.success(interests))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getAllGroups(completion: @escaping (Result<[Group], Error>) -> Void) {
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
                do {
                    let groupsData = try jsonDecoder.decode(Response<[Group]>.self, from: data)
                    let groups = groupsData.data
                    completion(.success(groups))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getAllUsers(completion: @escaping (Result<[CommunityUser], Error>) -> Void) {
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
                    let usersData = try jsonDecoder.decode(Response<[CommunityUser]>.self, from: data)
                    let users = usersData.data
                    completion(.success(users))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getUser(id: Int, completion: @escaping (Result<UserV2, Error>) -> Void) {
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
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getAllMatches(completion: @escaping (Result<[TempMatchV2], Error>) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/matches/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let matchData = try jsonDecoder.decode(Response<[TempMatchV2]>.self, from: data)
                    let matches = matchData.data
                    completion(.success(matches))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static func getCurrentMatch(completion: @escaping (Result<MatchV2, Error>) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/matches/current/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let matchData = try jsonDecoder.decode(Response<MatchV2>.self, from: data)
                    let match = matchData.data
                    completion(.success(match))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getPromptOptions(completion: @escaping([Prompt]) -> Void) {
        AF.request(
            "\(hostEndpoint)/api/prompts/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let promptOptions = try? jsonDecoder.decode(Response<[Prompt]>.self, from: data) {
                        let prompts = promptOptions.data
                        completion(prompts)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func updatePrompts(prompts: [Prompt], completion: @escaping (Bool) -> Void) {
        let prompts = prompts.filter( { $0.id != nil && $0.answer != nil })
        
        let parameters: [String: Any] = [
            "prompts": prompts.map({ prompt -> [String: Any] in
                if let id = prompt.id, let answer = prompt.answer {
                    return [
                        "id": id,
                        "answer": answer
                    ]
                }
                
                return [:]
            })
        ]
        
        print(parameters)
        
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
                completion(false)
            }
        }
    }

    static func getSearchedUsers(searchText: String, completion: @escaping (Result<[CommunityUser], Error>) -> Void) {
        let parameters: [String: Any] = [
            "query": searchText
        ]
        
        AF.request(
            "\(hostEndpoint)/api/users/",
            method: .get,
            parameters: parameters,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let usersData = try jsonDecoder.decode(Response<[CommunityUser]>.self, from: data)
                    completion(.success(usersData.data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
