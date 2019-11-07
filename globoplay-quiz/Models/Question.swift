//
//  Question.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

struct Question: Decodable {
    let id: String
    let description: String
    let correctAnswer: String
    let choices: [Choice]
}
