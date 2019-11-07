//
//  FooterView.swift
//  globoplay-quiz
//
//  Created by eduardo.silva on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class FooterView: UIView {
    
    enum State {
        case tryAgain
        case next
        case timer
    }
    
    private let footerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "footer-wave"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.darkGray
        return imageView
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.cornerRadius = 25
        button.backgroundColor = Color.black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(footerImageView)
        self.addSubview(nextButton)
        setupButton(state: .timer)
        self.setupAnchor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupButton(state: FooterView.State) {
        switch state {
        case .next:
            nextButton.setTitle("Próximo", for: .normal)
            nextButton.contentEdgeInsets = .init(top: 0, left: 38, bottom: 0, right: 38)
            nextButton.setTitleColor(Color.white, for: .normal)
        case .timer:
            nextButton.contentEdgeInsets = .init(top: 0, left: 12.5, bottom: 0, right: 12.5)
            nextButton.setTitleColor(Color.white, for: .disabled)
            nextButton.setTitle("30", for: .disabled)
        case .tryAgain:
            nextButton.setTitle("Tentar Novamente", for: .normal)
            nextButton.contentEdgeInsets = .init(top: 0, left: 38, bottom: 0, right: 38)
            nextButton.setTitleColor(Color.white, for: .normal)
        }
    }
    
    private func setupAnchor() {
        // MARK: - FooterImageView Anchor
        self.footerImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.footerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.footerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.footerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        //MARK: - NextButton Anchor
        self.nextButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
    }
}
