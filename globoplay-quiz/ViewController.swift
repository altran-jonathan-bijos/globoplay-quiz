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

