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

    /// True if two prompts have the same question, false otherwise. Used to filter the prompt questions that should be presented to a user after a user removes one of their answered prompts. Filtering is done by comparing the array of all prompts against the array of answered prompts
    static func == (lhs: Prompt, rhs: Prompt) -> Bool {
        return lhs.promptQuestion == rhs.promptQuestion
    }

}
