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
        case finished
    }
    
    
    // MARK: - Private properties
    
    private var state: State = .loading {
        didSet {
            switch state {
            case .loaded:
                footerView.setupButton(state: canShowNextButton ? .next : .hidden)
            case .loading:
                footerView.setupButton(state: .hidden)
            case .error:
                footerView.setupButton(state: .tryAgain)
            case .finished:
                footerView.setupButton(state: .restart)
            }
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    private let webservice = QuizWebservice()
    private var selectedQuestionIndex: Int?
    private var timerEndedAndNoneSelected = false
    private var selectedChoiceIndex: Int?
    private var selectedChoiceId: String?
    private var questions: [Question] = [] {
        didSet {
            selectedQuestionIndex = questions.count > 0 ? 0 : nil
        }
    }
    private var answers: [Answer] = []
    private let headerViewHeightMultiplier: CGFloat = 0.3873239437
    private let footerViewHeightMultiplier: CGFloat = 0.09375
    private var contentViewHeightMultipler: CGFloat {
        return 1.0 - headerViewHeightMultiplier - footerViewHeightMultiplier
    }
    private var canShowNextButton: Bool {
        return selectedChoiceId != nil || timerEndedAndNoneSelected
    }
    private var canSelectChoice: Bool {
        return selectedChoiceId == nil && !timerEndedAndNoneSelected
    }
    private var isFinished: Bool {
        guard let selectedQuestionIndex = selectedQuestionIndex else {
            return false
        }
        return questions.endIndex == selectedQuestionIndex
    }
    private var answersProgress: Float {
        let booleanAnswers = answers.map { (answer) -> Bool in
            guard let question = questions.enumerated().first(where: { $0.offset == answer.questionId }) else { return false }
            return answer.choiceId == question.element.correctAnswer
        }
        let correctAnswers = booleanAnswers.filter({ $0 == true })
        let progress = Float(correctAnswers.count)/Float(questions.count)
        return progress
    }
    
    
    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Color.darkGray
        return cv
    }()
    
    private lazy var footerView: FooterView = {
        let f = FooterView()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.backgroundColor = Color.darkGray
        f.delegate = self
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
        selectedQuestionIndex = nil
        selectedChoiceId = nil
        selectedChoiceIndex = nil
        timerEndedAndNoneSelected = false
        questions = []
        answers = []
        
        getQuestions()
    }
    
    
    // MARK: - Private functions
    
    private func registerCells() {
        collectionView.register(ChoiceCell.self, forCellWithReuseIdentifier: ChoiceCell.identifier)
        collectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.identifier)
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
                self.questions = Quiz.random(total: 5)
            case .failure:
                self.state = .error
            }
        }
    }
    
    private func goToNextQuestion() {
        selectedChoiceId = nil
        selectedChoiceIndex = nil
        timerEndedAndNoneSelected = false
        
        if isFinished {
            state = .finished
        } else {
            state = .loaded
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loaded:
            guard let selectedQuestionIndex = selectedQuestionIndex, selectedQuestionIndex < questions.endIndex else {
                return 0
            }
            let question = questions[selectedQuestionIndex]
            return question.choices.count
        case .loading:
            return 4
        case .error, .finished:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoiceCell.identifier, for: indexPath) as! ChoiceCell
        
        let cellState: ChoiceCell.State
        
        switch state {
        case .loading:
            cellState = .loading
        case .error:
            cellState = .error
        case .loaded:
            if let selectedQuestionIndex = selectedQuestionIndex, !isFinished {
                let question = questions[selectedQuestionIndex]
                let choice = question.choices[indexPath.item]
                
                if timerEndedAndNoneSelected {
                    cellState = .timerEndedAndNoneSelected(text: choice.answer)
                } else {
                    if let selectedChoiceIndex = selectedChoiceIndex {
                        let isCorrect = question.correctAnswer == choice.id
                        let isSelectedCell = indexPath.item == selectedChoiceIndex
                        
                        if isCorrect {
                            cellState = isSelectedCell ? .correct(text: choice.answer) : .correctNotSelected(text: choice.answer)
                        } else {
                            cellState = isSelectedCell ? .wrong(text: choice.answer) : .wrongNotSelected(text: choice.answer)
                        }
                    } else {
                        cellState = .unselected(text: choice.answer)
                    }
                }
            } else {
                #warning("Missing state")
                cellState = .loading
            }
        case .finished:
            cellState = .finished(progress: answersProgress)
        }
        
        cell.setup(state: cellState)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch state {
        case .loaded, .loading:
            return CGSize(width: view.frame.width, height: 45)
        case .error, .finished:
            return CGSize(width: view.frame.width, height: view.frame.height * contentViewHeightMultipler)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedQuestionIndex = selectedQuestionIndex, selectedQuestionIndex < questions.endIndex else { return }
        guard canSelectChoice else { return }
        let question = questions[selectedQuestionIndex]
        let choice = question.choices[indexPath.item]
        selectedChoiceIndex = indexPath.item
        selectedChoiceId = choice.id
        
        answers.append(Answer(questionId: selectedQuestionIndex, choiceId: choice.id))
        
        state = .loaded
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: HeaderView.identifier,
                                                                         for: indexPath) as! HeaderView
            header.delegate = self
            
            switch state {
            case .loaded:
                if let selectedQuestionIndex = selectedQuestionIndex, selectedQuestionIndex < questions.endIndex {
                    let question = questions[selectedQuestionIndex]
                    let state: HeaderView.State = .loaded(title: "Questão \(selectedQuestionIndex+1)", description: question.description, isTimerEnabled: canSelectChoice)
                    header.setup(state: state)
                }
            case .loading:
                header.setup(state: .loading)
            case .error:
                let state: HeaderView.State = .error(title: "Ops...", description: "Tivemos um problema ao carregar as informações.")
                header.setup(state: state)
            case .finished:
                let title: String
                let description: String
                switch answersProgress {
                case 0..<0.25:
                    title = "Não foi dessa vez"
                    description = "Quem acredita sempre alcança"
                case 0.25..<0.5:
                    title = "Vish..."
                    description = "Precisa estudar mais ein"
                case 0.5..<0.75:
                    title = "Quase lá!"
                    description = "Viver na média as vezez é bom né"
                case 0.75..<1.0:
                    title = "Mandou bem!"
                    description = "Digamos que você está acima da média. No pain no gain!"
                case 1.0:
                    title = "Você é o cara!"
                    description = "Acertar tudo é só pra quem realmente sabe! Parabéns!"
                default:
                    title = ""
                    description = ""
                }
                
                // Get percentage text
                let state: HeaderView.State = .loaded(title: title, description: description, isTimerEnabled: false)
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

extension ViewController: HeaderViewDelegate {
    func headerViewDidEndTimer() {
        timerEndedAndNoneSelected = true
        state = .loaded
    }
}

extension ViewController: FooterViewDelegate {
    func footerViewDidTapButton() {
        if isFinished {
            reload()
            return
        }
        if let selectedQuestionIndex = selectedQuestionIndex, selectedQuestionIndex < questions.endIndex {
            self.selectedQuestionIndex = selectedQuestionIndex + 1
            goToNextQuestion()
        }
    }
}
