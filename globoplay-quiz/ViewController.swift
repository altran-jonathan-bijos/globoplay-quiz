//
//  ViewController.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let webservice = QuizWebservice()
    
    private let container: UIView = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .yellow
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        webservice.getQuestions { (result) in
            switch result {
            case .success(let questions):
                print(questions)
            case .failure(let err):
                print(err)
            }
        }
        
        let questions = [
            Question(id: "1", description: "", correctAnswer: "", choices: [Choice(id: "10", answer: "")]),
            Question(id: "2", description: "", correctAnswer: "", choices: [Choice(id: "20", answer: "")]),
            Question(id: "3", description: "", correctAnswer: "", choices: [Choice(id: "30", answer: "")]),
            Question(id: "4", description: "", correctAnswer: "", choices: [Choice(id: "40", answer: "")]),
            Question(id: "5", description: "", correctAnswer: "", choices: [Choice(id: "50", answer: "")]),
            Question(id: "6", description: "", correctAnswer: "", choices: [Choice(id: "60", answer: "")]),
            Question(id: "7", description: "", correctAnswer: "", choices: [Choice(id: "70", answer: "")]),
        ]
        let quiz = Quiz(questions: questions)
        
        print(quiz.questions)
        print(quiz.questions.count)
        print("-----------------------------------")
        
        let total = quiz.random(total: 3)
        print(total)
        print(total.count)
    }
    
    private func setupViews() {
        self.view.addSubview(container)
    }
 
    private func setupConstraints() {
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

