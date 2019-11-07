//
//  ViewController.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    
    // MARK: - Private properties
    
    private let webservice = QuizWebservice()
    private var selectedQuestionIndex: Int?
    private var selectedChoiceIndex: Int?
    private var selectedChoiceId: String?
    private var questions: [Question] = [] {
        didSet {
            self.collectionView.reloadData()
            selectedQuestionIndex = questions.count > 0 ? 0 : nil
        }
    }

    
    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 30
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Color.darkGray
        return cv
    }()
    
    private let footerView: UIView = {
        let f = FooterView()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.backgroundColor = Color.darkGray
        return f
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupViews()
        setupConstraints()
        getQuestions()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
    }
    
    @objc private func reload() {
        selectedChoiceId = nil
        selectedQuestionIndex = nil
        selectedChoiceIndex = nil
        collectionView.reloadData()
        
        getQuestions()
    }
    
    
    // MARK: - Private functions
    
    private func registerCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(ChoiceCell.self, forCellWithReuseIdentifier: ChoiceCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        self.view.addSubview(footerView)
    }
 
    private func setupConstraints() {
        // MARK: - CollectionView Anchor
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: - FooterView Anchor
        footerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        footerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.09375).isActive = true
    }
    
    private func getQuestions() {
        webservice.getQuestions { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let questions):
                Quiz.questions = questions
                self.questions = Quiz.random(total: 3)
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let selectedQuestionIndex = selectedQuestionIndex else {
            return 0
        }
        let question = questions[selectedQuestionIndex]
        return question.choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let selectedQuestionIndex = selectedQuestionIndex else { return UICollectionViewCell() }
        let question = questions[selectedQuestionIndex]
        let choice = question.choices[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoiceCell.identifier, for: indexPath) as! ChoiceCell
        
        let cellState: ChoiceCell.State
        if let selectedChoiceIndex = selectedChoiceIndex {
            let isCorrect = question.correctAnswer == choice.id
            let isSelectedCell = indexPath.item == selectedChoiceIndex
            
            if isCorrect {
                if isSelectedCell {
                    cellState = .correct
                } else {
                    cellState = .correctNotSelected
                }
            } else {
                if isSelectedCell {
                    cellState = .wrong
                } else {
                    cellState = .wrongNotSelected
                }
            }
        } else {
            cellState = .unselected
        }
        
        cell.setup(text: choice.answer, state: cellState)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 45)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedQuestionIndex = selectedQuestionIndex else { return }
        let question = questions[selectedQuestionIndex]
        let choice = question.choices[indexPath.item]
        selectedChoiceIndex = indexPath.item
        selectedChoiceId = choice.id
        
        collectionView.reloadData()
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
            
            if let selectedQuestionIndex = selectedQuestionIndex {
                let question = questions[selectedQuestionIndex]
                header.setup(title: "Questão \(selectedQuestionIndex+1)", description: question.description)
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let percent: CGFloat = 0.3873239437
        return CGSize(width: self.view.frame.width, height: self.view.frame.height * percent)
    }
}

final class Cell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
