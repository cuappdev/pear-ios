//
//  ApiManager.swift
//  Pear
//
//  Created by Lucy Xu on 5/15/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Alamofire
import Foundation

class ApiManager {

    static let shared: ApiManager = ApiManager()

    private static let geoPlacesEndpoint = "http://geodb-free-service.wirefreethought.com/"

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

    static func getHometown(hometown: String, completion: @escaping ([GeoPlace]) -> Void) {
        guard let queryEndpoint = getUrlWithQuery(
            baseUrl: "\(geoPlacesEndpoint)/v1/geo/cities",
            items: [
                "limit": "4",
                "namePrefix": hometown
            ]
        ) else { return }

        AF.request(
            queryEndpoint,
            method: .get,
            encoding: JSONEncoding.default
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let geoPlacesResponse = try? jsonDecoder.decode(GeoPlacesResponse.self, from: data) {
                    let places = geoPlacesResponse.data
                    completion(places)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
