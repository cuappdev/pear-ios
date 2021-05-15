//
//  GeoPlaceResponse.swift
//  Pear
//
//  Created by Lucy Xu on 5/15/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation
import FutureNova

struct GeoPlacesResponse: Codable {

    let data: [GeoPlace]
    let metadata: GeoPlaceMetadata

}

struct GeoPlaceMetadata: Codable {

    let currentOffset: Int
    let totalCount: Int

}

struct GeoPlace: Codable {

    let id: Int
    let wikiDataId: String
    let type: String
    let city: String
    let name: String
    let country: String
    let countryCode: String
    let region: String
    let regionCode: String
    let latitude: Float
    let longitude: Float
    let population: Int

}
