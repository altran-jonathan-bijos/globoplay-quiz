//
//  Quiz.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

struct Quiz {
    let questions: [Question]
    
    func random(total: Int = 10) -> [Question] {
        return Array(questions.shuffled()[0..<total])
    }
}
