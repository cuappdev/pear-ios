//
//  Interest.swift
//  CoffeeChat
//
//  Created by Phillip OReggio on 2/4/20.
//  Copyright © 2020 cuappdev. All rights reserved.
//

import Foundation

struct Interest {

    let name: String
    let categories: String
    let image: String

    init(name: String, categories: String, image: String) {
        self.name = name
        self.categories = categories
        self.image = image
    }

}
