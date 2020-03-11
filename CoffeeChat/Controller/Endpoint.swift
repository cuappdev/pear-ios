//
//  Endpoint.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 3/8/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {

    static func setupEndpointConfig() {

        // TODO: Add server URL to Info.plist
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "SERVER_URL") as? String else {
            fatalError("Could not find SERVER_URL in Info.plist!")
        }

        #if LOCAL
            Endpoint.config.scheme = "http"
            Endpoint.config.port = 5000
        #else
            Endpoint.config.scheme = "https"
        #endif
        Endpoint.config.host = baseURL
        Endpoint.config.commonPath = "/api"
    }

    static func getAllStops() -> Endpoint {
        return Endpoint(path: "", body: body)
    }

}
