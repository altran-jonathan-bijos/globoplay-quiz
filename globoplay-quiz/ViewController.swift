//
//  ViewController.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    let webservice = QuizWebservice()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
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
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        self.view.addSubview(collectionView)
    }
 
    private func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderView.identifier,
                for: indexPath) as! HeaderView
            
            header.setup("Ola?")
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.27)
    }
}

final class Cell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
