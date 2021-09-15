//
//   NetworkManager.shared.swift
//  Pear
//
//  Created by Lucy Xu on 5/9/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//


import Foundation
import Alamofire

class NetworkManager {

    static let shared: NetworkManager = NetworkManager()

    var headers: HTTPHeaders {
        let accessToken = UserDefaults.standard.string(forKey: Constants.UserDefaults.accessToken) ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Token \(accessToken)",
            "Accept": "application/json"
        ]
        return headers
    }

    private let hostEndpoint = "http://\(Keys.pearServerURLV2)"
    
    enum Endpoints {
        static let me = "http://\(Keys.pearServerURLV2)/api/me/"
        static let majors = ""
        static let interests = ""
        static let groups = ""
        static let allUsers = ""
        static let user = ""
        static let allMatches = ""
        static let currentMatch = ""
    }
    
    private init() { }

    func uploadPhoto(base64: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = [
            "bucket": "pear",
            "image": "data:image/png;base64,\(base64)"
        ]

        // TODO: Update server URL
        AF.request(
            "https://\(Keys.pearServerURL)/upload/",
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

    private func getUrlWithQuery(baseUrl: String, items: [String: String]) -> String? {
        guard let baseUrl = URL(string: baseUrl) else { return nil }
        var urlComp = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        var queryItems: [URLQueryItem] = []
        items.forEach { (key, value) in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComp?.queryItems = queryItems
        return urlComp?.url?.absoluteString
    }

    func authenticateUser(idToken: String, completion: @escaping (Result<UserSession, Error>) -> Void) {
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

    func validateAccessToken(completion: @escaping (Result<Data, AFError>) -> Void) {

        AF.request(
            "\(hostEndpoint)/api/me/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            completion(response.result)
        }

    }

    // TODO: Refactor
    func getMe(completion: @escaping (Result<UserV2, Error>) -> Void) {
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

    func updateDemographics(
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

    func updateProfile(
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

    func updateInterests(
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

    func updateGroups(
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

    func updateSocialMedia(
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

    func updateAvailability(
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

    func updateGoals(
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

    //MARK: TODO: Refactor
    func getAllMajors(completion: @escaping (Result<[MajorV2], Error>) -> Void) {
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

    // Refactor
    func getAllInterests(completion: @escaping (Result<[Interest], Error>) -> Void) {
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

    // TODO: Refactor
    func getAllGroups(completion: @escaping (Result<[Group], Error>) -> Void) {
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

    // TODO: Refactor
    func getAllUsers(completion: @escaping (Result<[CommunityUser], Error>) -> Void) {
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

    // TODO: Refactor
    func getUser(id: Int, completion: @escaping (Result<UserV2, Error>) -> Void) {
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

    // TODO: Refactor
    func getAllMatches(completion: @escaping (Result<[TempMatchV2], Error>) -> Void) {
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

    // TODO: Refactor
    func getCurrentMatch(completion: @escaping (Result<MatchV2, Error>) -> Void) {
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
        
//        getData(TempMatchV2.self, endpoint: Endpoints.allMatches, parameters: [""]) { result in
//            
//        }
    }
    
    func getData<T: Codable>(_ data: T.Type, endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(
            endpoint,
            method: .get,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(Response<T>.self, from: data)
                    let modelData = responseData.data
                    completion(.success(modelData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
