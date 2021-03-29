//
//  Prompt.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 3/28/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

struct Prompt: Equatable {

    let didAnswerPrompt: Bool
    let promptResponse: String?
    let promptQuestion: String?

    static func == (lhs: Prompt, rhs: Prompt) -> Bool {
        return lhs.promptQuestion == rhs.promptQuestion
    }

}
