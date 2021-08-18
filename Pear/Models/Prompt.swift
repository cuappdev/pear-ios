//
//  Prompt.swift
//  Pear
//
//  Created by Amy Chin Siu Huang on 8/17/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import Foundation

struct Prompt: Codable, Equatable {

    let questionId: Int?
    let questionName: String
    let questionPlaceholder: String
    let answer: String?

    /// True if two prompts have the same id, false otherwise. Used to filter the prompt options that should be presented to a user after a user removes one of their answered prompts. Filtering is done by comparing the array of all prompts against the array of answered prompts
     static func == (lhs: Prompt, rhs: Prompt) -> Bool {
         return lhs.questionId == rhs.questionId
     }

 }
