//
//  ViewController.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private enum State {
        case loaded
        case loading
        case error
    }
    
    
    // MARK: - Private properties
    
    private var state: State = .loading {
        didSet {
//            switch state {
//            case .loaded:
//
//            case .loading:
//
//            case .error:
//            }
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    private let webservice = QuizWebservice()
    private var selectedQuestionIndex: Int?
    private var selectedChoiceIndex: Int?
    private var selectedChoiceId: String?
    private var questions: [Question] = [] {
        didSet {
            selectedQuestionIndex = questions.count > 0 ? 0 : nil
        }
    }
    private let headerViewHeightMultiplier: CGFloat = 0.3873239437
    private let footerViewHeightMultiplier: CGFloat = 0.09375
    private var contentViewHeightMultipler: CGFloat {
        return 1.0 - headerViewHeightMultiplier - footerViewHeightMultiplier
    }

    
    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.contentInset = .init(top: 0, left: 0, bottom: self.view.frame.height * self.footerViewHeightMultiplier, right: 0)
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
        questions = []
        
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
        view.addSubview(footerView)
    }
 
    private func setupConstraints() {
        // MARK: - CollectionView Anchor
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // MARK: - FooterView Anchor
        footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        footerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: footerViewHeightMultiplier).isActive = true
    }
    
    private func getQuestions() {
        state = .loading
        webservice.getQuestions { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let questions):
                self.state = .loaded
                Quiz.questions = questions
                self.questions = Quiz.random(total: 3)
            case .failure:
                self.state = .error
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: HeaderView.identifier,
                                                                         for: indexPath) as! HeaderView
            
            switch state {
            case .loaded:
                if let selectedQuestionIndex = selectedQuestionIndex {
                    let question = questions[selectedQuestionIndex]
                    let state: HeaderView.State = .error(title: "Questão \(selectedQuestionIndex+1)", description: question.description)
                    header.setup(state: state)
                }
            case .loading:
                header.setup(state: .loading)
            case .error:
                let state: HeaderView.State = .error(title: "Ops...", description: "Tivemos um problema ao carregar as informações.")
                header.setup(state: state)
            }
            
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height * headerViewHeightMultiplier)
    }
}

final class Cell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
